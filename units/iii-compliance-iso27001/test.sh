#!/bin/bash
# Unit iii-compliance-iso27001: Cumplimiento ISO 27001 / NIST CSF 2.0 — test.sh
# Validators accept only explicit student deliverables in the lab directory.

# Dual-path sourcing
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
fi

# Keep receipt routing aligned with the manifest canonical route.
UNIT_NAME="unit-III-compliance"
TOTAL_RETOS=5

LAB_DIR="$HOME/laboratorio/governance"
PLACEHOLDER_RE='\[.*\]|<[^>]+>|\b(TODO|TBD|PLACEHOLDER|REPLACE_ME|XXX)\b'

require_python3() {
    if ! command -v python3 >/dev/null 2>&1; then
        echo "FAIL: python3 es necesario para validar este reto" >&2
        return 1
    fi
}

# ── Reto 1: Risk Register CSV with complete, distinct risks ─────────
reto1() {
    local rr="$LAB_DIR/risk_register.csv"
    [ -f "$rr" ] || { echo "FAIL: crea risk_register.csv en $LAB_DIR" >&2; return 1; }
    require_python3 || return 1

    python3 - "$rr" <<'PY'
import csv, re, sys
path = sys.argv[1]
required = ("risk_id", "asset", "threat", "impact", "likelihood", "treatment", "owner")
placeholder = re.compile(r"\[.*?\]|<[^>]+>|\b(?:TODO|TBD|PLACEHOLDER|REPLACE_ME|XXX)\b", re.I)
try:
    with open(path, newline="", encoding="utf-8") as fh:
        rows = list(csv.DictReader(line for line in fh if not line.lstrip().startswith("#")))
except (OSError, csv.Error) as exc:
    raise SystemExit(f"FAIL: no se pudo leer risk_register.csv: {exc}")
if not rows or not rows[0] or any(column not in rows[0] for column in required):
    raise SystemExit("FAIL: el encabezado debe incluir: " + ", ".join(required))
ids = set()
for number, row in enumerate(rows, start=2):
    values = {field: (row.get(field) or "").strip() for field in required}
    missing = [field for field, value in values.items() if not value]
    if missing:
        raise SystemExit(f"FAIL: fila {number} tiene campos vacíos: {', '.join(missing)}")
    if any(placeholder.search(value) for value in values.values()):
        raise SystemExit(f"FAIL: fila {number} conserva placeholders")
    risk_id = values["risk_id"]
    if not re.fullmatch(r"RISK-[0-9]{3,}", risk_id, re.I):
        raise SystemExit(f"FAIL: fila {number} tiene un risk_id inválido: {risk_id}")
    normalized = risk_id.upper()
    if normalized in ids:
        raise SystemExit(f"FAIL: risk_id duplicado: {risk_id}")
    ids.add(normalized)
if len(ids) < 5:
    raise SystemExit(f"FAIL: se requieren 5 riesgos únicos y completos; hay {len(ids)}")
PY
}

# ── Reto 2: SoA with validated control records ──────────────────────
reto2() {
    local soa="$LAB_DIR/soa.json"
    [ -f "$soa" ] || { echo "FAIL: crea soa.json en $LAB_DIR" >&2; return 1; }
    require_python3 || return 1

    python3 - "$soa" <<'PY'
import json, re, sys
path = sys.argv[1]
placeholder = re.compile(r"\[.*?\]|<[^>]+>|\b(?:TODO|TBD|PLACEHOLDER|REPLACE_ME|XXX)\b", re.I)
control_id = re.compile(r"^(?:A\.[5-8](?:\.\d+){1,2}|(?:AC|AT|AU|CA|CM|CP|IA|IR|MA|MP|PE|PL|PM|PS|RA|SA|SC|SI)-\d+(?:\.\d+)?)$", re.I)
try:
    with open(path, encoding="utf-8") as fh:
        document = json.load(fh)
except (OSError, json.JSONDecodeError) as exc:
    raise SystemExit(f"FAIL: soa.json debe contener JSON válido: {exc}")
if isinstance(document, list):
    controls = document
elif isinstance(document, dict):
    controls = next((document[key] for key in ("controls", "applicable_controls", "statement_of_applicability") if isinstance(document.get(key), list)), None)
else:
    controls = None
if not isinstance(controls, list):
    raise SystemExit("FAIL: soa.json debe ser un array de controles o un objeto con un array controls")
valid = 0
for index, control in enumerate(controls, start=1):
    if not isinstance(control, dict):
        raise SystemExit(f"FAIL: control {index} debe ser un objeto, no un valor superficial")
    identifier = str(control.get("id") or control.get("control_id") or control.get("control") or "").strip()
    if not control_id.fullmatch(identifier):
        raise SystemExit(f"FAIL: control {index} no tiene un ID ISO/NIST válido: {identifier or '(vacío)'}")
    applicable = control.get("applicable")
    if not isinstance(applicable, (bool, str)) or isinstance(applicable, str) and not applicable.strip():
        raise SystemExit(f"FAIL: control {index} requiere applicable booleano o texto no vacío")
    for field in ("justification", "evidence", "status"):
        value = control.get(field)
        if not isinstance(value, str) or not value.strip() or placeholder.search(value):
            raise SystemExit(f"FAIL: control {index} requiere {field} no vacío y sin placeholders")
    valid += 1
if valid < 10:
    raise SystemExit(f"FAIL: se requieren 10 controles completos; hay {valid}")
PY
}

