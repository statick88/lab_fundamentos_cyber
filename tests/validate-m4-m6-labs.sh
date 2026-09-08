#!/bin/bash
# tests/validate-m4-m6-labs.sh — Automated QA validation for M4 E5 (Nginx Hardening)
# and M6 E5 (OpenSSL Cert Gen) exercises. Verifies file structure, configuration
# correctness, and progress tracking integration.
#
# Usage: bash tests/validate-m4-m6-labs.sh
# Runs inside the lab Docker container as estudiante.

set -o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAB_DIR="$(dirname "$SCRIPT_DIR")"
HOME_DIR="${HOME:-/home/estudiante}"

# Resolve shared/ — container image installs at /shared/, local dev has it as sibling
if [[ -d "${LAB_DIR}/shared" ]]; then
    SHARED_DIR="${LAB_DIR}/shared"
elif [[ -d "/shared" ]]; then
    SHARED_DIR="/shared"
elif [[ -d "/opt/shared" ]]; then
    SHARED_DIR="/opt/shared"
else
    echo "FATAL: Cannot find shared/ directory" >&2
    exit 1
fi

TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# ── Assertion helpers ────────────────────────────────────────
assert_eq() {
    TESTS_RUN=$((TESTS_RUN + 1))
    local label="$1" expected="$2" actual="$3"
    if [ "$expected" = "$actual" ]; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo "  [PASS] $label"
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo "  [FAIL] $label — expected='$expected' actual='$actual'"
    fi
}

assert_contains() {
    TESTS_RUN=$((TESTS_RUN + 1))
    local label="$1" haystack="$2" needle="$3"
    if echo "$haystack" | grep -qiF -- "$needle"; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo "  [PASS] $label"
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo "  [FAIL] $label — '$needle' not found"
    fi
}

assert_file_exists() {
    TESTS_RUN=$((TESTS_RUN + 1))
    local label="$1" filepath="$2"
    if [ -f "$filepath" ]; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo "  [PASS] $label"
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo "  [FAIL] $label — file '$filepath' not found"
    fi
}

assert_file_not_empty() {
    TESTS_RUN=$((TESTS_RUN + 1))
    local label="$1" filepath="$2"
    if [ -f "$filepath" ] && [ -s "$filepath" ]; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo "  [PASS] $label"
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo "  [FAIL] $label — file '$filepath' is empty or missing"
    fi
}

assert_file_contains() {
    TESTS_RUN=$((TESTS_RUN + 1))
    local label="$1" filepath="$2" pattern="$3"
    if [ -f "$filepath" ] && grep -qF "$pattern" "$filepath"; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo "  [PASS] $label"
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo "  [FAIL] $label — pattern '$pattern' not found in $filepath"
    fi
}

assert_exit_code() {
    TESTS_RUN=$((TESTS_RUN + 1))
    local label="$1" expected="$2" actual="$3"
    if [ "$expected" -eq "$actual" ]; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo "  [PASS] $label"
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo "  [FAIL] $label — exit=$actual expected=$expected"
    fi
}

print_summary() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  M4/M6 LAB VALIDATION RESULTS"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Total:  $TESTS_RUN"
    echo "  Passed: $TESTS_PASSED"
    echo "  Failed: $TESTS_FAILED"
    echo ""
    if [ $TESTS_FAILED -gt 0 ]; then
        echo "  ❌ $TESTS_FAILED test(s) failed"
        exit 1
    else
        echo "  ✓ All tests passed"
        exit 0
    fi
}

# ============================================================
# M4 E5: Nginx Hardening
# ============================================================

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  M4 E5 — Hardening de Nginx con nginx.conf"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

NGINX_DIR="${HOME_DIR}/laboratorio/nginx-hardening"
NGINX_CONF="${NGINX_DIR}/nginx.conf"
NGINX_DF="${NGINX_DIR}/Dockerfile"

# ── M4E5.1: Directory structure ─────────────────────────────
echo ""
echo "--- M4E5.1: Directory structure ---"

