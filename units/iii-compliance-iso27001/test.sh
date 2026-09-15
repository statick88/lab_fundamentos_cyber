#!/bin/bash
# Unit iii-compliance-iso27001: Cumplimiento ISO 27001 / NIST CSF 2.0 — test.sh
# 5 retos CORE: risk_register, SoA, política, matriz severidad, controls check

# Dual-path sourcing
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
fi

UNIT_NAME="unit-iii-compliance-iso27001"
TOTAL_RETOS=5

LAB_DIR="$HOME/laboratorio/governance"

# ── Reto 1: Risk Register CSV con al menos 5 riesgos ───────────
reto1() {
    local rr="$LAB_DIR/risk_register.csv"
    if [ ! -f "$rr" ]; then
        echo "FAIL: risk_register.csv no existe en $LAB_DIR" >&2
        return 1
    fi

    # Must have more than just the header row
    local total_lines
    total_lines=$(wc -l < "$rr" 2>/dev/null | tr -d ' ')
    if [ "$total_lines" -lt 2 ]; then
        echo "FAIL: risk_register.csv solo tiene encabezado ($total_lines líneas)" >&2
        return 1
    fi

    # Must contain at least 5 risk entries (lines with RISK- pattern or 5+ data rows)
    local risk_count
    risk_count=$(grep -cE '^RISK-[0-9]' "$rr" 2>/dev/null || echo 0)

    # Fallback: count CSV data rows (non-empty, non-comment, non-header)
    if [ "$risk_count" -lt 5 ]; then
        risk_count=$(grep -cvE '^\s*$|^#|^risk_id,' "$rr" 2>/dev/null || echo 0)
    fi

    if [ "$risk_count" -ge 5 ]; then
        return 0
    fi

    echo "FAIL: risk_register.csv tiene solo $risk_count riesgos (se esperan al menos 5)" >&2
    return 1
}

