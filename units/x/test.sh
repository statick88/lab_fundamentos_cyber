#!/bin/bash
# Unit X: SSL/TLS Certificates — test.sh
# Refactorizado (C4): usa /shared/validators.sh + /shared/sudo-wrappers.sh

source /shared/common.sh
source /shared/validators.sh
source /shared/sudo-wrappers.sh

UNIT_NAME="unit-X"
TOTAL_RETOS=15

reto1() {
    assert_command_ok openssl version
}

reto2() {
    local workdir="$HOME/laboratorio/ssl"
    mkdir -p "$workdir" && cd "$workdir" || return 1
    openssl genrsa -out clave_privada.pem 2048 2>/dev/null || true
    assert_file_exists "clave_privada.pem"
}

reto3() {
    local workdir="$HOME/laboratorio/ssl"
    mkdir -p "$workdir" && cd "$workdir" || return 1
    openssl genrsa -out clave_privada.pem 2048 2>/dev/null || true
    local output
    output=$(openssl rsa -in clave_privada.pem -check -noout 2>&1)
    assert_file_contains /dev/stdin "ok\|valid" <<< "$output"
}

reto4() {
    local workdir="$HOME/laboratorio/ssl"
    mkdir -p "$workdir" && cd "$workdir" || return 1
    openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem -days 365 -nodes \
        -subj "/C=EC/ST=Quito/O=Test/CN=localhost" 2>/dev/null || true
    assert_file_exists "cert.pem"
    assert_file_exists "key.pem"
}

reto5() {
    local workdir="$HOME/laboratorio/ssl"
    mkdir -p "$workdir" && cd "$workdir" || return 1
    openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem -days 365 -nodes \
        -subj "/C=EC/ST=Quito/O=Test/CN=localhost" 2>/dev/null || true
    local tmp
    tmp=$(mktemp)
    openssl x509 -in cert.pem -text -noout 2>/dev/null | head -5 > "$tmp"
    assert_file_contains "$tmp" "certificate\|subject\|issuer"
    rm -f "$tmp"
}

reto6() {
    local workdir="$HOME/laboratorio/ssl"
    mkdir -p "$workdir" && cd "$workdir" || return 1
    openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem -days 365 -nodes \
        -subj "/C=EC/ST=Quito/O=Test/CN=localhost" 2>/dev/null || true
    local output
    output=$(openssl x509 -in cert.pem -checkend 0 -noout 2>&1)
    assert_file_contains /dev/stdin "will not expire\|ok" <<< "$output"
}

reto7() {
    local workdir="$HOME/laboratorio/ssl"
    mkdir -p "$workdir" && cd "$workdir" || return 1
    openssl req -new -newkey rsa:2048 -nodes -out request.csr -keyout key_csr.pem \
        -subj "/C=EC/ST=Quito/O=Test/CN=test.com" 2>/dev/null || true
    assert_file_exists "request.csr"
    assert_file_exists "key_csr.pem"
}

reto8() {
    local workdir="$HOME/laboratorio/ssl"
    mkdir -p "$workdir" && cd "$workdir" || return 1
    openssl req -new -newkey rsa:2048 -nodes -out request.csr -keyout key_csr.pem \
        -subj "/C=EC/ST=Quito/O=Test/CN=test.com" 2>/dev/null || true
    local tmp
    tmp=$(mktemp)
    openssl req -in request.csr -text -noout 2>/dev/null | head -5 > "$tmp"
    assert_file_contains "$tmp" "certificate request\|subject"
    rm -f "$tmp"
}

reto9() {
    local workdir="$HOME/laboratorio/ssl"
    mkdir -p "$workdir" && cd "$workdir" || return 1
    mkdir -p "$workdir/ca"
    openssl genrsa -out "$workdir/ca/ca.key" 2048 2>/dev/null || true
    openssl req -x509 -new -nodes -key "$workdir/ca/ca.key" -sha256 -days 365 \
        -out "$workdir/ca/ca.crt" -subj "/C=EC/O=TestCA/CN=TestCA" 2>/dev/null || true
    assert_file_exists "ca/ca.key"
    assert_file_exists "ca/ca.crt"
}

reto10() {
    local workdir="$HOME/laboratorio/ssl"
    mkdir -p "$workdir" && cd "$workdir" || return 1
    mkdir -p "$workdir/ca"
    openssl genrsa -out "$workdir/ca/ca.key" 2048 2>/dev/null || true
    openssl req -x509 -new -nodes -key "$workdir/ca/ca.key" -sha256 -days 365 \
        -out "$workdir/ca/ca.crt" -subj "/C=EC/O=TestCA/CN=TestCA" 2>/dev/null || true
    openssl req -new -newkey rsa:2048 -nodes -out servidor.csr -keyout servidor.key \
        -subj "/C=EC/O=Test/CN=servidor.local" 2>/dev/null || true
    openssl x509 -req -in servidor.csr -CA "$workdir/ca/ca.crt" -CAkey "$workdir/ca/ca.key" -CAcreateserial \
        -out servidor.crt -days 365 -sha256 2>/dev/null || true
    assert_file_exists "servidor.crt"
    assert_file_exists "servidor.key"
    assert_openssl_chain "servidor.crt" "ca/ca.crt"
}

