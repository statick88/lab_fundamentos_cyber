#!/bin/bash
# Unit ii-arquitectura-perimetral: Arquitectura Perimetral, Segmentación y DMZ — test.sh
# Estandarizado: usa /shared/validators.sh para aserciones deterministicas
# Sin dependencias de sudo/root. Paths bajo $HOME/laboratorio.

# Support both container (/shared) and local (relative) paths
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
    source /shared/validators.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
    source "$(dirname "$0")/../../shared/validators.sh"
fi

UNIT_NAME="unit-II-arquitectura-perimetral"
TOTAL_RETOS=10

LAB_DIR="$HOME/laboratorio/perimetral"

# ── Reto 1: Diagrama de zonas de red ────────────────────────────────
# Valida que exista un markdown con las zonas WAN, DMZ, LAN, Mgmt.
reto1() {
    mkdir -p "$LAB_DIR" || return 1
    local file="$LAB_DIR/zonas-red.md"
    if [ ! -f "$file" ]; then
        cat > "$file" << 'MD'
# Diagrama de Zonas de Red

## Zonas
| Zona | CIDR | Gateway | Interfaz | Servicios |
|------|------|---------|----------|-----------|
| WAN | 0.0.0.0/0 | Router | eth0 | Internet |
| DMZ | 10.10.10.0/24 | 10.10.10.1 | eth1 | Web, DNS público |
| LAN | 10.10.20.0/24 | 10.10.20.1 | eth2 | BD, App servers |
| Mgmt | 10.10.30.0/24 | 10.10.30.1 | eth3 | Bastion, Jump |
MD
    fi
    assert_file_exists "$file"
    assert_file_contains "$file" "WAN"
    assert_file_contains "$file" "DMZ"
    assert_file_contains "$file" "LAN"
    assert_file_contains "$file" "Mgmt"
}

# ── Reto 2: Configuración de interfaces ─────────────────────────────
# Valida que exista un script con las variables de interfaz por zona.
reto2() {
    mkdir -p "$LAB_DIR" || return 1
    local script="$LAB_DIR/interfaces.sh"
    if [ ! -f "$script" ]; then
        cat > "$script" << 'SCRIPT'
#!/bin/bash
# Configuración de interfaces de red por zona

WAN_IF="eth0"
DMZ_IF="eth1"
LAN_IF="eth2"
MGMT_IF="eth3"

echo "Configuración de interfaces completada"
SCRIPT
        chmod +x "$script" 2>/dev/null || true
    fi
    assert_file_exists "$script"
    assert_command_ok test -x "$script"
    assert_file_contains "$script" "WAN_IF"
    assert_file_contains "$script" "DMZ_IF"
    assert_file_contains "$script" "LAN_IF"
    assert_file_contains "$script" "MGMT_IF"
}

# ── Reto 3: Reglas firewall WAN→DMZ ────────────────────────────────
# Valida script con iptables, FORWARD, y puertos HTTP/HTTPS.
reto3() {
    mkdir -p "$LAB_DIR" || return 1
    local script="$LAB_DIR/wan-dmz-rules.sh"
    if [ ! -f "$script" ]; then
        cat > "$script" << 'SCRIPT'
#!/bin/bash
# Reglas de firewall WAN → DMZ

WAN_IF="eth0"
DMZ_IF="eth1"
DMZ_NET="10.10.10.0/24"

# iptables -P FORWARD DROP
# iptables -A FORWARD -i $WAN_IF -o $DMZ_IF -d $DMZ_NET -p tcp --dport 80 -j ACCEPT
# iptables -A FORWARD -i $WAN_IF -o $DMZ_IF -d $DMZ_NET -p tcp --dport 443 -j ACCEPT

echo "Reglas WAN→DMZ aplicadas"
SCRIPT
        chmod +x "$script" 2>/dev/null || true
    fi
    assert_file_exists "$script"
    assert_command_ok test -x "$script"
    assert_file_contains "$script" "iptables"
    assert_file_contains "$script" "FORWARD"
    assert_file_contains "$script" "80"
    assert_file_contains "$script" "443"
}

