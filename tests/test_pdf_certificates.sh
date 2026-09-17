#!/bin/bash
# tests/test_pdf_certificates.sh — E2E tests for PDF certificate generation flow
# Validates student info loading, PDF generation via generar_pdf_reto,
# and verify.sh execution inside the Docker container.
#
# Patterns adapted from tests/metrics_e2e_test.sh

set -o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAB_DIR="$(dirname "$SCRIPT_DIR")"

TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# ── Assertion helpers (mirrors metrics_e2e_test.sh) ───────────────────────────

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
    if echo "$haystack" | grep -qF -- "$needle"; then
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

print_summary() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  E2E TEST RESULTS — test_pdf_certificates.sh"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Total:  $TESTS_RUN"
    echo "  Passed: $TESTS_PASSED"
    echo "  Failed: $TESTS_FAILED"
    echo ""
    if [ $TESTS_FAILED -gt 0 ]; then
        echo "  ❌ $TESTS_FAILED test(s) failed"
        return 1
    else
        echo "  ✓ All tests passed"
        return 0
    fi
}

# ── Cleanup ───────────────────────────────────────────────────────────────────

cleanup() {
    docker ps -a --format '{{.Names}}' 2>/dev/null | grep -q 'pdf-cert-test' && docker rm -f pdf-cert-test 2>/dev/null || true
}
trap cleanup EXIT

# ── Docker availability check ─────────────────────────────────────────────────

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  E2E TESTS — PDF Certificate Generation"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if ! command -v docker &>/dev/null; then
    echo ""
    echo "  [SKIP] Docker not available — skipping all Docker-based tests"
    TESTS_RUN=$((TESTS_RUN + 1))
    TESTS_PASSED=$((TESTS_PASSED + 1))
    echo "  [PASS] Docker availability skip (graceful)"
    print_summary
    exit 0
fi

# ── Build image ───────────────────────────────────────────────────────────────

echo ""
echo "--- Setup: Building Docker image ---"
docker build -t lab-ciberseguridad:test "$LAB_DIR" 2>&1 | tail -3 || {
    echo "  [FAIL] Docker image build failed"
    TESTS_RUN=$((TESTS_RUN + 1))
    TESTS_FAILED=$((TESTS_FAILED + 1))
    print_summary
    exit 1
}
TESTS_RUN=$((TESTS_RUN + 1))
TESTS_PASSED=$((TESTS_PASSED + 1))
echo "  [PASS] Docker image built (lab-ciberseguridad:test)"

# ── Test 1: Student info defaults (no .student_info) ──────────────────────────

