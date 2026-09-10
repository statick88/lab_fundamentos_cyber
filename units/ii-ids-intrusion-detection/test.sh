#!/bin/bash
# Unit II-ids: Detección de Intrusos con Suricata — test.sh

source /shared/common.sh

UNIT_NAME="unit-II-ids"
TOTAL_RETOS=3

# ── Validadores ────────────────────────────────────────────────

reto1() {
    # Verificar instalación de Suricata
    command -v suricata >/dev/null 2>&1 && \
    [ -f /etc/suricata/suricata.yaml ] && \
    suricata -T -c /etc/suricata/suricata.yaml >/dev/null 2>&1
}

reto2() {
    # Validar sintaxis de reglas personalizadas
    local rules_file="$HOME/laboratorio/ids/local.rules"
    [ -f "$rules_file" ] || return 1
    
    # Verificar que contiene al menos 3 reglas válidas
    local rule_count
    rule_count=$(grep -cE '^(alert|pass|drop|reject|sdrop)\s+' "$rules_file" 2>/dev/null || echo 0)
    [ "$rule_count" -ge 3 ] || return 1
    
    # Verificar que contiene palabras clave de detección específicas
    grep -q "SSH" "$rules_file" 2>/dev/null && \
    grep -q "SQL Injection" "$rules_file" 2>/dev/null && \
    grep -q "Port Scan" "$rules_file" 2>/dev/null
}

reto3() {
    # Verificar que existe tráfico simulado y archivo de logs
    local traffic_file="$HOME/laboratorio/ids/simulated_traffic.log"
    local logs_dir="$HOME/laboratorio/ids/suricata-logs"
    
    [ -f "$traffic_file" ] || return 1
    [ -d "$logs_dir" ] || return 1
    
    # Verificar que el tráfico simulado contiene patrones de ataque
    grep -q "UNION SELECT" "$traffic_file" 2>/dev/null && \
    grep -q "TCP SYN" "$traffic_file" 2>/dev/null
}

# ── Metadata ───────────────────────────────────────────────────

validators=(reto1 reto2 reto3)
challenge_names=(
    "Verificar instalación de Suricata"
    "Validar reglas personalizadas (local.rules)"
    "Generar y verificar alertas de tráfico"
)

ICONOS=("🔍" "📝" "⚠️")

# ── Info functions ─────────────────────────────────────────────

reto1_info() {
    separador
    echo -e "${CYAN}Reto 1: Verificar instalación de Suricata${NC}"
    echo ""
    echo "Verifica que Suricata está instalado y su configuración es válida."
    echo ""
    echo "Comandos útiles:"
    echo "  which suricata"
    echo "  suricata -V"
    echo "  suricata -T -c /etc/suricata/suricata.yaml"
    separador
}

reto2_info() {
    separador
    echo -e "${CYAN}Reto 2: Validar reglas personalizadas${NC}"
    echo ""
    echo "Crea el archivo ~/laboratorio/ids/local.rules con al menos 3 reglas:"
    echo "  - Detección de escaneo SSH"
    echo "  - Detección de SQL injection"
    echo "  - Detección de escaneo de puertos"
    echo ""
    echo "Comandos útiles:"
    echo "  nano ~/laboratorio/ids/local.rules"
    echo "  suricata -T -c /etc/suricata/suricata.yaml -S local.rules"
    separador
}

reto3_info() {
    separador
    echo -e "${CYAN}Reto 3: Generar y verificar alertas${NC}"
    echo ""
    echo "Crea un archivo de tráfico simulado que active las reglas"
    echo "y verifica que se detectan los patrones de ataque."
    echo ""
    echo "Comandos útiles:"
    echo "  nano ~/laboratorio/ids/simulated_traffic.log"
    echo "  grep 'UNION SELECT' simulated_traffic.log"
    echo "  grep 'TCP SYN' simulated_traffic.log"
    separador
}

# ── Standalone execution mode ──────────────────────────────────

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Unit II-ids: Detección de Intrusos con Suricata — Retos"
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
    echo "  Unit II-ids Results: $PASSED/$TOTAL_RETOS passed, $FAILED failed"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    [ "$FAILED" -eq 0 ]
fi
