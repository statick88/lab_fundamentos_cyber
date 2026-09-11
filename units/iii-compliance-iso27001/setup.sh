#!/bin/bash
# Unit III-compliance-iso27001: Cumplimiento ISO 27001 / NIST CSF 2.0 — setup.sh

set -e
# Support both container (/shared) and local (relative) paths
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
fi

UNIT_NAME="unit-III-compliance"
UNIT_NUM=0  # sin número romano en el manifest — se mantiene como III-compliance
export TOTAL_RETOS=5

banner_unidad 0 "Cumplimiento ISO 27001 / NIST CSF 2.0"

echo -e "${CYAN}Esta unidad cubre: ISO 27001, NIST CSF 2.0, ISMS, Statement of Applicability.${RESET}"
echo -e "${AMARILLO}Completarás 5 retos prácticos.${RESET}\n"

mkdir -p "$HOME/laboratorio/governance"
cd "$HOME/laboratorio/governance"

# Reto 1: Risk Register CSV (scaffolding)
cat > risk_register.csv << 'CSV'
# Risk Register — Ejemplo
risk_id,title,likelihood,impact,owner
RISK-001,Acceso no autorizado a datos sensibles,Alta,Alta,Equipo de Seguridad
CSV

# Reto 2: Statement of Applicability JSON (scaffolding)
cat > statement_of_applicability.json << 'JSON'
{
  "standard": "ISO 27001",
  "applicable_controls": [],
  "non_applicable_controls": []
}
JSON

# Reto 3: Policy Compliance MD (scaffolding)
cat > politica_cumplimiento.md << 'MD'
# Política de Cumplimiento

## 1. Alcance
Define el alcance del ISMS para la organización.

## 2. Referencias
- ISO/IEC 27001:2022
- NIST CSF 2.0

## 3. Responsabilidades
- Responsable del ISMS: [Nombre]
- Auditor interno: [Nombre]
MD

# Reto 4: Severity Matrix (scaffolding)
cat > severidad_matrix.csv << 'SEV'
severity,likelihood,impact,risk_level
Baja,Baja,Baja,Acceptable
Media,Media,Media,Tolerable
Alta,Alta,Alta,Intolerable
SEV

# Reto 5: Controls Compliance Check (scaffolding)
cat > controls_check.sh << 'CHECK'
#!/bin/bash
# Reto 5: Verificar cumplimiento de controles — completa la implementación
echo " Este script debe verificar controles de seguridad ISO 27001"
echo " Usa: declaraciones de cumplimiento y evidencia"
CHECK
chmod +x controls_check.sh

exito "Entorno de Unit III-Compliance preparado con 5 retos"
echo -e "${AMARILLO}Escribe ${CYAN}'manual'${AMARILLO} para ver la guía o ${CYAN}'evaluar'${AMARILLO} para evaluar.${RESET}"
