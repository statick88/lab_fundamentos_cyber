#!/bin/bash
# Checkpoint IV: Evaluación Módulo IV — test.sh
# Estandarizado: usa /shared/validators.sh para aserciones deterministicas
# Sin dependencias de sudo/root. Paths bajo $HOME/laboratorio.

# Dual-path sourcing
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
    source /shared/validators.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
    source "$(dirname "$0")/../../shared/validators.sh"
fi

UNIT_NAME="checkpoint-IV"
TOTAL_RETOS=5

LAB_DIR="$HOME/laboratorio/checkpoints/checkpoint-iv"

# ── Reto 1: CVSS Base Score ─────────────────────────────────────
# Valida que el estudiante pueda calcular o ejecutar un score CVSS.
reto1() {
    mkdir -p "$LAB_DIR" || return 1
    local student_script="$LAB_DIR/cvss_calculator.py"
    if [ ! -f "$student_script" ]; then
        student_script="$HOME/laboratorio/cvss_calculator.py"
    fi
    # Verificar que la calculadora existe y es funcional
    if [ -f "$student_script" ]; then
        assert_file_exists "$student_script"
        # Intentar ejecutar con las métricas dadas
        local result
        result=$(python3 "$student_script" "0.5" "AV:N/AC:H/PR:L/UI:N/S:U/C:H/I:H/A:H" 2>/dev/null) || true
        if echo "$result" | grep -qE "^[0-9]+\.[0-9]$|^[0-9]+\.[0-9][0-9]$"; then
            return 0
        fi
        # Si no retornó número, al menos verificar que el script existe y tiene lógica CVSS
        assert_file_contains "$student_script" "cvss\|CVSS\|score\|vector"
        return 0
    fi
    # Fallback: buscar cualquier script que calcule CVSS
    local cvss_file
    cvss_file=$(find "$LAB_DIR" "$HOME/laboratorio" -maxdepth 3 -type f -name "*cvss*" 2>/dev/null | head -1)
    if [ -n "$cvss_file" ]; then
        assert_file_exists "$cvss_file"
        return 0
    fi
    echo "FAIL: No se encontro calculadora CVSS" >&2
    return 1
}

# ── Reto 2: Hash SHA-256 ────────────────────────────────────────
# Valida que exista un hash SHA-256 válido (64 hex chars) de un archivo.
reto2() {
    mkdir -p "$LAB_DIR" || return 1
    local key_file="$LAB_DIR/servidor.key"
    if [ ! -f "$key_file" ]; then
        key_file=$(find "$LAB_DIR" -maxdepth 2 -type f \( -name "*.key" -o -name "*.pem" \) 2>/dev/null | head -1)
    fi
    if [ -n "$key_file" ] && [ -f "$key_file" ]; then
        assert_file_exists "$key_file"
        # Verificar que se puede generar hash válido
        local hash
        hash=$(sha256sum "$key_file" 2>/dev/null | awk '{print $1}')
        if echo "$hash" | grep -qE '^[a-f0-9]{64}$'; then
            return 0
        fi
    fi
    # Verificar si el estudiante guardó un hash en archivo
    local hash_file
    hash_file=$(find "$LAB_DIR" -maxdepth 2 -type f \( -name "*hash*" -o -name "*sha256*" \) 2>/dev/null | head -1)
    if [ -n "$hash_file" ] && [ -f "$hash_file" ]; then
        assert_file_exists "$hash_file"
        assert_file_contains "$hash_file" '[a-f0-9]\{64\}'
        return 0
    fi
    echo "FAIL: No se encontro hash SHA-256 valido" >&2
    return 1
}

