#!/bin/bash
# Unit II: Network Filtering and Firewalls — test.sh
# Sourced libs: common.sh, validators.sh, sudo-wrappers.sh (gold standard pattern)

# Dual-path sourcing
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
    source /shared/validators.sh
    source /shared/sudo-wrappers.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
    source "$(dirname "$0")/../../shared/validators.sh"
    source "$(dirname "$0")/../../shared/sudo-wrappers.sh"
fi

UNIT_NAME="unit-II"
TOTAL_RETOS=10

REDES_DIR="$HOME/laboratorio/redes"
FIXTURES_DIR="$REDES_DIR/fixtures"

require_analysis() {
    local file="$1"
    shift

    assert_file_exists "$file" || return 1

    local pattern
    for pattern in "$@"; do
        if ! grep -Eiq "$pattern" "$file"; then
            echo "FAIL: Required analysis evidence not found in $file: $pattern" >&2
            return 1
        fi
    done
}

has_ufw_rule() {
    local file="$1" action="$2" service_pattern="$3"

    assert_file_exists "$file" || return 1
    if grep -Eiq "^[[:space:]]*(sudo[[:space:]]+)?ufw[[:space:]]+(${action})[[:space:]]+(${service_pattern})([[:space:]]|$)" "$file"; then
        return 0
    fi

    echo "FAIL: A real UFW rule '${action} ${service_pattern}' is required in $file" >&2
    return 1
}

has_iptables_block_rule() {
    local file="$1"

    assert_file_exists "$file" || return 1
    if grep -Eiq '^[[:space:]]*(sudo[[:space:]]+)?iptables[[:space:]]+-[AI][[:space:]]+INPUT[[:space:]]+-s[[:space:]]+([0-9]{1,3}\.){3}[0-9]{1,3}([[:space:]]+[^#[:space:]]+)*[[:space:]]+-j[[:space:]]+(DROP|REJECT)([[:space:]]|$)' "$file"; then
        return 0
    fi

    echo "FAIL: An iptables INPUT DROP/REJECT rule for a specific source IP is required in $file" >&2
    return 1
}

has_iptables_list_evidence() {
    local script="$REDES_DIR/iptables_list.sh"
    local output="$REDES_DIR/iptables_list_output.txt"

    if [ -f "$script" ] && grep -Eiq '^[[:space:]]*(sudo[[:space:]]+)?iptables[[:space:]]+-L[[:space:]]+-n[[:space:]]+-v([[:space:]]|$)' "$script"; then
        return 0
    fi

    if [ -f "$output" ] \
        && grep -Eiq 'iptables[[:space:]]+-L[[:space:]]+-n[[:space:]]+-v' "$output" \
        && grep -Eiq '^Chain[[:space:]]+INPUT' "$output"; then
        return 0
    fi

    echo "FAIL: Create iptables_list.sh with 'iptables -L -n -v' or save documented output in $output" >&2
    return 1
}

reto1() {
    require_analysis "$REDES_DIR/http_analysis.txt" \
        '[Hh][Tt][Tt][Pp]' \
        '80[[:space:]]*/?[[:space:]]*[Tt][Cc][Pp]|[Tt][Cc][Pp][[:space:]]*/?[[:space:]]*80' \
        'GET|[Rr]equest'
}

reto2() {
    require_analysis "$REDES_DIR/https_analysis.txt" \
        '[Hh][Tt][Tt][Pp][Ss]' \
        '443[[:space:]]*/?[[:space:]]*[Tt][Cc][Pp]|[Tt][Cc][Pp][[:space:]]*/?[[:space:]]*443'
}

reto3() {
    require_analysis "$REDES_DIR/ssh_analysis.txt" \
        '[Ss][Ss][Hh]' \
        '22[[:space:]]*/?[[:space:]]*[Tt][Cc][Pp]|[Tt][Cc][Pp][[:space:]]*/?[[:space:]]*22' \
        'SSH-[0-9]|[Bb]anner'
}

reto4() {
    require_analysis "$REDES_DIR/dns_analysis.txt" \
        '[Dd][Nn][Ss]' \
        '53([[:space:]]*/?[[:space:]]*(tcp|udp|TCP|UDP))?|([Tt][Cc][Pp]|[Uu][Dd][Pp])[[:space:]]*/?[[:space:]]*53' \
        '[Qq]uery|[Dd]omain|google\.com'
}

reto5() {
    has_ufw_rule "$REDES_DIR/ufw_ssh.sh" 'allow' '22(/tcp)?|ssh'
}

reto6() {
    has_ufw_rule "$REDES_DIR/ufw_telnet.sh" 'deny|reject' '23(/tcp)?|telnet'
}

reto7() {
    has_ufw_rule "$REDES_DIR/ufw_web.sh" 'allow' '80(/tcp)?|http' \
        && has_ufw_rule "$REDES_DIR/ufw_web.sh" 'allow' '443(/tcp)?|https'
}

reto8() {
    has_iptables_block_rule "$REDES_DIR/iptables_block.sh"
}

reto9() {
    has_iptables_list_evidence
}

reto10() {
    require_analysis "$REDES_DIR/scan_analysis.txt" \
        '[Ss][Cc][Aa][Nn]|[Nn]map|[Pp]ort[[:space:]]+[Ss]can' \
        '[Ss][Yy][Nn]|[Mm]ultiple[[:space:]]+[Pp]orts|[Mm][Uu]ltiples[[:space:]]+[Pp]uertos'
}

