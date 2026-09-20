#!/bin/bash
# Unit i-risk-assessment: Evaluación de Riesgos con matriz ISO 31000 — test.sh
# Student work is evaluated only from explicit deliverables in $HOME/laboratorio/risk-assessment.

if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
fi

UNIT_NAME="unit-i-risk-assessment"
TOTAL_RETOS=10
LAB_DIR="$HOME/laboratorio/risk-assessment"

nonspace_chars() {
    [ -f "$1" ] || { echo 0; return; }
    tr -d '[:space:]' < "$1" | wc -c | tr -d ' '
}

has_asset_ids() {
    local file="$1" asset
    [ -f "$file" ] || return 1
    for asset in A1 A2 A3 A4 A5; do
        grep -q "$asset" "$file" || return 1
    done
}

risk_matrix_rows() {
    local file="$LAB_DIR/risk_matrix.md"
    [ -f "$file" ] || { echo 0; return; }
    awk -F'|' '
        function trim(s){gsub(/^[ \t]+|[ \t]+$/, "", s); return s}
        /^\|/ {
            threat=trim($2); probability=trim($3); impact=trim($4); inherent=trim($5); controls=trim($6); residual=trim($7); treatment=trim($8)
            if (threat != "" && threat !~ /Amenaza|---/ && probability ~ /^[1-5]$/ && impact ~ /^[1-5]$/ && inherent ~ /^[0-9]+$/ && controls != "" && residual ~ /^[0-9]+$/ && treatment != "") count++
        }
        END {print count+0}
    ' "$file"
}

# Reto 1: resumen explícito del escenario elaborado por el estudiante.
reto1() {
    local file="$LAB_DIR/scenario_summary.md"
    grep -qi "DataGuard" "$file" 2>/dev/null && grep -qiE '(5|cinco)[[:space:]]+activos' "$file" && grep -qiE '(10|diez)[[:space:]]+amenazas' "$file"
}

# Reto 2: inventario propio que cubre A1-A5 y activos/amenazas.
reto2() {
    local file="$LAB_DIR/risk_inventory.md"
    has_asset_ids "$file" && grep -qi "activo" "$file" && grep -qi "amenaza" "$file"
}

# Reto 3: el resumen debe documentar las amenazas del caso, no la referencia.
reto3() {
    local file="$LAB_DIR/scenario_summary.md"
    grep -qi "DataGuard" "$file" 2>/dev/null && grep -qiE '(10|diez)[[:space:]]+amenazas' "$file"
}

# Retos 4, 5 y 8: matriz entregada por el estudiante.
reto4() { [ "$(risk_matrix_rows)" -ge 5 ]; }
reto5() { [ "$(risk_matrix_rows)" -ge 5 ]; }
reto8() {
    local file="$LAB_DIR/residual_risk.md"
    grep -qi "inherente" "$file" 2>/dev/null && grep -qi "residual" "$file" && grep -qiE '(cálcul|calculo|probabilidad|impacto|[0-9]+[[:space:]]*\*)' "$file"
}

# Reto 6: tres niveles con amenazas asignadas en un archivo de estudiante.
reto6() {
    local file="$LAB_DIR/risk_levels.md" level count=0
    [ -f "$file" ] || return 1
    for level in bajo low medio medium alto high crítico critical; do
        if grep -qiE "$level.*[A-Za-zÁÉÍÓÚáéíóú]" "$file"; then
            count=$((count + 1))
        fi
    done
    [ "$count" -ge 3 ]
}

# Reto 7: tres tratamientos que incluyen controles y justificación.
reto7() {
    local file="$LAB_DIR/treatment_plan.md"
    [ -f "$file" ] || return 1
    [ "$(grep -icE '(^[-*]|^\|).*(mitigar|transferir|aceptar|evitar|tratamiento)' "$file")" -ge 3 ] && grep -qiE 'control|mfa|rbac|cifrado|backup|monitoreo' "$file" && grep -qi 'justific' "$file"
}

# Reto 9: justificación económica propia y sustantiva.
reto9() {
    local file="$LAB_DIR/economic_justification.md"
    [ "$(nonspace_chars "$file")" -ge 120 ] && grep -qiE 'costo|coste' "$file" && grep -qiE 'reducci[oó]n' "$file" && grep -qi 'riesgo' "$file"
}

