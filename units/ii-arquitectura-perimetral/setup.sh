#!/bin/bash
# Unit ii-arquitectura-perimetral: Arquitectura Perimetral, Segmentación y DMZ (Lab 7)
# setup.sh — Crea el entorno de laboratorio

set -e
# Support both container (/shared) and local (relative) paths
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
fi

UNIT_NAME="unit-II-arquitectura-perimetral"
export TOTAL_RETOS=10

banner_unidad 7 "Arquitectura Perimetral, Segmentación y DMZ"

echo -e "${CYAN}Esta unidad cubre: zonas de red (WAN/DMZ/LAN/Mgmt), firewalls, segmentación, DMZ.${RESET}"
echo -e "${AMARILLO}Completarás 10 retos prácticos.${RESET}\n"

mkdir -p "$HOME/laboratorio/perimetral"
cd "$HOME/laboratorio/perimetral"

# Reto 1: Diagrama de zonas de red (plantilla)
cat > zonas-red.md << 'EOF'
# Diagrama de Zonas de Red

## Zonas
| Zona | CIDR | Gateway | Interfaz | Servicios |
|------|------|---------|----------|-----------|
| WAN | <!-- ISP --> | <!-- Router --> | eth0 | Internet |
| DMZ | <!-- 10.10.10.0/24 --> | <!-- 10.10.10.1 --> | eth1 | Web, DNS público |
| LAN | <!-- 10.10.20.0/24 --> | <!-- 10.10.20.1 --> | eth2 | BD, App servers |
| Mgmt | <!-- 10.10.30.0/24 --> | <!-- 10.10.30.1 --> | eth3 | Bastion, Jump |

## Diagrama de Confianza
<!-- Dibuja las flechas de confianza entre zonas -->
EOF

# Reto 2: Configuración de interfaces (plantilla)
cat > interfaces.sh << 'SCRIPT'
#!/bin/bash
# Configuración de interfaces de red por zona
# Completar con los valores correctos

WAN_IF="eth0"
DMZ_IF="eth1"
LAN_IF="eth2"
MGMT_IF="eth3"

# Asignar IPs por zona
# ip addr add <IP>/<CIDR> dev <IFACE>
# ip link set <IFACE> up

echo "Configuración de interfaces completada"
SCRIPT
chmod +x interfaces.sh

# Reto 3: Reglas de firewall WAN→DMZ
cat > wan-dmz-rules.sh << 'SCRIPT'
#!/bin/bash
# Reglas de firewall WAN → DMZ
# Default-deny + allows explícitos para servicios públicos

WAN_IF="eth0"
DMZ_IF="eth1"
DMZ_NET="10.10.10.0/24"

# Default policy
# iptables -P FORWARD DROP

# Permitir tráfico WAN → DMZ solo para servicios públicos
# iptables -A FORWARD -i $WAN_IF -o $DMZ_IF -d $DMZ_NET -p tcp --dport 80 -j ACCEPT
# iptables -A FORWARD -i $WAN_IF -o $DMZ_IF -d $DMZ_NET -p tcp --dport 443 -j ACCEPT
# iptables -A FORWARD -i $WAN_IF -o $DMZ_IF -d $DMZ_NET -p udp --dport 53 -j ACCEPT

echo "Reglas WAN→DMZ aplicadas"
SCRIPT
chmod +x wan-dmz-rules.sh

# Reto 4: Reglas de firewall DMZ→LAN
cat > dmz-lan-rules.sh << 'SCRIPT'
#!/bin/bash
# Reglas de firewall DMZ → LAN
# Solo puertos app-to-DB específicos

DMZ_IF="eth1"
LAN_IF="eth2"
DMZ_NET="10.10.10.0/24"
LAN_NET="10.10.20.0/24"

# Default policy
# iptables -P FORWARD DROP

# Permitir DMZ → LAN solo para app-to-DB
# iptables -A FORWARD -i $DMZ_IF -o $LAN_IF -s $DMZ_NET -d $LAN_NET -p tcp --dport 3306 -j ACCEPT
# iptables -A FORWARD -i $DMZ_IF -o $LAN_IF -s $DMZ_NET -d $LAN_NET -p tcp --dport 5432 -j ACCEPT

echo "Reglas DMZ→LAN aplicadas"
SCRIPT
chmod +x dmz-lan-rules.sh

# Reto 5: Reglas de firewall LAN→WAN (egress via proxy)
cat > lan-wan-rules.sh << 'SCRIPT'
#!/bin/bash
# Reglas de firewall LAN → WAN
# NUNCA directo — siempre via proxy forward

