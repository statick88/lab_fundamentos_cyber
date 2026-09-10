#!/bin/bash
# Unit: i-asset-classification — Clasificación de Activos / CSF 2.0 (Lab 3)
# Standard pattern: defines retoN() validators + retoN_info() for menu-driven execution

# Support both container (/shared) and local (relative) paths
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
    source /shared/validators.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
    source "$(dirname "$0")/../../shared/validators.sh"
fi

UNIT_NAME="unit-I-asset"
TOTAL_RETOS=10

# Pure validators - no user interaction, check system state only

reto1() {
    # Verificar que escenario.json existe y es JSON válido
    local esc="$HOME/laboratorio/asset-classification/escenario.json"
    [ -f "$esc" ] || return 1
    command -v jq >/dev/null 2>&1 || return 1
    jq -e '.activos | length' "$esc" >/dev/null 2>&1
}

reto2() {
    # Verificar que plantilla-clasificacion.md existe
    assert_file_exists "$HOME/laboratorio/asset-classification/plantilla-clasificacion.md"
}

reto3() {
    # Verificar que asset_registry.csv tiene 5 filas de datos (excluyendo header)
    local csv="$HOME/laboratorio/asset-classification/data/asset_registry.csv"
    [ -f "$csv" ] || return 1
    local data_rows
    data_rows=$(($(wc -l < "$csv") - 1))
    [ "$data_rows" = "5" ]
}

reto4() {
    # Verificar que todas las clasificaciones están en {público,interno,confidencial,restringido}
    local csv="$HOME/laboratorio/asset-classification/data/asset_registry.csv"
    [ -f "$csv" ] || return 1
    # Extraer columna 3 (classification), saltar header, verificar valores válidos
    local invalid
    invalid=$(tail -n +2 "$csv" | cut -d',' -f3 | grep -vE '^(público|interno|confidencial|restringido)$' | wc -l)
    [ "$invalid" = "0" ]
}

reto5() {
    # Verificar que todos los ratings CIA son 1-5
    local csv="$HOME/laboratorio/asset-classification/data/asset_registry.csv"
    [ -f "$csv" ] || return 1
    # Verificar columnas 4, 5, 6 (confidencialidad, integridad, disponibilidad)
    local invalid
    invalid=$(tail -n +2 "$csv" | awk -F',' '$4 < 1 || $4 > 5 || $5 < 1 || $5 > 5 || $6 < 1 || $6 > 5' | wc -l)
    [ "$invalid" = "0" ]
}

reto6() {
    # Verificar que csf_mapping.md contiene ID.AM-01
    assert_file_contains "$HOME/laboratorio/asset-classification/data/csf_mapping.md" "ID.AM-01"
}

reto7() {
    # Verificar que csf_mapping.md contiene ID.AM-05
    assert_file_contains "$HOME/laboratorio/asset-classification/data/csf_mapping.md" "ID.AM-05"
}

reto8() {
    # Verificar que csf_mapping.md contiene ID.AM-07
    assert_file_contains "$HOME/laboratorio/asset-classification/data/csf_mapping.md" "ID.AM-07"
}

reto9() {
    # Verificar que escenario.json es JSON válido con array de activos
    local esc="$HOME/laboratorio/asset-classification/escenario.json"
    [ -f "$esc" ] || return 1
    command -v jq >/dev/null 2>&1 || return 1
    # Verificar que es array y tiene 5 elementos
    jq -e '.activos | length == 5' "$esc" >/dev/null 2>&1
}

reto10() {
    # Verificar que al menos un activo tiene clasificación "restringido" o "confidencial"
    local csv="$HOME/laboratorio/asset-classification/data/asset_registry.csv"
    [ -f "$csv" ] || return 1
    # Buscar en columna 3 (classification)
    tail -n +2 "$csv" | cut -d',' -f3 | grep -qE '^(restringido|confidencial)$'
}

# Array de funciones de evaluación (para compatibilidad con evaluación batch)
validators=(reto1 reto2 reto3 reto4 reto5 reto6 reto7 reto8 reto9 reto10)

challenge_names=(
    "Escenario JSON válido"
    "Plantilla de clasificación existe"
    "CSV tiene 5 filas de datos"
    "Clasificaciones válidas (público/interno/confidencial/restringido)"
    "Ratings CIA 1-5"
    "CSF mapping contiene ID.AM-01"
    "CSF mapping contiene ID.AM-05"
    "CSF mapping contiene ID.AM-07"
    "Escenario JSON con 5 activos"
    "Al menos un activo restringido/confidencial"
)

# Iconos para el menú (referenciados por menu.sh)
ICONOS=(🛡️ 📋 📊 🏷️ 🔢 📚 🎯 🔗 📦 🔐)

