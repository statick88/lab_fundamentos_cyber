#!/bin/bash
# Unit VII: Security Hardening — test.sh
# Refactorizado (C4): usa /shared/validators.sh + /shared/sudo-wrappers.sh

source /shared/common.sh
source /shared/validators.sh
source /shared/sudo-wrappers.sh

UNIT_NAME="unit-VII"
TOTAL_RETOS=15

reto1() {
    assert_command_ok awk -F: '$3 == 0 {print $1}' /etc/passwd
}

reto2() {
    assert_command_ok ls -la /etc/passwd /etc/shadow
}

reto3() {
    assert_command_ok awk -F: '($2 == "" || $2 == "!") {print $1}' /etc/shadow
}

reto4() {
    assert_sudo_ok cat /etc/sudoers
}

reto5() {
    assert_command_ok ss -tuln
}

reto6() {
    assert_ufw_active
}

reto7() {
    mkdir -p ~/.ssh
    assert_command_ok ssh-keygen -t rsa -b 2048 -f /tmp/test_key -N ""
    assert_file_exists /tmp/test_key
    rm -f /tmp/test_key /tmp/test_key.pub
}

reto8() {
    mkdir -p ~/.ssh
    assert_command_ok chmod 700 ~/.ssh
    perms=$(stat -c "%a" ~/.ssh 2>/dev/null)
    [ "$perms" = "700" ]
}

reto9() {
    local output
    output=$(lastb 2>/dev/null | head -5)
    [ -n "$output" ] || output=$(journalctl -u ssh 2>/dev/null | head -5)
    [ -n "$output" ] || output=$(cat /var/log/auth.log 2>/dev/null | head -5)
    [ -n "$output" ]
}

reto10() {
    assert_command_ok find / -perm -4000 -type f 2>/dev/null | head -5
}

reto11() {
    mount | grep -qE '/tmp.*noexec' 2>/dev/null || grep -qE '/tmp.*noexec' /etc/fstab 2>/dev/null
}

reto12() {
    mount | grep -qE '/var.*nosuid' 2>/dev/null || grep -qE '/var.*nosuid' /etc/fstab 2>/dev/null
}

reto13() {
    mount | grep -qE '/var/log.*nodev' 2>/dev/null || grep -qE '/var/log.*nodev' /etc/fstab 2>/dev/null
}

reto14() {
    assert_file_contains /etc/ssh/sshd_config "PermitRootLogin no" 2>/dev/null
}

reto15() {
    assert_file_contains /etc/ssh/sshd_config "Protocol 2" 2>/dev/null
}

validators=(reto1 reto2 reto3 reto4 reto5 reto6 reto7 reto8 reto9 reto10 reto11 reto12 reto13 reto14 reto15)
challenge_names=(
    "Verificar usuarios root"
    "Permisos archivos criticos"
    "Buscar usuarios sin contrasena"
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
    echo "Solo root deberia tener UID 0; si hay otros, son una amenaza."
    echo ""
    echo "Comandos utiles: awk, cat /etc/passwd"
    echo "Ejemplo: awk -F: '\$3 == 0 {print \$1}' /etc/passwd"
    separador
}

reto2_info() {
    separador
    echo -e "${CYAN}Reto 2: Permisos archivos criticos${NC}"
    echo ""
    echo "Revisa los permisos de los archivos mas sensibles del sistema:"
    echo "/etc/passwd y /etc/shadow."
    echo "Verifica quien puede leerlos y escribir en ellos."
    echo ""
    echo "Comandos utiles: ls -la, stat, getfacl"
    echo "Ejemplo: ls -la /etc/passwd /etc/shadow"
    separador
}

reto3_info() {
    separador
    echo -e "${CYAN}Reto 3: Buscar usuarios sin contrasena${NC}"
    echo ""
    echo "Identifica usuarios que no tienen contrasena asignada."
    echo "Un usuario sin contrasena es un vector de acceso directo."
    echo ""
    echo "Comandos utiles: awk, cat /etc/shadow"
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
    echo "Comandos utiles: cat, visudo -c, grep"
    echo "Ejemplo: cat /etc/sudoers"
    separador
}

