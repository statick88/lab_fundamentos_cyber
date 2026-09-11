#!/bin/bash
# Checkpoint IV: Evaluación Módulo IV — setup.sh

set -e
# Dual-path sourcing
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
fi

UNIT_NAME="checkpoint-IV"
UNIT_NUM=13
export TOTAL_RETOS=5

banner_unidad "$UNIT_NUM" "Checkpoint Módulo IV"

echo -e "${CYAN}Evaluación formativa Módulo IV: Amenazas y Criptografía${RESET}"
echo -e "${AMARILLO}Completarás 5 retos de evaluación.${RESET}\n"

mkdir -p "$HOME/laboratorio/checkpoints/checkpoint-iv"
cd "$HOME/laboratorio/checkpoints/checkpoint-iv"

# Crear CA y certificados
mkdir -p ca
openssl genrsa -out ca/ca.key 2048 2>/dev/null || true
openssl req -x509 -new -nodes -key ca/ca.key -sha256 -days 365 \
    -out ca/ca.crt -subj "/C=EC/O=TestCA/CN=CheckpointCA" 2>/dev/null || true

openssl req -new -newkey rsa:2048 -nodes -out servidor.csr -keyout servidor.key \
    -subj "/C=EC/O=Test/CN=checkpoint.local" 2>/dev/null || true

openssl x509 -req -in servidor.csr -CA ca/ca.crt -CAkey ca/ca.key -CAcreateserial \
    -out servidor.crt -days 365 -sha256 2>/dev/null || true

cp /shared/cvss_calculator.py "$HOME/laboratorio/checkpoints/checkpoint-iv/cvss_calculator.py" 2>/dev/null || true

exito "Checkpoint IV preparado"
echo -e "${AMARILLO}Escribe ${CYAN}'manual'${AMARILLO} para ver la guía o ${CYAN}'evaluar'${AMARILLO} para evaluar.${RESET}"