reto11() {
    local workdir="$HOME/laboratorio/ssl"
    mkdir -p "$workdir" && cd "$workdir" || return 1
    openssl genrsa -out rsa4096.pem 4096 2>/dev/null || true
    assert_file_exists "rsa4096.pem"
}

reto12() {
    local workdir="$HOME/laboratorio/ssl"
    mkdir -p "$workdir" && cd "$workdir" || return 1
    openssl ecparam -genkey -name secp384r1 -out ecc.key 2>/dev/null || true
    assert_file_exists "ecc.key"
}

reto13() {
    local workdir="$HOME/laboratorio/ssl"
    mkdir -p "$workdir" && cd "$workdir" || return 1
    openssl req -new -key clave_privada.pem -out request.csr \
        -subj "/C=EC/ST=Quito/O=Test/CN=test.com" 2>/dev/null || true
    assert_file_exists "request.csr"
}

reto14() {
    local workdir="$HOME/laboratorio/ssl"
    mkdir -p "$workdir" && cd "$workdir" || return 1
    mkdir -p "$workdir/ca" || true
    openssl genrsa -out "$workdir/ca/ca.key" 2048 2>/dev/null || true
    openssl req -x509 -new -nodes -key "$workdir/ca/ca.key" -sha256 -days 365 \
        -out "$workdir/ca/ca.crt" -subj "/C=EC/O=TestCA/CN=TestCA" 2>/dev/null || true
    openssl req -new -newkey rsa:2048 -nodes -out servidor.csr -keyout servidor.key \
        -subj "/C=EC/O=Test/CN=servidor.local" 2>/dev/null || true
    openssl x509 -req -in servidor.csr -CA "$workdir/ca/ca.crt" -CAkey "$workdir/ca/ca.key" -CAcreateserial \
        -out servidor.crt -days 365 -sha256 2>/dev/null || true
    assert_openssl_chain "servidor.crt" "ca/ca.crt"
}

reto15() {
    local workdir="$HOME/laboratorio/ssl"
    mkdir -p "$workdir" && cd "$workdir" || return 1
    mkdir -p "$workdir/ca" || true
    assert_file_exists "ca/ca.crt"
    assert_file_exists "servidor.crt"
    assert_file_exists "servidor.key"
    assert_openssl_chain "servidor.crt" "ca/ca.crt"
    assert_openssl_subject_matches "servidor.crt" "CN.*servidor"
}

validators=(reto1 reto2 reto3 reto4 reto5 reto6 reto7 reto8 reto9 reto10 reto11 reto12 reto13 reto14 reto15)
challenge_names=(
    "Verificar openssl"
    "Generar clave privada"
    "Verificar clave privada"
    "Generar certificado autofirmado"
    "Ver detalles del certificado"
    "Verificar validez del certificado"
    "Generar CSR"
    "Ver detalles del CSR"
    "Crear CA local"
    "Firmar certificado con CA"
    "Generar RSA 4096 bits"
    "Generar clave ECC secp384r1"
    "Generar CSR desde clave existente"
    "Verificar certificado X.509"
    "Verificar cadena de certificados"
)

ICONOS=("🔍" "🔑" "✅" "📜" "📋" "⏳" "📝" "🔎" "🏛️" "✍️" "🔐" "🔐" "📝" "✔️" "🔗")

reto1_info() {
    separador
    echo -e "${CYAN}Reto 1: Verificar openssl${NC}"
    echo ""
    echo "Confirma que OpenSSL esta instalado y disponible en el PATH."
    echo ""
    echo "Comandos utiles:"
    echo "  openssl version"
    separador
}

reto2_info() {
    separador
    echo -e "${CYAN}Reto 2: Generar clave privada${NC}"
    echo ""
    echo "Genera una clave privada RSA de 2048 bits para uso en criptografia."
    echo ""
    echo "Comandos utiles:"
    echo "  openssl genrsa -out clave_privada.pem 2048"
    separador
}

reto3_info() {
    separador
    echo -e "${CYAN}Reto 3: Verificar clave privada${NC}"
    echo ""
    echo "Comprueba que la clave privada generada es valida y consistente."
    echo ""
    echo "Comandos utiles:"
    echo "  openssl rsa -in clave_privada.pem -check -noout"
    separador
}

reto4_info() {
    separador
    echo -e "${CYAN}Reto 4: Generar certificado autofirmado${NC}"
    echo ""
    echo "Genera un certificado X.509 autofirmado con clave privada."
    echo "Util para desarrollo y pruebas con HTTPS local."
    echo ""
    echo "Comandos utiles:"
    echo "  openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem -days 365 -nodes"
    separador
}

reto5_info() {
    separador
    echo -e "${CYAN}Reto 5: Ver detalles del certificado${NC}"
    echo ""
    echo "Inspecciona el contenido de un certificado: sujeto, emisor, fechas, etc."
    echo ""
    echo "Comandos utiles:"
    echo "  openssl x509 -in cert.pem -text -noout"
    separador
}

