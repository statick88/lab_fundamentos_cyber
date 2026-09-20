#!/bin/bash
# Unit VII: Security Hardening — test.sh
# Each reto validates a student-authored deliverable under ~/laboratorio/security.

source /shared/common.sh
source /shared/validators.sh
source /shared/sudo-wrappers.sh

UNIT_NAME="unit-VII"
TOTAL_RETOS=15
LAB_DIR="$HOME/laboratorio/security"

student_file() {
    local file="$LAB_DIR/$1"
    [ -f "$file" ] && [ -s "$file" ] &&
        ! grep -qiE 'TODO|REPLACE[ _-]?ME|PLACEHOLDER|<insert|write your' "$file"
}

contains_all() {
    local file="$1"
    shift
    local term
    for term in "$@"; do
        grep -qiF "$term" "$file" || return 1
    done
}

at_least_lines_matching() {
    local file="$1" pattern="$2" minimum="$3"
    [ "$(grep -Eic "$pattern" "$file")" -ge "$minimum" ]
}

reto1() {
    local file="$LAB_DIR/uid0_audit.md"
    student_file "uid0_audit.md" && contains_all "$file" "UID 0" "root" "decision"
}

reto2() {
    local file="$LAB_DIR/critical_files_permissions.md"
    student_file "critical_files_permissions.md" &&
        contains_all "$file" "/etc/passwd" "/etc/shadow" "root" "0644" "0640"
}

reto3() {
    local file="$LAB_DIR/sensitive_processes.md"
    student_file "sensitive_processes.md" &&
        contains_all "$file" "PID" "user" "command" "security observation" &&
        at_least_lines_matching "$file" '[0-9]+' 2
}

reto4() {
    local file="$LAB_DIR/sudo_review.md"
    student_file "sudo_review.md" && contains_all "$file" "sudo" "risk" "remediation"
}

reto5() {
    local file="$LAB_DIR/open_ports.md"
    student_file "open_ports.md" &&
        contains_all "$file" "protocol" "service" "exposure" "decision" &&
        grep -qiE 'tcp|udp' "$file"
}

reto6() {
    local file="$LAB_DIR/suid_sgid_inventory.md"
    student_file "suid_sgid_inventory.md" &&
        contains_all "$file" "SUID" "SGID" "authorization decision"
}

reto7() {
    local file="$LAB_DIR/ssh_key_policy.md"
    student_file "ssh_key_policy.md" &&
        contains_all "$file" "SSH" "key" "rotation" "policy"
}

reto8() {
    local file="$LAB_DIR/ssh_permissions.md"
    student_file "ssh_permissions.md" &&
        contains_all "$file" ".ssh" "owner" "700" "600" "rationale"
}

reto9() {
    local file="$LAB_DIR/log_review.md"
    student_file "log_review.md" &&
        contains_all "$file" "finding" "auth" &&
        at_least_lines_matching "$file" 'finding' 3
}

reto10() {
    local plan="$LAB_DIR/suid_remediation_plan.md"
    student_file "suid_remediation_plan.md" &&
        contains_all "$plan" "allowlist" "denylist" "SUID" "remediation" &&
        grep -qiE 'chmod[[:space:]]+u-s|chmod[[:space:]]+[0-7]*[0-6][0-7][0-7]' "$plan" &&
        { [ ! -e "$LAB_DIR/suid_remediation.sh" ] ||
          { student_file "suid_remediation.sh" && grep -qE 'chmod[[:space:]]+u-s|chmod[[:space:]]+[0-7]*[0-6][0-7][0-7]' "$LAB_DIR/suid_remediation.sh"; }; }
}

reto11() {
    local file="$LAB_DIR/firewall_baseline.md"
    student_file "firewall_baseline.md" &&
        contains_all "$file" "default deny" "inbound" "allowed service" "review"
}

reto12() {
    local file="$LAB_DIR/fstab_mount_review.md"
    student_file "fstab_mount_review.md" &&
        contains_all "$file" "fstab" "/tmp" "nosuid" "nodev" "noexec"
}

reto13() {
    local file="$LAB_DIR/sshd_hardening.md"
    student_file "sshd_hardening.md" &&
        contains_all "$file" "PermitRootLogin no" "PasswordAuthentication no" "sshd"
}

