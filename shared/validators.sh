#!/bin/bash
# /shared/validators.sh — Helpers estandarizados para validadores de retos
# Contrato: retorna 0 en PASS, 1 en FAIL. Sin efectos secundarios.
# Sin dependencias de sudo/root. Paths bajo $HOME/laboratorio, /tmp o /shared.

assert_file_exists() {
    [ -f "$1" ] && return 0
    echo "FAIL: Archivo esperado no encontrado: $1" >&2
    return 1
}

assert_file_contains() {
    local file="$1" pattern="$2"
    if [ "$file" = "/dev/stdin" ]; then
        grep -q "$pattern" 2>/dev/null && return 0
    else
        grep -q "$pattern" "$file" 2>/dev/null && return 0
    fi
    echo "FAIL: Patrón no encontrado en $file: $pattern" >&2
    return 1
}

assert_command_ok() {
    "$@" >/dev/null 2>&1 && return 0
    echo "FAIL: Comando falló: $*" >&2
    return 1
}

assert_openssl_chain() {
    local cert="$1" ca="$2"
    openssl verify -CAfile "$ca" "$cert" 2>/dev/null | grep -q "OK" && return 0
    echo "FAIL: Cadena $cert -> $ca inválida" >&2
    return 1
}

assert_openssl_subject_matches() {
    local cert="$1" pattern="$2"
    local subject
    subject=$(openssl x509 -in "$cert" -noissuer -subject -nodates 2>/dev/null) || {
        echo "FAIL: No se pudo leer subject de $cert" >&2; return 1; }
    echo "$subject" | grep -qi "$pattern" && return 0
    echo "FAIL: Subject no coincide con '$pattern' en $cert" >&2
    return 1
}

assert_file_not_exists() {
    [ ! -f "$1" ] && return 0
    echo "FAIL: Archivo no esperado encontrado: $1" >&2
    return 1
}