# Funciones de información para cada reto (patrón estándar)

reto1_info() {
    separador
    echo -e "${CYAN}Reto 1: Escenario JSON válido${NC}"
    echo ""
    echo "El escenario define una organización con 5 activos críticos."
    echo "Verifica que el archivo escenario.json existe y es JSON válido con array 'activos'."
    echo ""
    echo "Comando útil: cat escenario.json | jq ."
    separador
}

reto2_info() {
    separador
    echo -e "${CYAN}Reto 2: Plantilla de clasificación${NC}"
    echo ""
    echo "La plantilla-clasificacion.md guía la clasificación de activos."
    echo "Contiene: tabla de inventario, priorización CIA, mapeo CSF ID.AM-01/05/07."
    echo ""
    echo "Comando útil: cat plantilla-clasificacion.md"
    separador
}

reto3_info() {
    separador
    echo -e "${CYAN}Reto 3: CSV con 5 filas de datos${NC}"
    echo ""
    echo "El registro de activos (asset_registry.csv) debe tener:"
    echo "  - 1 fila de header: name,type,classification,confidencialidad,integridad,disponibilidad"
    echo "  - 5 filas de datos (una por cada activo A1-A5)"
    echo ""
    echo "Comando útil: wc -l data/asset_registry.csv"
    separador
}

reto4_info() {
    separador
    echo -e "${CYAN}Reto 4: Clasificaciones válidas${NC}"
    echo ""
    echo "Cada activo debe tener una clasificación de las 4 permitidas:"
    echo "  • público      — información de acceso general"
    echo "  • interno      — uso interno de la organización"
    echo "  • confidencial — información sensible, acceso por necesidad"
    echo "  • restringido  — información altamente sensible, acceso muy limitado"
    echo ""
    echo "Comando útil: cut -d',' -f3 data/asset_registry.csv | sort -u"
    separador
}

reto5_info() {
    separador
    echo -e "${CYAN}Reto 5: Ratings CIA en escala 1-5${NC}"
    echo ""
    echo "Cada activo tiene 3 ratings (confidencialidad, integridad, disponibilidad):"
    echo "  1 = Muy bajo  |  2 = Bajo  |  3 = Medio  |  4 = Alto  |  5 = Muy alto"
    echo ""
    echo "Comando útil: cut -d',' -f4-6 data/asset_registry.csv"
    separador
}

reto6_info() {
    separador
    echo -e "${CYAN}Reto 6: CSF ID.AM-01 (Inventario de Activos)${NC}"
    echo ""
    echo "ID.AM-01: Los inventarios de hardware, software, datos y servicios se gestionan."
    echo "Verifica que csf_mapping.md referencia esta subcategoría."
    echo ""
    echo "Comando útil: grep 'ID.AM-01' data/csf_mapping.md"
    separador
}

reto7_info() {
    separador
    echo -e "${CYAN}Reto 7: CSF ID.AM-05 (Priorización de Activos)${NC}"
    echo ""
    echo "ID.AM-05: Los activos se priorizan según clasificación, criticidad y valor."
    echo "Verifica que csf_mapping.md referencia esta subcategoría."
    echo ""
    echo "Comando útil: grep 'ID.AM-05' data/csf_mapping.md"
    separador
}

reto8_info() {
    separador
    echo -e "${CYAN}Reto 8: CSF ID.AM-07 (Mapeo a Roles y Dependencias)${NC}"
    echo ""
    echo "ID.AM-07: Se establece mapa de activos con roles, responsabilidades y dependencias."
    echo "Verifica que csf_mapping.md referencia esta subcategoría."
    echo ""
    echo "Comando útil: grep 'ID.AM-07' data/csf_mapping.md"
    separador
}

reto9_info() {
    separador
    echo -e "${CYAN}Reto 9: Escenario con 5 activos (A1-A5)${NC}"
    echo ""
    echo "El escenario.json debe contener exactamente 5 activos con IDs A1 a A5,"
    echo "cada uno con: id, nombre, tipo, clasificación, confidencialidad, integridad, disponibilidad."
    echo ""
    echo "Comando útil: jq '.activos[] | {id, nombre, tipo, clasificacion}' escenario.json"
    separador
}

reto10_info() {
    separador
    echo -e "${CYAN}Reto 10: Al menos un activo restringido/confidencial${NC}"
    echo ""
    echo "Una organización financiera debe tener activos altamente sensibles."
    echo "Verifica que al menos un activo tiene clasificación 'restringido' o 'confidencial'."
    echo ""
    echo "Comando útil: cut -d',' -f3 data/asset_registry.csv | grep -E 'restringido|confidencial'"
    separador
}