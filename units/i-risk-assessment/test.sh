#!/bin/bash
# Unit i-risk-assessment: Evaluación de Riesgos con matriz ISO 31000 — test.sh
# 10 retos CORE: escenario, matriz, tratamientos, justificación

# Dual-path sourcing
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
fi

UNIT_NAME="unit-i-risk-assessment"
TOTAL_RETOS=10

LAB_DIR="$HOME/laboratorio/risk-assessment"

trim_field() {
    local value="$1"
    value="${value#${value%%[![:space:]]*}}"
    value="${value%${value##*[![:space:]]}}"
    printf '%s' "$value"
}

risk_table_completed_rows() {
    local template="$LAB_DIR/plantilla-analisis.md"
    [ -f "$template" ] || { echo 0; return; }
    awk -F'|' '
        function trim(s){gsub(/^[ \t]+|[ \t]+$/, "", s); return s}
        /^\|/ {
            amenaza=trim($2); prob=trim($3); impacto=trim($4); inherente=trim($5); controles=trim($6); residual=trim($7); tratamiento=trim($8);
            if (amenaza != "" && amenaza !~ /Amenaza|---/ && prob ~ /^[1-5]$/ && impacto ~ /^[1-5]$/ && inherente ~ /^[0-9]+$/ && controles != "" && residual ~ /^[0-9]+$/ && tratamiento != "") count++;
        }
        END {print count+0}
    ' "$template"
}

risk_table_rows_with_treatment() {
    local template="$LAB_DIR/plantilla-analisis.md"
    [ -f "$template" ] || { echo 0; return; }
    awk -F'|' '
        function trim(s){gsub(/^[ \t]+|[ \t]+$/, "", s); return s}
        /^\|/ {
            amenaza=trim($2); tratamiento=trim($8); controles=trim($6);
            if (amenaza != "" && amenaza !~ /Amenaza|---/ && controles != "" && tratamiento != "") count++;
        }
        END {print count+0}
    ' "$template"
}

section_body_chars() {
    local file="$1" heading_regex="$2"
    [ -f "$file" ] || { echo 0; return; }
    awk -v h="$heading_regex" '
        $0 ~ h {inside=1; next}
        inside && /^## / {inside=0}
        inside {gsub(/[[:space:]]/, ""); n += length($0)}
        END {print n+0}
    ' "$file"
}

# ── Reto 1: Verificar existencia del escenario ─────────────────
reto1() {
    local scenario="$LAB_DIR/escenario.json"
    if [ ! -f "$scenario" ]; then
        echo "FAIL: escenario.json no existe en $LAB_DIR" >&2
        return 1
    fi
    # Verificar que contiene la empresa
    grep -q "DataGuard" "$scenario" 2>/dev/null || grep -q "empresa" "$scenario" 2>/dev/null
}

# ── Reto 2: Validar que el escenario tiene 5 activos ───────────
reto2() {
    local scenario="$LAB_DIR/escenario.json"
    if [ ! -f "$scenario" ]; then
        echo "FAIL: escenario.json no existe" >&2
        return 1
    fi
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
    if [ ! -f "$scenario" ]; then
        echo "FAIL: escenario.json no existe" >&2
        return 1
    fi
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
    local rows
    rows=$(risk_table_completed_rows)
    if [ "$rows" -ge 5 ]; then
        return 0
    fi
    echo "FAIL: Tabla de probabilidad × impacto no completada por el estudiante ($rows/5 filas completas)" >&2
    return 1
}

# ── Reto 5: Asignar nivel de riesgo a cada amenaza ────────────
reto5() {
    local rows
    rows=$(risk_table_completed_rows)
    if [ "$rows" -ge 5 ]; then
        return 0
    fi
    echo "FAIL: Niveles de riesgo no asignados en la matriz completada ($rows/5 filas completas)" >&2
    return 1
}

# ── Reto 6: Clasificar riesgos por nivel (Bajo/Medio/Alto/Crítico) ──
reto6() {
    local template="$LAB_DIR/plantilla-analisis.md"
    if [ ! -f "$template" ]; then
        echo "FAIL: plantilla-analisis.md no existe" >&2
        return 1
    fi
    local filled_levels
    filled_levels=$(awk -F'|' '
        function trim(s){gsub(/^[ \t]+|[ \t]+$/, "", s); return s}
        /^\|[[:space:]]*(BAJO|MEDIO|ALTO|CR/ { amenazas=trim($4); if (amenazas != "") count++ }
        END {print count+0}
    ' "$template")
    if [ "$filled_levels" -ge 3 ]; then
        return 0
    fi
    echo "FAIL: Clasificación de niveles de riesgo sin amenazas asignadas ($filled_levels/3 niveles mínimos)" >&2
    return 1
}

# ── Reto 7: Definir tratamiento para al menos 3 amenazas ──────
reto7() {
    local rows
    rows=$(risk_table_rows_with_treatment)
    if [ "$rows" -ge 3 ]; then
        return 0
    fi
    echo "FAIL: Tratamientos/controles del estudiante insuficientes ($rows/3 amenazas)" >&2
    return 1
}

# ── Reto 8: Calcular riesgo inherente y residual ──────────────
reto8() {
    local rows
    rows=$(risk_table_completed_rows)
    if [ "$rows" -ge 5 ]; then
        return 0
    fi
    echo "FAIL: Cálculos de riesgo inherente/residual incompletos ($rows/5 filas completas)" >&2
    return 1
}

# ── Reto 9: Generar justificación económica ────────────────────
reto9() {
    local template="$LAB_DIR/plantilla-analisis.md"
    local chars
    chars=$(section_body_chars "$template" '^## Justificación económica')
    if [ "$chars" -ge 120 ]; then
        return 0
    fi
    echo "FAIL: Justificación económica sin desarrollo propio suficiente (${chars}/120 caracteres no vacíos)" >&2
    return 1
}

# ── Reto 10: Documentar plan de seguimiento ────────────────────
reto10() {
    local followup
    followup=$(find "$LAB_DIR" -maxdepth 1 -type f ! -name "plantilla-*" \( -name "*seguimiento*" -o -name "*tracking*" -o -name "*plan*" \) 2>/dev/null | head -1)
    if [ -n "$followup" ] && [ -f "$followup" ]; then
        local chars
        chars=$(tr -d '[:space:]' < "$followup" 2>/dev/null | wc -c | tr -d ' ')
        if [ "$chars" -ge 120 ]; then
            return 0
        fi
    fi

    local template="$LAB_DIR/plantilla-analisis.md"
    local chars
    chars=$(section_body_chars "$template" '^## Plan de seguimiento|^## Seguimiento')
    if [ "$chars" -ge 120 ]; then
        return 0
    fi

    echo "FAIL: Plan de seguimiento no documentado con desarrollo suficiente" >&2
    return 1
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