reto5_info() {
    separador
    echo -e "${CYAN}Reto 5: Ver servicios abiertos${NC}"
    echo ""
    echo "Lista todos los puertos y servicios que estan escuchando conexiones."
    echo "Cada puerto abierto es una puerta de entrada potencial."
    echo ""
    echo "Comandos utiles: ss, netstat, lsof"
    echo "Ejemplo: ss -tuln"
    separador
}

reto6_info() {
    separador
    echo -e "${CYAN}Reto 6: Verificar firewall${NC}"
    echo ""
    echo "Consulta el estado del firewall configurado en el sistema."
    echo "Verifica si UFW, iptables u otro firewall esta activo y que reglas tiene."
    echo ""
    echo "Comandos utiles: ufw status, iptables -L, nft list ruleset"
    echo "Ejemplo: sudo ufw status verbose"
    separador
}

reto7_info() {
    separador
    echo -e "${CYAN}Reto 7: Generar claves SSH${NC}"
    echo ""
    echo "Genera un par de claves SSH (publica y privada) usando RSA de 2048 bits."
    echo "Las claves SSH son mas seguras que las contrasenas para autenticacion."
    echo ""
    echo "Comandos utiles: ssh-keygen"
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
    echo "Comandos utiles: chmod, stat"
    echo "Ejemplo: chmod 700 ~/.ssh"
    separador
}

reto9_info() {
    separador
    echo -e "${CYAN}Reto 9: Ver intentos de login${NC}"
    echo ""
    echo "Revisa los registros de intentos de inicio de sesion fallidos."
    echo "Detecta posibles ataques de fuerza bruta o accesos no autorizados."
    echo ""
    echo "Comandos utiles: lastb, journalctl, grep /var/log/auth.log"
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
    echo "Comandos utiles: find, chmod"
    echo "Ejemplo: find / -perm -4000 -type f 2>/dev/null"
    separador
}

reto11_info() {
    separador
    echo -e "${CYAN}Reto 11: /tmp montado noexec,nosuid,nodev${NC}"
    echo ""
    echo "Verifica que /tmp esta montado con las opciones noexec, nosuid y nodev."
    echo "Esto previene ejecucion de binarios en /tmp y reduces la superficie de ataque."
    echo ""
    echo "Comandos utiles: mount, grep /etc/fstab"
    echo "Ejemplo: mount | grep /tmp"
    separador
}

reto12_info() {
    separador
    echo -e "${CYAN}Reto 12: /var montado nosuid,nodev${NC}"
    echo ""
    echo "Verifica que /var esta montado con nosuid y nodev."
    echo "Esto evita que binarios SUID/SGID se ejecuten desde /var."
    echo ""
    echo "Comandos utiles: mount, grep /etc/fstab"
    echo "Ejemplo: mount | grep /var"
    separador
}

reto13_info() {
    separador
    echo -e "${CYAN}Reto 13: /var/log montado nodev${NC}"
    echo ""
    echo "Verifica que /var/log esta montado con nodev."
    echo "Esto impide la creacion de dispositivos especiales en /var/log."
    echo ""
    echo "Comandos utiles: mount, grep /etc/fstab"
    echo "Ejemplo: mount | grep /var/log"
    separador
}

reto14_info() {
    separador
    echo -e "${CYAN}Reto 14: PermitRootLogin deshabilitado${NC}"
    echo ""
    echo "Verifica que PermitRootLogin esta configurado como 'no' en /etc/ssh/sshd_config."
    echo "Deshabilitar login root por SSH es una medida fundamental de hardening."
    echo ""
    echo "Comandos utiles: grep /etc/ssh/sshd_config"
    echo "Ejemplo: grep -i 'PermitRootLogin' /etc/ssh/sshd_config"
    separador
}

reto15_info() {
    separador
    echo -e "${CYAN}Reto 15: SSH Protocol 2${NC}"
    echo ""
    echo "Verifica que SSH esta configurado para usar solo Protocolo 2 en /etc/ssh/sshd_config."
    echo "El protocolo 1 esta obsoleto y tiene vulnerabilidades conocidas."
    echo ""
    echo "Comandos utiles: grep /etc/ssh/sshd_config"
    echo "Ejemplo: grep -i 'Protocol' /etc/ssh/sshd_config"
    separador
}

# ── Standalone execution mode ────────────────────────
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
