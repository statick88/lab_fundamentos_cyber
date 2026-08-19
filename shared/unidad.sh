#!/bin/bash
# unidad.sh - Cambiar a una unidad del curso
# Uso: unidad <número> o unidad <nombre>

source /shared/common.sh

# Solo ejecutar el código principal si el archivo se ejecuta directamente
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    if [ $# -eq 0 ]; then
        echo -e "${CYAN}Uso: unidad <número>${RESET}"
        echo -e "${CYAN}Unidades disponibles: 1-18${RESET}"
        echo ""
        for i in $(seq 1 $UNIT_COUNT); do
            echo -e "  ${VERDE}${i}${RESET}  $(get_unit_title $i)"
        done
        echo ""
        echo -e "${AMARILLO}Unidad actual: ${CURRENT_UNIT:-ninguna}${RESET}"
        exit 0
    fi

    UNIT_NUM=$1

    if [ "$UNIT_NUM" -lt 1 ] || [ "$UNIT_NUM" -gt "$UNIT_COUNT" ]; then
        error "Unidad debe estar entre 1 y $UNIT_COUNT"
        exit 1
    fi

    UNIT_DIR_NAME=$(get_unit_dir "$UNIT_NUM")
    UNIT_NAME=$(get_unit_name "$UNIT_NUM")

    UNIT_DIR="$HOME/laboratorio/units/$UNIT_DIR_NAME"
    if [ ! -d "$UNIT_DIR" ]; then
        error "Unidad $UNIT_NUM no encontrada en $UNIT_DIR"
        exit 1
    fi

    MARKER="$HOME/.unit_${UNIT_NAME}_initialized"
    if [ ! -f "$MARKER" ]; then
        info "Ejecutando configuración inicial para $UNIT_NAME..."
        cd "$UNIT_DIR"
        bash setup.sh
        touch "$MARKER"
        exito "Configuración completada"
    else
        info "Unidad $UNIT_NAME ya configurada"
    fi

    export CURRENT_UNIT="$UNIT_NAME"
    echo "$UNIT_NAME" > "$HOME/.current_unit"

    echo ""
    banner_unidad "$UNIT_NUM" "$(get_unit_title "$UNIT_NUM")"
    bash "$UNIT_DIR/manual.sh"

    echo -e "\n${AMARILLO}Comandos disponibles:${RESET}"
    echo -e "  ${CYAN}retos-unidad${RESET}  Ver retos de esta unidad"
    echo -e "  ${CYAN}evaluar-unidad${RESET}  Evaluar progreso"
    echo -e "  ${CYAN}revelar-frase${RESET}   Ver frase oculta"
fi
