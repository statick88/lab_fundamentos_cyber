# Networking Cheat Sheet — CIDR, Zonas y Referencia Rápida

## Notación CIDR — Referencia Rápida

| CIDR | Máscara | Hosts Usables | Uso Común |
|------|---------|---------------|-----------|
| /32 | 255.255.255.255 | 1 | Host único (loopback, VIP) |
| /30 | 255.255.255.252 | 2 | Enlace punto-a-punto (WAN) |
| /29 | 255.255.255.248 | 6 | DMZ pequeña, VIPs |
| /28 | 255.255.255.240 | 14 | DMZ, Mgmt |
| /27 | 255.255.255.224 | 30 | DMZ, Mgmt, segmentos pequeños |
| /26 | 255.255.255.192 | 62 | LAN departamental |
| /25 | 255.255.255.128 | 126 | LAN mediana |
| /24 | 255.255.255.0 | 254 | **Estándar zona (DMZ, LAN, Mgmt)** |
| /23 | 255.255.254.0 | 510 | LAN grande |
| /22 | 255.255.252.0 | 1022 | Supernet LAN |
| /16 | 255.255.0.0 | 65534 | RFC 1918 Class B (172.16-31) |
| /8  | 255.0.0.0 | 16M+ | RFC 1918 Class A (10.x) |

### Rangos Privados RFC 1918 (Usar en Laboratorio)
```
10.0.0.0/8        → 10.0.0.0 – 10.255.255.255   (Clase A)
172.16.0.0/12     → 172.16.0.0 – 172.31.255.255 (Clase B)
192.168.0.0/16    → 192.168.0.0 – 192.168.255.255 (Clase C)
```

## Topología de Referencia — Lab 7 (ii-arquitectura-perimetral)

### Asignación de Zonas (Sugerida)

| Zona | CIDR | Gateway | Interfaz | Descripción |
|------|------|---------|----------|-------------|
| **WAN** | 203.0.113.0/24 (TEST-NET-3) | 203.0.113.1 | eth0 | Internet / ISP (simulado) |
| **DMZ** | 10.10.10.0/24 | 10.10.10.1 | eth1 | Servicios públicos |
| **LAN** | 10.10.20.0/24 | 10.10.20.1 | eth2 | Red interna corporativa |
| **Mgmt** | 10.10.30.0/24 | 10.10.30.1 | eth3 | Administración OOB |

### IPs de Servicios Clave (Ejemplo)

| Servicio | Activo | Zona | IP | Puertos |
|----------|--------|------|-----|---------|
| Web Server | A2 | DMZ | 10.10.10.10 | 80, 443 |
| DNS Público | — | DMZ | 10.10.10.20 | 53 (UDP/TCP) |
| Mail Relay | — | DMZ | 10.10.10.30 | 25, 587 |
| Forward Proxy | — | DMZ | 10.10.10.40 | 3128 |
| Database | A1 | LAN | 10.10.20.10 | 3306, 5432, 1433 |
| App Server | — | LAN | 10.10.20.20 | 8080, 8443 |
| Bastion/Jump | — | Mgmt | 10.10.30.10 | 22 |

## Comandos Útiles — Verificación Rápida

### Verificar CIDR y Rango
```bash
# ipcalc (si instalado)
ipcalc 10.10.10.0/24

# Manual con bash
cidr="10.10.10.0/24"
IFS='/' read -r ip prefix <<< "$cidr"
# Network: primer IP, Broadcast: última IP, Usables: (2^(32-prefix))-2
```

### Verificar Conectividad entre Zonas
```bash
# Desde DMZ a LAN (debe FALLAR salvo puertos app-to-DB)
nc -zv 10.10.20.10 3306   # MySQL - DEBE PASAR
nc -zv 10.10.20.10 22    # SSH - DEBE FALLAR

# Desde LAN a WAN (debe FALLAR - egress controlado)
nc -zv 8.8.8.8 53        # DNS directo - DEBE FALLAR
curl -x http://10.10.10.40:3128 http://example.com  # Via proxy - DEBE PASAR

# Desde Mgmt a LAN (SSH solo desde bastion)
ssh -J bastion@10.10.30.10 user@10.10.20.20  # DEBE PASAR
ssh user@10.10.20.20                         # DEBE FALLAR (sin jump)
```

### Verificar Reglas Firewall (iptables/nftables)
```bash
# Listar reglas FORWARD con contadores
iptables -L FORWARD -n -v --line-numbers

# Ver reglas por interfaz
iptables -L FORWARD -n -v | grep -E "(eth0|eth1|eth2|eth3)"

# Contar hits en reglas de log
grep "WAN-DMZ-DENY" /var/log/kern.log | wc -l
```

### Validar JSON topology.json
```bash
# Sintaxis
jq . topology.json

# Verificar 4 zonas
jq '.zones | length' topology.json

# Verificar campos por zona
jq '.zones[] | {name, cidr, gateway, interface}' topology.json

# Extraer zona específica
jq '.zones[] | select(.name=="DMZ")' topology.json
```

### Validar CSV placement-matrix.csv
```bash
# Ver header y filas
head -n 10 placement-matrix.csv

# Contar filas de datos (excluye header)
echo $(( $(wc -l < placement-matrix.csv) - 1 ))

# Verificar A1-A5 presentes
cut -d',' -f1 placement-matrix.csv | sort | uniq

# Ver zonas asignadas
cut -d',' -f2 placement-matrix.csv | sort | uniq
```

