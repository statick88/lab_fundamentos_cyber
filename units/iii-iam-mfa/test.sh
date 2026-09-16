#!/bin/bash
# Unit iii-iam-mfa: IAM, MFA y Control de Acceso — test.sh
# Refactorizado (C4): usa /shared/validators.sh + /shared/sudo-wrappers.sh

source /shared/common.sh
source /shared/validators.sh
source /shared/sudo-wrappers.sh

UNIT_NAME="unit-III"
TOTAL_RETOS=5

reto1() {
    # Live check: group + user exist
    if assert_group_exists sysadmins && assert_user_exists ops_admin; then
        return 0
    fi
    # Fallback: script contains creation commands
    local script="$HOME/laboratorio/iam/crear_grupo_usuario.sh"
    assert_file_exists "$script" || return 1
    assert_file_contains "$script" "groupadd.*sysadmins" || return 1
    assert_file_contains "$script" "useradd.*ops_admin" || return 1
}

reto2() {
    local config_file="/etc/sudoers.d/lab-cyber"
    assert_file_exists "$config_file" || return 1
    # Verify permissions are 440 (root-read only)
    local perms
    perms=$(stat -c "%a" "$config_file" 2>/dev/null || stat -f "%Lp" "$config_file" 2>/dev/null || echo "")
    if [ "$perms" != "440" ] && [ "$perms" != "0440" ]; then
        echo "FAIL: Permisos esperados 440, obtendidos $perms" >&2
        return 1
    fi
    assert_command_ok visudo -c -f "$config_file"
}

reto3() {
    assert_file_contains /etc/login.defs "PASS_MAX_DAYS|PASS_MIN_DAYS"
}

reto4() {
    assert_file_contains /etc/pam.d/common-auth "google_authenticator|pam_google"
}

reto5() {
    local script="$HOME/laboratorio/iam/audit_privileged.sh"
    assert_file_exists "$script" || return 1
    assert_command_ok "$script"
}

validators=(reto1 reto2 reto3 reto4 reto5)
challenge_names=(
    "Crear grupo y usuario sysadmin"
    "Configurar sudoers"
    "Politica de contrasenas"
    "Google Authenticator PAM"
    "Script auditoria usuarios"
)

ICONOS=("👤" "🔑" "🔒" "🔐" "📊")

reto1_info() {
    separador
    echo -e "${CYAN}Reto 1: Crear grupo sysadmins y usuario ops_admin${NC}"
    echo ""
    echo "Crea un script o documento que defina la creación del grupo 'sysadmins'"
    echo "y el usuario 'ops_admin' asignado a ese grupo."
    echo ""
    echo "Comandos útiles:"
    echo "  nano ~/laboratorio/iam/crear_grupo_usuario.sh"
    echo "  echo 'sudo groupadd sysadmins' > ~/laboratorio/iam/crear_grupo_usuario.sh"
    separador
}

reto2_info() {
    separador
    echo -e "${CYAN}Reto 2: Configurar sudoers para comandos específicos${NC}"
    echo ""
    echo "Crea un archivo de configuración sudoers en tu directorio de laboratorio."
    echo "Ejemplo: %sysadmins ALL=(ALL) NOPASSWD: /usr/bin/systemctl"
    echo ""
    echo "Comandos útiles:"
    echo "  nano ~/laboratorio/iam/sudoers_config/lab-cyber"
    separador
}

reto3_info() {
    separador
    echo -e "${CYAN}Reto 3: Configurar política de contraseñas${NC}"
    echo ""
    echo "Crea un documento o script que defina la política de contraseñas."
    echo "Incluye: PASS_MAX_DAYS, PASS_MIN_DAYS, PASS_WARN_AGE."
    echo ""
    echo "Comandos útiles:"
    echo "  nano ~/laboratorio/iam/password_policy.sh"
    separador
}

reto4_info() {
    separador
    echo -e "${CYAN}Reto 4: Instalar Google Authenticator PAM${NC}"
    echo ""
    echo "Crea un script o documento que configure PAM para Google Authenticator."
    echo "Incluye la línea: auth required pam_google_authenticator.so"
    echo ""
    echo "Comandos útiles:"
    echo "  nano ~/laboratorio/iam/google_auth_setup.sh"
    separador
}

reto5_info() {
    separador
    echo -e "${CYAN}Reto 5: Script de auditoría de usuarios con privilegios${NC}"
    echo ""
    echo "Crea un script audit_privileged.sh que liste usuarios con UID 0 o"
    echo "permisos sudo. Usa awk para filtrar /etc/passwd y /etc/sudoers."
    echo ""
    echo "Comandos útiles:"
    echo "  nano ~/laboratorio/iam/audit_privileged.sh"
    echo "  awk -F: '\$3 == 0 {print \$1}' /etc/passwd"
    separador
}
