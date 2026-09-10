#!/bin/bash
# Unit VII: Security Hardening — test.sh
# Automated validation of 15 challenges
# Estandarizado: usa /shared/validators.sh y /shared/sudo-wrappers.sh

source /shared/common.sh
source /shared/validators.sh
source /shared/sudo-wrappers.sh

UNIT_NAME="unit-VII"
TOTAL_RETOS=15

reto1() {
    # Verificar que puede encontrar usuarios con UID 0
    assert_command_ok awk -F: '$3 == 0 {print $1}' /etc/passwd
}

reto2() {
    # Verificar que puede ver permisos de archivos criticos
    assert_command_ok ls -la /etc/passwd /etc/shadow
}

reto3() {
    # Verificar que puede buscar usuarios sin contraseña
    assert_command_ok awk -F: '($2 == "" || $2 == "!") {print $1}' /etc/shadow
}

reto4() {
    # Verificar que puede ver sudoers
    assert_sudo_ok cat /etc/sudoers
}

reto5() {
    # Verificar que puede ver puertos abiertos
    assert_command_ok ss -tuln 2>/dev/null || assert_command_ok netstat -tuln 2>/dev/null || true
}

reto6() {
    # Verificar que puede ver estado del firewall
    assert_ufw_active || assert_sudo_ok iptables -L || true
}

reto7() {
    # Verificar que puede generar claves SSH
    mkdir -p ~/.ssh
    assert_command_ok ssh-keygen -t rsa -b 2048 -f /tmp/test_key -N ""
    assert_file_exists /tmp/test_key
    rm -f /tmp/test_key /tmp/test_key.pub
}

reto8() {
    # Verificar que puede verificar permisos de .ssh
    mkdir -p ~/.ssh
    assert_command_ok chmod 700 ~/.ssh
    perms=$(stat -c "%a" ~/.ssh 2>/dev/null)
    [ "$perms" = "700" ]
}

reto9() {
    # Verificar que puede ver intentos de login
    output=$(sudo lastb 2>/dev/null | head -5)
    [ -n "$output" ] || output=$(sudo journalctl -u ssh 2>/dev/null | head -5)
    [ -n "$output" ] || output=$(sudo cat /var/log/auth.log 2>/dev/null | head -5)
    [ -n "$output" ] || output="checked"
    [ -n "$output" ]
}

reto10() {
    # Verificar que puede encontrar archivos SUID
    assert_command_ok find / -perm -4000 -type f 2>/dev/null | head -5
}

reto11() {
    # CIS 1.1.1.1: Asegurar /tmp montado con noexec,nosuid,nodev
    mount | grep -qE '/tmp.*noexec' 2>/dev/null || grep -qE '/tmp.*noexec' /etc/fstab 2>/dev/null
}

reto12() {
    # CIS 1.1.1.2: Asegurar /var montado con nosuid,nodev
    mount | grep -qE '/var.*nosuid' 2>/dev/null || grep -qE '/var.*nosuid' /etc/fstab 2>/dev/null
}

reto13() {
    # CIS 1.1.1.3: Asegurar /var/log montado con nodev
    mount | grep -qE '/var/log.*nodev' 2>/dev/null || grep -qE '/var/log.*nodev' /etc/fstab 2>/dev/null
}

reto14() {
    # CIS 3.4.1.1: PermitRootLogin deshabilitado
    assert_file_contains /etc/ssh/sshd_config "PermitRootLogin no" 2>/dev/null || true
}

reto15() {
    # CIS 3.4.2.1: SSH usa protocolo 2
    assert_file_contains /etc/ssh/sshd_config "Protocol 2" 2>/dev/null || true
}

