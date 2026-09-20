#!/bin/bash
# Unit III-compliance-iso27001: Cumplimiento ISO 27001 / NIST CSF 2.0 — setup.sh

set -e
# Support both container (/shared) and local (relative) paths
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
fi

# Keep receipt routing aligned with the canonical manifest route.
UNIT_NAME="unit-III-compliance"
UNIT_NUM=0  # sin número romano en el manifest — se mantiene como III-compliance
export TOTAL_RETOS=5

banner_unidad 0 "Cumplimiento ISO 27001 / NIST CSF 2.0"

echo -e "${CYAN}Esta unidad cubre: ISO 27001, NIST CSF 2.0, ISMS, Statement of Applicability.${RESET}"
echo -e "${AMARILLO}Completarás 5 retos prácticos.${RESET}\n"

LAB_DIR="$HOME/laboratorio/governance"
REFERENCE_DIR="$LAB_DIR/referencias"
mkdir -p "$REFERENCE_DIR"
cd "$LAB_DIR"

# These are references only. Student deliverables must be created in $LAB_DIR,
# never copied unchanged from referencias/.
cat > "$REFERENCE_DIR/risk_register.template.csv" << 'CSV'
risk_id,asset,threat,impact,likelihood,treatment,owner
RISK-XXX,[asset],[threat],[impact],[likelihood],[treatment],[owner]
CSV

cat > "$REFERENCE_DIR/soa.template.json" << 'JSON'
{
  "controls": [
    {
      "id": "A.X.X",
      "applicable": "[true-or-false]",
      "justification": "[why this control applies]",
      "evidence": "[evidence location]",
      "status": "[implementation status]"
    }
  ]
}
JSON

cat > "$REFERENCE_DIR/security_policy.template.md" << 'MD'
# Security Policy Template

## Scope
[Define the ISMS scope.]

## Roles and responsibilities
[Assign accountable roles.]

## Access control
[Define access-control requirements.]

## Incident management and continuity
[Define incident and continuity requirements.]

## Review
[Define the policy review cycle.]
MD

cat > "$REFERENCE_DIR/risk_matrix.template.csv" << 'CSV'
probability,impact,severity,level
[probability], [impact], [severity], [level]
CSV

cat > "$REFERENCE_DIR/controls_check.template.sh" << 'CHECK'
#!/bin/bash
# Create your own controls_check.sh in the lab directory.
# It must check at least two student-supplied fixtures or named configuration paths.
# Record an intentional PASS and FAIL outcome in controls_check_results.txt.
CHECK

exito "Entorno de Unit III-Compliance preparado con 5 retos"
echo -e "${AMARILLO}Crea tus entregables en ${CYAN}$LAB_DIR${AMARILLO}; las plantillas en referencias/ no se evalúan.${RESET}"
echo -e "${AMARILLO}Escribe ${CYAN}'manual'${AMARILLO} para ver la guía o ${CYAN}'evaluar'${AMARILLO} para evaluar.${RESET}"
