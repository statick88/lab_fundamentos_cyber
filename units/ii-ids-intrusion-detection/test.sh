#!/bin/bash
# Unit II-ids: Detección de Intrusos con Suricata — test.sh
# 3 retos CORE: Suricata install/status, local.rules validation, alert generation

# Dual-path sourcing
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
fi

UNIT_NAME="unit-II-ids"
TOTAL_RETOS=3

LAB_DIR="$HOME/laboratorio/ids"

# ── Reto 1: Verificar instalación y estado de Suricata ──────────
# Valida que Suricata esté instalado y el binario funcione.
reto1() {
    # Verificar que suricata existe como comando
    if ! command -v suricata >/dev/null 2>&1; then
        echo "FAIL: suricata no encontrado en PATH" >&2
        return 1
    fi
    # Verificar que el binario ejecuta correctamente (con -V para versión)
    local ver_output
    ver_output=$(suricata -V 2>&1 || true)
    if echo "$ver_output" | grep -qi "suricata"; then
        return 0
    fi
    echo "FAIL: suricata instalado pero no responde correctamente" >&2
    return 1
}

# ── Reto 2: Validar reglas personalizadas (local.rules) ─────────
# Valida que exista local.rules con las 3 reglas de detección.
reto2() {
    local rules_file="$LAB_DIR/local.rules"
    if [ ! -f "$rules_file" ]; then
        echo "FAIL: $rules_file no existe" >&2
        return 1
    fi
    # Verificar presencia de las 3 reglas (sid:1000001, sid:1000002, sid:1000003)
    local has_ssh=0 has_sqli=0 has_portscan=0
    grep -q "sid:1000001" "$rules_file" 2>/dev/null && has_ssh=1
    grep -q "sid:1000002" "$rules_file" 2>/dev/null && has_sqli=1
    grep -q "sid:1000003" "$rules_file" 2>/dev/null && has_portscan=1

    if [ "$has_ssh" -eq 1 ] && [ "$has_sqli" -eq 1 ] && [ "$has_portscan" -eq 1 ]; then
        return 0
    fi
    echo "FAIL: local.rules incompleto (faltan reglas SSH=$has_ssh SQLi=$has_sqli PortScan=$has_portscan)" >&2
    return 1
}

# ── Reto 3: Generar y verificar alertas ─────────────────────────
# Valida que existan logs de alertas generados por Suricata.
reto3() {
    # Verificar que exista el directorio de logs
    local log_dir="$LAB_DIR/suricata-logs"
    if [ ! -d "$log_dir" ]; then
        echo "FAIL: Directorio de logs $log_dir no existe" >&2
        return 1
    fi
    # Verificar que exista fast.log con contenido de alertas
    local fast_log="$log_dir/fast.log"
    if [ -f "$fast_log" ] && [ -s "$fast_log" ]; then
        return 0
    fi
    # Alternativa: verificar que simulated_traffic.log existe como evidencia
    # de que el estudiante procesó tráfico
    if [ -f "$LAB_DIR/simulated_traffic.log" ]; then
        # Verificar que hay evidencia de análisis
        local alert_files
        alert_files=$(find "$log_dir" -type f -name "*.log" -o -name "*.json" 2>/dev/null)
        if [ -n "$alert_files" ]; then
            return 0
        fi
    fi
    echo "FAIL: No se encontraron alertas generadas en $log_dir" >&2
    return 1
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
