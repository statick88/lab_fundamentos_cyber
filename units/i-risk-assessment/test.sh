#!/bin/bash
# Unit: i-risk-assessment — Evaluación de Riesgos con matriz ISO 31000 (Lab 2)
# Standard pattern: defines retoN() validators + retoN_info() for menu-driven execution

source /shared/common.sh
source /shared/validators.sh

UNIT_NAME="unit-i-risk-assessment"
TOTAL_RETOS=10

# Pure validators - no user interaction, check system state only

reto1() {
    # Verificar que el escenario JSON existe y es válido
    local esc="$HOME/laboratorio/risk-assessment/escenario.json"
    [ -f "$esc" ] || return 1
    command -v jq >/dev/null 2>&1 || return 1
    jq -e '.activos | length' "$esc" >/dev/null 2>&1
}

reto2() {
    # Verificar que la plantilla de análisis existe
    assert_file_exists "$HOME/laboratorio/risk-assessment/plantilla-analisis.md"
}

reto3() {
    # Verificar que el escenario tiene exactamente 5 activos
    local esc="$HOME/laboratorio/risk-assessment/escenario.json"
    [ -f "$esc" ] || return 1
    [ "$(jq '.activos | length' "$esc" 2>/dev/null)" = "5" ]
}

reto4() {
    # Verificar que cada activo tiene al menos una amenaza
    local esc="$HOME/laboratorio/risk-assessment/escenario.json"
    [ -f "$esc" ] || return 1
    # jq -e returns 4 (no match) when no asset has <1 threat — that's the pass case
    local out
    out=$(jq -e '.activos[] | select((.amenazas | length) < 1) | .id' "$esc" 2>/dev/null) && return 1
    [ -z "$out" ]
}

reto5() {
    # Verificar que A1 (Servidor BD) tiene criticidad 'alta'
    local esc="$HOME/laboratorio/risk-assessment/escenario.json"
    [ -f "$esc" ] || return 1
    jq -e '.activos[] | select(.id=="A1") | select(.criticidad=="alta")' "$esc" >/dev/null 2>&1
}

reto6() {
    # Verificar que A4 (laptop) tiene criticidad 'baja'
    local esc="$HOME/laboratorio/risk-assessment/escenario.json"
    [ -f "$esc" ] || return 1
    jq -e '.activos[] | select(.id=="A4") | select(.criticidad=="baja")' "$esc" >/dev/null 2>&1
}

reto7() {
    # Verificar que A5 (DRP) tiene criticidad 'alta'
    local esc="$HOME/laboratorio/risk-assessment/escenario.json"
    [ -f "$esc" ] || return 1
    jq -e '.activos[] | select(.id=="A5") | select(.criticidad=="alta")' "$esc" >/dev/null 2>&1
}

reto8() {
    # Verificar que A2 (nginx) tiene criticidad 'media'
    local esc="$HOME/laboratorio/risk-assessment/escenario.json"
    [ -f "$esc" ] || return 1
    jq -e '.activos[] | select(.id=="A2") | select(.criticidad=="media")' "$esc" >/dev/null 2>&1
}

reto9() {
    # Verificar que A3 (red) tiene criticidad 'alta'
    local esc="$HOME/laboratorio/risk-assessment/escenario.json"
    [ -f "$esc" ] || return 1
    jq -e '.activos[] | select(.id=="A3") | select(.criticidad=="alta")' "$esc" >/dev/null 2>&1
}

reto10() {
    # Verificar que la suma de probabilidad×impacto es calculable (jq evalúa)
    local esc="$HOME/laboratorio/risk-assessment/escenario.json"
    [ -f "$esc" ] || return 1
    jq -e '[.activos[].amenazas[] | (.probabilidad * .impacto)] | add' "$esc" >/dev/null 2>&1
}

# Array de funciones de evaluación (para compatibilidad con evaluación batch)
validators=(reto1 reto2 reto3 reto4 reto5 reto6 reto7 reto8 reto9 reto10)

challenge_names=(
    "Escenario JSON válido"
    "Plantilla de análisis existe"
    "5 activos en escenario"
    "Cada activo tiene amenazas"
    "A1 criticidad alta"
    "A4 criticidad baja"
    "A5 criticidad alta"
    "A2 criticidad media"
    "A3 criticidad alta"
    "Riesgo calculable"
)