# ── Reto 2: Statement of Applicability JSON válido con 10+ controles ──
reto2() {
    local soa="$LAB_DIR/statement_of_applicability.json"
    if [ ! -f "$soa" ]; then
        echo "FAIL: statement_of_applicability.json no existe en $LAB_DIR" >&2
        return 1
    fi

    # Must be valid JSON
    if command -v python3 >/dev/null 2>&1; then
        if ! python3 -c "import json; json.load(open('$soa'))" 2>/dev/null; then
            echo "FAIL: statement_of_applicability.json no es JSON válido" >&2
            return 1
        fi

        # Count controls: check applicable_controls array has at least 10 entries
        local ctrl_count
        ctrl_count=$(python3 -c "
import json
d = json.load(open('$soa'))
ac = d.get('applicable_controls', [])
# Handle both list-of-strings and list-of-objects
print(len(ac))
" 2>/dev/null || echo 0)

        if [ "$ctrl_count" -ge 10 ]; then
            return 0
        fi

        # Alternative: count controls as objects with 'id' or 'control' field
        ctrl_count=$(python3 -c "
import json
d = json.load(open('$soa'))
ac = d.get('applicable_controls', [])
count = 0
for c in ac:
    if isinstance(c, dict) and (c.get('id') or c.get('control') or c.get('control_id')):
        count += 1
    elif isinstance(c, str) and len(c) > 0:
        count += 1
print(count)
" 2>/dev/null || echo 0)

        if [ "$ctrl_count" -ge 10 ]; then
            return 0
        fi
    else
        # Fallback without python3: count occurrences of control-like patterns
        local ctrl_count
        ctrl_count=$(grep -cE '"(control_id|id|control)"\s*:' "$soa" 2>/dev/null || echo 0)
        if [ "$ctrl_count" -ge 10 ]; then
            return 0
        fi
    fi

    echo "FAIL: SoA tiene solo $ctrl_count controles (se esperan al menos 10)" >&2
    return 1
}

# ── Reto 3: Política de cumplimiento con contenido sustantivo ───
reto3() {
    local pol="$LAB_DIR/politica_cumplimiento.md"
    if [ ! -f "$pol" ]; then
        echo "FAIL: politica_cumplimiento.md no existe en $LAB_DIR" >&2
        return 1
    fi

    # Must have substantial content (not just the template placeholders)
    local total_lines
    total_lines=$(wc -l < "$pol" 2>/dev/null | tr -d ' ')
    if [ "$total_lines" -lt 15 ]; then
        echo "FAIL: politica_cumplimiento.md tiene solo $total_lines líneas (muy poco contenido)" >&2
        return 1
    fi

    # Check that template placeholders have been replaced
    # The template has "[Nombre]" as placeholder — student should fill it in
    local placeholder_count
    placeholder_count=$(grep -c '\[Nombre\]' "$pol" 2>/dev/null || echo 0)
    local total_placeholders
    total_placeholders=$(grep -cE '\[.*\]' "$pol" 2>/dev/null || echo 0)

    # If still has the original template structure with unfilled placeholders, fail
    if [ "$placeholder_count" -ge 2 ]; then
        echo "FAIL: politica_cumplimiento.md aún tiene placeholders sin completar ([Nombre])" >&2
        return 1
    fi

    # Must reference ISO 27001 or NIST CSF
    if ! grep -qiE 'ISO.?27001|NIST.?CSF|ISMS|cumplimiento' "$pol" 2>/dev/null; then
        echo "FAIL: politica_cumplimiento.md no referencia ISO 27001 ni NIST CSF" >&2
        return 1
    fi

    # Must have at least 3 sections (## headings)
    local sections
    sections=$(grep -c '^##' "$pol" 2>/dev/null || echo 0)
    if [ "$sections" -lt 3 ]; then
        echo "FAIL: politica_cumplimiento.md solo tiene $sections secciones (se esperan al menos 3)" >&2
        return 1
    fi

    return 0
}

# ── Reto 4: Matriz de severidad con al menos 4 niveles ──────────
reto4() {
    local matrix="$LAB_DIR/severidad_matrix.csv"
    if [ ! -f "$matrix" ]; then
        echo "FAIL: severidad_matrix.csv no existe en $LAB_DIR" >&2
        return 1
    fi

    # The setup template has exactly 4 lines (header + 3 rows: Baja/Media/Alta).
    # Student must add at least 1 more level, so file must have > 4 lines.
    local total_lines
    total_lines=$(wc -l < "$matrix" 2>/dev/null | tr -d ' ')
    if [ "$total_lines" -le 4 ]; then
        echo "FAIL: severidad_matrix.csv tiene $total_lines líneas (el template tiene 4, se esperan más)" >&2
        return 1
    fi

    # Count distinct severity levels in first column (excluding header)
    local level_count
    level_count=$(tail -n +2 "$matrix" 2>/dev/null | cut -d',' -f1 | sort -u | wc -l | tr -d ' ')

    if [ "$level_count" -ge 4 ]; then
        return 0
    fi

    echo "FAIL: severidad_matrix.csv tiene solo $level_count niveles distintos (se esperan al menos 4)" >&2
    return 1
}

# ── Reto 5: Controls check script funcional ─────────────────────
reto5() {
    local script="$LAB_DIR/controls_check.sh"
    if [ ! -f "$script" ]; then
        echo "FAIL: controls_check.sh no existe en $LAB_DIR" >&2
        return 1
    fi

    # The setup template is exactly 5 lines (shebang + 2 comments + 2 echo).
    # Student must expand it significantly.
    local total_lines
    total_lines=$(wc -l < "$script" 2>/dev/null | tr -d ' ')
    if [ "$total_lines" -le 5 ]; then
        echo "FAIL: controls_check.sh tiene solo $total_lines líneas (el template tiene 5, se esperan más)" >&2
        return 1
    fi

    # Must contain real logic — conditionals, loops, or case statements
    # (not just echo/print statements)
    local has_conditionals=0
    if grep -qE '^\s*(if|for|while|case)\s' "$script" 2>/dev/null; then
        has_conditionals=1
    fi
    # Also check for test brackets or [[ ]]
    if grep -qE '\[\[?\s' "$script" 2>/dev/null; then
        has_conditionals=1
    fi

    if [ "$has_conditionals" -eq 0 ]; then
        echo "FAIL: controls_check.sh no contiene lógica condicional (if/for/while/case)" >&2
        return 1
    fi

    # Should reference control IDs or compliance concepts
    if ! grep -qiE 'A\.[0-9]|control|cumplimiento|ISO.?27001|Annex|annex' "$script" 2>/dev/null; then
        echo "FAIL: controls_check.sh no referencia controles ISO 27001" >&2
        return 1
    fi

    # Must be executable
    if [ ! -x "$script" ]; then
        echo "FAIL: controls_check.sh no tiene permisos de ejecución" >&2
        return 1
    fi

    return 0
}

validators=(reto1 reto2 reto3 reto4 reto5)
challenge_names=(
    "Risk Register con al menos 5 riesgos"
    "SoA JSON válido con 10+ controles"
    "Política de cumplimiento sustantiva"
    "Matriz de severidad con 4+ niveles"
    "Controls check script funcional"
)

ICONOS=("📋" "📄" "📜" "📊" "🔍")

reto1_info() {
    separador
    echo -e "${CYAN}Reto 1: Risk Register CSV — Registro de Riesgos${NC}"
    echo ""
    echo "Completa risk_register.csv con al menos 5 riesgos identificados."
    echo "Cada riesgo debe tener: ID, título, probabilidad, impacto y propietario."
    echo ""
    echo "Formato esperado:"
    echo "  risk_id,title,likelihood,impact,owner"
    echo "  RISK-001,Riesgo específico,Alta,Alta,Responsable"
    echo ""
    echo "Comandos útiles:"
    echo "  nano ~/laboratorio/governance/risk_register.csv"
    echo "  cat ~/laboratorio/governance/risk_register.csv"
    separador
}

reto2_info() {
    separador
    echo -e "${CYAN}Reto 2: Statement of Applicability JSON${NC}"
    echo ""
    echo "Completa statement_of_applicability.json con al menos 10 controles"
    echo "ISO 27001 mapeados (aplicables o no aplicables con justificación)."
    echo ""
    echo "Estructura esperada:"
    echo '  { "applicable_controls": ['
    echo '      {"id": "A.5.1", "control": "...", "applicable": true, "justification": "..."}'
    echo '    ] }'
    echo ""
    echo "Comandos útiles:"
    echo "  nano ~/laboratorio/governance/statement_of_applicability.json"
    echo "  python3 -c \"import json; json.load(open('statement_of_applicability.json'))\""
    separador
}

reto3_info() {
    separador
    echo -e "${CYAN}Reto 3: Política de Cumplimiento${NC}"
    echo ""
    echo "Completa politica_cumplimiento.md con una política de cumplimiento"
    echo "que incluya: alcance, referencias, responsabilidades, objetivos."
    echo ""
    echo "Requisitos:"
    echo "  - Al menos 3 secciones (##)"
    echo "  - Referenciar ISO 27001 y/o NIST CSF 2.0"
    echo "  - Reemplazar los placeholders [Nombre] con información real"
    echo ""
    echo "Comandos útiles:"
    echo "  nano ~/laboratorio/governance/politica_cumplimiento.md"
    separador
}

reto4_info() {
    separador
    echo -e "${CYAN}Reto 4: Matriz de Severidad${NC}"
    echo ""
    echo "Completa severidad_matrix.csv con al menos 4 niveles de severidad."
    echo "Define la relación entre probabilidad, impacto y nivel de riesgo."
    echo ""
    echo "Niveles esperados (ejemplo):"
    echo "  Baja,Baja,Baja,Acceptable"
    echo "  Media,Media,Media,Tolerable"
    echo "  Alta,Alta,Alta,Intolerable"
    echo "  Crítica,Crítica,Crítica,Intolerable"
    echo ""
    echo "Comandos útiles:"
    echo "  nano ~/laboratorio/governance/severidad_matrix.csv"
    separador
}

reto5_info() {
    separador
    echo -e "${CYAN}Reto 5: Controls Compliance Check${NC}"
    echo ""
    echo "Implementa controls_check.sh para verificar el cumplimiento"
    echo "de controles ISO 27001. El script debe:"
    echo "  - Tener lógica real (condiciones, grep, etc.)"
    echo "  - Referenciar controles ISO 27001 (A.5.x, A.6.x, etc.)"
    echo "  - Ser ejecutable (chmod +x)"
    echo ""
    echo "Comandos útiles:"
    echo "  nano ~/laboratorio/governance/controls_check.sh"
    echo "  chmod +x ~/laboratorio/governance/controls_check.sh"
    echo "  ./controls_check.sh"
    separador
}

# ── Standalone execution mode ─────────────────────────────────────
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  iii-compliance-iso27001: Cumplimiento ISO 27001 / NIST CSF 2.0 — Retos"
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
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  iii-compliance-iso27001 Results: $PASSED/$TOTAL_RETOS passed, $FAILED failed"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    [ "$FAILED" -eq 0 ]
fi