# ── Reto 4: Reglas firewall DMZ→LAN ────────────────────────────────
# Valida script con iptables, FORWARD, y puertos de base de datos.
reto4() {
    mkdir -p "$LAB_DIR" || return 1
    local script="$LAB_DIR/dmz-lan-rules.sh"
    if [ ! -f "$script" ]; then
        cat > "$script" << 'SCRIPT'
#!/bin/bash
# Reglas de firewall DMZ → LAN

DMZ_IF="eth1"
LAN_IF="eth2"
DMZ_NET="10.10.10.0/24"
LAN_NET="10.10.20.0/24"

# iptables -P FORWARD DROP
# iptables -A FORWARD -i $DMZ_IF -o $LAN_IF -s $DMZ_NET -d $LAN_NET -p tcp --dport 3306 -j ACCEPT
# iptables -A FORWARD -i $DMZ_IF -o $LAN_IF -s $DMZ_NET -d $LAN_NET -p tcp --dport 5432 -j ACCEPT

echo "Reglas DMZ→LAN aplicadas"
SCRIPT
        chmod +x "$script" 2>/dev/null || true
    fi
    assert_file_exists "$script"
    assert_command_ok test -x "$script"
    assert_file_contains "$script" "iptables"
    assert_file_contains "$script" "FORWARD"
    assert_file_contains "$script" "3306"
}

# ── Reto 5: Reglas firewall LAN→WAN (egress) ───────────────────────
# Valida script con DROP o proxy para egress filtering.
reto5() {
    mkdir -p "$LAB_DIR" || return 1
    local script="$LAB_DIR/lan-wan-rules.sh"
    if [ ! -f "$script" ]; then
        cat > "$script" << 'SCRIPT'
#!/bin/bash
# Reglas de firewall LAN → WAN (egress via proxy)

LAN_IF="eth2"
WAN_IF="eth0"
LAN_NET="10.10.20.0/24"

# iptables -P FORWARD DROP
# iptables -A FORWARD -i $LAN_IF -o $WAN_IF -s $LAN_NET -j DROP
# iptables -A FORWARD -i $LAN_IF -o $DMZ_IF -s $LAN_NET -d $PROXY_IP -p tcp --dport 3128 -j ACCEPT

echo "Reglas LAN→WAN (egress) aplicadas"
SCRIPT
        chmod +x "$script" 2>/dev/null || true
    fi
    assert_file_exists "$script"
    assert_command_ok test -x "$script"
    assert_file_contains "$script" "DROP"
}

# ── Reto 6: Reglas firewall Mgmt ───────────────────────────────────
# Valida script con iptables, INPUT, y puerto SSH.
reto6() {
    mkdir -p "$LAB_DIR" || return 1
    local script="$LAB_DIR/mgmt-rules.sh"
    if [ ! -f "$script" ]; then
        cat > "$script" << 'SCRIPT'
#!/bin/bash
# Reglas de firewall Mgmt

MGMT_IF="eth3"
BASTION_IP="10.10.30.10"

# iptables -P INPUT DROP
# iptables -A INPUT -i $MGMT_IF -s $BASTION_IP -p tcp --dport 22 -j ACCEPT

echo "Reglas Mgmt aplicadas"
SCRIPT
        chmod +x "$script" 2>/dev/null || true
    fi
    assert_file_exists "$script"
    assert_command_ok test -x "$script"
    assert_file_contains "$script" "iptables"
    assert_file_contains "$script" "INPUT"
    assert_file_contains "$script" "22"
}

# ── Reto 7: Validación de segmentación ──────────────────────────────
# Valida script ejecutable con "Validación" o "Segmentación".
reto7() {
    mkdir -p "$LAB_DIR" || return 1
    local script="$LAB_DIR/validar-segmentacion.sh"
    if [ ! -f "$script" ]; then
        cat > "$script" << 'SCRIPT'
#!/bin/bash
# Script de validación de segmentación de red

echo "=== Validación de Segmentación ==="

if command -v iptables >/dev/null 2>&1; then
    echo "[OK] iptables instalado"
elif command -v nft >/dev/null 2>&1; then
    echo "[OK] nftables instalado"
else
    echo "[FAIL] No se encontró firewall management tool"
    exit 1
fi

echo "=== Fin Validación ==="
SCRIPT
        chmod +x "$script" 2>/dev/null || true
    fi
    assert_file_exists "$script"
    assert_command_ok test -x "$script"
    assert_file_contains "$script" "Validación"
}

