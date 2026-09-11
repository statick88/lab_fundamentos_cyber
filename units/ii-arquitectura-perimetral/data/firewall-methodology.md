# Metodología de Reglas de Firewall — Arquitectura Perimetral

## Principios Fundamentales

### 1. Default-Deny (Denegar por Defecto)
**Regla de oro**: Todo lo que no esté explícitamente permitido, se deniega.
- Aplicar en **todos** los firewalls: perimetral, interno, management
- Orden de evaluación: reglas específicas PRIMERO, regla default-deny AL FINAL
- Logging de denegaciones para análisis y tuning

```bash
# Ejemplo iptables/nftables - Default Deny
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP
# Luego adds explícitos...
```

### 2. Allowlisting (Lista de Permitidos) vs Blocklisting
- **Allowlisting (RECOMENDADO)**: Define QUÉ se permite, todo lo demás cae en default-deny
- **Blocklisting (EVITAR)**: Define QUÉ se bloquea, todo lo demás pasa — inseguro por omisión
- Usar allowlisting para: puertos, IPs origen/destino, protocolos, usuarios

### 3. Mínimo Privilegio por Zona
| Zona | Principio |
|------|-----------|
| WAN→DMZ | Solo puertos de servicios públicos (80, 443, 53, 25/587) |
| DMZ→LAN | Solo puertos app-to-DB específicos (ej. 3306, 5432, 1433) |
| LAN→WAN | **NUNCA** directo — siempre via proxy forward |
| Mgmt→Any | Solo bastion/jump host IPs, puertos 22/3389 |

### 4. Separación de Tráfico por Interfaz
- Cada zona en su **propia interfaz física o VLAN**
- Reglas atadas a interfaz (ingress/egress), no solo IP
- Evita "hairpinning" y bypass de controles

## Estructura de Archivos de Reglas por Zona

### wan-dmz.sh — Perímetro Externo → DMZ
```bash
#!/bin/bash
# WAN → DMZ: Default-deny + allows explícitos para servicios públicos

# Variables
WAN_IF="eth0"
DMZ_IF="eth1"
DMZ_NET="10.10.10.0/24"

# Default policies
iptables -P FORWARD DROP

# ESTADO: Permitir tráfico establecido/relacionado
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

# HTTP/HTTPS → Web Server (A2) en DMZ
iptables -A FORWARD -i $WAN_IF -o $DMZ_IF -p tcp -d 10.10.10.10 \
  -m multiport --dports 80,443 -m state --state NEW -j ACCEPT

# DNS → DNS Server en DMZ
iptables -A FORWARD -i $WAN_IF -o $DMZ_IF -p udp -d 10.10.10.20 \
  --dport 53 -m state --state NEW -j ACCEPT
iptables -A FORWARD -i $WAN_IF -o $DMZ_IF -p tcp -d 10.10.10.20 \
  --dport 53 -m state --state NEW -j ACCEPT

# SMTP/Submission → Mail Relay en DMZ
iptables -A FORWARD -i $WAN_IF -o $DMZ_IF -p tcp -d 10.10.10.30 \
  -m multiport --dports 25,587 -m state --state NEW -j ACCEPT

# LOG denegaciones para análisis
iptables -A FORWARD -i $WAN_IF -o $DMZ_IF -j LOG --log-prefix "WAN-DMZ-DENY: "
```

### dmz-lan.sh — DMZ → LAN (Acceso Interno)
```bash
#!/bin/bash
# DMZ → LAN: Solo app-to-DB ports explícitos (NO wildcard)

DMZ_IF="eth1"
LAN_IF="eth2"
LAN_NET="10.10.20.0/24"
DB_SERVER="10.10.20.10"  # A1 Database

# Default deny
iptables -P FORWARD DROP

# ESTADO
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

# App Server (en DMZ) → Database (A1 en LAN) — PUERTOS EXPLÍCITOS
# MySQL/MariaDB
iptables -A FORWARD -i $DMZ_IF -o $LAN_IF -p tcp -s 10.10.10.10 -d $DB_SERVER \
  --dport 3306 -m state --state NEW -j ACCEPT
# PostgreSQL
iptables -A FORWARD -i $DMZ_IF -o $LAN_IF -p tcp -s 10.10.10.10 -d $DB_SERVER \
  --dport 5432 -m state --state NEW -j ACCEPT
# SQL Server
iptables -A FORWARD -i $DMZ_IF -o $LAN_IF -p tcp -s 10.10.10.10 -d $DB_SERVER \
  --dport 1433 -m state --state NEW -j ACCEPT

# NO wildcard, NO puertos no documentados
# LOG
iptables -A FORWARD -i $DMZ_IF -o $LAN_IF -j LOG --log-prefix "DMZ-LAN-DENY: "
```

