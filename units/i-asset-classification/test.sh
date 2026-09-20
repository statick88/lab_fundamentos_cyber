#!/bin/bash
# Unit i-asset-classification: Clasificación de Activos / CSF 2.0 — test.sh
# Validators inspect only explicit student deliverables, never setup reference material.

if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
fi

UNIT_NAME="unit-i-asset-classification"
TOTAL_RETOS=10
LAB_DIR="$HOME/laboratorio/asset-classification"

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

student_inventory() {
    local csv="$LAB_DIR/asset_inventory.csv" markdown="$LAB_DIR/asset_inventory.md"
    if [ -f "$csv" ] && [ "$(tail -n +2 "$csv" | grep -c '[^[:space:]]')" -ge 5 ]; then
        return 0
    fi
    has_asset_ids "$markdown" && [ "$(grep -icE '^\|[[:space:]]*A[1-5]|^[-*].*A[1-5]' "$markdown")" -ge 5 ]
}

# Reto 1: resumen de estudiante, no fixtures/escenario.json.
reto1() {
    local file="$LAB_DIR/scenario_summary.md"
    grep -qi "FinSecure" "$file" 2>/dev/null && has_asset_ids "$file" && grep -qi "hardware" "$file" && grep -qi "software" "$file" && grep -qiE 'data|datos' "$file" && grep -qiE 'supplier-service|servicio.*proveedor|proveedor.*servicio' "$file"
}

# Retos 2 y 4: inventario explícito del estudiante.
reto2() { student_inventory; }
reto4() { student_inventory; }

# Reto 3: calificaciones CIA para A1-A5.
reto3() {
    local file="$LAB_DIR/cia_ratings.md" asset
    [ -f "$file" ] || return 1
    for asset in A1 A2 A3 A4 A5; do
        grep -qiE "$asset.*(confidencialidad|confidentiality|C).*([1-5]).*(integridad|integrity|I).*([1-5]).*(disponibilidad|availability|D).*([1-5])" "$file" || return 1
    done
}

# Reto 5: mapeo CSF de estudiante, con las tres subcategorías y activos.
reto5() {
    local file="$LAB_DIR/csf_mapping_student.md"
    grep -q "ID.AM-01" "$file" 2>/dev/null && grep -q "ID.AM-05" "$file" && grep -q "ID.AM-07" "$file" && has_asset_ids "$file"
}

# Retos 6 y 7: clasificación con justificaciones para A1-A5.
reto6() {
    local file="$LAB_DIR/asset_classification.md"
    has_asset_ids "$file" && grep -qiE 'público|publico|interno|confidencial|restringido' "$file"
}
reto7() {
    local file="$LAB_DIR/asset_classification.md"
    has_asset_ids "$file" && [ "$(grep -icE 'justific|criterio|porque|por qué' "$file")" -ge 5 ]
}

# Reto 8: priorización y criterios explícitos para A1-A5.
reto8() {
    local file="$LAB_DIR/asset_prioritization.md"
    has_asset_ids "$file" && grep -qiE 'prioridad|criticidad' "$file" && grep -qiE 'criterio|CIA|impacto|valor' "$file"
}

# Reto 9: controles descritos por activo.
reto9() {
    local file="$LAB_DIR/asset_controls.md" asset
    [ -f "$file" ] || return 1
    for asset in A1 A2 A3 A4 A5; do
        grep -qiE "$asset.*(control|medida|salvaguarda|mfa|rbac|cifrado|backup|monitoreo|segmentaci[oó]n)" "$file" || return 1
    done
}

# Reto 10: informe final de estudiante.
reto10() {
    local file
    for file in "$LAB_DIR/final_report.md" "$LAB_DIR/resumen_final.md"; do
        if [ "$(nonspace_chars "$file")" -ge 300 ]; then return 0; fi
    done
    return 1
}

validators=(reto1 reto2 reto3 reto4 reto5 reto6 reto7 reto8 reto9 reto10)
challenge_names=(
    "Documentar el resumen del escenario"
    "Crear inventario de al menos 5 activos"
    "Asignar ratings CIA a A1-A5"
    "Entregar inventario CSV o Markdown"
    "Mapear ID.AM-01/05/07 a activos"
    "Asignar clasificaciones a A1-A5"
    "Justificar cada clasificación"
    "Priorizar A1-A5 con criterios"
    "Definir controles por activo"
    "Entregar informe final"
)
ICONOS=("📋" "🏢" "🔐" "📊" "🗺️" "🏷️" "📝" "⚖️" "🛡️" "📄")

reto1_info() { separador; echo -e "${CYAN}Reto 1: Crea scenario_summary.md${NC}"; echo "Consulta fixtures/escenario.json y documenta FinSecure, A1-A5 y los tipos de activo."; separador; }
reto2_info() { separador; echo -e "${CYAN}Reto 2: Crea asset_inventory.csv o asset_inventory.md${NC}"; echo "Entrega un inventario propio con al menos cinco activos."; separador; }
reto3_info() { separador; echo -e "${CYAN}Reto 3: Crea cia_ratings.md${NC}"; echo "Incluye CIA (1-5) para A1-A5."; separador; }
reto4_info() { separador; echo -e "${CYAN}Reto 4: Entrega el inventario${NC}"; echo "No se acepta fixtures/asset_registry.csv; usa asset_inventory.csv o asset_inventory.md."; separador; }
reto5_info() { separador; echo -e "${CYAN}Reto 5: Crea csf_mapping_student.md${NC}"; echo "Mapea ID.AM-01, ID.AM-05 e ID.AM-07 a A1-A5. fixtures/csf_mapping.md es referencia."; separador; }
reto6_info() { separador; echo -e "${CYAN}Reto 6: Crea asset_classification.md${NC}"; echo "Clasifica A1-A5 como público, interno, confidencial o restringido."; separador; }
reto7_info() { separador; echo -e "${CYAN}Reto 7: Justifica asset_classification.md${NC}"; echo "Incluye cinco justificaciones o criterios, uno por activo."; separador; }
reto8_info() { separador; echo -e "${CYAN}Reto 8: Crea asset_prioritization.md${NC}"; echo "Prioriza A1-A5 y explica los criterios."; separador; }
reto9_info() { separador; echo -e "${CYAN}Reto 9: Crea asset_controls.md${NC}"; echo "Define al menos un control por activo."; separador; }
reto10_info() { separador; echo -e "${CYAN}Reto 10: Crea final_report.md o resumen_final.md${NC}"; echo "Entrega un informe con al menos 300 caracteres no vacíos."; separador; }

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  i-asset-classification: Clasificación de Activos / CSF 2.0 — Retos"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    PASSED=0; FAILED=0
    for i in $(seq 1 "$TOTAL_RETOS"); do
        validator="${validators[$((i-1))]}"; name="${challenge_names[$((i-1))]}"; icon="${ICONOS[$((i-1))]}"
        if "$validator" >/dev/null 2>&1; then echo "  [PASS] Reto $i: $name $icon"; PASSED=$((PASSED + 1)); else echo "  [FAIL] Reto $i: $name"; FAILED=$((FAILED + 1)); fi
    done
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  i-asset-classification Results: $PASSED/$TOTAL_RETOS passed, $FAILED failed"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    [ "$FAILED" -eq 0 ]
fi
