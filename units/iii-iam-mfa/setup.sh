#!/bin/bash
# Unit III-iam-mfa: IAM, MFA y Control de Acceso — setup.sh

set -e
source /shared/common.sh

UNIT_NAME="unit-III"
UNIT_NUM=3
export TOTAL_RETOS=5

banner_unidad "$UNIT_NUM" "IAM, MFA y Control de Acceso"

echo -e "${CYAN}Esta unidad cubre: IAM, MFA, sudoers, políticas de contraseñas, PAM.${RESET}"
echo -e "${AMARILLO}Completarás 5 retos prácticos.${RESET}\n"

mkdir -p "$HOME/laboratorio/iam"
cd "$HOME/laboratorio/iam"

# Crear archivos de configuración de ejemplo (en el directorio del usuario)
mkdir -p sudoers_config
cat > sudoers_config/lab-cyber << 'SUDOERS'
# Configuracion de ejemplo para sudoers
# %sysadmins ALL=(ALL) NOPASSWD: /usr/bin/systemctl, /usr/bin/journalctl
SUDOERS

mkdir -p pam_config
cat > pam_config/common-auth << 'PAM'
# Configuracion de ejemplo para PAM
# auth required pam_google_authenticator.so
PAM

cat > login_defs_example.txt << 'LOGINDEFS'
# Ejemplo de /etc/login.defs
PASS_MAX_DAYS 90
PASS_MIN_DAYS 1
PASS_WARN_AGE 14
LOGINDEFS

exito "Entorno de Unit III preparado con 5 retos"
echo -e "${AMARILLO}Escribe ${CYAN}'manual'${AMARILLO} para ver la guía o ${CYAN}'evaluar'${AMARILLO} para evaluar.${RESET}"
