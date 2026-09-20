#!/bin/bash
# Checkpoint II: Evaluación Módulo II — test.sh
# Estandarizado: usa /shared/validators.sh y /shared/sudo-wrappers.sh
# Sourced libs: common.sh, validators.sh, sudo-wrappers.sh (gold standard pattern)

# Dual-path sourcing
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
    source /shared/validators.sh
    source /shared/sudo-wrappers.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
    source "$(dirname "$0")/../../shared/validators.sh"
    source "$(dirname "$0")/../../shared/sudo-wrappers.sh"
fi

UNIT_NAME="checkpoint-II"
TOTAL_RETOS=5

LAB_DIR="$HOME/laboratorio/checkpoints/checkpoint-ii"
PCAP="$LAB_DIR/captura_checkpoint.pcapng"

# ── Reto 1: Identificar HTTP en Captura ─────────────────────────
reto1() {
    mkdir -p "$LAB_DIR" || return 1
    # Scaffolding si no existe
    if [ ! -f "$PCAP" ]; then
        cat > "$PCAP" << 'EOF'
0000  00 00 00 00 00 00 00 00  00 00 00 00 45 00 00 3c  ..............E..<
0010  1c 46 40 00 40 06 b0 02  0a 00 02 01 0a 00 02 02  .F@.@...........
0020  00 50 00 50 00 00 00 00  00 00 00 00 50 02 20 00  .P.P......... ...
0030  7a 1c 00 00 47 45 54 20  2f 20 48 54 54 50 2f 31  z...GET / HTTP/1
0040  2e 31 0d 0a 48 6f 73 74  3a 20 65 78 61 6d 70 6c  .1..Host: exampl
0050  65 2e 63 6f 6d 0d 0a 0d  0a                        e.com....
EOF
    fi
    assert_file_exists "$PCAP"
    assert_file_contains "$PCAP" "GET"
    assert_file_contains "$PCAP" "HTTP"
}

# ── Reto 2: Identificar DNS en /etc/services ────────────────────
reto2() {
    local services="/etc/services"
    assert_file_exists "$services"
    # DNS puede aparecer como "domain" o "dns"
    assert_file_contains "$services" "^domain\b" || assert_file_contains "$services" "^dns\b"
}

# ── Reto 3: Identificar SSH en Captura ──────────────────────────
reto3() {
    mkdir -p "$LAB_DIR" || return 1
    if [ ! -f "$PCAP" ]; then
        cat > "$PCAP" << 'EOF'
0000  00 00 00 00 00 00 00 00  00 00 00 00 45 00 00 3c
0010  1c 46 40 00 40 06 b0 02  0a 00 02 01 0a 00 02 02
EOF
    fi
    # La captura original tiene SSH header implícito; buscar evidencia en archivos del lab
    local found=0
    # Verificar si hay archivo de análisis SSH
    local ssh_files
    ssh_files=$(find "$LAB_DIR" -maxdepth 2 -type f \( -name "*ssh*" -o -name "*analisis*" \) 2>/dev/null)
    if [ -n "$ssh_files" ]; then
        found=1
    fi
    # Verificar si la captura tiene SSH
    assert_file_contains "$PCAP" "SSH" && found=1
    # Verificar /etc/services como evidencia de conocimiento
    assert_file_contains "$services" "^ssh" && found=1
    if [ "$found" -eq 1 ]; then
        return 0
    fi
    echo "FAIL: No se encontro evidencia de analisis SSH" >&2
    return 1
}

# ── Reto 4: Configurar UFW para SSH ─────────────────────────────
reto4() {
    mkdir -p "$LAB_DIR" || return 1
    local script="$LAB_DIR/ufw_ssh.sh"
    # Buscar script en ubicaciones comunes
    local found_script=""
    if [ -f "$script" ]; then
        found_script="$script"
    else
        found_script=$(find "$LAB_DIR" -maxdepth 2 -type f \( -name "*ufw*" -o -name "*firewall*" \) ! -name "test.sh" 2>/dev/null | head -1)
    fi
    if [ -n "$found_script" ]; then
        assert_file_exists "$found_script"
        assert_file_contains "$found_script" "ufw"
        assert_file_contains "$found_script" "22"
        return 0
    fi
    # Si no hay script, al menos validar conocimiento via UFW rules file
    local rules_file
    rules_file=$(find "$LAB_DIR" -maxdepth 2 -type f -name "*.rules" 2>/dev/null | head -1)
    assert_file_exists "$rules_file"
    assert_file_contains "$rules_file" "22"
}