### mgmt.sh — Zona de Administración
```bash
#!/bin/bash
# Mgmt: Solo SSH desde Bastion/Jump Host

MGMT_IF="eth3"
MGMT_NET="10.10.30.0/24"
BASTION_IP="10.10.30.10"  # Bastion/Jump Host

iptables -P INPUT DROP
iptables -P FORWARD DROP

# ESTADO
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

# SSH SOLO desde Bastion
iptables -A INPUT -i $MGMT_IF -p tcp -s $BASTION_IP --dport 22 \
  -m state --state NEW -j ACCEPT

# Opcional: RDP desde Bastion (si Windows)
# iptables -A INPUT -i $MGMT_IF -p tcp -s $BASTION_IP --dport 3389 -j ACCEPT

# TODO lo demás DENEGADO + LOG
iptables -A INPUT -i $MGMT_IF -j LOG --log-prefix "MGMT-DENY: "
iptables -A FORWARD -i $MGMT_IF -j LOG --log-prefix "MGMT-FWD-DENY: "
```

### dns-proxy.sh — DNS/Proxy Chokepoint
```bash
#!/bin/bash
# DNS Resolution en DMZ + LAN Egress via Forward Proxy

DMZ_IF="eth1"
LAN_IF="eth2"
DMZ_DNS="10.10.10.20"      # DNS Server en DMZ
PROXY_IP="10.10.10.40"     # Forward Proxy en DMZ
LAN_NET="10.10.20.0/24"

# DNS: LAN → DMZ DNS (resolución centralizada)
iptables -A FORWARD -i $LAN_IF -o $DMZ_IF -p udp -d $DMZ_DNS --dport 53 -j ACCEPT
iptables -A FORWARD -i $LAN_IF -o $DMZ_IF -p tcp -d $DMZ_DNS --dport 53 -j ACCEPT

# PROXY: LAN → Forward Proxy (egress controlado)
iptables -A FORWARD -i $LAN_IF -o $DMZ_IF -p tcp -d $PROXY_IP --dport 3128 \
  -m state --state NEW -j ACCEPT

# BLOQUEAR: LAN → WAN directo (sin proxy)
iptables -A FORWARD -i $LAN_IF -o eth0 -j DROP
iptables -A FORWARD -i $LAN_IF -o eth0 -j LOG --log-prefix "LAN-WAN-DIRECT-DENY: "

# BLOQUEAR: DNS directo LAN → Internet (forzar DMZ DNS)
iptables -A FORWARD -i $LAN_IF -o eth0 -p udp --dport 53 -j DROP
iptables -A FORWARD -i $LAN_IF -o eth0 -p tcp --dport 53 -j DROP
```

## Egress Filtering — Filtrado de Salida

### Por qué bloquear LAN→WAN directo
1. **Data Exfiltration** — Malware/insiders sacando datos
2. **C2 Communications** — Beaconing a servidores de comando y control
3. **Unpatched Services** — Servicios internos expuestos inadvertidamente
4. **Compliance** — PCI DSS, NIST, ISO requieren egress controlado

### Implementación
```bash
# EN LAN firewall (egress)
# 1. Permitir SOLO al forward proxy
iptables -A FORWARD -i $LAN_IF -o $DMZ_IF -p tcp -d $PROXY_IP --dport 3128 -j ACCEPT

# 2. Permitir DNS SOLO al DMZ DNS
iptables -A FORWARD -i $LAN_IF -o $DMZ_IF -p udp -d $DMZ_DNS --dport 53 -j ACCEPT
iptables -A FORWARD -i $LAN_IF -o $DMZ_IF -p tcp -d $DMZ_DNS --dport 53 -j ACCEPT

# 3. NTP si necesario (via proxy o DMZ NTP)
# iptables -A FORWARD -i $LAN_IF -o $DMZ_IF -p udp -d $DMZ_NTP --dport 123 -j ACCEPT

# 4. DENEGAR TODO LO DEMÁS LAN → WAN
iptables -A FORWARD -i $LAN_IF -o eth0 -j DROP
iptables -A FORWARD -i $LAN_IF -o eth0 -j LOG --log-prefix "EGRESS-DENY: "
```

### Base de Datos (A1) — Sin Egress Directo
- A1 (10.10.20.10) en LAN
- **NUNCA** reglas que permitan A1 → eth0 (WAN)
- Updates de BD: via proxy forward o repositorio interno mirror
- Time sync: via NTP interno o DMZ NTP

## Validación de Reglas (Checklist)

- [ ] Default-deny en FORWARD/INPUT/OUTPUT según zona
- [ ] Reglas ESTABLISHED,RELATED primero
- [ ] Allowlisting por IP origen, IP destino, puerto, protocolo
- [ ] NO wildcards (0.0.0.0/0, any, *)
- [ ] Logging de denegaciones con prefijo único por zona
- [ ] Orden: específicas → default-deny → log
- [ ] Persistencia: iptables-save / nftables config
- [ ] Testing: `nmap -sS -p-` desde cada zona, verificar solo puertos esperados abiertos

## Referencias
- **NIST SP 800-41 Rev. 1** — Section 3.2: Default Deny Policy
- **CIS Controls v8** — Control 13.3: Automated Network Filtering
- **PCI DSS 4.0** — Req 1.2.1: Restrict inbound/outbound traffic
- **OWASP ASVS 4.0** — V13: Network Security Requirements