assert_file_exists "nginx-hardening directory exists" "$NGINX_DIR"
assert_file_exists "nginx.conf exists" "$NGINX_CONF"
assert_file_not_empty "nginx.conf is not empty" "$NGINX_CONF"
assert_file_exists "Dockerfile exists" "$NGINX_DF"
assert_file_not_empty "Dockerfile is not empty" "$NGINX_DF"

# ── M4E5.2: nginx.conf — server_tokens off ──────────────────
echo ""
echo "--- M4E5.2: server_tokens off ---"

assert_file_contains "server_tokens off present" "$NGINX_CONF" "server_tokens off"

# ── M4E5.3: nginx.conf — security headers ───────────────────
echo ""
echo "--- M4E5.3: Security headers ---"

assert_file_contains "X-Content-Type-Options header" "$NGINX_CONF" "X-Content-Type-Options"
assert_file_contains "nosniff value" "$NGINX_CONF" "nosniff"
assert_file_contains "X-Frame-Options header" "$NGINX_CONF" "X-Frame-Options"
assert_file_contains "SAMEORIGIN value" "$NGINX_CONF" "SAMEORIGIN"
assert_file_contains "X-XSS-Protection header" "$NGINX_CONF" "X-XSS-Protection"
assert_file_contains "1; mode=block value" "$NGINX_CONF" "1; mode=block"
assert_file_contains "Referrer-Policy header" "$NGINX_CONF" "Referrer-Policy"
assert_file_contains "strict-origin-when-cross-origin value" "$NGINX_CONF" "strict-origin-when-cross-origin"

# ── M4E5.4: nginx.conf — HTTP method restriction ────────────
echo ""
echo "--- M4E5.4: HTTP method restriction ---"

assert_file_contains "GET allowed" "$NGINX_CONF" "GET"
assert_file_contains "HEAD allowed" "$NGINX_CONF" "HEAD"
assert_file_contains "POST allowed" "$NGINX_CONF" "POST"
assert_file_contains "DELETE blocked (405)" "$NGINX_CONF" "405"
assert_file_contains "request_method check present" "$NGINX_CONF" "request_method"

# ── M4E5.5: nginx.conf — listen port ────────────────────────
echo ""
echo "--- M4E5.5: Listen port 8080 ---"

assert_file_contains "listens on port 8080" "$NGINX_CONF" "listen 8080"

# ── M4E5.6: Dockerfile correctness ──────────────────────────
echo ""
echo "--- M4E5.6: Dockerfile ---"

assert_file_contains "FROM nginx base image" "$NGINX_DF" "FROM nginx"
assert_file_contains "COPY nginx.conf" "$NGINX_DF" "COPY nginx.conf"
assert_file_contains "EXPOSE 8080" "$NGINX_DF" "EXPOSE 8080"

# ============================================================
# M6 E5: OpenSSL Certificate Generation
# ============================================================

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  M6 E5 — Certificados TLS autofirmados con openssl"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

CERT_DIR="${HOME_DIR}/laboratorio/certificados"
KEY_FILE="${CERT_DIR}/servidor.key"
CRT_FILE="${CERT_DIR}/servidor.crt"

# ── M6E5.1: Directory and files exist ───────────────────────
echo ""
echo "--- M6E5.1: Directory structure ---"

assert_file_exists "certificados directory exists" "$CERT_DIR"
assert_file_exists "servidor.key exists" "$KEY_FILE"
assert_file_not_empty "servidor.key is not empty" "$KEY_FILE"
assert_file_exists "servidor.crt exists" "$CRT_FILE"
assert_file_not_empty "servidor.crt is not empty" "$CRT_FILE"

# ── M6E5.2: Key file is valid RSA ───────────────────────────
echo ""
echo "--- M6E5.2: RSA key validation ---"

if [ -f "$KEY_FILE" ]; then
    KEY_INFO=$(openssl rsa -in "$KEY_FILE" -check -noout 2>&1)
    assert_exit_code "RSA key is valid" 0 $?

    KEY_BITS=$(openssl rsa -in "$KEY_FILE" -text -noout 2>/dev/null | grep -oP '(?<=RSA Key: )\d+' || \
               openssl rsa -in "$KEY_FILE" -text -noout 2>/dev/null | head -1 | grep -oP '\d+(?= bit)')
    assert_eq "RSA key is 2048 bits" "2048" "${KEY_BITS:-0}"
