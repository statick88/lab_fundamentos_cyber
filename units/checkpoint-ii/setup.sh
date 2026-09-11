#!/bin/bash
# Checkpoint II: Evaluación Módulo II — setup.sh

set -e
# Dual-path sourcing
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
fi

UNIT_NAME="checkpoint-II"
UNIT_NUM=12
export TOTAL_RETOS=5

banner_unidad "$UNIT_NUM" "Checkpoint Módulo II"

echo -e "${CYAN}Evaluación formativa Módulo II: Redes y Firewalls${RESET}"
echo -e "${AMARILLO}Completarás 5 retos de evaluación.${RESET}\n"

mkdir -p "$HOME/laboratorio/checkpoints/checkpoint-ii"
cd "$HOME/laboratorio/checkpoints/checkpoint-ii"

cat > captura_checkpoint.pcapng << 'EOF'
0000  00 00 00 00 00 00 00 00  00 00 00 00 45 00 00 3c  ..............E..<
0010  1c 46 40 00 40 06 b0 02  0a 00 02 01 0a 00 02 02  .F@.@...........
0020  00 50 00 50 00 00 00 00  00 00 00 00 50 02 20 00  .P.P......... ...
0030  7a 1c 00 00 47 45 54 20  2f 20 48 54 54 50 2f 31  z...GET / HTTP/1
0040  2e 31 0d 0a 48 6f 73 74  3a 20 65 78 61 6d 70 6c  .1..Host: exampl
0050  65 2e 63 6f 6d 0d 0a 0d  0a                        e.com....
EOF

exito "Checkpoint II preparado"
echo -e "${AMARILLO}Escribe ${CYAN}'manual'${AMARILLO} para ver la guía o ${CYAN}'evaluar'${AMARILLO} para evaluar.${RESET}"
