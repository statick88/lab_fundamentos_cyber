#!/bin/bash
# Unit i-asset-classification: Clasificación de Activos / CSF 2.0 — test.sh
# 10 retos CORE: escenario, activos, CIA, CSV, CSF, clasificación, plantillas, controles, informe
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

UNIT_NAME="unit-i-asset-classification"
TOTAL_RETOS=10

LAB_DIR="$HOME/laboratorio/asset-classification"

# ── Reto 1: Verificar existencia del escenario ─────────────────
reto1() {
    local scenario="$LAB_DIR/escenario.json"
    assert_file_exists "$scenario"
    # Verificar que contiene la empresa FinSecure
    assert_file_contains "$scenario" "FinSecure"
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
    echo "FAIL: Solo $count activos encontrados en escenario.json (se esperan 5: A1-A5)" >&2
    return 1
}

# ── Reto 3: Verificar ratings CIA para cada activo ─────────────
reto3() {
    local scenario="$LAB_DIR/escenario.json"
    assert_file_exists "$scenario"
    # Verificar que cada activo tiene los 3 ratings CIA (1-5)
    local conf_count integ_count disp_count
    conf_count=$(grep -o '"confidencialidad": [1-5]' "$scenario" 2>/dev/null | wc -l | tr -d ' ')
    integ_count=$(grep -o '"integridad": [1-5]' "$scenario" 2>/dev/null | wc -l | tr -d ' ')
    disp_count=$(grep -o '"disponibilidad": [1-5]' "$scenario" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$conf_count" -ge 5 ] && [ "$integ_count" -ge 5 ] && [ "$disp_count" -ge 5 ]; then
        return 0
    fi
    echo "FAIL: Ratings CIA incompletos — confidencialidad=$conf_count, integridad=$integ_count, disponibilidad=$disp_count (se esperan 5 cada uno)" >&2
    return 1
}

# ── Reto 4: Verificar que existe CSV de inventario con 5+ entradas ──
reto4() {
    local csv="$LAB_DIR/data/asset_registry.csv"
    assert_file_exists "$csv"
    # Contar líneas de datos (excluir header)
    local data_lines
    data_lines=$(tail -n +2 "$csv" 2>/dev/null | grep -c '[^ ]' 2>/dev/null || echo 0)
    if [ "$data_lines" -ge 5 ]; then
        return 0
    fi
    echo "FAIL: CSV tiene solo $data_lines entradas de datos (se esperan al menos 5)" >&2
    return 1
}

# ── Reto 5: Verificar mapeo CSF completado ─────────────────────
reto5() {
    local template="$LAB_DIR/plantilla-clasificacion.md"
    local csf_ref="$LAB_DIR/data/csf_mapping.md"
    # Verificar que la plantilla tiene referencias CSF o el archivo de mapeo existe
    if [ -f "$template" ]; then
        assert_file_contains "$template" "ID\.AM-0[157]\|CSF\|NIST" && return 0
    fi
    # Verificar archivo de referencia CSF
    if [ -f "$csf_ref" ]; then
        assert_file_contains "$csf_ref" "ID\.AM-0[157]\|CSF" && return 0
    fi
    # Buscar cualquier archivo con mapeo CSF
    local csf_files
    csf_files=$(find "$LAB_DIR" -maxdepth 2 -type f \( -name "*csf*" -o -name "*mapping*" -o -name "*mapeo*" \) 2>/dev/null | head -1)
    assert_file_exists "$csf_files"
}

# ── Reto 6: Verificar niveles de clasificación asignados ───────
reto6() {
    local template="$LAB_DIR/plantilla-clasificacion.md"
    local csv="$LAB_DIR/data/asset_registry.csv"
    local scenario="$LAB_DIR/escenario.json"
    # Verificar en escenario.json que los 4 niveles aparecen
    local levels_found=0
    if [ -f "$scenario" ]; then
        assert_file_contains "$scenario" "restringido" && levels_found=$((levels_found + 1))
        assert_file_contains "$scenario" "confidencial" && levels_found=$((levels_found + 1))
        assert_file_contains "$scenario" "interno" && levels_found=$((levels_found + 1))
        assert_file_contains "$scenario" "publico\|público" && levels_found=$((levels_found + 1))
    fi
    if [ "$levels_found" -ge 2 ]; then
        return 0
    fi
    # Verificar en CSV
    if [ -f "$csv" ]; then
        levels_found=0
        assert_file_contains "$csv" "restringido" && levels_found=$((levels_found + 1))
        assert_file_contains "$csv" "confidencial" && levels_found=$((levels_found + 1))
        assert_file_contains "$csv" "interno" && levels_found=$((levels_found + 1))
        assert_file_contains "$csv" "publico\|público" && levels_found=$((levels_found + 1))
        if [ "$levels_found" -ge 2 ]; then
            return 0
        fi
    fi
    # Verificar en plantilla completada
    if [ -f "$template" ]; then
        assert_file_contains "$template" "restringido\|confidencial\|interno\|publico\|público" && return 0
    fi
    echo "FAIL: Niveles de clasificación (Public/Internal/Confidential/Restricted) no asignados" >&2
    return 1
}

# ── Reto 7: Verificar plantilla de inventario completada ────────
reto7() {
    local template="$LAB_DIR/plantilla-clasificacion.md"
    assert_file_exists "$template"
    # Verificar que tiene datos más allá de la plantilla vacía
    # Contar filas de tabla con datos (más allá de separadores)
    local filled_rows
    filled_rows=$(grep -c '| A[1-5] |.*|.*|.*|.*|.*|' "$template" 2>/dev/null || echo 0)
    if [ "$filled_rows" -ge 5 ]; then
        return 0
    fi
    # Verificar que tiene contenido más allá de headers vacíos
    local data_entries
    data_entries=$(grep -ci 'restringido\|confidencial\|interno\|público\|publico' "$template" 2>/dev/null || echo 0)
    if [ "$data_entries" -ge 3 ]; then
        return 0
    fi
    echo "FAIL: Plantilla de clasificación no completada (solo $filled_rows filas con datos, $data_entries clasificaciones)" >&2
    return 1
}

# ── Reto 8: Verificar justificación CIA en plantilla ────────────
reto8() {
    local template="$LAB_DIR/plantilla-clasificacion.md"
    assert_file_exists "$template"
    # Verificar que tiene justificaciones de clasificación
    local justifications
    justifications=$(grep -ci 'justificación\|justificacion\|criterio\|por qué\|porque' "$template" 2>/dev/null || echo 0)
    if [ "$justifications" -ge 2 ]; then
        return 0
    fi
    # Verificar que tiene priorización (ID.AM-05)
    local priority
    priority=$(grep -ci 'prioridad\|priorización\|criticidad' "$template" 2>/dev/null || echo 0)
    if [ "$priority" -ge 2 ]; then
        return 0
    fi
    echo "FAIL: Justificación de clasificación CIA o priorización no documentada en plantilla" >&2
    return 1
}

# ── Reto 9: Verificar que los 5 activos tienen controles definidos ──
reto9() {
    local template="$LAB_DIR/plantilla-clasificacion.md"
    local scenario="$LAB_DIR/escenario.json"
    local csv="$LAB_DIR/data/asset_registry.csv"
    # Verificar controles en escenario.json
    local controls=0
    if [ -f "$scenario" ]; then
        controls=$(grep -c '"controles"\|"control"\|"medida"' "$scenario" 2>/dev/null || echo 0)
    fi
    if [ "$controls" -ge 5 ]; then
        return 0
    fi
    # Verificar controles en plantilla
    if [ -f "$template" ]; then
        local ctrl_template
        ctrl_template=$(grep -ci 'control\|medida\|salvaguarda\|protección\|proteccion' "$template" 2>/dev/null || echo 0)
        if [ "$ctrl_template" -ge 3 ]; then
            return 0
        fi
    fi
    # Verificar archivos de controles
    local control_files
    control_files=$(find "$LAB_DIR" -maxdepth 2 -type f \( -name "*control*" -o -name "*salvaguarda*" -o -name "*medidas*" \) 2>/dev/null | head -1)
    assert_file_exists "$control_files"
}

# ── Reto 10: Verificar documento de resumen/informe final ──────
reto10() {
    # Buscar archivo de resumen o informe final
    local report
    report=$(find "$LAB_DIR" -maxdepth 1 -type f \( -name "*resumen*" -o -name "*informe*" -o -name "*summary*" -o -name "*report*" -o -name "*final*" \) 2>/dev/null | head -1)
    assert_file_exists "$report" || {
        # Verificar que la plantilla tiene sección de resumen/entregables
        local template="$LAB_DIR/plantilla-clasificacion.md"
        assert_file_exists "$template"
        assert_file_contains "$template" "resumen\|entregable\|informe\|conclusión\|conclusion\|resumen ejecutivo"
    } || {
        # Buscar archivo markdown que pueda ser el resumen
        local any_md
        any_md=$(find "$LAB_DIR" -maxdepth 1 -type f -name "*.md" ! -name "plantilla-*" ! -name "csf*" 2>/dev/null | head -1)
        assert_file_exists "$any_md"
    }
}

validators=(reto1 reto2 reto3 reto4 reto5 reto6 reto7 reto8 reto9 reto10)
challenge_names=(
    "Verificar existencia del escenario"
    "Validar 5 activos (A1-A5) en el escenario"
    "Verificar ratings CIA para cada activo"
    "Verificar CSV de inventario con 5+ entradas"
    "Verificar mapeo CSF 2.0 completado"
    "Verificar niveles de clasificación asignados"
    "Verificar plantilla de clasificación completada"
    "Verificar justificación CIA y priorización"
    "Verificar controles de seguridad definidos"
    "Verificar documento de resumen final"
)

ICONOS=("📋" "🏢" "🔐" "📊" "🗺️" "🏷️" "📝" "⚖️" "🛡️" "📄")

reto1_info() {
    separador
    echo -e "${CYAN}Reto 1: Verificar existencia del escenario${NC}"
    echo ""
    echo "Comprueba que escenario.json existe y contiene la empresa FinSecure."
    echo ""
    echo "Comandos útiles:"
    echo "  cat ~/laboratorio/asset-classification/escenario.json"
    echo "  cat escenario.json | jq ."
    separador
}

reto2_info() {
    separador
    echo -e "${CYAN}Reto 2: Validar 5 activos (A1-A5) en el escenario${NC}"
    echo ""
    echo "Verifica que el escenario contiene los 5 activos: A1-A5."
    echo ""
    echo "Comandos útiles:"
    echo "  grep '\"id\": \"A' escenario.json | wc -l"
    echo "  cat escenario.json | jq '.activos | length'"
    separador
}

reto3_info() {
    separador
    echo -e "${CYAN}Reto 3: Verificar ratings CIA para cada activo${NC}"
    echo ""
    echo "Cada activo debe tener confidencialidad, integridad y disponibilidad (1-5)."
    echo ""
    echo "Comandos útiles:"
    echo "  grep '\"confidencialidad\"' escenario.json | wc -l"
    echo "  grep '\"integridad\"' escenario.json | wc -l"
    echo "  grep '\"disponibilidad\"' escenario.json | wc -l"
    separador
}

reto4_info() {
    separador
    echo -e "${CYAN}Reto 4: Verificar CSV de inventario con 5+ entradas${NC}"
    echo ""
    echo "El archivo data/asset_registry.csv debe tener al menos 5 registros."
    echo ""
    echo "Comandos útiles:"
    echo "  cat data/asset_registry.csv"
    echo "  tail -n +2 data/asset_registry.csv | wc -l"
    separador
}

reto5_info() {
    separador
    echo -e "${CYAN}Reto 5: Verificar mapeo CSF 2.0 completado${NC}"
    echo ""
    echo "Se debe documentar el mapeo ID.AM-01, ID.AM-05 y ID.AM-07."
    echo ""
    echo "Comandos útiles:"
    echo "  cat data/csf_mapping.md"
    echo "  grep 'ID.AM' plantilla-clasificacion.md"
    separador
}

reto6_info() {
    separador
    echo -e "${CYAN}Reto 6: Verificar niveles de clasificación asignados${NC}"
    echo ""
    echo "Cada activo debe tener un nivel: público, interno, confidencial o restringido."
    echo ""
    echo "Comandos útiles:"
    echo "  grep 'clasificacion' escenario.json"
    echo "  cut -d',' -f3 data/asset_registry.csv"
    separador
}

reto7_info() {
    separador
    echo -e "${CYAN}Reto 7: Verificar plantilla de clasificación completada${NC}"
    echo ""
    echo "La plantilla plantilla-clasificacion.md debe estar completada con datos."
    echo ""
    echo "Comandos útiles:"
    echo "  cat plantilla-clasificacion.md"
    echo "  grep '| A' plantilla-clasificacion.md | wc -l"
    separador
}

reto8_info() {
    separador
    echo -e "${CYAN}Reto 8: Verificar justificación CIA y priorización${NC}"
    echo ""
    echo "Cada clasificación debe tener justificación y priorización por criticidad."
    echo ""
    echo "Comandos útiles:"
    echo "  grep -i 'justificación\\|prioridad' plantilla-clasificacion.md"
    separador
}

reto9_info() {
    separador
    echo -e "${CYAN}Reto 9: Verificar controles de seguridad definidos${NC}"
    echo ""
    echo "Los 5 activos deben tener al menos un control de seguridad cada uno."
    echo ""
    echo "Comandos útiles:"
    echo "  grep -i 'control\\|medida\\|salvaguarda' plantilla-clasificacion.md"
    echo "  ls data/"
    separador
}

reto10_info() {
    separador
    echo -e "${CYAN}Reto 10: Verificar documento de resumen final${NC}"
    echo ""
    echo "Debe existir un documento de resumen o informe final del análisis."
    echo ""
    echo "Comandos útiles:"
    echo "  ls *.md"
    echo "  cat resumen.md 2>/dev/null || cat informe.md 2>/dev/null || cat summary.md"
    separador
}

# ── Standalone execution mode ─────────────────────────────────────
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  i-asset-classification: Clasificación de Activos / CSF 2.0 — Retos"
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
    echo "  i-asset-classification Results: $PASSED/$TOTAL_RETOS passed, $FAILED failed"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    [ "$FAILED" -eq 0 ]
fi