else
    TESTS_RUN=$((TESTS_RUN + 2))
    TESTS_FAILED=$((TESTS_FAILED + 2))
    echo "  [FAIL] RSA key validation — key file missing"
    echo "  [FAIL] RSA key bits — key file missing"
fi

# ── M6E5.3: Certificate is valid X.509 ──────────────────────
echo ""
echo "--- M6E5.3: Certificate validation ---"

if [ -f "$CRT_FILE" ]; then
    CRT_TEXT=$(openssl x509 -in "$CRT_FILE" -noout -text 2>&1)
    CRT_EXIT=$?
    assert_exit_code "Certificate parses as valid X.509" 0 $CRT_EXIT

    # Check signature algorithm
    if [ $CRT_EXIT -eq 0 ]; then
        assert_contains "Uses SHA-256 signature" "$CRT_TEXT" "sha256WithRSAEncryption"
    else
        TESTS_RUN=$((TESTS_RUN + 1))
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo "  [FAIL] Uses SHA-256 signature — cert invalid"
    fi

    # Check subject fields
    if [ $CRT_EXIT -eq 0 ]; then
        CRT_SUBJECT=$(openssl x509 -in "$CRT_FILE" -noout -subject 2>&1)
        assert_contains "Subject CN=localhost" "$CRT_SUBJECT" "CN=localhost"
        assert_contains "Subject O=Lab" "$CRT_SUBJECT" "O=Lab"
        assert_contains "Subject L=Quito" "$CRT_SUBJECT" "L=Quito"
        assert_contains "Subject ST=Pichincha" "$CRT_SUBJECT" "ST=Pichincha"
        assert_contains "Subject C=EC" "$CRT_SUBJECT" "C=EC"
    else
        TESTS_RUN=$((TESTS_RUN + 5))
        TESTS_FAILED=$((TESTS_FAILED + 5))
        echo "  [FAIL] Subject fields — cert invalid"
    fi
else
    TESTS_RUN=$((TESTS_RUN + 7))
    TESTS_FAILED=$((TESTS_FAILED + 7))
    echo "  [FAIL] Certificate validation — crt file missing"
fi

# ── M6E5.4: Key and certificate match ───────────────────────
echo ""
echo "--- M6E5.4: Key-certificate pair match ---"

if [ -f "$KEY_FILE" ] && [ -f "$CRT_FILE" ]; then
    KEY_HASH=$(openssl rsa -in "$KEY_FILE" -pubout 2>/dev/null | openssl dgst -sha256 | awk '{print $2}')
    CRT_HASH=$(openssl x509 -in "$CRT_FILE" -noout -pubkey 2>/dev/null | openssl dgst -sha256 | awk '{print $2}')
    assert_eq "Key and certificate public keys match" "$KEY_HASH" "$CRT_HASH"
else
    TESTS_RUN=$((TESTS_RUN + 1))
    TESTS_FAILED=$((TESTS_FAILED + 1))
    echo "  [FAIL] Key-certificate match — files missing"
fi

# ── M6E5.5: Certificate validity dates ──────────────────────
echo ""
echo "--- M6E5.5: Certificate validity ---"

if [ -f "$CRT_FILE" ]; then
    CERT_DATES=$(openssl x509 -in "$CRT_FILE" -noout -dates 2>&1)
    assert_contains "Has notBefore date" "$CERT_DATES" "notBefore"
    assert_contains "Has notAfter date" "$CERT_DATES" "notAfter"
else
    TESTS_RUN=$((TESTS_RUN + 2))
    TESTS_FAILED=$((TESTS_FAILED + 2))
    echo "  [FAIL] Certificate validity — crt file missing"
fi

# ============================================================
# Progress Integration
# ============================================================

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Progress Integration — progreso() + eval.sh"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# ── PROG.1: eval.sh is loadable ─────────────────────────────
echo ""
echo "--- PROG.1: eval.sh sourceable ---"