reto14() {
    local file="$LAB_DIR/auditd_aide_baseline.md"
    student_file "auditd_aide_baseline.md" &&
        contains_all "$file" "auditd" "AIDE" "baseline" "review"
}

reto15() {
    local file="$LAB_DIR/hardening_summary.md"
    student_file "hardening_summary.md" &&
        contains_all "$file" "priority" "owner" "deadline" "verification" "hardening"
}

validators=(reto1 reto2 reto3 reto4 reto5 reto6 reto7 reto8 reto9 reto10 reto11 reto12 reto13 reto14 reto15)
challenge_names=(
    "Auditar cuentas UID 0"
    "Documentar permisos de archivos críticos"
    "Inventariar procesos sensibles"
    "Revisar privilegios sudo"
    "Decidir exposición de puertos"
    "Autorizar inventario SUID/SGID"
    "Definir política de claves SSH"
    "Documentar permisos SSH"
    "Revisar hallazgos de logs"
    "Planificar remediación SUID"
    "Definir baseline de firewall"
    "Revisar fstab y montajes"
    "Endurecer configuración sshd"
    "Establecer baseline auditd/AIDE"
    "Resumir plan de hardening"
)

ICONOS=("👑" "🔒" "🧭" "⚙️" "🔌" "⚠️" "🔑" "📁" "📋" "🛠️" "🛡️" "💽" "🚫" "🔎" "✅")

reto1_info() { separador; echo -e "${CYAN}Reto 1: uid0_audit.md${NC}"; echo "Documentá cuentas UID 0, evidencia de root y una decision de autorización."; separador; }
reto2_info() { separador; echo -e "${CYAN}Reto 2: critical_files_permissions.md${NC}"; echo "Registrá owner y modos seguros (root, 0644, 0640) de passwd/shadow o fixtures."; separador; }
reto3_info() { separador; echo -e "${CYAN}Reto 3: sensitive_processes.md${NC}"; echo "Incluí PID, user, command y observación de seguridad para procesos sensibles."; separador; }
reto4_info() { separador; echo -e "${CYAN}Reto 4: sudo_review.md${NC}"; echo "Evaluá privilegios sudo, riesgo y remediación."; separador; }
reto5_info() { separador; echo -e "${CYAN}Reto 5: open_ports.md${NC}"; echo "Inventariá protocol, service, exposure y decision por puerto."; separador; }
reto6_info() { separador; echo -e "${CYAN}Reto 6: suid_sgid_inventory.md${NC}"; echo "Inventariá SUID/SGID y decidí qué autorizás."; separador; }
reto7_info() { separador; echo -e "${CYAN}Reto 7: ssh_key_policy.md${NC}"; echo "Definí política y rotación de claves SSH; no generes claves para este reto."; separador; }
reto8_info() { separador; echo -e "${CYAN}Reto 8: ssh_permissions.md${NC}"; echo "Documentá owner, 700 para .ssh, 600 para claves y su rationale."; separador; }
reto9_info() { separador; echo -e "${CYAN}Reto 9: log_review.md${NC}"; echo "Anotá al menos tres findings de logs de autenticación o de los fixtures."; separador; }
reto10_info() { separador; echo -e "${CYAN}Reto 10: suid_remediation_plan.md${NC}"; echo "Creá allowlist/denylist y un comando de remediación para SUID no autorizados; el script es opcional."; separador; }
reto11_info() { separador; echo -e "${CYAN}Reto 11: firewall_baseline.md${NC}"; echo "Definí default deny inbound, servicios permitidos y revisión."; separador; }
reto12_info() { separador; echo -e "${CYAN}Reto 12: fstab_mount_review.md${NC}"; echo "Revisá fstab y opciones noexec,nosuid,nodev, especialmente para /tmp."; separador; }
reto13_info() { separador; echo -e "${CYAN}Reto 13: sshd_hardening.md${NC}"; echo "Documentá sshd con PermitRootLogin no y PasswordAuthentication no."; separador; }
reto14_info() { separador; echo -e "${CYAN}Reto 14: auditd_aide_baseline.md${NC}"; echo "Definí baseline y revisión para auditd y AIDE."; separador; }
reto15_info() { separador; echo -e "${CYAN}Reto 15: hardening_summary.md${NC}"; echo "Resumí prioridades, owner, deadline y verification del hardening."; separador; }

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
