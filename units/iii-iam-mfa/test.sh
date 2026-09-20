#!/bin/bash
# Unit iii-iam-mfa: IAM, MFA y Control de Acceso — test.sh
# Validators inspect only explicit student deliverables under ~/laboratorio/iam.

if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
    source /shared/validators.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
    source "$(dirname "$0")/../../shared/validators.sh"
fi

# Canonical evaluator identity from shared/units_manifest.sh.
UNIT_NAME="unit-III"
TOTAL_RETOS=5
LAB_DIR="$HOME/laboratorio/iam"

has_placeholder() {
    grep -Eqi 'TODO|FIXME|<[^>]+>|REPLACE|COMPLETA(R)?|PLACEHOLDER' "$1"
}

reto1() {
    local script="$LAB_DIR/crear_grupo_usuario.sh"
    assert_file_exists "$script" || return 1
    [ -x "$script" ] || return 1
    assert_command_ok bash -n "$script" || return 1
    ! has_placeholder "$script" || return 1
    grep -Eq '(^|[;&[:space:]])(sudo[[:space:]]+)?groupadd([[:space:]]|[^[:alnum:]_]).*sysadmins' "$script" || return 1
    grep -Eq '(^|[;&[:space:]])(sudo[[:space:]]+)?(useradd|adduser)([[:space:]]|[^[:alnum:]_]).*ops_admin' "$script" || return 1
    grep -Eq '(usermod[[:space:]]+-aG[[:space:]]+sysadmins.*ops_admin|gpasswd[[:space:]]+-a[[:space:]]+ops_admin[[:space:]]+sysadmins)' "$script"
}

reto2() {
    local config_file="$LAB_DIR/sudoers_lab-cyber"
    assert_file_exists "$config_file" || return 1
    ! has_placeholder "$config_file" || return 1
    assert_command_ok visudo -c -f "$config_file" || return 1
    grep -Eq '(^|[[:space:]])(ops_admin|%sysadmins)[[:space:]]+ALL=\(ALL\)[[:space:]]+' "$config_file" || return 1
    grep -Eq '/(usr/)?(bin|sbin)/[[:alnum:]_.-]+' "$config_file" || return 1
    ! grep -Eq '(^|[[:space:]])(ops_admin|%sysadmins)[[:space:]]+ALL=\(ALL\)[[:space:]]+(NOPASSWD:[[:space:]]+)?ALL([[:space:]]|$)' "$config_file"
}

reto3() {
    local policy_file=""
    local candidate
    for candidate in "$LAB_DIR/password_policy.conf" "$LAB_DIR/login_defs_hardening.conf"; do
        if [ -f "$candidate" ]; then
            policy_file="$candidate"
            break
        fi
    done
    [ -n "$policy_file" ] || return 1
    ! has_placeholder "$policy_file" || return 1
    awk '
        /^[[:space:]]*#/ { next }
        $1 == "PASS_MAX_DAYS" && $2 ~ /^[0-9]+$/ && $2 >= 1 && $2 <= 365 { max=$2 }
        $1 == "PASS_MIN_DAYS" && $2 ~ /^[0-9]+$/ && $2 >= 0 && $2 <= 30 { min=$2 }
        $1 == "PASS_WARN_AGE" && $2 ~ /^[0-9]+$/ && $2 >= 1 && $2 <= 30 { warn=$2 }
        END { exit !(max && min != "" && warn && min < max) }
    ' "$policy_file"
}

reto4() {
    local mfa_file=""
    local candidate
    for candidate in "$LAB_DIR/pam_mfa_plan.conf" "$LAB_DIR/common-auth-mfa.conf"; do
        if [ -f "$candidate" ]; then
            mfa_file="$candidate"
            break
        fi
    done
    [ -n "$mfa_file" ] || return 1
    ! has_placeholder "$mfa_file" || return 1
    grep -Eqi '^[[:space:]]*auth[[:space:]].*pam_(google_authenticator|oath)\.so' "$mfa_file" || return 1
    if [ -f "$LAB_DIR/mfa_rollback.md" ]; then
        grep -Eqi 'rollback|respaldo|backup' "$LAB_DIR/mfa_rollback.md"
    else
        grep -Eqi 'rollback|respaldo|backup' "$mfa_file"
    fi
}

