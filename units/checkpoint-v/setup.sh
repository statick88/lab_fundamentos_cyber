#!/bin/bash
# Checkpoint V: Evaluación Módulo V — setup.sh

set -e
# Dual-path sourcing
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
fi

UNIT_NAME="checkpoint-V"
UNIT_NUM=14
export TOTAL_RETOS=5

banner_unidad "$UNIT_NUM" "Checkpoint Módulo V"

echo -e "${CYAN}Evaluación formativa Módulo V: Logging y BCP${RESET}"
echo -e "${AMARILLO}Completarás 5 retos de evaluación.${RESET}\n"

mkdir -p "$HOME/laboratorio/checkpoints/checkpoint-v"
cd "$HOME/laboratorio/checkpoints/checkpoint-v"

cat > syslog_sample.log << 'EOF'
Oct 10 14:00:01 lab CRON[1001]: (root) CMD (/usr/local/bin/backup.sh)
Oct 10 14:00:02 lab systemd[1]: Started Daily apt upgrade and clean activities.
Oct 10 14:00:03 lab sshd[1002]: Failed password for invalid user admin from 10.0.0.1 port 22 ssh2
Oct 10 14:00:04 lab kernel: [UFW BLOCK] IN=eth0 OUT= MAC=00:00:00:00:00:00 SRC=10.0.0.1 DST=172.20.0.10 PROTO=TCP SPT=23 DPT=22
EOF

exito "Checkpoint V preparado"
echo -e "${AMARILLO}Escribe ${CYAN}'manual'${AMARILLO} para ver la guía o ${CYAN}'evaluar'${AMARILLO} para evaluar.${RESET}"
