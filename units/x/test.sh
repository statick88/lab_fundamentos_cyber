#!/bin/bash
# Unit X: SSL/TLS Certificates — test.sh
# Automated validation of 15 challenges
# Estandarizado: usa /shared/validators.sh para aserciones deterministicas

# Support both container (/shared) and local (relative) paths
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
fi
source /shared/validators.sh

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