validators=(reto1 reto2 reto3 reto4 reto5 reto6 reto7 reto8 reto9 reto10)
challenge_names=(
    "Analyze HTTP fixture"
    "Analyze HTTPS"
    "Analyze SSH fixture"
    "Analyze DNS fixture"
    "UFW: allow SSH"
    "UFW: deny Telnet"
    "UFW: allow HTTP/HTTPS"
    "iptables DROP a source IP"
    "List iptables rules"
    "Analyze a port scan"
)

ICONOS=("🔍" "🔒" "🔑" "📡" "✅" "🚫" "🌐" "🛡️" "📋" "⚠️")

reto1_info() {
    separador
    echo -e "${CYAN}Reto 1: Analyze HTTP fixture${NC}"
    echo ""
    echo "Read fixtures/captura_http.pcapng and write http_analysis.txt."
    echo "Your analysis must identify HTTP, 80/tcp, and GET or request evidence."
    echo ""
    echo "Useful commands:"
    echo "  grep -iE 'GET|HTTP|80' ~/laboratorio/redes/fixtures/captura_http.pcapng"
    echo "  nano ~/laboratorio/redes/http_analysis.txt"
    separador
}

reto2_info() {
    separador
    echo -e "${CYAN}Reto 2: Analyze HTTPS${NC}"
    echo ""
    echo "Read fixtures/captura_https.pcapng and write https_analysis.txt."
    echo "Your analysis must identify HTTPS and 443/tcp; /etc/services is not evidence for this reto."
    echo ""
    echo "Useful commands:"
    echo "  cat ~/laboratorio/redes/fixtures/captura_https.pcapng"
    echo "  nano ~/laboratorio/redes/https_analysis.txt"
    separador
}

reto3_info() {
    separador
    echo -e "${CYAN}Reto 3: Analyze SSH fixture${NC}"
    echo ""
    echo "Read fixtures/captura_ssh.pcapng and write ssh_analysis.txt."
    echo "Your analysis must identify SSH, 22/tcp, and the SSH banner."
    echo ""
    echo "Useful commands:"
    echo "  grep -iE 'SSH|22' ~/laboratorio/redes/fixtures/captura_ssh.pcapng"
    echo "  nano ~/laboratorio/redes/ssh_analysis.txt"
    separador
}

reto4_info() {
    separador
    echo -e "${CYAN}Reto 4: Analyze DNS fixture${NC}"
    echo ""
    echo "Read fixtures/captura_dns.pcapng and write dns_analysis.txt."
    echo "Your analysis must identify DNS, port 53, and query or domain evidence."
    echo ""
    echo "Useful commands:"
    echo "  grep -iE '53|google|query' ~/laboratorio/redes/fixtures/captura_dns.pcapng"
    echo "  nano ~/laboratorio/redes/dns_analysis.txt"
    separador
}

reto5_info() {
    separador
    echo -e "${CYAN}Reto 5: UFW - Allow SSH${NC}"
    echo ""
    echo "Create ufw_ssh.sh with a real UFW allow rule for 22/tcp or ssh."
    echo "Do not use an echo-only scaffold."
    echo ""
    echo "Useful command:"
    echo "  printf '%s\\n' 'sudo ufw allow 22/tcp' > ~/laboratorio/redes/ufw_ssh.sh"
    separador
}

reto6_info() {
    separador
    echo -e "${CYAN}Reto 6: UFW - Deny Telnet${NC}"
    echo ""
    echo "Create ufw_telnet.sh with a real UFW deny or reject rule for 23/tcp or telnet."
    echo "Do not use an echo-only scaffold."
    echo ""
    echo "Useful command:"
    echo "  printf '%s\\n' 'sudo ufw deny 23/tcp' > ~/laboratorio/redes/ufw_telnet.sh"
    separador
}

reto7_info() {
    separador
    echo -e "${CYAN}Reto 7: UFW - Allow HTTP/HTTPS${NC}"
    echo ""
    echo "Create ufw_web.sh with real UFW allow rules for both 80/tcp and 443/tcp."
    echo "Do not use an echo-only scaffold."
    echo ""
    echo "Useful commands:"
    echo "  printf '%s\\n' 'sudo ufw allow 80/tcp' > ~/laboratorio/redes/ufw_web.sh"
    echo "  printf '%s\\n' 'sudo ufw allow 443/tcp' >> ~/laboratorio/redes/ufw_web.sh"
    separador
}

reto8_info() {
    separador
    echo -e "${CYAN}Reto 8: iptables - Block a source IP${NC}"
    echo ""
    echo "Create iptables_block.sh with a real INPUT DROP or REJECT rule for one concrete source IP."
    echo ""
    echo "Useful command:"
    echo "  printf '%s\\n' 'sudo iptables -A INPUT -s 10.0.0.99 -j DROP' > ~/laboratorio/redes/iptables_block.sh"
    separador
}

reto9_info() {
    separador
    echo -e "${CYAN}Reto 9: List iptables rules${NC}"
    echo ""
    echo "Create iptables_list.sh with the real command 'iptables -L -n -v', or save a documented"
    echo "command and its output (including Chain INPUT) in iptables_list_output.txt."
    echo ""
    echo "Useful command:"
    echo "  printf '%s\\n' 'sudo iptables -L -n -v' > ~/laboratorio/redes/iptables_list.sh"
    separador
}

reto10_info() {
    separador
    echo -e "${CYAN}Reto 10: Analyze a port scan${NC}"
    echo ""
    echo "Read fixtures/captura_scan.pcapng and write scan_analysis.txt."
    echo "Explain the scan behavior using SYN traffic, multiple ports, nmap, or port-scan reasoning."
    echo ""
    echo "Useful commands:"
    echo "  cat ~/laboratorio/redes/fixtures/captura_scan.pcapng"
    echo "  nano ~/laboratorio/redes/scan_analysis.txt"
    separador
}