# Iconos para el menú (referenciados por menu.sh)
ICONOS=(🛡️ 📋 📊 🔢 🎯 📉 📈 💰 🏢 📝)

# Funciones de información para cada reto (patrón estándar Units II-XI)

reto1_info() {
    separador
    echo -e "${CYAN}Reto 1: Escenario JSON válido${NC}"
    echo ""
    echo "El escenario define una PyME con 5 activos críticos."
    echo "Verifica que el archivo escenario.json existe y es JSON válido."
    echo ""
    echo "Comando útil: cat escenario.json | jq ."
    separador
}

reto2_info() {
    separador
    echo -e "${CYAN}Reto 2: Plantilla de análisis${NC}"
    echo ""
    echo "La plantilla-analisis.md guía el análisis de riesgos."
    echo "Contiene: matriz probabilidad×impacto, niveles de riesgo, tratamientos."
    echo ""
    echo "Comando útil: cat plantilla-analisis.md"
    separador
}

reto3_info() {
    separador
    echo -e "${CYAN}Reto 3: 5 activos en escenario${NC}"
    echo ""
    echo "La PyME DataGuard tiene 5 activos críticos:"
    echo "A1-Servidor BD, A2-Servidor Web, A3-Infraestructura de Red,"
    echo "A4-Equipo Desarrollo, A5-Plan de Recuperación."
    echo ""
    echo "Comando útil: jq '.activos[].id' escenario.json"
    separador
}

reto4_info() {
    separador
    echo -e "${CYAN}Reto 4: Cada activo tiene amenazas${NC}"
    echo ""
    echo "ISO 31000 requiere identificar amenazas por activo."
    echo "Cada activo debe tener al menos una amenaza identificada."
    echo ""
    echo "Comando útil: jq '.activos[].amenazas | length' escenario.json"
    separador
}

reto5_info() {
    separador
    echo -e "${CYAN}Reto 5: A1 (Servidor BD) criticidad alta${NC}"
    echo ""
    echo "El servidor de base de datos es activo de información crítica."
    echo "Su pérdida comprometería la operación del negocio."
    echo ""
    echo "Comando útil: jq '.activos[] | select(.id=="A1")' escenario.json"
    separador
}

reto6_info() {
    separador
    echo -e "${CYAN}Reto 6: A4 (laptop) criticidad baja${NC}"
    echo ""
    echo "El equipo de desarrollo es activo de hardware de menor criticidad."
    echo "Pero contiene datos sensibles (código, credenciales)."
    echo ""
    echo "Comando útil: jq '.activos[] | select(.id=="A4")' escenario.json"
    separador
}

reto7_info() {
    separador
    echo -e "${CYAN}Reto 7: A5 (DRP) criticidad alta${NC}"
    echo ""
    echo "El plan de recuperación ante desastres es activo de información crítica."
    echo "Sin él, la organización no puede recuperarse de un incidente."
    echo ""
    echo "Comando útil: jq '.activos[] | select(.id=="A5")' escenario.json"
    separador
}

reto8_info() {
    separador
    echo -e "${CYAN}Reto 8: A2 (nginx) criticidad media${NC}"
    echo ""
    echo "El servidor web es activo de software de criticidad media."
    echo "Es expuesto a internet, pero su pérdida es recuperable."
    echo ""
    echo "Comando útil: jq '.activos[] | select(.id=="A2")' escenario.json"
    separador
}

reto9_info() {
    separador
    echo -e "${CYAN}Reto 9: A3 (red) criticidad alta${NC}"
    echo ""
    echo "La infraestructura de red es activo de hardware crítica."
    echo "Su configuración errónea puede comprometer toda la organización."
    echo ""
    echo "Comando útil: jq '.activos[] | select(.id=="A3")' escenario.json"
    separador
}

reto10_info() {
    separador
    echo -e "${CYAN}Reto 10: Riesgo inherente calculable${NC}"
    echo ""
    echo "Riesgo inherente = Probabilidad × Impacto (escala 1-5)."
    echo "Con 10 amenazas, la suma total es el indicador de riesgo global."
    echo ""
    echo "Comando útil: jq '[.activos[].amenazas[] | (.probabilidad * .impacto)] | add' escenario.json"
    separador
}
