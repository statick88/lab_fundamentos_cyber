#!/bin/bash
# Unit II: Filtrado de Red y Firewalls — test.sh

set -e
source /shared/common.sh

UNIT_NAME="unit-II"
TOTAL_RETOS=10

reto1() {
    [ -f "$HOME/laboratorio/redes/captura_http.pcapng" ]
    grep -qi "GET / HTTP" "$HOME/laboratorio/redes/captura_http.pcapng" 2>/dev/null
}

reto2() {
    grep -q "^https" /etc/services 2>/dev/null
}

reto3() {
    [ -f "$HOME/laboratorio/redes/captura_ssh.pcapng" ]
    grep -qi "SSH" "$HOME/laboratorio/redes/captura_ssh.pcapng" 2>/dev/null
}

reto4() {
    grep -q "^domain" /etc/services 2>/dev/null
}

reto5() {
    if command -v sudo >/dev/null 2>&1 && sudo -n ufw status >/dev/null 2>&1; then
        sudo ufw status | grep -q "22/tcp"
    else
        [ -f "$HOME/laboratorio/redes/ufw_ssh.sh" ] && [ -x "$HOME/laboratorio/redes/ufw_ssh.sh" ]
    fi
}

reto6() {
    if command -v sudo >/dev/null 2>&1 && sudo -n ufw status >/dev/null 2>&1; then
        sudo ufw status | grep -q "23/tcp"
    else
        [ -f "$HOME/laboratorio/redes/ufw_telnet.sh" ] && [ -x "$HOME/laboratorio/redes/ufw_telnet.sh" ]
    fi
}

reto7() {
    if command -v sudo >/dev/null 2>&1 && sudo -n ufw status >/dev/null 2>&1; then
        sudo ufw status | grep -qE "80/tcp|443/tcp"
    else
        [ -f "$HOME/laboratorio/redes/ufw_web.sh" ] && [ -x "$HOME/laboratorio/redes/ufw_web.sh" ]
    fi
}

reto8() {
    if command -v sudo >/dev/null 2>&1 && sudo -n iptables -L INPUT -n -v >/dev/null 2>&1; then
        sudo iptables -L INPUT -n -v | grep -q "DROP"
    else
        [ -f "$HOME/laboratorio/redes/iptables_block.sh" ] && [ -x "$HOME/laboratorio/redes/iptables_block.sh" ]
    fi
}

reto9() {
    if command -v sudo >/dev/null 2>&1 && sudo -n iptables -L >/dev/null 2>&1; then
        sudo iptables -L >/dev/null 2>&1
    else
        command -v iptables >/dev/null 2>&1
        [ -f "$HOME/laboratorio/redes/iptables_list.sh" ] && [ -x "$HOME/laboratorio/redes/iptables_list.sh" ]
    fi
}

reto10() {
    if command -v nmap >/dev/null 2>&1; then
        nmap -sS -p- 127.0.0.1 >/dev/null 2>&1 || true
    fi
    command -v nmap >/dev/null 2>&1 || command -v tcpdump >/dev/null 2>&1
    [ -f "$HOME/laboratorio/redes/captura_scan.pcapng" ]
}

validators=(reto1 reto2 reto3 reto4 reto5 reto6 reto7 reto8 reto9 reto10)
challenge_names=(
    "Identificar HTTP en captura"
    "Identificar HTTPS"
    "Identificar SSH en captura"
    "Identificar DNS en captura"
    "UFW: permitir SSH"
    "UFW: denegar Telnet"
    "UFW: permitir HTTP/HTTPS"
    "iptables DROP a IP"
    "Listar reglas iptables"
    "Identificar escaneo de puertos"
)

ICONOS=("🔍" "🔒" "🔑" "📡" "✅" "🚫" "🌐" "🛡️" "📋" "⚠️")

reto1_info() {
    separador
    echo -e "${CYAN}Reto 1: Identificar HTTP en captura${NC}"
    echo ""
    echo "Analiza la captura captura_http.pcapng y identifica el protocolo HTTP."
    echo "HTTP usa el puerto 80 TCP y comienza con GET / HTTP/1.1"
    echo ""
    echo "Comandos útiles:"
    echo "  grep -i 'HTTP' captura_http.pcapng"
    echo "  cat captura_http.pcapng"
    separador
}