LAN_IF="eth2"
WAN_IF="eth0"
LAN_NET="10.10.20.0/24"

# Default policy
# iptables -P FORWARD DROP

# Bloquear LAN → WAN directo
# iptables -A FORWARD -i $LAN_IF -o $WAN_IF -s $LAN_NET -j DROP

# Permitir LAN → Proxy (en DMZ o LAN border)
# iptables -A FORWARD -i $LAN_IF -o $DMZ_IF -s $LAN_NET -d $PROXY_IP -p tcp --dport 3128 -j ACCEPT

echo "Reglas LAN→WAN (egress) aplicadas"
SCRIPT
chmod +x lan-wan-rules.sh

# Reto 6: Reglas de firewall Mgmt
cat > mgmt-rules.sh << 'SCRIPT'
#!/bin/bash
# Reglas de firewall Mgmt
# Solo bastion/jump host autorizado

MGMT_IF="eth3"
BASTION_IP="10.10.30.10"

# Default policy
# iptables -P INPUT DROP
# iptables -P FORWARD DROP

# Permitir SSH solo desde bastion
# iptables -A INPUT -i $MGMT_IF -s $BASTION_IP -p tcp --dport 22 -j ACCEPT

echo "Reglas Mgmt aplicadas"
SCRIPT
chmod +x mgmt-rules.sh

# Reto 7: Script de validación de segmentación
cat > validar-segmentacion.sh << 'SCRIPT'
#!/bin/bash
# Script de validación de segmentación de red
# Verifica que las reglas de firewall estén correctamente configuradas

echo "=== Validación de Segmentación ==="

# Verificar que iptables/nftables esté instalado
if command -v iptables >/dev/null 2>&1; then
    echo "[OK] iptables instalado"
elif command -v nft >/dev/null 2>&1; then
    echo "[OK] nftables instalado"
else
    echo "[FAIL] No se encontró firewall management tool"
    exit 1
fi

# Verificar políticas default
echo "Políticas actuales:"
iptables -L -n 2>/dev/null | grep "policy" || echo "No se pudieron leer políticas"

echo "=== Fin Validación ==="
SCRIPT
chmod +x validar-segmentacion.sh

# Reto 8: Documentación de arquitectura
cat > arquitectura-doc.md << 'EOF'
# Documentación de Arquitectura Perimetral

## 1. Objetivo
Describe el propósito de la arquitectura perimetral implementada.

## 2. Zonas de Red
Documenta cada zona con su CIDR, gateway y servicios.

## 3. Políticas de Firewall
Documenta las reglas por zona y la justificación de cada allow.

## 4. Flujo de Confianza
Describe cómo fluye el tráfico entre zonas.

## 5. Referencias
- NIST SP 800-41 Rev. 1
- CIS Controls v8
EOF

# Reto 9: Script de auditoría de firewall
cat > auditar-firewall.sh << 'SCRIPT'
#!/bin/bash
# Auditoría de configuración de firewall
# Verifica best practices de seguridad

echo "=== Auditoría de Firewall ==="

# Verificar default-deny
echo "1. Verificando default-deny..."
if iptables -L -n 2>/dev/null | grep -q "DROP"; then
    echo "   [OK] Políticas de denegación encontradas"
else
    echo "   [WARN] No se encontraron políticas DROP explícitas"
fi

# Verificar logging
echo "2. Verificando logging..."
if iptables -L -n 2>/dev/null | grep -q "LOG"; then
    echo "   [OK] Logging habilitado"
else
    echo "   [WARN] Logging no configurado"
fi

echo "=== Fin Auditoría ==="
SCRIPT
chmod +x auditar-firewall.sh

# Reto 10: Resumen de arquitectura
cat > resumen-arquitectura.md << 'EOF'
# Resumen de Arquitectura Perimetral

## Capas de Defensa (Defense in Depth)
1. **Perímetro** — Firewall WAN→DMZ
2. **Segmentación Interna** — Firewall DMZ→LAN
3. **Aislamiento de Management** — Firewall Mgmt
4. **Control de Egress** — Proxy forward
5. **Endpoints** — Hardening, HIDS
6. **Datos** — Cifrado, DLP

## Principios Clave
- Default-deny en todos los firewalls
- Allowlisting explícito
- Segmentación por función
- Mínimo privilegio por zona
EOF

echo -e "${VERDE}✅ Entorno de laboratorio creado en $HOME/laboratorio/perimetral/${RESET}"
echo -e "${AMARILLO}Usa 'menu' para ver los retos disponibles${RESET}"
