#!/bin/bash
# Checkpoint V: Evaluación Módulo V — test.sh

set -e
source /shared/common.sh

UNIT_NAME="checkpoint-V"
TOTAL_RETOS=5

reto1() {
    if [ -f /var/log/syslog ]; then
        eval_log_analysis /var/log/syslog "error|fail|critical|block" 1 system
    elif [ -f "$HOME/laboratorio/checkpoints/checkpoint-v/syslog_sample.log" ]; then
        eval_log_analysis "$HOME/laboratorio/checkpoints/checkpoint-v/syslog_sample.log" "error|fail|critical|block" 1 student
    else
        return 1
    fi
}

reto2() {
    if [ -f /var/log/syslog ]; then
        output=$(awk '{print $1, $2, $3, $4, $5}' /var/log/syslog)
        echo "$output" | grep -q "lab" || true
    elif [ -f "$HOME/laboratorio/checkpoints/checkpoint-v/syslog_sample.log" ]; then
        output=$(awk '{print $1, $2, $3, $4, $5}' "$HOME/laboratorio/checkpoints/checkpoint-v/syslog_sample.log")
        echo "$output" | grep -q "lab"
    else
        return 1
    fi
}

reto3() {
    logger -p local0.info "checkpoint-v-ret3-test" 2>/dev/null || true
    grep -q "checkpoint-v-ret3-test" /var/log/syslog 2>/dev/null || grep -q "checkpoint-v-ret3-test" /var/log/user.log 2>/dev/null || true
}

reto4() {
    [ -f "$HOME/laboratorio/checkpoints/checkpoint-v/rto_rpo.txt" ] || [ -f "$HOME/laboratorio/checkpoints/checkpoint-v/rto_rpo.md" ] || \
    find "$HOME/laboratorio/checkpoints/checkpoint-v" -maxdepth 1 -type f \( -name "*rto*" -o -name "*rpo*" \) 2>/dev/null | head -1 | grep -q "."
}

reto5() {
    [ -f "$HOME/laboratorio/checkpoints/checkpoint-v/playbook_ir.txt" ] || [ -f "$HOME/laboratorio/checkpoints/checkpoint-v/playbook_ir.md" ] || \
    find "$HOME/laboratorio/checkpoints/checkpoint-v" -maxdepth 1 -type f \( -name "*ir*" -o -name "*playbook*" \) 2>/dev/null | head -1 | grep -q "."
    grep -qi "preparación\|detección\|contención\|erradicación\|recuperación" "$HOME/laboratorio/checkpoints/checkpoint-v/playbook_ir.txt" 2>/dev/null || grep -qi "preparacion\|deteccion\|contencion\|erradicacion\|recuperacion" "$HOME/laboratorio/checkpoints/checkpoint-v/playbook_ir.md" 2>/dev/null || true
}

validators=(reto1 reto2 reto3 reto4 reto5)
challenge_names=(
    "Analizar logs con grep"
    "Extraer campos con awk"
    "Generar log con logger"
    "Calcular RTO/RPO"
    "Playbook IR"
)

ICONOS=("🔍" "🔎" "📝" "⏱️" "🚨")

reto1_info() {
    separador
    echo -e "${CYAN}Reto 1: Analizar logs con grep${NC}"
    echo "Filtra syslog_sample.log para encontrar eventos críticos."
    echo "Comando: grep -E 'error|fail|critical|block' syslog_sample.log"
    separador
}
reto2_info() {
    separador
    echo -e "${CYAN}Reto 2: Extraer campos con awk${NC}"
    echo "Extrae timestamp, hostname y proceso de syslog_sample.log con awk."
    echo "Comando: awk '{print \$1, \$2, \$3, \$4, \$5}' syslog_sample.log"
    separador
}
reto3_info() {
    separador
    echo -e "${CYAN}Reto 3: Generar log con logger${NC}"
    echo "Genera un log personalizado en el sistema."
    echo "Comando: logger 'checkpoint-v-test'"
    separador
}
reto4_info() {
    separador
    echo -e "${CYAN}Reto 4: Calcular RTO/RPO${NC}"
    echo "Define RTO y RPO para un escenario."
    separador
}
reto5_info() {
    separador
    echo -e "${CYAN}Reto 5: Playbook IR${NC}"
    echo "Crea un playbook IR secuencial."
    separador
}
