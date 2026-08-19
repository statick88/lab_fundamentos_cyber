#!/bin/bash
# Checkpoint II: Evaluación Módulo II — test.sh

set -e
source /shared/common.sh

UNIT_NAME="checkpoint-II"
TOTAL_RETOS=5

reto1() {
    grep -qi "GET / HTTP" "$HOME/laboratorio/checkpoints/checkpoint-ii/captura_checkpoint.pcapng" 2>/dev/null
}

reto2() {
    cat /etc/services 2>/dev/null | grep -q "^domain"
}

reto3() {
    [ -f "$HOME/laboratorio/checkpoints/checkpoint-ii/captura_checkpoint.pcapng" ] && grep -qi "SSH" "$HOME/laboratorio/checkpoints/checkpoint-ii/captura_checkpoint.pcapng" 2>/dev/null || true
    cat /etc/services 2>/dev/null | grep -q "^ssh"
}

reto4() {
    if command -v sudo >/dev/null 2>&1 && sudo -n ufw status >/dev/null 2>&1; then
        sudo ufw status | grep -q "22/tcp"
    else
        find "$HOME/laboratorio" -maxdepth 4 -type f \( -name "*.sh" -o -name "*.rules" -o -name "*.conf" \) ! -name "test.sh" 2>/dev/null | xargs grep -l "ufw.*22\|22.*ufw\|allow.*ssh" 2>/dev/null | head -1 | grep -q "." || true
    fi
}

reto5() {
    if command -v sudo >/dev/null 2>&1 && sudo -n iptables -L >/dev/null 2>&1; then
        sudo iptables -L >/dev/null 2>&1
    else
        command -v iptables >/dev/null 2>&1
        find "$HOME/laboratorio" -maxdepth 4 -type f \( -name "*.sh" -o -name "*.txt" -o -name "*.md" \) ! -name "test.sh" 2>/dev/null | xargs grep -l "iptables.*-L\|iptables.*list" 2>/dev/null | head -1 | grep -q "." || true
    fi
}

validators=(reto1 reto2 reto3 reto4 reto5)
challenge_names=(
    "Identificar HTTP en captura"
    "Identificar DNS"
    "Identificar SSH"
    "Configurar UFW SSH"
    "Listar reglas iptables"
)

ICONOS=("🔍" "📡" "🔑" "✅" "📋")

reto1_info() {
    separador
    echo -e "${CYAN}Reto 1: Identificar HTTP en captura${NC}"
    echo "Analiza la captura y identifica tráfico HTTP (puerto 80)."
    separador
}
reto2_info() {
    separador
    echo -e "${CYAN}Reto 2: Identificar DNS${NC}"
    echo "Verifica que DNS usa el puerto 53 en /etc/services."
    separador
}
reto3_info() {
    separador
    echo -e "${CYAN}Reto 3: Identificar SSH${NC}"
    echo "Identifica el protocolo SSH y su puerto estándar."
    separador
}
reto4_info() {
    separador
    echo -e "${CYAN}Reto 4: Configurar UFW para SSH${NC}"
    echo "Crea un script o configuracion que permita SSH (puerto 22/tcp) en UFW."
    separador
}
reto5_info() {
    separador
    echo -e "${CYAN}Reto 5: Listar reglas iptables${NC}"
    echo "Crea un script que liste las reglas activas de iptables."
    separador
}