# ── Reto 3: Substantive security policy ─────────────────────────────
reto3() {
    local policy="$LAB_DIR/security_policy.md"
    [ -f "$policy" ] || { echo "FAIL: crea security_policy.md en $LAB_DIR" >&2; return 1; }

    if grep -qiE "$PLACEHOLDER_RE" "$policy"; then
        echo "FAIL: security_policy.md conserva placeholders" >&2
        return 1
    fi
    if [ "$(wc -c < "$policy" | tr -d ' ')" -lt 800 ] || [ "$(grep -cvE '^\s*$|^\s*#' "$policy")" -lt 12 ]; then
        echo "FAIL: security_policy.md necesita contenido sustantivo (800 caracteres y 12 líneas de contenido)" >&2
        return 1
    fi
    if ! grep -qiE 'ISO[ /-]?(IEC )?27001|NIST[ -]?CSF' "$policy"; then
        echo "FAIL: security_policy.md debe referenciar ISO 27001 o NIST CSF" >&2
        return 1
    fi

    local section
    for section in \
        '^##+ .*\b(scope|alcance)\b' \
        '^##+ .*(roles?|responsibilit)' \
        '^##+ .*(access.?control|control de acceso)' \
        '^##+ .*(incident|incidente|continuity|continuidad)' \
        '^##+ .*(review|revisi.n)'; do
        if ! grep -qiE "$section" "$policy"; then
            echo "FAIL: security_policy.md no incluye una sección obligatoria: $section" >&2
            return 1
        fi
    done
}

# ── Reto 4: Risk matrix with explicit mapped criteria ──────────────
reto4() {
    local matrix=""
    if [ -f "$LAB_DIR/risk_matrix.csv" ]; then
        matrix="$LAB_DIR/risk_matrix.csv"
    elif [ -f "$LAB_DIR/risk_matrix.md" ]; then
        matrix="$LAB_DIR/risk_matrix.md"
    else
        echo "FAIL: crea risk_matrix.csv o risk_matrix.md en $LAB_DIR" >&2
        return 1
    fi
    require_python3 || return 1

    python3 - "$matrix" <<'PY'
import csv, pathlib, re, sys
path = pathlib.Path(sys.argv[1])
placeholder = re.compile(r"\[.*?\]|<[^>]+>|\b(?:TODO|TBD|PLACEHOLDER|REPLACE_ME|XXX)\b", re.I)
recognized = re.compile(r"^(?:very[ _-]?low|low|medium|moderate|high|very[ _-]?high|critical|muy[ _-]?baj[ao]|baj[ao]|medi[ao]|moderad[ao]|alt[ao]|muy[ _-]?alt[ao]|cr[ií]tic[ao])$", re.I)
def normalized(name):
    return re.sub(r"[^a-z]", "", name.lower())
def field(headers, names):
    return next((header for header in headers if normalized(header) in names), None)
try:
    if path.suffix == ".csv":
        with path.open(newline="", encoding="utf-8") as fh:
            rows = list(csv.DictReader(fh))
    else:
        lines = [line.strip() for line in path.read_text(encoding="utf-8").splitlines() if line.strip().startswith("|")]
        if len(lines) < 3:
            raise ValueError("la tabla Markdown necesita encabezado, separador y filas")
        headers = [cell.strip() for cell in lines[0].strip("|").split("|")]
        rows = [dict(zip(headers, [cell.strip() for cell in line.strip("|").split("|")])) for line in lines[2:]]
except (OSError, csv.Error, ValueError) as exc:
    raise SystemExit(f"FAIL: no se pudo leer la matriz: {exc}")
if not rows or not rows[0]:
    raise SystemExit("FAIL: la matriz no contiene mapeos")
headers = list(rows[0])
probability = field(headers, {"probability", "probabilidad", "likelihood"})
impact = field(headers, {"impact", "impacto"})
severity = field(headers, {"severity", "severidad"})
level = field(headers, {"level", "risklevel", "nivel", "nivelderiesgo"})
if not all((probability, impact, severity, level)):
    raise SystemExit("FAIL: la matriz requiere criterios explícitos de probability, impact, severity y level")
levels = set()
for number, row in enumerate(rows, start=2):
    values = [str(row.get(key) or "").strip() for key in (probability, impact, severity, level)]
    if any(not value for value in values) or any(placeholder.search(value) for value in values):
        raise SystemExit(f"FAIL: el mapeo {number} tiene campos vacíos o placeholders")
    if not all(recognized.fullmatch(value) for value in values):
        raise SystemExit(f"FAIL: el mapeo {number} usa categorías no explícitas o arbitrarias")
    levels.add(tuple(value.casefold() for value in values))
if len(levels) < 4:
    raise SystemExit(f"FAIL: se requieren al menos 4 mapeos explícitos; hay {len(levels)}")
PY
}

