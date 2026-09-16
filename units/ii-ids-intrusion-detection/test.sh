#!/bin/bash
# Unit II-ids: Detección de Intrusos con Suricata — test.sh
# 3 retos OPT: Suricata install/status, local.rules validation, alert generation
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

UNIT_NAME="unit-II-ids"
TOTAL_RETOS=3

LAB_DIR="$HOME/laboratorio/ids"

# ── Reto 1: Verificar instalación y estado de Suricata ──────────
reto1() {
    assert_command_ok suricata -V
}

# ── Reto 2: Validar reglas personalizadas (local.rules) ─────────
reto2() {
    local rules_file="$LAB_DIR/local.rules"
    assert_file_exists "$rules_file"
    assert_file_contains "$rules_file" "sid:1000001"
    assert_file_contains "$rules_file" "sid:1000002"
    assert_file_contains "$rules_file" "sid:1000003"
}

# ── Reto 3: Generar y verificar alertas ─────────────────────────
reto3() {
    local log_dir="$LAB_DIR/suricata-logs"
    assert_file_exists "$log_dir/fast.log"
}

validators=(reto1 reto2 reto3)
challenge_names=(
    "Verificar instalación y estado de Suricata"
    "Validar reglas personalizadas (local.rules)"
    "Generar y verificar alertas"
)

ICONOS=("🔧" "📜" "🚨")

reto1_info() {
    separador
    echo -e "${CYAN}Reto 1: Verificar instalación y estado de Suricata${NC}"
    echo ""
    echo "Comprueba que Suricata esté instalado, el binario existe,"
    echo "y la configuración es válida."
    echo ""
    echo "Comandos útiles:"
    echo "  suricata -V              — verificar versión"
    echo "  which suricata           — ubicación del binario"
    echo "  suricata -T -c /etc/suricata/suricata.yaml — validar config"
    separador
}

reto2_info() {
    separador
    echo -e "${CYAN}Reto 2: Validar reglas personalizadas (local.rules)${NC}"
    echo ""
    echo "Verifica que local.rules contenga las 3 reglas de detección:"
    echo "  - sid:1000001 — Escaneo SSH"
    echo "  - sid:1000002 — SQL Injection"
    echo "  - sid:1000003 — Escaneo de puertos"
    echo ""
    echo "Comandos útiles:"
    echo "  cat ~/laboratorio/ids/local.rules"
    echo "  grep 'sid:1000001' ~/laboratorio/ids/local.rules"
    separador
}

reto3_info() {
    separador
    echo -e "${CYAN}Reto 3: Generar y verificar alertas${NC}"
    echo ""
    echo "Simula tráfico de red que active las reglas y verifica"
    echo "que se generan alertas en /var/log/suricata/fast.log"
    echo ""
    echo "Comandos útiles:"
    echo "  suricata -S local.rules -l suricata-logs/"
    echo "  cat suricata-logs/fast.log"
    separador
}

# ── Standalone execution mode ─────────────────────────────────────
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  II-ids: Detección de Intrusos con Suricata — Retos"
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
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  II-ids Results: $PASSED/$TOTAL_RETOS passed, $FAILED failed"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    [ "$FAILED" -eq 0 ]
fi