reto2_info() {
    separador
    echo -e "${CYAN}Reto 2: Identificar HTTPS${NC}"
    echo ""
    echo "HTTPS usa el puerto 443 TCP. Verifica que el puerto 443 está registrado en /etc/services."
    echo ""
    echo "Comandos útiles:"
    echo "  grep '^https' /etc/services"
    separador
}

reto3_info() {
    separador
    echo -e "${CYAN}Reto 3: Identificar SSH en captura${NC}"
    echo ""
    echo "Analiza captura_ssh.pcapng y busca el banner SSH."
    echo "El banner típico es: SSH-2.0-OpenSSH_..."
    echo ""
    echo "Comandos útiles:"
    echo "  grep -i 'SSH' captura_ssh.pcapng"
    separador
}

reto4_info() {
    separador
    echo -e "${CYAN}Reto 4: Identificar DNS en captura${NC}"
    echo ""
    echo "Analiza captura_dns.pcapng y busca queries DNS."
    echo "DNS usa el puerto 53 UDP/TCP."
    echo ""
    echo "Comandos útiles:"
    echo "  grep -i 'google' captura_dns.pcapng"
    echo "  grep '^domain' /etc/services"
    separador
}

reto5_info() {
    separador
    echo -e "${CYAN}Reto 5: UFW - Permitir SSH${NC}"
    echo ""
    echo "Crea un script o archivo de configuración que defina una regla UFW"
    echo "para permitir SSH (puerto 22/tcp)."
    echo "Guárdalo en tu directorio de laboratorio."
    echo ""
    echo "Comandos útiles:"
    echo "  nano ~/laboratorio/redes/ufw_ssh.sh"
    echo "  echo 'sudo ufw allow 22/tcp' > ~/laboratorio/redes/ufw_ssh.sh"
    separador
}

reto6_info() {
    separador
    echo -e "${CYAN}Reto 6: UFW - Denegar Telnet${NC}"
    echo ""
    echo "Crea un script o archivo de configuración que defina una regla UFW"
    echo "para denegar Telnet (puerto 23/tcp)."
    echo ""
    echo "Comandos útiles:"
    echo "  echo 'sudo ufw deny 23/tcp' > ~/laboratorio/redes/ufw_telnet.sh"
    separador
}

reto7_info() {
    separador
    echo -e "${CYAN}Reto 7: UFW - Permitir HTTP/HTTPS${NC}"
    echo ""
    echo "Crea un script o archivo de configuración que defina reglas UFW"
    echo "para permitir HTTP (puerto 80) y HTTPS (puerto 443)."
    echo ""
    echo "Comandos útiles:"
    echo "  echo 'sudo ufw allow 80/tcp' > ~/laboratorio/redes/ufw_web.sh"
    echo "  echo 'sudo ufw allow 443/tcp' >> ~/laboratorio/redes/ufw_web.sh"
    separador
}

reto8_info() {
    separador
    echo -e "${CYAN}Reto 8: iptables - Bloquear IP sospechosa${NC}"
    echo ""
    echo "Crea un script que use iptables para bloquear una IP sospechosa."
    echo "Ejemplo: iptables -A INPUT -s 10.0.0.99 -j DROP"
    echo ""
    echo "Comandos útiles:"
    echo "  nano ~/laboratorio/redes/iptables_block.sh"
    echo "  echo 'iptables -A INPUT -s 10.0.0.99 -j DROP' > ~/laboratorio/redes/iptables_block.sh"
    separador
}

reto9_info() {
    separador
    echo -e "${CYAN}Reto 9: Listar reglas iptables${NC}"
    echo ""
    echo "Crea un script que liste las reglas activas de iptables."
    echo "El comando es: iptables -L -n -v"
    echo ""
    echo "Comandos útiles:"
    echo "  echo 'iptables -L -n -v' > ~/laboratorio/redes/iptables_list.sh"
    separador
}

reto10_info() {
    separador
    echo -e "${CYAN}Reto 10: Identificar escaneo de puertos${NC}"
    echo ""
    echo "Analiza captura_scan.pcapng para identificar un escaneo de puertos."
    echo "Un escaneo típico envía paquetes SYN a múltiples puertos."
    echo "Puedes usar nmap para simular y detectar escaneos."
    echo ""
    echo "Comandos útiles:"
    echo "  nmap -sS -p- 127.0.0.1"
    echo "  tcpdump -nn -r captura_scan.pcapng"
    separador
}
