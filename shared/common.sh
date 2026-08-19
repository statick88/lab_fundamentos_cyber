#!/bin/bash
# Modulo comun - carga todos los modulos compartidos
COURSE_DIR="/shared"
source "${COURSE_DIR}/colors.sh"
source "${COURSE_DIR}/eval.sh"
source "${COURSE_DIR}/metrics.sh" 2>/dev/null || true
source "${COURSE_DIR}/units_manifest.sh"
source "${COURSE_DIR}/menu.sh"
source "${COURSE_DIR}/banner.sh"
init_state

CURRENT_UNIT=""
FRASES_OCULTAS=("Toda" "revolution" "comienza" "con" "un" "pass"
                "Los" "administradores" "nunca" "duermen" "!"
                "Ciberseguridad" "es" "todos")

get_frase_for_unit() {
    local idx=$1
    [ "$idx" -ge 1 ] && [ "$idx" -le ${#FRASES_OCULTAS[@]} ] && echo "${FRASES_OCULTAS[$((idx-1))]}"
}

mostrar_frase_unidad() {
    local frase; frase=$(get_frase_for_unit "$1")
    [ -n "$frase" ] && echo -e "${AMARILLO}Frase revelada: ${frase}${RESET}"
}

unidad_completada() {
    local total; total=$(get_unit_total_retos "$(get_unit_index "$1")")
    local compl; compl=$(contar_completados "$1" "$total")
    [ "$compl" -eq "$total" ]
}

get_all_units() {
    local units_dir="$HOME/laboratorio/units"
    if [ ! -d "$units_dir" ]; then
        echo ""
        return
    fi
    find "$units_dir" -maxdepth 1 -type d -name "[!.]*" | sort | while read -r dir; do
        local dirname=$(basename "$dir")
        if [ -f "$dir/test.sh" ]; then
            echo "$dirname"
        fi
    done
}
