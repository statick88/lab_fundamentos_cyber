#!/bin/bash
# Unit i-asset-classification: Clasificación de Activos / CSF 2.0 — test.sh
# 10 retos CORE: escenario, activos, CIA, CSV, CSF, clasificación, plantillas, controles, informe

# Dual-path sourcing
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
fi

UNIT_NAME="unit-i-asset-classification"
TOTAL_RETOS=10

LAB_DIR="$HOME/laboratorio/asset-classification"

asset_table_completed_rows() {
    local template="$LAB_DIR/plantilla-clasificacion.md"
    [ -f "$template" ] || { echo 0; return; }
    awk -F'|' '
        function trim(s){gsub(/^[ \t]+|[ \t]+$/, "", s); return s}
        /^\|[[:space:]]*A[1-5][[:space:]]*\|/ {
            activo=trim($2); tipo=trim($3); clas=tolower(trim($4)); c=trim($5); i=trim($6); d=trim($7); just=trim($8);
            if (activo ~ /^A[1-5]$/ && tipo != "" && clas ~ /^(público|publico|interno|confidencial|restringido)$/ && c ~ /^[1-5]$/ && i ~ /^[1-5]$/ && d ~ /^[1-5]$/ && length(just) >= 20) count++;
        }
        END {print count+0}
    ' "$template"
}

asset_priority_completed_rows() {
    local template="$LAB_DIR/plantilla-clasificacion.md"
    [ -f "$template" ] || { echo 0; return; }
    awk -F'|' '
        function trim(s){gsub(/^[ \t]+|[ \t]+$/, "", s); return s}
        /^\|[[:space:]]*A[1-5][[:space:]]*\|/ {
            activo=trim($2); priority=trim($3); criteria=trim($4);
            if (activo ~ /^A[1-5]$/ && priority ~ /^[1-5]$/ && length(criteria) >= 20) count++;
        }
        END {print count+0}
    ' "$template"
}

asset_controls_completed_count() {
    local template="$LAB_DIR/plantilla-clasificacion.md"
    [ -f "$template" ] || { echo 0; return; }
    local count=0 asset
    for asset in A1 A2 A3 A4 A5; do
        if grep -iE "${asset}.*(control|medida|salvaguarda|mitigaci[oó]n|mfa|rbac|cifrado|backup|monitoreo|segmentaci[oó]n)" "$template" >/dev/null 2>&1; then
            count=$((count + 1))
        fi
    done
    echo "$count"
}

non_template_report() {
    find "$LAB_DIR" -maxdepth 1 -type f \( -name "*resumen*" -o -name "*informe*" -o -name "*summary*" -o -name "*report*" -o -name "*final*" \) 2>/dev/null | head -1
}

# ── Reto 1: Verificar existencia del escenario ─────────────────
reto1() {
    local scenario="$LAB_DIR/escenario.json"
    if [ ! -f "$scenario" ]; then
        echo "FAIL: escenario.json no existe en $LAB_DIR" >&2
        return 1
    fi
    # Verificar que contiene la empresa FinSecure
    grep -qi "FinSecure" "$scenario" 2>/dev/null
    if [ $? -ne 0 ]; then
        echo "FAIL: escenario.json no contiene la empresa FinSecure" >&2
        return 1
    fi
    return 0
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
    echo "FAIL: Solo $count activos encontrados en escenario.json (se esperan 5: A1-A5)" >&2
    return 1
}

# ── Reto 3: Verificar ratings CIA para cada activo ─────────────
reto3() {
    local scenario="$LAB_DIR/escenario.json"
    if [ ! -f "$scenario" ]; then
        echo "FAIL: escenario.json no existe" >&2
        return 1
    fi
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
    if [ ! -f "$csv" ]; then
        echo "FAIL: data/asset_registry.csv no existe en $LAB_DIR" >&2
        return 1
    fi
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
        if grep -qi "ID\.AM-0[157]\|CSF\|NIST" "$template" 2>/dev/null; then
            return 0
        fi
    fi
    # Verificar archivo de referencia CSF
    if [ -f "$csf_ref" ]; then
        if grep -qi "ID\.AM-0[157]\|CSF" "$csf_ref" 2>/dev/null; then
            return 0
        fi
    fi
    # Buscar cualquier archivo con mapeo CSF
    local csf_files
    csf_files=$(find "$LAB_DIR" -maxdepth 2 -type f \( -name "*csf*" -o -name "*mapping*" -o -name "*mapeo*" \) 2>/dev/null | head -1)
    if [ -n "$csf_files" ] && [ -f "$csf_files" ]; then
        return 0
    fi
    echo "FAIL: Mapeo CSF 2.0 no encontrado (ID.AM-01/05/07)" >&2
    return 1
}

# ── Reto 6: Verificar niveles de clasificación asignados ───────
reto6() {
    local rows
    rows=$(asset_table_completed_rows)
    if [ "$rows" -ge 5 ]; then
        return 0
    fi
    echo "FAIL: Niveles de clasificación no asignados por el estudiante en A1-A5 ($rows/5 filas completas)" >&2
    return 1
}

# ── Reto 7: Verificar plantilla de inventario completada ────────
reto7() {
    local rows
    rows=$(asset_table_completed_rows)
    if [ "$rows" -ge 5 ]; then
        return 0
    fi
    echo "FAIL: Plantilla de clasificación no completada con justificaciones suficientes ($rows/5 filas completas)" >&2
    return 1
}

# ── Reto 8: Verificar justificación CIA en plantilla ────────────
reto8() {
    local classified priority
    classified=$(asset_table_completed_rows)
    priority=$(asset_priority_completed_rows)
    if [ "$classified" -ge 5 ] && [ "$priority" -ge 5 ]; then
        return 0
    fi
    echo "FAIL: Justificación CIA o priorización incompleta (clasificación=$classified/5, prioridad=$priority/5)" >&2
    return 1
}

# ── Reto 9: Verificar que los 5 activos tienen controles definidos ──
reto9() {
    local controls
    controls=$(asset_controls_completed_count)
    if [ "$controls" -ge 5 ]; then
        return 0
    fi
    echo "FAIL: Controles de seguridad no definidos por activo ($controls/5 activos)" >&2
    return 1
}

# ── Reto 10: Verificar documento de resumen/informe final ──────
reto10() {
    local report
    report=$(non_template_report)
    if [ -n "$report" ] && [ -f "$report" ]; then
        local chars
        chars=$(tr -d '[:space:]' < "$report" 2>/dev/null | wc -c | tr -d ' ')
        if [ "$chars" -ge 300 ]; then
            return 0
        fi
    fi
    echo "FAIL: Documento de resumen o informe final no encontrado con desarrollo suficiente" >&2
    return 1
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