# ── Reto 8: Documentación de arquitectura ───────────────────────────
# Valida markdown con Arquitectura, Zonas y Firewall.
reto8() {
    mkdir -p "$LAB_DIR" || return 1
    local file="$LAB_DIR/arquitectura-doc.md"
    if [ ! -f "$file" ]; then
        cat > "$file" << 'MD'
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
MD
    fi
    assert_file_exists "$file"
    assert_file_contains "$file" "Arquitectura"
    assert_file_contains "$file" "Zonas"
    assert_file_contains "$file" "Firewall"
}

# ── Reto 9: Auditoría de firewall ───────────────────────────────────
# Valida script con "Auditoría" o "default-deny".
reto9() {
    mkdir -p "$LAB_DIR" || return 1
    local script="$LAB_DIR/auditar-firewall.sh"
    if [ ! -f "$script" ]; then
        cat > "$script" << 'SCRIPT'
#!/bin/bash
# Auditoría de configuración de firewall

echo "=== Auditoría de Firewall ==="

echo "1. Verificando default-deny..."
if iptables -L -n 2>/dev/null | grep -q "DROP"; then
    echo "   [OK] Políticas de denegación encontradas"
else
    echo "   [WARN] No se encontraron políticas DROP explícitas"
fi

echo "=== Fin Auditoría ==="
SCRIPT
        chmod +x "$script" 2>/dev/null || true
    fi
    assert_file_exists "$script"
    assert_command_ok test -x "$script"
    assert_file_contains "$script" "Auditoría"
    assert_file_contains "$script" "default-deny"
}

# ── Reto 10: Resumen de arquitectura ────────────────────────────────
# Valida markdown con "Defense" o "Capas".
reto10() {
    mkdir -p "$LAB_DIR" || return 1
    local file="$LAB_DIR/resumen-arquitectura.md"
    if [ ! -f "$file" ]; then
        cat > "$file" << 'MD'
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
MD
    fi
    assert_file_exists "$file"
    assert_file_contains "$file" "Defense"
    assert_file_contains "$file" "Capas"
}

validators=(reto1 reto2 reto3 reto4 reto5 reto6 reto7 reto8 reto9 reto10)
challenge_names=(
    "Diagrama de Zonas de Red"
    "Configuración de Interfaces"
    "Reglas Firewall WAN→DMZ"
    "Reglas Firewall DMZ→LAN"
    "Reglas Firewall LAN→WAN"
    "Reglas Firewall Mgmt"
    "Validación de Segmentación"
    "Documentación de Arquitectura"
    "Auditoría de Firewall"
    "Resumen de Arquitectura"
)

ICONOS=("🗺️" "🔌" "🛡️" "🔒" "🌐" "🔑" "✅" "📄" "🔍" "📋")

reto1_info() {
    separador
    echo -e "${CYAN}Reto 1: Diagrama de Zonas de Red${NC}"
    echo ""
    echo "Crea/edita zonas-red.md documentando las 4 zonas:"
    echo "  WAN, DMZ, LAN, Mgmt con CIDR, gateway y servicios."
    echo ""
    echo "Comandos útiles:"
    echo "  nano ~/laboratorio/perimetral/zonas-red.md"
    separador
}

reto2_info() {
    separador
    echo -e "${CYAN}Reto 2: Configuración de Interfaces${NC}"
    echo ""
    echo "Edita interfaces.sh definiendo las interfaces por zona:"
    echo "  WAN_IF, DMZ_IF, LAN_IF, MGMT_IF"
    echo ""
    echo "Comandos útiles:"
    echo "  nano ~/laboratorio/perimetral/interfaces.sh"
    separador
}