reto5() {
    local script="$LAB_DIR/audit_privileged.sh"
    assert_file_exists "$script" || return 1
    [ -x "$script" ] || return 1
    assert_command_ok bash -n "$script" || return 1
    ! has_placeholder "$script" || return 1
    grep -Eq 'getent[[:space:]]+passwd' "$script" || return 1
    grep -Eq '\$3[[:space:]]*==[[:space:]]*0|UID[[:space:]]*0' "$script" || return 1
    grep -Eqi 'getent[[:space:]]+group.*(sudo|wheel|sysadmins)|(sudo|wheel|sysadmins).*getent[[:space:]]+group' "$script" || return 1
    grep -Eq 'REPORT(_PATH)?=|[[:space:]]>>?[[:space:]]*[^[:space:]]+' "$script" || return 1
    grep -Eq '(getent|awk|id|cut|grep)[[:space:]]' "$script"
}

validators=(reto1 reto2 reto3 reto4 reto5)
challenge_names=(
    "Crear grupo y usuario sysadmin"
    "Configurar sudoers restringido"
    "Politica de contrasenas"
    "Plan PAM MFA con rollback"
    "Script auditoria usuarios"
)

ICONOS=("👤" "🔑" "🔒" "🔐" "📊")

reto1_info() {
    separador
    echo -e "${CYAN}Reto 1: Crear grupo sysadmins y usuario ops_admin${NC}"
    echo "Entrega ~/laboratorio/iam/crear_grupo_usuario.sh, ejecutable y sin placeholders."
    echo "Debe incluir groupadd para sysadmins, useradd/adduser para ops_admin y"
    echo "usermod -aG sysadmins ops_admin (o gpasswd equivalente)."
    separador
}

reto2_info() {
    separador
    echo -e "${CYAN}Reto 2: Configurar sudoers para comandos específicos${NC}"
    echo "Entrega ~/laboratorio/iam/sudoers_lab-cyber. Debe pasar:"
    echo "  visudo -c -f ~/laboratorio/iam/sudoers_lab-cyber"
    echo "Otorga a ops_admin o %sysadmins solo rutas de comandos concretas;"
    echo "no uses ALL=(ALL) ALL sin restricción."
    separador
}

reto3_info() {
    separador
    echo -e "${CYAN}Reto 3: Configurar política de contraseñas${NC}"
    echo "Entrega password_policy.conf o login_defs_hardening.conf en ~/laboratorio/iam."
    echo "Incluye valores numéricos razonables para PASS_MAX_DAYS, PASS_MIN_DAYS"
    echo "y PASS_WARN_AGE, sin placeholders."
    separador
}

reto4_info() {
    separador
    echo -e "${CYAN}Reto 4: Plan PAM MFA con rollback${NC}"
    echo "Entrega pam_mfa_plan.conf o common-auth-mfa.conf en ~/laboratorio/iam."
    echo "Incluye una directiva auth para pam_google_authenticator.so o pam_oath.so"
    echo "y documenta rollback/respaldo en ese archivo o en mfa_rollback.md."
    separador
}

reto5_info() {
    separador
    echo -e "${CYAN}Reto 5: Script de auditoría de usuarios con privilegios${NC}"
    echo "Entrega ~/laboratorio/iam/audit_privileged.sh, ejecutable y con sintaxis válida."
    echo "Debe inspeccionar UID 0 y grupos sudo/wheel/sysadmins, y escribir un reporte;"
    echo "un script de solo echo no cuenta."
    separador
}