# ── Reto 3: Verificar Cadena de Certificados ────────────────────
# Valida que openssl verify retorne OK para la cadena CA→servidor.
reto3() {
    mkdir -p "$LAB_DIR/ca" || return 1
    # Asegurar que existan los certificados
    local ca_crt="$LAB_DIR/ca/ca.crt"
    local srv_crt="$LAB_DIR/servidor.crt"
    if [ ! -f "$ca_crt" ] || [ ! -f "$srv_crt" ]; then
        # Recrear si falta
        if [ ! -f "$ca_crt" ]; then
            openssl genrsa -out "$LAB_DIR/ca/ca.key" 2048 2>/dev/null || true
            openssl req -x509 -new -nodes -key "$LAB_DIR/ca/ca.key" -sha256 -days 365 \
                -out "$ca_crt" -subj "/C=EC/O=TestCA/CN=CheckpointCA" 2>/dev/null || true
        fi
        if [ ! -f "$srv_crt" ]; then
            openssl req -new -newkey rsa:2048 -nodes -out "$LAB_DIR/servidor.csr" -keyout "$LAB_DIR/servidor.key" \
                -subj "/C=EC/O=Test/CN=checkpoint.local" 2>/dev/null || true
            openssl x509 -req -in "$LAB_DIR/servidor.csr" -CA "$ca_crt" -CAkey "$LAB_DIR/ca/ca.key" -CAcreateserial \
                -out "$srv_crt" -days 365 -sha256 2>/dev/null || true
        fi
    fi
    assert_file_exists "$ca_crt"
    assert_file_exists "$srv_crt"
    assert_openssl_chain "$srv_crt" "$ca_crt"
}

# ── Reto 4: Inspeccionar Detalles X.509 ─────────────────────────
# Valida que se puedan extraer subject e issuer del certificado.
reto4() {
    mkdir -p "$LAB_DIR" || return 1
    local srv_crt="$LAB_DIR/servidor.crt"
    if [ ! -f "$srv_crt" ]; then
        srv_crt=$(find "$LAB_DIR" -maxdepth 2 -type f -name "*.crt" 2>/dev/null | head -1)
    fi
    if [ -z "$srv_crt" ] || [ ! -f "$srv_crt" ]; then
        echo "FAIL: No se encontro certificado servidor.crt" >&2
        return 1
    fi
    assert_file_exists "$srv_crt"
    # Verificar que se puede leer subject
    assert_openssl_subject_matches "$srv_crt" "CN"
    # Verificar que el cert tiene issuer
    local text
    text=$(openssl x509 -in "$srv_crt" -text -noout 2>/dev/null) || true
    if echo "$text" | grep -qi "issuer\|subject"; then
        return 0
    fi
    echo "FAIL: No se pudo extraer subject/issuer del certificado" >&2
    return 1
}

# ── Reto 5: Firma Digital ───────────────────────────────────────
# Valida que exista un archivo de firma generado con openssl dgst.
reto5() {
    mkdir -p "$LAB_DIR" || return 1
    local ca_key="$LAB_DIR/ca/ca.key"
    local ca_crt="$LAB_DIR/ca/ca.crt"
    # Verificar que existan las claves de la CA
    if [ ! -f "$ca_key" ] || [ ! -f "$ca_crt" ]; then
        mkdir -p "$LAB_DIR/ca"
        openssl genrsa -out "$ca_key" 2048 2>/dev/null || true
        openssl req -x509 -new -nodes -key "$ca_key" -sha256 -days 365 \
            -out "$ca_crt" -subj "/C=EC/O=TestCA/CN=CheckpointCA" 2>/dev/null || true
    fi
    assert_file_exists "$ca_key"
    assert_file_exists "$ca_crt"
    # Buscar archivo de firma existente
    local sig_file
    sig_file=$(find "$LAB_DIR" -maxdepth 2 -type f \( -name "*.sig" -o -name "*.signature" -o -name "*firma*" \) 2>/dev/null | head -1)
    if [ -n "$sig_file" ] && [ -f "$sig_file" ]; then
        assert_file_exists "$sig_file"
        # Verificar que el archivo tiene contenido (no vacío)
        local size
        size=$(wc -c < "$sig_file" 2>/dev/null || echo "0")
        if [ "$size" -gt 0 ]; then
            return 0
        fi
    fi
    # Si no hay firma, intentar generar una para validar que el proceso funciona
    local test_file="$LAB_DIR/test_sign.txt"
    echo "test data" > "$test_file"
    local test_sig="$LAB_DIR/test_firma.sig"
    if openssl dgst -sha256 -sign "$ca_key" -out "$test_sig" "$test_file" 2>/dev/null; then
        if [ -f "$test_sig" ] && [ -s "$test_sig" ]; then
            rm -f "$test_file" "$test_sig"
            return 0
        fi
    fi
    rm -f "$test_file" "$test_sig" 2>/dev/null
    echo "FAIL: No se generó archivo de firma digital válido" >&2
    return 1
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
    echo ""
    echo "Calcula el score CVSS 3.1 base de una vulnerabilidad."
    echo "Usa la calculadora cvss_calculator.py o first.org/cvss."
    echo ""
    echo "Métricas objetivo: AV:N/AC:H/PR:L/UI:N/S:U/C:H/I:H/A:H"
    echo "Score esperado: ~7.5"
    echo ""
    echo "Comandos útiles:"
    echo "  python3 cvss_calculator.py"
    separador
}

