#!/bin/bash
# evaluar-unidad.sh - Evaluar la unidad actual

source /shared/common.sh

if [ -z "$CURRENT_UNIT" ]; then
    if [ -f "$HOME/.current_unit" ]; then
        export CURRENT_UNIT=$(cat "$HOME/.current_unit")
    fi
fi

if [ -z "$CURRENT_UNIT" ]; then
    advertencia "No hay unidad seleccionada. Usa 'unidad <1-26>' para seleccionar una."
    exit 1
fi

# Resolver la unidad desde el manifiesto centralizado para evitar rutas legacy.
# Ej.: unit-V debe apuntar a units/v-logging-siem-bcp, no a units/v.
UNIT_PATH=$(resolve_unit_path "$CURRENT_UNIT")

if [ -z "$UNIT_PATH" ]; then
    error "No se pudo determinar el directorio de la unidad: $CURRENT_UNIT"
    exit 1
fi

TEST_FILE="$UNIT_PATH/test.sh"

if [ ! -f "$TEST_FILE" ]; then
    error "Test no encontrado: $TEST_FILE"
    exit 1
fi

# Extraer número de unidad del nombre (unit-II -> II) solo para frase final.
UNIT_ROMAN=$(echo "$CURRENT_UNIT" | sed 's/unit-//')
case "$UNIT_ROMAN" in
    I) IDX=1 ;;
    II) IDX=2 ;;
    III) IDX=3 ;;
    IV) IDX=4 ;;
    V) IDX=5 ;;
    VI) IDX=6 ;;
    VII) IDX=7 ;;
    VIII) IDX=8 ;;
    IX) IDX=9 ;;
    X) IDX=10 ;;
    XI) IDX=11 ;;
    *) IDX=0 ;;
esac

echo -e "${CYAN_B}Evaluando $CURRENT_UNIT...${RESET}"
echo ""

source "$TEST_FILE"
ejecutar_evaluacion "$UNIT_NAME" "$TOTAL_RETOS" "${validators[@]}"
status=$?

# Mostrar frase si la unidad está completada
if [ "$IDX" -gt 0 ] && unidad_completada "$CURRENT_UNIT"; then
    echo ""
    mostrar_frase_unidad "$IDX"
fi

exit "$status"