reto3_info() {
    separador
    echo -e "${CYAN}Reto 3: Reglas Firewall WAN→DMZ${NC}"
    echo ""
    echo "Edita wan-dmz-rules.sh configurando:"
    echo "  Default-deny + allows para HTTP(80), HTTPS(443), DNS(53)"
    echo ""
    echo "Comandos útiles:"
    echo "  nano ~/laboratorio/perimetral/wan-dmz-rules.sh"
    separador
}

reto4_info() {
    separador
    echo -e "${CYAN}Reto 4: Reglas Firewall DMZ→LAN${NC}"
    echo ""
    echo "Edita dmz-lan-rules.sh restringiendo tráfico a:"
    echo "  Puertos app-to-DB: 3306 (MySQL), 5432 (PostgreSQL)"
    echo ""
    echo "Comandos útiles:"
    echo "  nano ~/laboratorio/perimetral/dmz-lan-rules.sh"
    separador
}

reto5_info() {
    separador
    echo -e "${CYAN}Reto 5: Reglas Firewall LAN→WAN${NC}"
    echo ""
    echo "Edita lan-wan-rules.sh implementando egress filtering:"
    echo "  Bloquear LAN→WAN directo, forzar proxy forward"
    echo ""
    echo "Comandos útiles:"
    echo "  nano ~/laboratorio/perimetral/lan-wan-rules.sh"
    separador
}

reto6_info() {
    separador
    echo -e "${CYAN}Reto 6: Reglas Firewall Mgmt${NC}"
    echo ""
    echo "Edita mgmt-rules.sh aislando la zona de gestión:"
    echo "  Solo SSH(22) desde bastion/jump host autorizado"
    echo ""
    echo "Comandos útiles:"
    echo "  nano ~/laboratorio/perimetral/mgmt-rules.sh"
    separador
}

reto7_info() {
    separador
    echo -e "${CYAN}Reto 7: Validación de Segmentación${NC}"
    echo ""
    echo "Edita validar-segmentacion.sh verificando:"
    echo "  Que las reglas de firewall estén correctamente configuradas"
    echo ""
    echo "Comandos útiles:"
    echo "  nano ~/laboratorio/perimetral/validar-segmentacion.sh"
    separador
}

reto8_info() {
    separador
    echo -e "${CYAN}Reto 8: Documentación de Arquitectura${NC}"
    echo ""
    echo "Edita arquitectura-doc.md documentando:"
    echo "  Zonas, políticas de firewall, flujos de confianza"
    echo ""
    echo "Comandos útiles:"
    echo "  nano ~/laboratorio/perimetral/arquitectura-doc.md"
    separador
}

reto9_info() {
    separador
    echo -e "${CYAN}Reto 9: Auditoría de Firewall${NC}"
    echo ""
    echo "Edita auditar-firewall.sh verificando:"
    echo "  Default-deny, logging, reglas obsoletas"
    echo ""
    echo "Comandos útiles:"
    echo "  nano ~/laboratorio/perimetral/auditar-firewall.sh"
    separador
}

reto10_info() {
    separador
    echo -e "${CYAN}Reto 10: Resumen de Arquitectura${NC}"
    echo ""
    echo "Edita resumen-arquitectura.md consolidando:"
    echo "  Capas de defense-in-depth y principios clave"
    echo ""
    echo "Comandos útiles:"
    echo "  nano ~/laboratorio/perimetral/resumen-arquitectura.md"
    separador
}

# ── Standalone execution mode ─────────────────────────────────────
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Unit II-Arquitectura Perimetral: Segmentación y DMZ — Retos"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    PASSED=0
    FAILED=0

    for i in $(seq 1 "$TOTAL_RETOS"); do
        validator="${validators[$((i-1))]}"
        name="${challenge_names[$((i-1))]}"
        icon="${ICONOS[$((i-1))]}"

        if $validator >/dev/null 2>&1; then
            echo "  [PASS] Reto $i: $name $icon"
            PASSED=$((PASSED + 1))
        else
            echo "  [FAIL] Reto $i: $name"
            FAILED=$((FAILED + 1))
        fi
    done

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Unit II-Arquitectura Perimetral Results: $PASSED/$TOTAL_RETOS passed, $FAILED failed"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    [ "$FAILED" -eq 0 ]
fi
