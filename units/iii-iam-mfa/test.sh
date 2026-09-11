#!/bin/bash
# Unit III-iam-mfa: IAM, MFA y Control de Acceso — test.sh
# Estandarizado: usa /shared/validators.sh para aserciones deterministicas
# Sin dependencias de sudo/root. Paths bajo $HOME/laboratorio.

# Support both container (/shared) and local (relative) paths
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
fi
if [ -f "/shared/validators.sh" ]; then
    source /shared/validators.sh
else
    source "$(dirname "$0")/../../shared/validators.sh"
fi

UNIT_NAME="unit-III"
TOTAL_RETOS=5

LAB_DIR="$HOME/laboratorio/iam"

# ── Reto 1: Crear grupo sysadmins y usuario ops_admin ─────────────
# Valida que el script de scaffold contenga los comandos de creación.
# Escribe contenido correcto para garantizar idempotencia.
reto1() {
    local script="$LAB_DIR/crear_grupo_usuario.sh"
    assert_file_exists "$script"
    assert_file_contains "$script" "sysadmins"
    assert_file_contains "$script" "ops_admin"
}

# ── Reto 2: Configurar sudoers ────────────────────────────────────
# Valida el archivo de configuracion sudoers en el directorio de
# laboratorio, no en /etc/sudoers.d (que requiere root).
reto2() {
    local config_file="$LAB_DIR/sudoers_config/lab-cyber"
    assert_file_exists "$config_file"
    assert_file_contains "$config_file" "sysadmins"
    assert_file_contains "$config_file" "NOPASSWD"
}

# ── Reto 3: Configurar politica de contrasenas ────────────────────
# Valida que el script/documento de política de contraseñas contenga
# las directivas PASS_MAX_DAYS y PASS_MIN_DAYS.
reto3() {
    local policy_file="$LAB_DIR/password_policy.sh"
    assert_file_exists "$policy_file"
    assert_file_contains "$policy_file" "PASS_MAX_DAYS"
    assert_file_contains "$policy_file" "PASS_MIN_DAYS"
}

# ── Reto 4: Configurar Google Authenticator PAM ───────────────────
# Valida que el archivo de configuracion PAM en el directorio de
# laboratorio contenga la directiva pam_google_authenticator.so.
reto4() {
    local pam_file="$LAB_DIR/pam_config/common-auth"
    assert_file_exists "$pam_file"
    assert_file_contains "$pam_file" "pam_google_authenticator"
}

# ── Reto 5: Script de auditoria de usuarios privilegiados ───────────
# Reutiliza el script ya existente en el directorio de laboratorio.
reto5() {
    local script="$LAB_DIR/audit_privileged.sh"
    assert_file_exists "$script"
    assert_command_ok test -x "$script"
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
    echo "Crea un script que defina la creación del grupo 'sysadmins'"
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
    echo "Crea un archivo de configuración PAM que habilite Google Authenticator."
    echo "Incluye la línea: auth required pam_google_authenticator.so"
    echo ""
    echo "Comandos útiles:"
    echo "  nano ~/laboratorio/iam/pam_config/common-auth"
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

# ── Standalone execution mode ─────────────────────────────────────
# When invoked directly (not sourced), run all validators and report results.
# This enables: bash test.sh | ./test.sh | validate-m4-m6-labs.sh sourcing.
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Unit III: IAM, MFA y Control de Acceso — Retos"
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
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Unit III-iam-mfa Results: $PASSED/$TOTAL_RETOS passed, $FAILED failed"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    [ "$FAILED" -eq 0 ]
fi