#!/bin/bash
# Checkpoint IV: Evaluación Módulo IV — setup.sh

set -e
source /shared/common.sh

UNIT_NAME="checkpoint-IV"
UNIT_NUM=13
export TOTAL_RETOS=5

banner_unidad "$UNIT_NUM" "Checkpoint Módulo IV"

echo -e "${CYAN}Evaluación formativa Módulo IV: Amenazas y Criptografía${RESET}"
echo -e "${AMARILLO}Completarás 5 retos de evaluación.${RESET}\n"

mkdir -p "$HOME/laboratorio/checkpoints/checkpoint-iv"
cd "$HOME/laboratorio/checkpoints/checkpoint-iv"

# Crear archivos para verificación de certificados
mkdir -p ca
openssl genrsa -out ca/ca.key 2048 2>/dev/null || true
openssl req -x509 -new -nodes -key ca/ca.key -sha256 -days 365 \
    -out ca/ca.crt -subj "/C=EC/O=TestCA/CN=CheckpointCA" 2>/dev/null || true

openssl req -new -newkey rsa:2048 -nodes -out servidor.csr -keyout servidor.key \
    -subj "/C=EC/O=Test/CN=checkpoint.local" 2>/dev/null || true

openssl x509 -req -in servidor.csr -CA ca/ca.crt -CAkey ca/ca.key -CAcreateserial \
    -out servidor.crt -days 365 -sha256 2>/dev/null || true

exito "Checkpoint IV preparado"