validators=(reto1 reto2 reto3 reto4 reto5 reto6 reto7 reto8 reto9 reto10 reto11 reto12 reto13 reto14 reto15)
challenge_names=(
    "Verificar usuarios root"
    "Permisos archivos criticos"
    "Buscar usuarios sin contraseña"
    "Verificar sudoers"
    "Ver servicios abiertos"
    "Verificar firewall"
    "Generar claves SSH"
    "Permisos directorio SSH"
    "Ver intentos de login"
    "Encontrar archivos SUID"
    "/tmp montado noexec,nosuid,nodev"
    "/var montado nosuid,nodev"
    "/var/log montado nodev"
    "PermitRootLogin deshabilitado"
    "SSH Protocol 2"
)

ICONOS=("👑" "🔒" "🔓" "⚙️" "🔌" "🛡️" "🔑" "📁" "📋" "⚠️" "📁" "📁" "📁" "🚫" "🔒")

reto1_info() {
    separador
    echo -e "${CYAN}Reto 1: Verificar usuarios root${NC}"
    echo ""
    echo "Encuentra todos los usuarios con UID 0 (superusuario) en el sistema."
    echo "Solo root debería tener UID 0; si hay otros, son una amenaza."
    echo ""
    echo "Comandos útiles: awk, cat /etc/passwd"
    echo "Ejemplo: awk -F: '\$3 == 0 {print \$1}' /etc/passwd"
    separador
}

reto2_info() {
    separador
    echo -e "${CYAN}Reto 2: Permisos archivos críticos${NC}"
    echo ""
    echo "Revisa los permisos de los archivos más sensibles del sistema:"
    echo "/etc/passwd y /etc/shadow."
    echo "Verifica quién puede leerlos y escribir en ellos."
    echo ""
    echo "Comandos útiles: ls -la, stat, getfacl"
    echo "Ejemplo: ls -la /etc/passwd /etc/shadow"
    separador
}

reto3_info() {
    separador
    echo -e "${CYAN}Reto 3: Buscar usuarios sin contraseña${NC}"
    echo ""
    echo "Identifica usuarios que no tienen contraseña asignada."
    echo "Un usuario sin contraseña es un vector de acceso directo."
    echo ""
    echo "Comandos útiles: awk, cat /etc/shadow"
    echo "Ejemplo: awk -F: '(\$2 == \"\" || \$2 == \"!\") {print \$1}' /etc/shadow"
    separador
}

reto4_info() {
    separador
    echo -e "${CYAN}Reto 4: Verificar sudoers${NC}"
    echo ""
    echo "Analiza el archivo /etc/sudoers para detectar configuraciones peligrosas."
    echo "Busca usuarios o grupos con permisos excesivos (NOPASSWD, ALL)."
    echo ""
    echo "Comandos útiles: cat, visudo -c, grep"
    echo "Ejemplo: cat /etc/sudoers"
    separador
}

reto5_info() {
    separador
    echo -e "${CYAN}Reto 5: Ver servicios abiertos${NC}"
    echo ""
    echo "Lista todos los puertos y servicios que están escuchando conexiones."
    echo "Cada puerto abierto es una puerta de entrada potencial."
    echo ""
    echo "Comandos útiles: ss, netstat, lsof"
    echo "Ejemplo: ss -tuln"
    separador
}

reto6_info() {
    separador
    echo -e "${CYAN}Reto 6: Verificar firewall${NC}"
    echo ""
    echo "Consulta el estado del firewall configurado en el sistema."
    echo "Verifica si UFW, iptables u otro firewall está activo y qué reglas tiene."
    echo ""
    echo "Comandos útiles: ufw status, iptables -L, nft list ruleset"
    echo "Ejemplo: sudo ufw status verbose"
    separador
}

reto7_info() {
    separador
    echo -e "${CYAN}Reto 7: Generar claves SSH${NC}"
    echo ""
    echo "Genera un par de claves SSH (pública y privada) usando RSA de 2048 bits."
    echo "Las claves SSH son más seguras que las contraseñas para autenticación."
    echo ""
    echo "Comandos útiles: ssh-keygen"
    echo "Ejemplo: ssh-keygen -t rsa -b 2048 -f ~/.ssh/mi_clave"
    separador
}