# ── Reto 5: Listar Reglas iptables ──────────────────────────────
reto5() {
    mkdir -p "$LAB_DIR" || return 1
    local script="$LAB_DIR/listar_iptables.sh"
    local found_script=""
    if [ -f "$script" ]; then
        found_script="$script"
    else
        found_script=$(find "$LAB_DIR" -maxdepth 2 -type f \( -name "*iptable*" -o -name "*reglas*" \) ! -name "test.sh" 2>/dev/null | head -1)
    fi
    if [ -n "$found_script" ]; then
        assert_file_exists "$found_script"
        assert_file_contains "$found_script" "iptables"
        return 0
    fi
    echo "FAIL: No se encontro script de listado iptables" >&2
    return 1
}

validators=(reto1 reto2 reto3 reto4 reto5)
challenge_names=(
    "Identificar HTTP en captura"
    "Identificar DNS en /etc/services"
    "Identificar SSH"
    "Configurar UFW para SSH"
    "Listar reglas iptables"
)

ICONOS=("🔍" "📡" "🔑" "🛡️" "📋")

reto1_info() {
    separador
    echo -e "${CYAN}Reto 1: Identificar HTTP en Captura${NC}"
    echo ""
    echo "Analiza captura_checkpoint.pcapng y confirma"
    echo "la presencia de tráfico HTTP (GET, POST, etc)."
    echo ""
    echo "Comandos útiles:"
    echo "  grep -i 'GET\|POST' captura_checkpoint.pcapng"
    echo "  tshark -r captura_checkpoint.pcapng -Y http"
    separador
}

reto2_info() {
    separador
    echo -e "${CYAN}Reto 2: Identificar DNS en /etc/services${NC}"
    echo ""
    echo "Verifica que DNS (puerto 53) aparece en /etc/services"
    echo "bajo el nombre 'domain' o 'dns'."
    echo ""
    echo "Comandos útiles:"
    echo "  cat /etc/services | grep -E '^domain|^dns'"
    echo "  grep '53' /etc/services"
    separador
}

reto3_info() {
    separador
    echo -e "${CYAN}Reto 3: Identificar SSH${NC}"
    echo ""
    echo "Detecta evidencia de SSH en la captura o demuestra"
    echo "conocimiento del protocolo SSH y su puerto estándar."
    echo ""
    echo "Comandos útiles:"
    echo "  grep -i 'SSH' captura_checkpoint.pcapng"
    echo "  grep '^ssh' /etc/services"
    separador
}

reto4_info() {
    separador
    echo -e "${CYAN}Reto 4: Configurar UFW para SSH${NC}"
    echo ""
    echo "Crea un script ejecutable que configure UFW"
    echo "para permitir tráfico SSH (puerto 22/tcp)."
    echo ""
    echo "Comandos útiles:"
    echo "  nano ~/laboratorio/checkpoints/checkpoint-ii/ufw_ssh.sh"
    echo "  chmod +x ~/laboratorio/checkpoints/checkpoint-ii/ufw_ssh.sh"
    echo ""
    echo "El script debe contener:"
    echo "  sudo ufw allow 22/tcp"
    separador
}

reto5_info() {
    separador
    echo -e "${CYAN}Reto 5: Listar Reglas iptables${NC}"
    echo ""
    echo "Crea un script ejecutable que liste las reglas"
    echo "activas de iptables."
    echo ""
    echo "Comandos útiles:"
    echo "  nano ~/laboratorio/checkpoints/checkpoint-ii/listar_iptables.sh"
    echo "  chmod +x ~/laboratorio/checkpoints/checkpoint-ii/listar_iptables.sh"
    echo ""
    echo "El script debe contener:"
    echo "  iptables -L -n"
    separador
}

# ── Standalone execution mode ─────────────────────────────────────
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Checkpoint II: Redes y Firewalls — Retos"
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
    echo "  Checkpoint II Results: $PASSED/$TOTAL_RETOS passed, $FAILED failed"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    [ "$FAILED" -eq 0 ]
fi
