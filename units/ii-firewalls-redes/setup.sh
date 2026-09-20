#!/bin/bash
# Unit II: Network Filtering and Firewalls — setup.sh

set -e
# Support both container (/shared) and local (relative) paths
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
fi

UNIT_NAME="unit-II"
UNIT_NUM=2
export TOTAL_RETOS=10

banner_unidad "$UNIT_NUM" "Network Filtering and Firewalls"

echo -e "${CYAN}This unit covers network protocols, firewalls, iptables, and UFW.${RESET}"
echo -e "${AMARILLO}You will complete 10 practical challenges.${RESET}\n"

REDES_DIR="$HOME/laboratorio/redes"
FIXTURES_DIR="$REDES_DIR/fixtures"
mkdir -p "$FIXTURES_DIR"

# Source material only. These fixtures are intentionally outside the student
# deliverable paths evaluated by test.sh and cannot satisfy a reto by themselves.
cat > "$FIXTURES_DIR/captura_http.pcapng" << 'EOF'
Frame 1: client 10.0.2.1:49152 -> server 10.0.2.2:80/tcp
GET / HTTP/1.1
Host: example.com
EOF

cat > "$FIXTURES_DIR/captura_https.pcapng" << 'EOF'
Frame 1: client 10.0.2.1:49153 -> server 10.0.2.2:443/tcp
TLS Client Hello for an HTTPS service
EOF

cat > "$FIXTURES_DIR/captura_ssh.pcapng" << 'EOF'
Frame 1: client 10.0.2.1:49154 -> server 10.0.2.2:22/tcp
SSH-2.0-OpenSSH_8.9p1
EOF

cat > "$FIXTURES_DIR/captura_dns.pcapng" << 'EOF'
Frame 1: client 10.0.2.1:53000 -> resolver 10.0.2.2:53/udp
DNS query: www.google.com A
EOF

cat > "$FIXTURES_DIR/captura_scan.pcapng" << 'EOF'
Frame 1: 10.0.2.2 -> 10.0.2.1:22/tcp SYN
Frame 2: 10.0.2.2 -> 10.0.2.1:80/tcp SYN
Frame 3: 10.0.2.2 -> 10.0.2.1:443/tcp SYN
EOF

cat > "$FIXTURES_DIR/README.template" << 'EOF'
Use the captures in this directory as source material. Create your own analysis
files and firewall scripts directly in ~/laboratorio/redes as each reto requests.
Templates and fixtures are not submitted answers and do not pass validators.
EOF

exito "Unit II environment prepared with source fixtures only"
echo -e "${AMARILLO}Read ${CYAN}$FIXTURES_DIR${AMARILLO}; write your deliverables in ${CYAN}$REDES_DIR${AMARILLO}.${RESET}"
echo -e "${AMARILLO}Type ${CYAN}'manual'${AMARILLO} for the guide or ${CYAN}'evaluar'${AMARILLO} to evaluate.${RESET}"
