#!/bin/bash
# Unit III-iam-mfa: IAM, MFA y Control de Acceso — test.sh

source /shared/common.sh

UNIT_NAME="unit-III"
TOTAL_RETOS=5

reto1() {
    local has_group=0 has_user=0
    if getent group sysadmins >/dev/null 2>&1; then
        has_group=1
    fi
    if id -u ops_admin >/dev/null 2>&1; then
        has_user=1
    fi
    if [ "$has_group" -eq 1 ] && [ "$has_user" -eq 1 ]; then
        return 0
    fi
    local script="$HOME/laboratorio/iam/crear_grupo_usuario.sh"
    if [ -f "$script" ]; then
        grep -q "groupadd.*sysadmins" "$script" 2>/dev/null && grep -q "useradd.*ops_admin" "$script" 2>/dev/null
    else
        return 1
    fi
}

reto2() {
    local config_file="/etc/sudoers.d/lab-cyber"
    if [ -f "$config_file" ]; then
        local perms
        perms=$(stat -c "%a" "$config_file" 2>/dev/null || stat -f "%Lp" "$config_file" 2>/dev/null || echo "")
        if [ "$perms" = "440" ] || [ "$perms" = "0440" ]; then
            visudo -c -f "$config_file" >/dev/null 2>&1
        else
            return 1
        fi
    else
        return 1
    fi
}

reto3() {
    if [ -f /etc/login.defs ]; then
        grep -qE "PASS_MAX_DAYS|PASS_MIN_DAYS" /etc/login.defs 2>/dev/null
    else
        return 1
    fi
}

reto4() {
    if [ -f /etc/pam.d/common-auth ]; then
        grep -qi "google_authenticator\|pam_google" /etc/pam.d/common-auth 2>/dev/null
    else
        return 1
    fi
}

reto5() {
    local script="$HOME/laboratorio/iam/audit_privileged.sh"
    if [ -f "$script" ] && [ -x "$script" ]; then
        "$script" >/dev/null 2>&1
    else
        return 1
    fi
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

# ── Standalone execution mode ────────────────────────────────
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
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Unit III-iam-mfa Results: $PASSED/$TOTAL_RETOS passed, $FAILED failed"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    [ "$FAILED" -eq 0 ]
fi
