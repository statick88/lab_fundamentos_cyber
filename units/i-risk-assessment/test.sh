#!/bin/bash
# Unit i-risk-assessment: Evaluación de Riesgos con matriz ISO 31000 — test.sh
# 10 retos CORE: escenario, matriz, tratamientos, justificación
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

UNIT_NAME="unit-i-risk-assessment"
TOTAL_RETOS=10

LAB_DIR="$HOME/laboratorio/risk-assessment"

# ── Reto 1: Verificar existencia del escenario ─────────────────
reto1() {
    local scenario="$LAB_DIR/escenario.json"
    assert_file_exists "$scenario"
    # Verificar que contiene la empresa
    assert_file_contains "$scenario" "DataGuard" || assert_file_contains "$scenario" "empresa"
}

# ── Reto 2: Validar que el escenario tiene 5 activos ───────────
reto2() {
    local scenario="$LAB_DIR/escenario.json"
    assert_file_exists "$scenario"
    # Contar IDs de activos (A1-A5)
    local count
    count=$(grep -o '"id": "A[1-5]"' "$scenario" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$count" -ge 5 ]; then
        return 0
    fi
    echo "FAIL: Solo $count activos encontrados (se esperan 5)" >&2
    return 1
}

# ── Reto 3: Verificar amenazas para cada activo ────────────────
reto3() {
    local scenario="$LAB_DIR/escenario.json"
    assert_file_exists "$scenario"
    # Verificar que cada activo tiene al menos 1 amenaza
    local threats
    threats=$(grep -c '"nombre"' "$scenario" 2>/dev/null || echo 0)
    if [ "$threats" -ge 10 ]; then
        return 0
    fi
    echo "FAIL: Solo $threats amenazas encontradas (se esperan al menos 10)" >&2
    return 1
}

# ── Reto 4: Completar tabla de probabilidad × impacto ──────────
reto4() {
    # Verificar que existe la plantilla o un archivo de análisis completado
    local template="$LAB_DIR/plantilla-analisis.md"
    assert_file_exists "$template" || {
        # Buscar archivo de análisis alternativo
        local analysis
        analysis=$(find "$LAB_DIR" -maxdepth 1 -type f -name "*analisis*" -o -name "*matrix*" -o -name "*matriz*" 2>/dev/null | head -1)
        assert_file_exists "$analysis"
        return 0
    }
    # Verificar que tiene datos más allá del template
    local filled
    filled=$(grep -c '|.*|.*|.*|' "$template" 2>/dev/null || echo 0)
    if [ "$filled" -gt 5 ]; then
        return 0
    fi
    echo "FAIL: Tabla de probabilidad × impacto no completada" >&2
    return 1
}

# ── Reto 5: Asignar nivel de riesgo a cada amenaza ────────────
reto5() {
    local scenario="$LAB_DIR/escenario.json"
    assert_file_exists "$scenario"
    # Verificar que hay scores de probabilidad (1-5) e impacto (1-5)
    local probs
    probs=$(grep -o '"probabilidad": [1-5]' "$scenario" 2>/dev/null | wc -l | tr -d ' ')
    local impacts
    impacts=$(grep -o '"impacto": [1-5]' "$scenario" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$probs" -ge 5 ] && [ "$impacts" -ge 5 ]; then
        return 0
    fi
    echo "FAIL: Probabilidades ($probs) o impactos ($impacts) insuficientes" >&2
    return 1
}

# ── Reto 6: Clasificar riesgos por nivel (Bajo/Medio/Alto/Crítico) ──
reto6() {
    local template="$LAB_DIR/plantilla-analisis.md"
    assert_file_contains "$template" "BAJO\|MEDIO\|ALTO\|CRÍTICO\|CRITICO" || {
        # Buscar archivos de clasificación
        local classified
        classified=$(find "$LAB_DIR" -maxdepth 1 -type f \( -name "*clasif*" -o -name "*nivel*" \) 2>/dev/null | head -1)
        assert_file_exists "$classified"
        return 0
    }
    return 0
}

# ── Reto 7: Definir tratamiento para al menos 3 amenazas ──────
reto7() {
    local scenario="$LAB_DIR/escenario.json"
    assert_file_exists "$scenario"
    # Verificar que hay controles definidos para al menos 3 amenazas
    local controls
    controls=$(grep -c '"controles"' "$scenario" 2>/dev/null || echo 0)
    if [ "$controls" -ge 3 ]; then
        return 0
    fi
    echo "FAIL: Solo $controls amenazas con controles (se esperan al menos 3)" >&2
    return 1
}

# ── Reto 8: Calcular riesgo inherente y residual ──────────────
reto8() {
    local template="$LAB_DIR/plantilla-analisis.md"
    assert_file_exists "$template"
    if grep -qi "inherente\|residual" "$template" 2>/dev/null; then
        return 0
    fi
    # Buscar archivos con cálculos de riesgo
    local risk_files
    risk_files=$(find "$LAB_DIR" -maxdepth 1 -type f \( -name "*risk*" -o -name "*riesgo*" \) 2>/dev/null | head -1)
    assert_file_exists "$risk_files"
    return 0
}

# ── Reto 9: Generar justificación económica ────────────────────
reto9() {
    local template="$LAB_DIR/plantilla-analisis.md"
    assert_file_exists "$template"
    if grep -qi "costo\|económico\|inversión\|ROI" "$template" 2>/dev/null; then
        return 0
    fi
    # Buscar archivos de justificación
    local econ_files
    econ_files=$(find "$LAB_DIR" -maxdepth 1 -type f \( -name "*costo*" -o -name "*econom*" -o -name "*justif*" \) 2>/dev/null | head -1)
    assert_file_exists "$econ_files"
    return 0
}

# ── Reto 10: Documentar plan de seguimiento ────────────────────
reto10() {
    # Verificar que existe documentación de seguimiento
    local followup
    followup=$(find "$LAB_DIR" -maxdepth 1 -type f \( -name "*seguimiento*" -o -name "*tracking*" -o -name "*plan*" \) 2>/dev/null | head -1)
    assert_file_exists "$followup" || {
        # Verificar que la plantilla tiene sección de seguimiento
        local template="$LAB_DIR/plantilla-analisis.md"
        assert_file_exists "$template"
        assert_file_contains "$template" "seguimiento\|tracking\|monitoreo\|revisión"
    }
}

validators=(reto1 reto2 reto3 reto4 reto5 reto6 reto7 reto8 reto9 reto10)
challenge_names=(
    "Verificar existencia del escenario"
    "Validar 5 activos en el escenario"
    "Verificar amenazas para cada activo"
    "Completar tabla probabilidad × impacto"
    "Asignar nivel de riesgo a cada amenaza"
    "Clasificar riesgos por nivel"
    "Definir tratamiento para al menos 3 amenazas"
    "Calcular riesgo inherente y residual"
    "Generar justificación económica"
    "Documentar plan de seguimiento"
)

ICONOS=("📋" "🏢" "⚠️" "📊" "🎯" "🏷️" "🔧" "🔢" "💰" "📅")

reto1_info() {
    separador
    echo -e "${CYAN}Reto 1: Verificar existencia del escenario${NC}"
    echo ""
    echo "Comprueba que escenario.json existe y contiene la empresa DataGuard."
    echo ""
    echo "Comandos útiles:"
    echo "  cat ~/laboratorio/risk-assessment/escenario.json"
    separador
}

reto2_info() {
    separador
    echo -e "${CYAN}Reto 2: Validar 5 activos en el escenario${NC}"
    echo ""
    echo "Verifica que el escenario contiene 5 activos (A1-A5)."
    echo ""
    echo "Comandos útiles:"
    echo "  grep '\"id\": \"A' escenario.json | wc -l"
    separador
}

reto3_info() {
    separador
    echo -e "${CYAN}Reto 3: Verificar amenazas para cada activo${NC}"
    echo ""
    echo "Cada activo debe tener al menos 1 amenaza definida."
    echo ""
    echo "Comandos útiles:"
    echo "  grep '\"nombre\"' escenario.json | wc -l"
    separador
}

reto4_info() {
    separador
    echo -e "${CYAN}Reto 4: Completar tabla probabilidad × impacto${NC}"
    echo ""
    echo "Completa la matriz de probabilidad e impacto para cada amenaza."
    echo ""
    echo "Comandos útiles:"
    echo "  nano ~/laboratorio/risk-assessment/plantilla-analisis.md"
    separador
}

reto5_info() {
    separador
    echo -e "${CYAN}Reto 5: Asignar nivel de riesgo a cada amenaza${NC}"
    echo ""
    echo "Asigna nivel (Bajo/Medio/Alto/Crítico) a cada amenaza."
    echo ""
    echo "Comandos útiles:"
    echo "  cat ~/laboratorio/risk-assessment/plantilla-analisis.md"
    separador
}

reto6_info() {
    separador
    echo -e "${CYAN}Reto 6: Clasificar riesgos por nivel${NC}"
    echo ""
    echo "Clasifica todas las amenazas en niveles de riesgo."
    echo ""
    echo "Comandos útiles:"
    echo "  nano ~/laboratorio/risk-assessment/clasificacion.md"
    separador
}

reto7_info() {
    separador
    echo -e "${CYAN}Reto 7: Definir tratamiento para al menos 3 amenazas${NC}"
    echo ""
    echo "Para al menos 3 amenazas, define tratamiento."
    echo ""
    echo "Comandos útiles:"
    echo "  nano ~/laboratorio/risk-assessment/tratamientos.md"
    separador
}

reto8_info() {
    separador
    echo -e "${CYAN}Reto 8: Calcular riesgo inherente y residual${NC}"
    echo ""
    echo "Calcula riesgo inherente y residual para cada amenaza."
    echo ""
    echo "Comandos útiles:"
    echo "  nano ~/laboratorio/risk-assessment/calculos.md"
    separador
}

reto9_info() {
    separador
    echo -e "${CYAN}Reto 9: Generar justificación económica${NC}"
    echo ""
    echo "Documenta la justificación económica de cada tratamiento."
    echo ""
    echo "Comandos útiles:"
    echo "  nano ~/laboratorio/risk-assessment/economia.md"
    separador
}

reto10_info() {
    separador
    echo -e "${CYAN}Reto 10: Documentar plan de seguimiento${NC}"
    echo ""
    echo "Crea un plan de seguimiento para los riesgos."
    echo ""
    echo "Comandos útiles:"
    echo "  nano ~/laboratorio/risk-assessment/seguimiento.md"
    separador
}

# ── Standalone execution mode ─────────────────────────────────────
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  i-risk-assessment: Evaluación de Riesgos ISO 31000 — Retos"
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
    echo "  i-risk-assessment Results: $PASSED/$TOTAL_RETOS passed, $FAILED failed"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    [ "$FAILED" -eq 0 ]
fi