echo ""
echo "--- Test 1: Student info defaults ---"
OUTPUT=$(docker run --rm --entrypoint bash lab-ciberseguridad:test -c '
    export HOME=/home/estudiante
    source /shared/eval.sh
    cargar_datos_estudiante
    echo "STUDENT_NAME=${STUDENT_NAME}"
    echo "COURSE=${COURSE}"
' 2>&1)

assert_contains "Test 1 output produced" "$OUTPUT" "STUDENT_NAME"
assert_eq "Default STUDENT_NAME" "Estudiante" "$(echo "$OUTPUT" | grep '^STUDENT_NAME=' | head -1 | cut -d= -f2-)"
assert_eq "Default COURSE" "ABC-CYB-101" "$(echo "$OUTPUT" | grep '^COURSE=' | head -1 | cut -d= -f2-)"

# ── Test 2: Student info from .student_info file ──────────────────────────────

echo ""
echo "--- Test 2: Student info from file ---"

OUTPUT=$(docker run --rm --entrypoint bash lab-ciberseguridad:test -c '
    export HOME=/home/estudiante
    mkdir -p "$HOME/laboratorio"
    printf "STUDENT_NAME=Maria Garcia\nCOURSE=ABC-CYB-101\n" > "$HOME/laboratorio/.student_info"
    source /shared/eval.sh
    cargar_datos_estudiante
    echo "STUDENT_NAME=${STUDENT_NAME}"
    echo "COURSE=${COURSE}"
' 2>&1)

assert_eq "Loaded STUDENT_NAME from file" "Maria Garcia" "$(echo "$OUTPUT" | grep '^STUDENT_NAME=' | head -1 | cut -d= -f2-)"
assert_eq "Loaded COURSE from file" "ABC-CYB-101" "$(echo "$OUTPUT" | grep '^COURSE=' | head -1 | cut -d= -f2-)"

# ── Test 3: PDF generation for unit-I-asset reto 1 ────────────────────────────

echo ""
echo "--- Test 3: PDF generation ---"

OUTPUT=$(docker run --rm --entrypoint bash lab-ciberseguridad:test -c '
    export HOME=/home/estudiante

    # Ensure units are copied
    mkdir -p "$HOME/laboratorio/units"
    cp -r /opt/lab-units/* "$HOME/laboratorio/units/" 2>/dev/null || true

    # Set up student info
    mkdir -p "$HOME/laboratorio"
    printf "STUDENT_NAME=Maria Garcia\nCOURSE=ABC-CYB-101\n" > "$HOME/laboratorio/.student_info"

    # Source shared libraries
    source /shared/common.sh 2>/dev/null || true
    source /shared/eval.sh

    # Source the unit test to get challenge_names and ICONOS
    source "$HOME/laboratorio/units/i-asset-classification/test.sh" 2>/dev/null || true

    # Generate the PDF
    reto_name="${challenge_names[0]:-Verificar existencia del escenario}"
    reto_icon="${ICONOS[0]:-📋}"
    if generar_pdf_reto "unit-I-asset" 1 "$reto_name" "$reto_name" "$reto_icon"; then
        echo "PDF_GENERATION=SUCCESS"
    else
        echo "PDF_GENERATION=FAILED"
    fi

    # Output PDF path and check
    PDF_FILE="$HOME/laboratorio/units/i-asset-classification/certs/reto_1.pdf"
    if [ -f "$PDF_FILE" ]; then
        echo "PDF_EXISTS=YES"
        # Check it is a valid PDF (starts with %PDF-)
        header=$(head -c 5 "$PDF_FILE")
        if [ "$header" = "%PDF-" ]; then
            echo "PDF_VALID=YES"
        else
            echo "PDF_VALID=NO"
        fi
        # File size
        echo "PDF_SIZE=$(stat -c %s "$PDF_FILE" 2>/dev/null || stat -f %z "$PDF_FILE" 2>/dev/null || echo 0)"
    else
        echo "PDF_EXISTS=NO"
        echo "PDF_VALID=NO"
        echo "PDF_SIZE=0"
    fi
' 2>&1)

# Parse results
assert_contains "PDF generation succeeded" "$OUTPUT" "PDF_GENERATION=SUCCESS"
PDF_EXISTS=$(echo "$OUTPUT" | grep '^PDF_EXISTS=' | cut -d= -f2)
assert_eq "PDF file exists" "YES" "$PDF_EXISTS"

PDF_VALID=$(echo "$OUTPUT" | grep '^PDF_VALID=' | cut -d= -f2)
assert_eq "PDF has valid header" "YES" "$PDF_VALID"

PDF_SIZE=$(echo "$OUTPUT" | grep '^PDF_SIZE=' | head -1 | cut -d= -f2)
if [ -n "$PDF_SIZE" ] && [ "$PDF_SIZE" -gt 1000 ] 2>/dev/null; then
    TESTS_RUN=$((TESTS_RUN + 1))
    TESTS_PASSED=$((TESTS_PASSED + 1))
    echo "  [PASS] PDF file non-empty (size=$PDF_SIZE bytes)"
else
    TESTS_RUN=$((TESTS_RUN + 1))
    TESTS_FAILED=$((TESTS_FAILED + 1))
    echo "  [FAIL] PDF file empty or too small (size=$PDF_SIZE)"
fi

# ── Test 4: verify.sh inside container ─────────────────────────────────────────

echo ""
echo "--- Test 4: verify.sh inside container ---"

# Mount repo into container so verify.sh can read Dockerfile, docker-compose.yml, shared/
# Use --entrypoint bash to bypass the interactive entrypoint.sh
OUTPUT=$(docker run --rm \
    -v "$LAB_DIR:/mnt/lab:ro" \
    --entrypoint bash lab-ciberseguridad:test -c '
    cd /mnt/lab
    bash verify.sh 2>&1
    echo "VERIFY_EXIT=$?"
' 2>&1)

VERIFY_EXIT=$(echo "$OUTPUT" | grep '^VERIFY_EXIT=' | head -1 | cut -d= -f2)
if [ -z "$VERIFY_EXIT" ]; then
    VERIFY_EXIT=1
fi
assert_eq "verify.sh exits 0 in container" 0 "$VERIFY_EXIT"
assert_contains "verify.sh output shows PASS" "$OUTPUT" "All verification checks PASSED"

# ── Cleanup and summary ───────────────────────────────────────────────────────

echo ""
echo "--- Cleanup ---"
TESTS_RUN=$((TESTS_RUN + 1))
# Verify no containers left running
RUNNING=$(docker ps -a --format '{{.Names}}' 2>/dev/null | grep 'pdf-cert-test' || true)
if [ -z "$RUNNING" ]; then
    TESTS_PASSED=$((TESTS_PASSED + 1))
    echo "  [PASS] No leftover containers"
else
    TESTS_FAILED=$((TESTS_FAILED + 1))
    echo "  [FAIL] Leftover containers: $RUNNING"
fi

print_summary