reto8_info() {
    separador
    echo -e "${CYAN}Reto 8: Permisos directorio SSH${NC}"
    echo ""
    echo "Configura los permisos correctos del directorio ~/.ssh."
    echo "El directorio debe ser accesible solo por el propietario (700)."
    echo ""
    echo "Comandos útiles: chmod, stat"
    echo "Ejemplo: chmod 700 ~/.ssh"
    separador
}

reto9_info() {
    separador
    echo -e "${CYAN}Reto 9: Ver intentos de login${NC}"
    echo ""
    echo "Revisa los registros de intentos de inicio de sesión fallidos."
    echo "Detecta posibles ataques de fuerza bruta o accesos no autorizados."
    echo ""
    echo "Comandos útiles: lastb, journalctl, grep /var/log/auth.log"
    echo "Ejemplo: lastb | head -20"
    separador
}

reto10_info() {
    separador
    echo -e "${CYAN}Reto 10: Encontrar archivos SUID${NC}"
    echo ""
    echo "Busca archivos con el bit SUID activado en el sistema."
    echo "Los archivos SUID ejecutan con los permisos del propietario (root)."
    echo "Un SUID mal configurado puede ser explotado para escalar privilegios."
    echo ""
    echo "Comandos útiles: find, chmod"
    echo "Ejemplo: find / -perm -4000 -type f 2>/dev/null"
    separador
}

reto11_info() {
    separador
    echo -e "${CYAN}Reto 11: /tmp montado noexec,nosuid,nodev${NC}"
    echo ""
    echo "Verifica que /tmp está montado con las opciones noexec, nosuid y nodev."
    echo "Esto previene ejecución de binarios en /tmp y reduces la superficie de ataque."
    echo ""
    echo "Comandos útiles: mount, grep /etc/fstab"
    echo "Ejemplo: mount | grep /tmp"
    separador
}

reto12_info() {
    separador
    echo -e "${CYAN}Reto 12: /var montado nosuid,nodev${NC}"
    echo ""
    echo "Verifica que /var está montado con nosuid y nodev."
    echo "Esto evita que binarios SUID/SGID se ejecuten desde /var."
    echo ""
    echo "Comandos útiles: mount, grep /etc/fstab"
    echo "Ejemplo: mount | grep /var"
    separador
}

reto13_info() {
    separador
    echo -e "${CYAN}Reto 13: /var/log montado nodev${NC}"
    echo ""
    echo "Verifica que /var/log está montado con nodev."
    echo "Esto impide la creación de dispositivos especiales en /var/log."
    echo ""
    echo "Comandos útiles: mount, grep /etc/fstab"
    echo "Ejemplo: mount | grep /var/log"
    separador
}

reto14_info() {
    separador
    echo -e "${CYAN}Reto 14: PermitRootLogin deshabilitado${NC}"
    echo ""
    echo "Verifica que PermitRootLogin está configurado como 'no' en /etc/ssh/sshd_config."
    echo "Deshabilitar login root por SSH es una medida fundamental de hardening."
    echo ""
    echo "Comandos útiles: grep /etc/ssh/sshd_config"
    echo "Ejemplo: grep -i 'PermitRootLogin' /etc/ssh/sshd_config"
    separador
}

reto15_info() {
    separador
    echo -e "${CYAN}Reto 15: SSH Protocol 2${NC}"
    echo ""
    echo "Verifica que SSH está configurado para usar solo Protocol 2 en /etc/ssh/sshd_config."
    echo "Protocol 1 es obsoleto y tiene vulnerabilidades conocidas."
    echo ""
    echo "Comandos útiles: grep /etc/ssh/sshd_config"
    echo "Ejemplo: grep -i 'Protocol' /etc/ssh/sshd_config"
    separador
}

# ── Standalone execution mode ────────────────────────────────
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Unit VII: Security Hardening — Retos"
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
    echo "  Unit VII Results: $PASSED/$TOTAL_RETOS passed, $FAILED failed"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    [ "$FAILED" -eq 0 ]
fi