# ── Reto 5: Student-written controls check and evidence ────────────
reto5() {
    local script="$LAB_DIR/controls_check.sh"
    local results="$LAB_DIR/controls_check_results.txt"
    [ -f "$script" ] || { echo "FAIL: crea controls_check.sh en $LAB_DIR" >&2; return 1; }
    [ -x "$script" ] || { echo "FAIL: controls_check.sh debe ser ejecutable" >&2; return 1; }
    bash -n "$script" 2>/dev/null || { echo "FAIL: controls_check.sh tiene errores de sintaxis" >&2; return 1; }

    if ! grep -qE '\b(if|case|for|while)\b|\[\[?[^]]+\]\]|\b(grep|test|find)\b' "$script"; then
        echo "FAIL: controls_check.sh no contiene comprobaciones reales" >&2
        return 1
    fi
    if [ "$(grep -Eo '(/[^[:space:]"'"'"']+|\$\{?LAB_DIR\}?/[^[:space:]"'"'"']+|fixtures/[^[:space:]"'"'"']+|[^[:space:]"'"'"']+\.(conf|cfg|ini|yaml|yml|json))' "$script" | sort -u | wc -l | tr -d ' ')" -lt 2 ]; then
        echo "FAIL: controls_check.sh debe comprobar al menos dos fixtures o rutas de configuración distintas" >&2
        return 1
    fi
    if [ ! -f "$results" ]; then
        echo "FAIL: ejecuta tu script y guarda controls_check_results.txt" >&2
        return 1
    fi
    if ! grep -qiE '^.*\bPASS\b' "$results" || ! grep -qiE '^.*\bFAIL\b' "$results"; then
        echo "FAIL: controls_check_results.txt debe registrar resultados PASS y FAIL" >&2
        return 1
    fi
}

validators=(reto1 reto2 reto3 reto4 reto5)
challenge_names=(
    "Risk Register completo con 5 riesgos únicos"
    "SoA JSON con 10 controles validados"
    "Política de seguridad sustantiva"
    "Matriz de riesgo con criterios y mapeos"
    "Controls check y resultados producidos por estudiante"
)

ICONOS=("📋" "📄" "📜" "📊" "🔍")

reto1_info() {
    separador
    echo -e "${CYAN}Reto 1: Risk Register CSV — Registro de Riesgos${NC}"
    echo "Crea risk_register.csv (no copies la plantilla) con 5 risk_id únicos RISK-001 o similares."
    echo "El encabezado obligatorio es: risk_id,asset,threat,impact,likelihood,treatment,owner."
    echo "Todos los campos deben ser específicos y no contener placeholders."
    separador
}

reto2_info() {
    separador
    echo -e "${CYAN}Reto 2: Statement of Applicability JSON${NC}"
    echo "Crea soa.json con un array controls de al menos 10 objetos completos."
    echo "Cada control requiere ID ISO/NIST, applicable (booleano o texto), justification, evidence y status."
    echo "Ejemplo de ID: A.5.1 o AC-2. Las plantillas de referencias/ no se aceptan."
    separador
}

reto3_info() {
    separador
    echo -e "${CYAN}Reto 3: Política de Seguridad${NC}"
    echo "Crea security_policy.md con secciones para alcance, roles/responsabilidades, control de acceso,"
    echo "gestión de incidentes o continuidad y revisión. Referencia ISO 27001 o NIST CSF."
    echo "La política debe tener al menos 800 caracteres, 12 líneas sustantivas y ningún placeholder."
    separador
}

reto4_info() {
    separador
    echo -e "${CYAN}Reto 4: Matriz de Riesgo${NC}"
    echo "Crea risk_matrix.csv o risk_matrix.md con probability/probabilidad, impact/impacto, severity/severidad y level/nivel."
    echo "Incluye al menos 4 mapeos con categorías explícitas (por ejemplo: Baja, Media, Alta, Crítica)."
    echo "No se aceptan valores arbitrarios de una primera columna sin criterios y mapeo completos."
    separador
}

reto5_info() {
    separador
    echo -e "${CYAN}Reto 5: Controls Compliance Check${NC}"
    echo "Implementa y ejecuta controls_check.sh; debe ser ejecutable, sintácticamente válido y tener lógica real."
    echo "Comprueba al menos dos fixtures que crees o rutas de configuración nombradas, y registra una prueba PASS y otra FAIL."
    echo "Guarda la salida producida por vos en controls_check_results.txt."
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
