#!/bin/bash
# Unit VII: Security Hardening — setup.sh
# Creates reference-only fixtures for the 15 student hardening deliverables.

set -e

if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
fi

UNIT_NAME="unit-VII"
UNIT_NUM=7
export TOTAL_RETOS=15

banner_unidad "$UNIT_NUM" "Seguridad del Sistema"
echo -e "${CYAN}Esta unidad ensena a documentar decisiones de hardening reproducibles.${RESET}"
echo -e "${AMARILLO}Completarás 15 retos con entregables propios en ~/laboratorio/security.${RESET}\n"

LAB_DIR="$HOME/laboratorio/security"
FIXTURES_DIR="$LAB_DIR/fixtures"
mkdir -p "$FIXTURES_DIR"

# These inputs are deliberately reference-only. Validators accept deliverables in
# $LAB_DIR, never files in fixtures/ or files that retain template placeholders.
cat > "$FIXTURES_DIR/passwd.sample" <<'EOF'
root:x:0:0:root:/root:/bin/bash
analyst:x:1000:1000:Analyst:/home/analyst:/bin/bash
EOF
cat > "$FIXTURES_DIR/shadow.sample" <<'EOF'
root:*:19700:0:99999:7:::
analyst:$6$example$hash:19700:0:99999:7:::
EOF
cat > "$FIXTURES_DIR/find-suid.sample" <<'EOF'
-rwsr-xr-x root root /usr/bin/passwd
-rwsr-xr-x root root /opt/lab/legacy-helper
EOF
cat > "$FIXTURES_DIR/ss.sample" <<'EOF'
tcp LISTEN 0 4096 0.0.0.0:22 0.0.0.0:* users:(("sshd",pid=123,fd=3))
udp UNCONN 0 0 127.0.0.53:53 0.0.0.0:* users:(("systemd-resolve",pid=99,fd=13))
EOF
cat > "$FIXTURES_DIR/auth.log.sample" <<'EOF'
Failed password for invalid user admin from 203.0.113.8 port 44321 ssh2
Accepted publickey for analyst from 192.0.2.44 port 51230 ssh2
sudo: analyst : COMMAND=/usr/bin/systemctl restart ssh
EOF
cat > "$FIXTURES_DIR/sshd_config.sample" <<'EOF'
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
EOF
cat > "$FIXTURES_DIR/fstab.sample" <<'EOF'
tmpfs /tmp tmpfs defaults,noexec,nosuid,nodev 0 0
/dev/vda2 /var ext4 defaults,nosuid,nodev 0 2
EOF

create_template() {
    local name="$1"
    cat > "$FIXTURES_DIR/${name}.template" <<EOF
# Reference template only — copy concepts, then replace every TODO with your evidence.
# TODO: record evidence, security decision, and rationale for ${name}.
EOF
}

for deliverable in \
    uid0_audit.md critical_files_permissions.md sensitive_processes.md sudo_review.md \
    open_ports.md suid_sgid_inventory.md ssh_key_policy.md ssh_permissions.md log_review.md \
    suid_remediation_plan.md firewall_baseline.md fstab_mount_review.md sshd_hardening.md \
    auditd_aide_baseline.md hardening_summary.md; do
    create_template "$deliverable"
done

exito "Entorno de Unit VII preparado con fixtures y plantillas de referencia"
echo -e "${AMARILLO}Usá ${CYAN}manual${AMARILLO} para ver los entregables requeridos o ${CYAN}evaluar${AMARILLO} para evaluar.${RESET}"