reto6_info() {
    separador
    echo -e "${CYAN}Reto 6: Verificar validez del certificado${NC}"
    echo ""
    echo "Comprueba si un certificado ha expirado o sigue vigente."
    echo ""
    echo "Comandos utiles:"
    echo "  openssl x509 -in cert.pem -checkend 0 -noout"
    separador
}

reto7_info() {
    separador
    echo -e "${CYAN}Reto 7: Generar CSR${NC}"
    echo ""
    echo "Genera una solicitud de firma de certificado (CSR) y su clave privada."
    echo "El CSR se envia a una CA para obtener un certificado firmado."
    echo ""
    echo "Comandos utiles:"
    echo "  openssl req -new -newkey rsa:2048 -nodes -out request.csr -keyout key.pem"
    separador
}

reto8_info() {
    separador
    echo -e "${CYAN}Reto 8: Ver detalles del CSR${NC}"
    echo ""
    echo "Inspecciona el contenido de una solicitud de firma de certificado."
    echo ""
    echo "Comandos utiles:"
    echo "  openssl req -in request.csr -text -noout"
    separador
}

reto9_info() {
    separador
    echo -e "${CYAN}Reto 9: Crear CA local${NC}"
    echo ""
    echo "Crea una Autoridad de Certificacion (CA) local con clave y certificado."
    echo "La CA firmara certificados de servidores y clientes."
    echo ""
    echo "Comandos utiles:"
    echo "  openssl genrsa -out ca/ca.key 2048"
    echo "  openssl req -x509 -new -nodes -key ca/ca.key -out ca/ca.crt"
    separador
}

reto10_info() {
    separador
    echo -e "${CYAN}Reto 10: Firmar certificado con CA${NC}"
    echo ""
    echo "Usa tu CA local para firmar un CSR y generar un certificado valido."
    echo ""
    echo "Comandos utiles:"
    echo "  openssl x509 -req -in servidor.csr -CA ca/ca.crt -CAkey ca/ca.key -CAcreateserial -out servidor.crt"
    separador
}

reto11_info() {
    separador
    echo -e "${CYAN}Reto 11: Generar RSA 4096 bits${NC}"
    echo ""
    echo "Genera una clave RSA de 4096 bits para mayor seguridad."
    echo "Mas bits = mayor resistencia a fuerza bruta."
    echo ""
    echo "Comandos utiles:"
    echo "  openssl genrsa -out rsa4096.pem 4096"
    separador
}

reto12_info() {
    separador
    echo -e "${CYAN}Reto 12: Generar clave ECC secp384r1${NC}"
    echo ""
    echo "Genera una clave de curva eliptica (ECC) con la curva secp384r1."
    echo "ECC ofrece la misma seguridad que RSA con claves mucho mas pequenas."
    echo ""
    echo "Comandos utiles:"
    echo "  openssl ecparam -genkey -name secp384r1 -out ecc.key"
    separador
}

reto13_info() {
    separador
    echo -e "${CYAN}Reto 13: Generar CSR desde clave existente${NC}"
    echo ""
    echo "Genera un CSR reutilizando una clave privada que ya tienes."
    echo "Util cuando la clave ya fue generada anteriormente."
    echo ""
    echo "Comandos utiles:"
    echo "  openssl req -new -key clave_privada.pem -out request.csr"
    separador
}

reto14_info() {
    separador
    echo -e "${CYAN}Reto 14: Verificar certificado X.509${NC}"
    echo ""
    echo "Valida que un certificado firmado por una CA tiene la estructura correcta."
    echo ""
    echo "Comandos utiles:"
    echo "  openssl verify -CAfile ca/ca.crt servidor.crt"
    separador
}

reto15_info() {
    separador
    echo -e "${CYAN}Reto 15: Verificar cadena de certificados${NC}"
    echo ""
    echo "Comprueba que la cadena de certificados completa es valida."
    echo "Incluye verificar que el sujeto del certificado coincide con lo esperado."
    echo ""
    echo "Comandos utiles:"
    echo "  openssl verify -CAfile ca/ca.crt servidor.crt"
    echo "  openssl x509 -in servidor.crt -noout -subject"
    separador
}

# ── Standalone execution mode ────────────────────────
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Unit X: SSL/TLS Certificates — Retos"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    PASSED=0
    FAILED=0

    for i in $(seq 1 "$TOTAL_RETOS"); do
        validator="${validators[$((i-1))]}"
        name="${challenge_names[$((i-1))]}"

        if $validator >/dev/null 2>&1; then
            echo "  [PASS] Reto $i: $name"
            PASSED=$((PASSED + 1))
        else
            echo "  [FAIL] Reto $i: $name"
            FAILED=$((FAILED + 1))
        fi
    done

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Unit X Results: $PASSED/$TOTAL_RETOS passed, $FAILED failed"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    [ "$FAILED" -eq 0 ]
fi
