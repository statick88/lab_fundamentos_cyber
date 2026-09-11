#!/bin/bash
# Unit III-compliance-iso27001: Cumplimiento ISO 27001 / NIST CSF 2.0 — test.sh
# Estandarizado: usa /shared/validators.sh para aserciones deterministicas
# Sin dependencias de sudo/root. Paths bajo $HOME/laboratorio.

# Support both container (/shared) and local (relative) paths
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
    source /shared/validators.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
    source "$(dirname "$0")/../../shared/validators.sh"
fi

UNIT_NAME="unit-III-compliance"
TOTAL_RETOS=5

LAB_DIR="$HOME/laboratorio/governance"

# ── Reto 1: Risk Register CSV ──────────────────────────────────────
# Valida que exista un CSV con encabezados estándar de risk register.
reto1() {
    local file="$LAB_DIR/risk_register.csv"
    assert_file_exists "$file"
    assert_file_contains "$file" "risk_id"
    assert_file_contains "$file" "likelihood"
    assert_file_contains "$file" "impact"
    assert_file_contains "$file" "owner"
}

# ── Reto 2: Statement of Applicability JSON ────────────────────────
# Valida que exista un JSON válido con campos SoA.
reto2() {
    local file="$LAB_DIR/statement_of_applicability.json"
    assert_file_exists "$file"
    assert_file_contains "$file" "applicable_controls"
    assert_file_contains "$file" "standard"
}

# ── Reto 3: Policy Compliance MD ───────────────────────────────────
# Valida que exista un documento de política de cumplimiento.
reto3() {
    local file="$LAB_DIR/politica_cumplimiento.md"
    assert_file_exists "$file"
    assert_file_contains "$file" "Alcance"
    assert_file_contains "$file" "ISO"
}

# ── Reto 4: Severity Matrix ────────────────────────────────────────
# Valida que exista una matriz de severidad con likelihood/impact.
reto4() {
    local file="$LAB_DIR/severidad_matrix.csv"
    assert_file_exists "$file"
    assert_file_contains "$file" "likelihood"
    assert_file_contains "$file" "impact"
    assert_file_contains "$file" "risk_level"
}

# ── Reto 5: Controls Compliance Check ──────────────────────────────
# Valida que exista un script verificador de controles ISO 27001.
reto5() {
    local script="$LAB_DIR/controls_check.sh"
    assert_file_exists "$script"
    assert_command_ok test -x "$script"
    assert_file_contains "$script" "ISO"
}

validators=(reto1 reto2 reto3 reto4 reto5)
challenge_names=(
    "Risk Register CSV"
    "Statement of Applicability JSON"
    "Policy Compliance MD"
    "Severity Matrix"
    "Controls Compliance Check"
)

ICONOS=("📋" "📑" "📜" "⚠️" "✅")

reto1_info() {
    separador
    echo -e "${CYAN}Reto 1: Risk Register CSV${NC}"
    echo ""
    echo "Crea un archivo risk_register.csv con columnas:"
    echo "  risk_id, title, likelihood, impact, owner"
    echo ""
    echo "Comandos útiles:"
    echo "  nano ~/laboratorio/governance/risk_register.csv"
    separador
}

reto2_info() {
    separador
    echo -e "${CYAN}Reto 2: Statement of Applicability JSON${NC}"
    echo ""
    echo "Crea un archivo statement_of_applicability.json que defina"
    echo "los controles aplicables del ISO 27001."
    echo ""
    echo "Comandos útiles:"
    echo "  nano ~/laboratorio/governance/statement_of_applicability.json"
    separador
}

reto3_info() {
    separador
    echo -e "${CYAN}Reto 3: Policy Compliance MD${NC}"
    echo ""
    echo "Crea un documento politica_cumplimiento.md que documente"
    echo "la política de cumplimiento ISO 27001 / NIST CSF 2.0."
    echo ""
    echo "Comandos útiles:"
    echo "  nano ~/laboratorio/governance/politica_cumplimiento.md"
    separador
}

reto4_info() {
    separador
    echo -e "${CYAN}Reto 4: Severity Matrix${NC}"
    echo ""
    echo "Crea un archivo severidad_matrix.csv con columnas:"
    echo "  severity, likelihood, impact, risk_level"
    echo ""
    echo "Comandos útiles:"
    echo "  nano ~/laboratorio/governance/severidad_matrix.csv"
    separador
}

reto5_info() {
    separador
    echo -e "${CYAN}Reto 5: Controls Compliance Check${NC}"
    echo ""
    echo "Crea un script controls_check.sh que verifique el"
    echo "cumplimiento de controles ISO 27001 (A.5, A.8, etc)."
    echo ""
    echo "Comandos útiles:"
    echo "  nano ~/laboratorio/governance/controls_check.sh"
    separador
}

# ── Standalone execution mode ─────────────────────────────────────
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Unit III-Compliance: ISO 27001 / NIST CSF 2.0 — Retos"
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
    echo "  Unit III-Compliance Results: $PASSED/$TOTAL_RETOS passed, $FAILED failed"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    [ "$FAILED" -eq 0 ]
fi
