#!/bin/bash
# Checkpoint IV: Evaluación Módulo IV — test.sh

set -e
source /shared/common.sh

UNIT_NAME="checkpoint-IV"
TOTAL_RETOS=5

reto1() {
    local student_script="$HOME/laboratorio/checkpoints/checkpoint-iv/cvss_calculator.py"
    if [ ! -f "$student_script" ]; then
        student_script="$HOME/laboratorio/cvss_calculator.py"
    fi
    eval_cvss "7.5" "$student_script" "0.5"
}

reto2() {
    # Hash verification
    [ -f "$HOME/laboratorio/checkpoints/checkpoint-iv/servidor.key" ]
    sha256sum "$HOME/laboratorio/checkpoints/checkpoint-iv/servidor.key" 2>/dev/null | grep -qE '^[a-f0-9]{64}'
}

reto3() {
    # Certificate chain verification
    [ -f "$HOME/laboratorio/checkpoints/checkpoint-iv/ca/ca.crt" ]
    [ -f "$HOME/laboratorio/checkpoints/checkpoint-iv/servidor.crt" ]
    openssl verify -CAfile "$HOME/laboratorio/checkpoints/checkpoint-iv/ca/ca.crt" "$HOME/laboratorio/checkpoints/checkpoint-iv/servidor.crt" 2>/dev/null | grep -q "OK"
}

reto4() {
    # X.509 certificate details
    [ -f "$HOME/laboratorio/checkpoints/checkpoint-iv/servidor.crt" ]
    openssl x509 -in "$HOME/laboratorio/checkpoints/checkpoint-iv/servidor.crt" -text -noout 2>/dev/null | grep -qi "subject\|issuer"
}

reto5() {
    # Digital signature verification
    [ -f "$HOME/laboratorio/checkpoints/checkpoint-iv/ca/ca.key" ]
    [ -f "$HOME/laboratorio/checkpoints/checkpoint-iv/ca/ca.crt" ]
    openssl dgst -sha256 -sign "$HOME/laboratorio/checkpoints/checkpoint-iv/ca/ca.key" -out /tmp/test.sig /etc/hostname 2>/dev/null || true
    [ -f /tmp/test.sig ]
}

validators=(reto1 reto2 reto3 reto4 reto5)
challenge_names=(
    "CVSS base score"
    "Hash SHA-256"
    "Verificar cadena certificados"
    "Detalles X.509"
    "Firma digital"
)

ICONOS=("📐" "🔒" "🔗" "📄" "✍️")

reto1_info() {
    separador
    echo -e "${CYAN}Reto 1: CVSS Base Score${NC}"
    echo "Calcula un score CVSS 3.1 base para una vulnerabilidad."
    echo "Usa python3 o la calculadora first.org/cvss."
    separador
}
reto2_info() {
    separador
    echo -e "${CYAN}Reto 2: Hash SHA-256${NC}"
    echo "Genera el hash SHA-256 de un archivo de clave."
    echo "Comando: sha256sum servidor.key"
    separador
}
reto3_info() {
    separador
    echo -e "${CYAN}Reto 3: Verificar cadena de certificados${NC}"
    echo "Verifica servidor.crt contra la CA local."
    echo "Comando: openssl verify -CAfile ca/ca.crt servidor.crt"
    separador
}
reto4_info() {
    separador
    echo -e "${CYAN}Reto 4: Detalles X.509${NC}"
    echo "Inspecciona los detalles de un certificado X.509."
    echo "Comando: openssl x509 -in servidor.crt -text -noout"
    separador
}
reto5_info() {
    separador
    echo -e "${CYAN}Reto 5: Firma digital${NC}"
    echo "Firma un archivo con la clave privada de la CA."
    echo "Comando: openssl dgst -sha256 -sign ca/ca.key -out firma.sig archivo"
    separador
}
