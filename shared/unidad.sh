#!/bin/bash
# unidad.sh - Cambiar a una unidad del curso
# Uso: unidad <número> o unidad <nombre>

source /shared/common.sh

get_unit_title() {
    case $1 in
        1) echo "Principios y Gestión de Riesgo" ;;
        2) echo "Filtrado de Red y Firewalls" ;;
        3) echo "IAM, MFA y Control de Acceso" ;;
        4) echo "Criptografía y CVSS" ;;
        5) echo "Logging, SIEM y BCP" ;;
        6) echo "Almacenamiento y LVM" ;;
        7) echo "Hardening y CIS Benchmarks" ;;
        8) echo "Docker" ;;
        9) echo "Nginx" ;;
        10) echo "SSL/TLS y Criptografía Aplicada" ;;
        11) echo "Docker Compose + DB" ;;
        12) echo "Checkpoint Módulo II" ;;
        13) echo "Checkpoint Módulo IV" ;;
        14) echo "Checkpoint Módulo V" ;;
        *) echo "Unidad $1" ;;
    esac
}

# Mapear número a nombre de directorio (minúsculas como en el filesystem)
get_unit_dir() {
    case $1 in
        1) echo "i" ;;2) echo "ii-firewalls-redes" ;;3) echo "iii-iam-mfa" ;;4) echo "iv-criptografia-cvss" ;;
        5) echo "v-logging-siem-bcp" ;;6) echo "vi" ;;7) echo "vii" ;;8) echo "viii" ;;
        9) echo "ix" ;;10) echo "x" ;;11) echo "xi" ;;
        12) echo "checkpoint-ii" ;;13) echo "checkpoint-iv" ;;14) echo "checkpoint-v" ;;
        *) echo "" ;;
    esac
}

# Mapear número a nombre de unidad para el estado (con prefijo unit- o checkpoint-)
get_unit_name() {
    case $1 in
        1) echo "unit-I" ;;2) echo "unit-II" ;;3) echo "unit-III" ;;4) echo "unit-IV" ;;
        5) echo "unit-V" ;;6) echo "unit-VI" ;;7) echo "unit-VII" ;;8) echo "unit-VIII" ;;
        9) echo "unit-IX" ;;10) echo "unit-X" ;;11) echo "unit-XI" ;;
        12) echo "checkpoint-II" ;;13) echo "checkpoint-IV" ;;14) echo "checkpoint-V" ;;
        *) echo "" ;;
    esac
}

# Solo ejecutar el código principal si el archivo se ejecuta directamente
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    if [ $# -eq 0 ]; then
        echo -e "${CYAN}Uso: unidad <número>${RESET}"
        echo -e "${CYAN}Unidades disponibles: 1-14${RESET}"
        echo ""
        echo -e "  ${VERDE}1${RESET}  Principios y Gestión de Riesgo"
        echo -e "  ${VERDE}2${RESET}  Filtrado de Red y Firewalls"
        echo -e "  ${VERDE}3${RESET}  IAM, MFA y Control de Acceso"
        echo -e "  ${VERDE}4${RESET}  Criptografía y CVSS"
        echo -e "  ${VERDE}5${RESET}  Logging, SIEM y BCP"
        echo -e "  ${VERDE}6${RESET}  Almacenamiento y LVM"
        echo -e "  ${VERDE}7${RESET}  Hardening y CIS Benchmarks"
        echo -e "  ${VERDE}8${RESET}  Docker"
        echo -e "  ${VERDE}9${RESET}  Nginx"
        echo -e "  ${VERDE}10${RESET} SSL/TLS y Criptografía Aplicada"
        echo -e "  ${VERDE}11${RESET} Docker Compose + DB"
        echo -e "  ${VERDE}12${RESET} Checkpoint Módulo II"
        echo -e "  ${VERDE}13${RESET} Checkpoint Módulo IV"
        echo -e "  ${VERDE}14${RESET} Checkpoint Módulo V"
        echo ""
        echo -e "${AMARILLO}Unidad actual: ${CURRENT_UNIT:-ninguna}${RESET}"
        exit 0
    fi

    UNIT_NUM=$1

    if [ "$UNIT_NUM" -lt 1 ] || [ "$UNIT_NUM" -gt 14 ]; then
        error "Unidad debe estar entre 1 y 14"
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