EVAL_SH="${SHARED_DIR}/eval.sh"
assert_file_exists "shared/eval.sh exists" "$EVAL_SH"

# ── PROG.2: marcar_completado / esta_completado ──────────────
echo ""
echo "--- PROG.2: marcar_completado / esta_completado ---"

# Use a temporary test state to avoid polluting real progress
TEST_STATE_DIR=$(mktemp -d)
TEST_PROGRESS="${TEST_STATE_DIR}/progress"
touch "$TEST_PROGRESS"

# Source eval.sh with overridden STATE_DIR and PROGRESS_FILE
(
    export STATE_DIR="$TEST_STATE_DIR"
    export PROGRESS_FILE="$TEST_PROGRESS"
    source "$EVAL_SH"

    # Test marking completion
    marcar_completado "test-unit" "1"
    marcar_completado "test-unit" "3"

    # Verify marks
    esta_completado "test-unit" "1"
    exit $?
)
assert_exit_code "marcar_completado marks reto 1" 0 $?

(
    export STATE_DIR="$TEST_STATE_DIR"
    export PROGRESS_FILE="$TEST_PROGRESS"
    source "$EVAL_SH"
    esta_completado "test-unit" "3"
    exit $?
)
assert_exit_code "marcar_completado marks reto 3" 0 $?

# Verify unmarked reto returns failure
(
    export STATE_DIR="$TEST_STATE_DIR"
    export PROGRESS_FILE="$TEST_PROGRESS"
    source "$EVAL_SH"
    esta_completado "test-unit" "2"
    exit $?
)
assert_exit_code "Unmarked reto 2 returns non-zero" 1 $?

# ── PROG.3: contar_completados ───────────────────────────────
echo ""
echo "--- PROG.3: contar_completados ---"

COUNT=$( (
    export STATE_DIR="$TEST_STATE_DIR"
    export PROGRESS_FILE="$TEST_PROGRESS"
    source "$EVAL_SH"
    contar_completados "test-unit" "5"
) 2>/dev/null)
assert_eq "contar_completados returns 2 for 5 total" "2" "$COUNT"

# ── PROG.4: Duplicate marking is idempotent ─────────────────
echo ""
echo "--- PROG.4: Idempotent marking ---"

(
    export STATE_DIR="$TEST_STATE_DIR"
    export PROGRESS_FILE="$TEST_PROGRESS"
    source "$EVAL_SH"
    marcar_completado "test-unit" "1"
    marcar_completado "test-unit" "1"
    marcar_completado "test-unit" "1"
) 2>/dev/null

LINE_COUNT=$(grep -c "^test-unit:reto:1$" "$TEST_PROGRESS" 2>/dev/null) || true
assert_eq "Duplicate marking produces 1 line" "1" "${LINE_COUNT:-0}"

# ── PROG.5: Different units are isolated ─────────────────────
echo ""
echo "--- PROG.5: Unit isolation ---"

(
    export STATE_DIR="$TEST_STATE_DIR"
    export PROGRESS_FILE="$TEST_PROGRESS"
    source "$EVAL_SH"
    marcar_completado "other-unit" "1"
    esta_completado "other-unit" "1"
    exit $?
)
assert_exit_code "Other unit reto 1 marked" 0 $?

(
    export STATE_DIR="$TEST_STATE_DIR"
    export PROGRESS_FILE="$TEST_PROGRESS"
    source "$EVAL_SH"
    esta_completado "test-unit" "2"
    exit $?
)
assert_exit_code "test-unit reto 2 still unmarked after other-unit change" 1 $?

# ── PROG.6: Shared modules are loadable ─────────────────────
echo ""
echo "--- PROG.6: Shared modules loadable ---"

for module in colors.sh eval.sh menu.sh; do
    assert_file_exists "shared/$module exists" "${SHARED_DIR}/$module"
done

# Cleanup test state
rm -rf "$TEST_STATE_DIR"

# ============================================================
# RESULTS
# ============================================================

print_summary
