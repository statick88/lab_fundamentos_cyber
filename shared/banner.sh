#!/bin/bash
# Banners y elementos visuales

banner_bienvenida() {
    clear
    echo -e "${CYAN_B}"
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║     FUNDAMENTOS DE CIBERSEGURIDAD - ABC-CYB-101            ║
║     Laboratorio Interactivo de Ciberseguridad              ║
╚══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${RESET}"
}

banner_unidad() {
    local num=$1 titulo=$2
    echo -e "\n${CYAN_B}╔══════════════════════════════════════════════════╗"
    echo "║  Unidad $num: $titulo"
    echo -e "╚══════════════════════════════════════════════════╝${RESET}\n"
}

banner_felicitacion() {
    echo -e "\n${VERDE_B}╔══════════════════════════════════════════════════╗"
    echo "║   🎉  FELICIDADES - UNIDAD COMPLETADA"
    echo "║   Palabra revelada: $2"
    echo -e "╚══════════════════════════════════════════════════╝${RESET}"
}

banner_frase_completa() {
    echo -e "\n${VERDE_B}╔══════════════════════════════════════════════════╗"
    echo "║   🏆  FRASE SECRETA COMPLETA"
    echo "║   Has completado todas las unidades del curso."
    echo -e "╚══════════════════════════════════════════════════╝${RESET}"
}
