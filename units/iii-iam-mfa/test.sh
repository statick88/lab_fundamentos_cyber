#!/bin/bash
# Unit III-iam-mfa: IAM, MFA y Control de Acceso — test.sh

set -e
source /shared/common.sh

UNIT_NAME="unit-III"
TOTAL_RETOS=5

reto1() {
    # Verify student created group and user scripts/configs
    [ -f "$HOME/laboratorio/iam/crear_grupo_usuario.sh" ] || [ -f "$HOME/laboratorio/iam/grupo_sysadmins.txt" ]
    getent group sysadmins >/dev/null 2>&1 || true
    id ops_admin >/dev/null 2>&1 || true
}

reto2() {
    # Verify student created sudoers configuration
    [ -f "$HOME/laboratorio/iam/sudoers_config/lab-cyber" ]
    grep -qi "NOPASSWD\|sudoers" "$HOME/laboratorio/iam/sudoers_config/lab-cyber" 2>/dev/null || true
}

reto3() {
    # Verify student configured password policy
    [ -f "$HOME/laboratorio/iam/login_defs_example.txt" ] || [ -f "$HOME/laboratorio/iam/password_policy.sh" ]
    grep -qi "PASS_MAX_DAYS\|PASS_MIN_DAYS" "$HOME/laboratorio/iam/login_defs_example.txt" 2>/dev/null || true
}

reto4() {
    # Verify student configured Google Authenticator PAM
    [ -f "$HOME/laboratorio/iam/pam_config/common-auth" ] || [ -f "$HOME/laboratorio/iam/google_auth_setup.sh" ]
    grep -qi "google_authenticator\|pam_google" "$HOME/laboratorio/iam/pam_config/common-auth" 2>/dev/null || true
}

reto5() {
    # Verify student created audit script
    [ -f "$HOME/laboratorio/iam/audit_privileged.sh" ] && [ -x "$HOME/laboratorio/iam/audit_privileged.sh" ]
    grep -qi "awk\|grep\|passwd\|sudoers" "$HOME/laboratorio/iam/audit_privileged.sh" 2>/dev/null || true
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