### Validar Archivos de Reglas zone-rules/
```bash
# Verificar default-deny en wan-dmz.sh
grep -c "DROP" zone-rules/wan-dmz.sh
grep -E "(80|443|53|25|587)" zone-rules/wan-dmz.sh

# Verificar solo puertos explícitos en dmz-lan.sh
grep -E "(3306|5432|1433)" zone-rules/dmz-lan.sh
# NO debe haber: ANY, 0.0.0.0/0, *, --dport 1:65535

# Verificar SSH solo bastion en mgmt.sh
grep "BASTION" zone-rules/mgmt.sh
grep "\-s.*22" zone-rules/mgmt.sh

# Verificar DNS/Proxy chokepoint en dns-proxy.sh
grep "DMZ_DNS" zone-rules/dns-proxy.sh
grep "PROXY" zone-rules/dns-proxy.sh
grep "eth0.*DROP" zone-rules/dns-proxy.sh
```

### Validar defense-in-depth.md
```bash
# Contar capas (buscar patrones: "Capa", "Layer", "1.", "2.", "3.")
grep -cE "(^[0-9]+\.|Capa |Layer )" defense-in-depth.md

# Debe ser >= 3
```

### Validar diagram.txt
```bash
# Verificar elementos clave
grep -i "WAN\|DMZ\|LAN\|Mgmt" diagram.txt
grep -i "trust\|boundary\|flujo\|flow" diagram.txt
```

## Puertos Comunes — Referencia

| Servicio | Puerto | Protocolo | Zona Típica |
|----------|--------|-----------|-------------|
| HTTP | 80 | TCP | DMZ |
| HTTPS | 443 | TCP | DMZ |
| DNS | 53 | UDP/TCP | DMZ |
| SMTP | 25 | TCP | DMZ |
| Submission | 587 | TCP | DMZ |
| SSH | 22 | TCP | Mgmt (bastion) |
| RDP | 3389 | TCP | Mgmt (bastion) |
| MySQL/MariaDB | 3306 | TCP | LAN (DB) |
| PostgreSQL | 5432 | TCP | LAN (DB) |
| SQL Server | 1433 | TCP | LAN (DB) |
| HTTP Proxy | 3128 | TCP | DMZ (forward proxy) |
| NTP | 123 | UDP | DMZ/LAN |
| LDAP | 389 | TCP | LAN |
| LDAPS | 636 | TCP | LAN |
| Kerberos | 88 | TCP/UDP | LAN |

## Estructura de Archivos Generados por setup.sh

```
$HOME/laboratorio/perimetral/
├── topology.json              # 4 zonas con CIDR/gateway/interface
├── placement-matrix.csv       # A1-A5 → zona (asset_id,zone)
├── zone-rules/
│   ├── wan-dmz.sh            # WAN→DMZ: default-deny + HTTP/HTTPS/DNS/SMTP
│   ├── dmz-lan.sh            # DMZ→LAN: solo app-to-DB ports
│   ├── mgmt.sh               # Mgmt: SSH solo bastion
│   └── dns-proxy.sh          # DNS en DMZ + proxy forward LAN→DMZ
├── defense-in-depth.md        # ≥3 capas documentadas
└── diagram.txt                # ASCII: zonas, flujos, trust boundaries
```

## Validación Rápida End-to-End

```bash
# 1. Generar
cd units/ii-arquitectura-perimetral && ./setup.sh

# 2. Verificar artifacts
ls -la $HOME/laboratorio/perimetral/
ls -la $HOME/laboratorio/perimetral/zone-rules/

# 3. Validar test.sh (10 retos)
./test.sh

# 4. Ver manual
./manual.sh
```

## Troubleshooting Común

| Síntoma | Causa Probable | Verificación |
|---------|----------------|--------------|
| reto1 FAIL | topology.json malformado | `jq . topology.json` |
| reto2 FAIL | CSV sin 5 filas | `wc -l placement-matrix.csv` |
| reto3 FAIL | A2/DNS/Mail no en DMZ o A1 no en LAN | `grep -E "(A1|A2)" placement-matrix.csv` |
| reto4 FAIL | wan-dmz.sh sin default-deny o allows | `grep DROP wan-dmz.sh` |
| reto5 FAIL | dmz-lan.sh con wildcard | `grep -E "(ANY|0\.0\.0\.0|/\*|1:65535)" dmz-lan.sh` |
| reto6 FAIL | mgmt.sh permite SSH no-bastion | `grep -v BASTION mgmt.sh | grep 22` |
| reto7 FAIL | A1 tiene camino a WAN | `grep -A5 -B5 "10.10.20.10" dns-proxy.sh` |
| reto8 FAIL | DNS/Proxy no en DMZ o bypass | `grep -E "(DMZ_DNS|PROXY|eth0.*DROP)" dns-proxy.sh` |
| reto9 FAIL | defense-in-depth.md < 3 capas | `grep -cE "^[0-9]+\." defense-in-depth.md` |
| reto10 FAIL | diagram.txt incompleto | `grep -i "wan\|dmz\|lan\|mgmt\|trust\|boundary" diagram.txt` |