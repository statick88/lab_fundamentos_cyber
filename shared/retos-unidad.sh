#!/bin/bash
# retos-unidad.sh - Mostrar retos de la unidad actual

source /shared/common.sh

if [ -z "$CURRENT_UNIT" ]; then
    # Intentar cargar desde archivo
    if [ -f "$HOME/.current_unit" ]; then
        export CURRENT_UNIT=$(cat "$HOME/.current_unit")
    fi
fi

if [ -z "$CURRENT_UNIT" ]; then
    advertencia "No hay unidad seleccionada. Usa 'unidad <1-11>' para seleccionar una."
    exit 1
fi

# Extraer número de unidad del nombre (unit-II -> 2)
UNIT_NUM=$(echo "$CURRENT_UNIT" | sed 's/unit-//' | tr 'IVX' 'ivx')
# Convertir a número romano minúscula
case "$UNIT_NUM" in
    i) UNIT_DIR="i" ;;
    ii) UNIT_DIR="ii" ;;
    iii) UNIT_DIR="iii" ;;
    iv) UNIT_DIR="iv" ;;
    v) UNIT_DIR="v" ;;
    vi) UNIT_DIR="vi" ;;
    vii) UNIT_DIR="vii" ;;
    viii) UNIT_DIR="viii" ;;
    ix) UNIT_DIR="ix" ;;
    x) UNIT_DIR="x" ;;
    xi) UNIT_DIR="xi" ;;
    i-risk) UNIT_DIR="i-risk-assessment" ;;
    i-asset) UNIT_DIR="i-asset-classification" ;;
    checkpoint-ii) UNIT_DIR="checkpoint-ii" ;;
    checkpoint-iv) UNIT_DIR="checkpoint-iv" ;;
    checkpoint-v) UNIT_DIR="checkpoint-v" ;;
    iii-compliance-iso27001) UNIT_DIR="iii-compliance-iso27001" ;;
    *) UNIT_DIR="" ;;
esac

if [ -z "$UNIT_DIR" ]; then
    error "No se pudo determinar el directorio de la unidad: $CURRENT_UNIT"
    exit 1
fi

# Normalizar nombres de checkpoint para coincidir con UNIT_NAMES (romano mayúscula)
case "$CURRENT_UNIT" in
    checkpoint-ii) CURRENT_UNIT="checkpoint-II" ;;
    checkpoint-iv) CURRENT_UNIT="checkpoint-IV" ;;
    checkpoint-v) CURRENT_UNIT="checkpoint-V" ;;
esac

UNIT_DIR_PATH="$HOME/laboratorio/units/$UNIT_DIR"
MANUAL_FILE="$UNIT_DIR_PATH/manual.sh"

if [ -f "$MANUAL_FILE" ]; then
    bash "$MANUAL_FILE"
else
    error "Manual no encontrado: $MANUAL_FILE"
    exit 1
fi