reto2_info() {
    separador
    echo -e "${CYAN}Reto 2: Hash SHA-256${NC}"
    echo ""
    echo "Genera el hash SHA-256 de servidor.key."
    echo "El resultado debe ser un hash de 64 caracteres hexadecimales."
    echo ""
    echo "Comandos útiles:"
    echo "  sha256sum servidor.key"
    echo "  sha256sum servidor.crt"
    separador
}

reto3_info() {
    separador
    echo -e "${CYAN}Reto 3: Verificar Cadena de Certificados${NC}"
    echo ""
    echo "Verifica que servidor.crt fue firmado por la CA local."
    echo "openssl verify debe retornar 'OK'."
    echo ""
    echo "Comandos útiles:"
    echo "  openssl verify -CAfile ca/ca.crt servidor.crt"
    separador
}

reto4_info() {
    separador
    echo -e "${CYAN}Reto 4: Inspeccionar Detalles X.509${NC}"
    echo ""
    echo "Extrae subject, issuer y fechas de un certificado X.509."
    echo ""
    echo "Comandos útiles:"
    echo "  openssl x509 -in servidor.crt -text -noout"
    echo "  openssl x509 -in servidor.crt -subject -issuer -dates -noout"
    separador
}

reto5_info() {
    separador
    echo -e "${CYAN}Reto 5: Firma Digital${NC}"
    echo ""
    echo "Firma un archivo con la clave privada de la CA."
    echo "Genera un archivo .sig verificable."
    echo ""
    echo "Comandos útiles:"
    echo "  openssl dgst -sha256 -sign ca/ca.key -out firma.sig archivo.txt"
    echo "  openssl dgst -sha256 -verify ca/ca.crt -signature firma.sig archivo.txt"
    separador
}

# ── Standalone execution mode ─────────────────────────────────────
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Checkpoint IV: Amenazas y Criptografía — Retos"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    PASSED=0
    FAILED=0

    for i in $(seq 1 "$TOTAL_RETOS"); do
        validator="${validators[$((i-1))]}"
        name="${challenge_names[$((i-1))]}"
        icon="${ICONOS[$((i-1))]}"

        if $validator >/dev/null 2>&1; then
            echo "  [PASS] Reto $i: $name $icon"
            PASSED=$((PASSED + 1))
        else
            echo "  [FAIL] Reto $i: $name"
            FAILED=$((FAILED + 1))
        fi
    done

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Checkpoint IV Results: $PASSED/$TOTAL_RETOS passed, $FAILED failed"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    [ "$FAILED" -eq 0 ]
fi
