#!/bin/bash
# Unit III-iam-mfa: IAM, MFA y Control de Acceso — setup.sh

set -e
# Support both container (/shared) and local (relative) paths
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
fi

# Canonical evaluator identity from shared/units_manifest.sh.
UNIT_NAME="unit-III"
UNIT_NUM=3
export TOTAL_RETOS=5

banner_unidad "$UNIT_NUM" "IAM, MFA y Control de Acceso"

echo -e "${CYAN}Esta unidad cubre: IAM, MFA, sudoers, políticas de contraseñas, PAM.${RESET}"
echo -e "${AMARILLO}Completarás 5 retos prácticos.${RESET}\n"

LAB_DIR="$HOME/laboratorio/iam"
REFERENCE_DIR="$LAB_DIR/referencias"
mkdir -p "$REFERENCE_DIR"

# Reference-only material: these files are intentionally outside the validator
# targets and contain placeholders, so setup alone cannot complete a challenge.
cat > "$REFERENCE_DIR/README.md" << 'EOF'
# IAM lab reference material

Create your own deliverables directly in `~/laboratorio/iam` using the names
shown in each challenge. The reference files are not submissions.
EOF

cat > "$REFERENCE_DIR/sudoers_lab-cyber.template" << 'EOF'
# Replace the placeholders in your own ~/laboratorio/iam/sudoers_lab-cyber file.
# <principal> ALL=(ALL) NOPASSWD: <restricted-command-path>
EOF

cat > "$REFERENCE_DIR/password_policy.conf.template" << 'EOF'
# Document the selected values in your own password_policy.conf.
PASS_MAX_DAYS <maximum-days>
PASS_MIN_DAYS <minimum-days>
PASS_WARN_AGE <warning-days>
EOF

cat > "$REFERENCE_DIR/pam_mfa_plan.conf.template" << 'EOF'
# Document the selected PAM MFA module and a rollback/backup plan in your own file.
# auth required pam_google_authenticator.so <module-options>
EOF

cat > "$REFERENCE_DIR/audit_privileged.sh.template" << 'EOF'
#!/bin/bash
# Create your own audit_privileged.sh. It must inspect accounts and write a report.
EOF

exito "Entorno de Unit III-IAM-MFA preparado con 5 retos"
echo -e "${AMARILLO}Crea tus entregables en ${CYAN}$LAB_DIR${AMARILLO}; las referencias no cuentan como respuestas.${RESET}"
echo -e "${AMARILLO}Escribe ${CYAN}'manual'${AMARILLO} para ver la guía o ${CYAN}'evaluar'${AMARILLO} para evaluar.${RESET}"
