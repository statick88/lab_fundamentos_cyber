#!/bin/bash
# Unit VI: Storage Management — test.sh
# Refactorizado (C4): usa /shared/validators.sh + /shared/sudo-wrappers.sh

source /shared/common.sh
source /shared/validators.sh
source /shared/sudo-wrappers.sh

UNIT_NAME="unit-VI"
TOTAL_RETOS=10

reto1() {
    assert_command_ok lsblk
}

reto2() {
    assert_sudo_ok fdisk -l
}

reto3() {
    assert_command_ok dd if=/dev/zero of=/tmp/test_disk.img bs=1M count=5 2>/dev/null
    assert_file_exists /tmp/test_disk.img
    size=$(stat -c%s /tmp/test_disk.img 2>/dev/null || stat -f%z /tmp/test_disk.img 2>/dev/null)
    [ "$size" -gt 4000000 ]
    rm -f /tmp/test_disk.img
}

reto4() {
    assert_command_ok dd if=/dev/zero of=/tmp/test_disk.img bs=1M count=5 2>/dev/null
    assert_sudo_ok mkfs.ext4 /tmp/test_disk.img
    rm -f /tmp/test_disk.img
}

reto5() {
    assert_command_ok dd if=/dev/zero of=/tmp/test_disk.img bs=1M count=5 2>/dev/null
    assert_sudo_ok mkfs.ext4 /tmp/test_disk.img
    mkdir -p /tmp/test_mount
    assert_sudo_ok mount /tmp/test_disk.img /tmp/test_mount
    assert_mount_active /tmp/test_mount
    assert_sudo_ok umount /tmp/test_mount
    rm -f /tmp/test_disk.img
    rmdir /tmp/test_mount 2>/dev/null || true
}

reto6() {
    assert_command_ok dd if=/dev/zero of=/tmp/test_disk.img bs=1M count=5 2>/dev/null
    assert_sudo_ok mkfs.ext4 /tmp/test_disk.img
    mkdir -p /tmp/test_mount
    assert_sudo_ok mount /tmp/test_disk.img /tmp/test_mount
    echo "test" > /tmp/test_mount/test.txt
    assert_file_exists /tmp/test_mount/test.txt
    assert_sudo_ok umount /tmp/test_mount
    rm -f /tmp/test_disk.img
    rmdir /tmp/test_mount 2>/dev/null || true
}

reto7() {
    assert_command_ok dd if=/dev/zero of=/tmp/test_disk.img bs=1M count=5 2>/dev/null
    assert_sudo_ok mkfs.ext4 /tmp/test_disk.img
    mkdir -p /tmp/test_mount
    assert_sudo_ok mount /tmp/test_disk.img /tmp/test_mount
    assert_sudo_ok umount /tmp/test_mount
    ! assert_mount_active /tmp/test_mount
    rm -f /tmp/test_disk.img
    rmdir /tmp/test_mount 2>/dev/null || true
}

reto8() {
    assert_command_ok df -h
}

reto9() {
    assert_command_ok du -sh ~/laboratorio/
}

reto10() {
    rm -f ~/laboratorio/storage/disco_virtual.img 2>/dev/null
    assert_file_not_exists ~/laboratorio/storage/disco_virtual.img
}

validators=(reto1 reto2 reto3 reto4 reto5 reto6 reto7 reto8 reto9 reto10)
challenge_names=(
    "Ver dispositivos de bloque"
    "Ver tabla de particiones"
    "Crear disco virtual"
    "Formatear disco virtual"
    "Montar disco virtual"
    "Copiar archivos a disco"
    "Desmontar disco"
    "Ver espacio en disco"
    "Medir tamano de directorio"
    "Limpiar disco virtual"
)

ICONOS=("💾" "📋" "🟢" "🔄" "📂" "📝" "⭕" "📊" "📏" "🗑️")

reto1_info() {
    separador
    echo -e "${CYAN}Reto 1: Ver dispositivos de bloque${NC}"
    echo ""
    echo "Descubre los dispositivos de bloque disponibles en el sistema."
    echo "Comando util: lsblk"
    separador
}

reto2_info() {
    separador
    echo -e "${CYAN}Reto 2: Ver tabla de particiones${NC}"
    echo ""
    echo "Consulta la tabla de particiones de los discos del sistema."
    echo "Comando util: sudo fdisk -l"
    separador
}

reto3_info() {
    separador
    echo -e "${CYAN}Reto 3: Crear disco virtual${NC}"
    echo ""
    echo "Crea un archivo de disco virtual de al menos 5 MB usando dd."
    echo "Comando util: dd if=/dev/zero of=/tmp/disco_virtual.img bs=1M count=5"
    separador
}

reto4_info() {
    separador
    echo -e "${CYAN}Reto 4: Formatear disco virtual${NC}"
    echo ""
    echo "Formatea el disco virtual creado con el sistema de archivos ext4."
    echo "Comando util: sudo mkfs.ext4 /tmp/disco_virtual.img"
    separador
}

reto5_info() {
    separador
    echo -e "${CYAN}Reto 5: Montar disco virtual${NC}"
    echo ""
    echo "Monta el disco virtual en un directorio de tu sistema."
    echo "Comandos utiles: mkdir /tmp/montaje && sudo mount /tmp/disco_virtual.img /tmp/montaje"
    separador
}

reto6_info() {
    separador
    echo -e "${CYAN}Reto 6: Copiar archivos a disco${NC}"
    echo ""
    echo "Copia archivos al disco virtual montado."
    echo "Comando util: echo \"hola\" > /tmp/montaje/archivo.txt"
    separador
}

reto7_info() {
    separador
    echo -e "${CYAN}Reto 7: Desmontar disco${NC}"
    echo ""
    echo "Desmonta el disco virtual de forma segura."
    echo "Comando util: sudo umount /tmp/montaje"
    separador
}

reto8_info() {
    separador
    echo -e "${CYAN}Reto 8: Ver espacio en disco${NC}"
    echo ""
    echo "Consulta el espacio en disco disponible en el sistema."
    echo "Comando util: df -h"
    separador
}

reto9_info() {
    separador
    echo -e "${CYAN}Reto 9: Medir tamano de directorio${NC}"
    echo ""
    echo "Mide el tamano que ocupa un directorio."
    echo "Comando util: du -sh ~/laboratorio/"
    separador
}

reto10_info() {
    separador
    echo -e "${CYAN}Reto 10: Limpiar disco virtual${NC}"
    echo ""
    echo "Elimina el disco virtual que creaste para liberar espacio."
    echo "Comando util: rm ~/laboratorio/storage/disco_virtual.img"
    separador
}

# ── Standalone execution mode ────────────────────────────────
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Unit VI: Storage Management — Retos"
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
    echo "  Unit VI Results: $PASSED/$TOTAL_RETOS passed, $FAILED failed"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    [ "$FAILED" -eq 0 ]
fi