# Reto 10: seguimiento explícito; no se aceptan archivos de plantilla o fixtures.
reto10() {
    local file
    for file in "$LAB_DIR/seguimiento.md" "$LAB_DIR/followup_plan.md"; do
        if [ "$(nonspace_chars "$file")" -ge 120 ]; then
            return 0
        fi
    done
    return 1
}

validators=(reto1 reto2 reto3 reto4 reto5 reto6 reto7 reto8 reto9 reto10)
challenge_names=(
    "Documentar el resumen del escenario"
    "Inventariar A1-A5 y sus amenazas"
    "Documentar al menos 10 amenazas"
    "Completar matriz probabilidad × impacto"
    "Asignar niveles de riesgo en la matriz"
    "Clasificar riesgos por nivel"
    "Definir tres tratamientos justificados"
    "Calcular riesgo inherente y residual"
    "Generar justificación económica"
    "Documentar plan de seguimiento"
)
ICONOS=("📋" "🏢" "⚠️" "📊" "🎯" "🏷️" "🔧" "🔢" "💰" "📅")

reto1_info() { separador; echo -e "${CYAN}Reto 1: Resume el caso en scenario_summary.md${NC}"; echo "Consulta fixtures/escenario.json y entrega scenario_summary.md con DataGuard, 5 activos y 10 amenazas."; separador; }
reto2_info() { separador; echo -e "${CYAN}Reto 2: Crea risk_inventory.md${NC}"; echo "Documenta A1-A5, los activos y sus amenazas; fixtures/escenario.json es solo referencia."; separador; }
reto3_info() { separador; echo -e "${CYAN}Reto 3: Documenta las amenazas${NC}"; echo "Actualiza scenario_summary.md con al menos 10 amenazas del caso."; separador; }
reto4_info() { separador; echo -e "${CYAN}Reto 4: Crea risk_matrix.md${NC}"; echo "Incluye al menos 5 filas completas: probabilidad, impacto, inherente, controles, residual y tratamiento."; separador; }
reto5_info() { separador; echo -e "${CYAN}Reto 5: Asigna niveles en risk_matrix.md${NC}"; echo "Completa las filas de la matriz con su nivel/tratamiento."; separador; }
reto6_info() { separador; echo -e "${CYAN}Reto 6: Crea risk_levels.md${NC}"; echo "Asigna amenazas a por lo menos tres niveles (bajo, medio, alto o crítico)."; separador; }
reto7_info() { separador; echo -e "${CYAN}Reto 7: Crea treatment_plan.md${NC}"; echo "Define tres tratamientos con controles y justificación."; separador; }
reto8_info() { separador; echo -e "${CYAN}Reto 8: Crea residual_risk.md${NC}"; echo "Documenta los cálculos de riesgo inherente y residual."; separador; }
reto9_info() { separador; echo -e "${CYAN}Reto 9: Crea economic_justification.md${NC}"; echo "Explica costo, reducción y riesgo en al menos 120 caracteres no vacíos."; separador; }
reto10_info() { separador; echo -e "${CYAN}Reto 10: Crea seguimiento.md o followup_plan.md${NC}"; echo "Documenta el seguimiento en al menos 120 caracteres no vacíos."; separador; }

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  i-risk-assessment: Evaluación de Riesgos ISO 31000 — Retos"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    PASSED=0; FAILED=0
    for i in $(seq 1 "$TOTAL_RETOS"); do
        validator="${validators[$((i-1))]}"; name="${challenge_names[$((i-1))]}"; icon="${ICONOS[$((i-1))]}"
        if "$validator" >/dev/null 2>&1; then echo "  [PASS] Reto $i: $name $icon"; PASSED=$((PASSED + 1)); else echo "  [FAIL] Reto $i: $name"; FAILED=$((FAILED + 1)); fi
    done
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  i-risk-assessment Results: $PASSED/$TOTAL_RETOS passed, $FAILED failed"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    [ "$FAILED" -eq 0 ]
fi
