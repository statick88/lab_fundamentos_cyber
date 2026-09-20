#!/bin/bash
# Unit: i-risk-assessment — Evaluación de Riesgos con matriz ISO 31000 (Lab 2)
# Setup creates reference fixtures and a non-submittable template only.

set -e
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
fi

UNIT_NAME="unit-i-risk-assessment"
UNIT_NUM=2
export TOTAL_RETOS=10

banner_unidad "$UNIT_NUM" "Evaluación de Riesgos con matriz ISO 31000"
echo -e "${CYAN}Esta unidad cubre: gestión de riesgos ISO 31000, matriz probabilidad/impacto, tratamientos.${RESET}"
echo -e "${AMARILLO}Completarás 10 retos CORE sobre evaluación de riesgos.${RESET}\n"

LAB_DIR="$HOME/laboratorio/risk-assessment"
mkdir -p "$LAB_DIR/fixtures"
cd "$LAB_DIR"

cat > fixtures/escenario.json << 'JSON_EOF'
{
  "empresa": "PyME Tecnológica 'DataGuard'",
  "industria": "Servicios Financieros",
  "activos": [
    {"id":"A1","nombre":"Servidor de Base de Datos","tipo":"información","amenazas":["Inyección SQL","Fuga de datos por insider"]},
    {"id":"A2","nombre":"Servidor Web (nginx)","tipo":"software","amenazas":["Ataque DDoS","Exploit de vulnerabilidad"]},
    {"id":"A3","nombre":"Infraestructura de Red","tipo":"hardware","amenazas":["Configuración errónea","Saturación de red"]},
    {"id":"A4","nombre":"Equipo de Desarrollo","tipo":"hardware","amenazas":["Phishing","Robo físico"]},
    {"id":"A5","nombre":"Plan de Recuperación ante Desastres","tipo":"información","amenazas":["Corrupción de respaldos","Ransomware"]}
  ]
}
JSON_EOF

cat > plantilla-analisis.template.md << 'TEMPLATE_EOF'
# NON-SUBMITTED EXAMPLE — Do not submit this template

Use `fixtures/escenario.json` as reference. Create the required student deliverables in this directory:
`scenario_summary.md`, `risk_inventory.md`, `risk_matrix.md`, `risk_levels.md`,
`treatment_plan.md`, `residual_risk.md`, `economic_justification.md`, and
`seguimiento.md` or `followup_plan.md`.

## Example matrix format (leave blank; this file is never evaluated)
| Threat | Probability | Impact | Inherent | Controls | Residual | Treatment |
|---|---|---|---|---|---|---|
| | | | | | | |
TEMPLATE_EOF

echo -e "${VERDE}✅ Referencias creadas en $LAB_DIR/fixtures/${RESET}"
echo "  fixtures/escenario.json            — escenario de referencia (no evaluado)"
echo "  plantilla-analisis.template.md     — ejemplo no entregable (no evaluado)"
echo ""
echo -e "${AMARILLO}Próximo paso: crea tus entregables explícitos y ejecuta ./test.sh${RESET}"
