#!/bin/bash
# Unit: i-asset-classification — Clasificación de Activos / CSF 2.0 (Lab 3)
# Setup creates reference fixtures and a non-submittable template only.

set -e
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
fi

UNIT_NAME="unit-I-asset"
UNIT_NUM=21
export TOTAL_RETOS=10

banner_unidad "$UNIT_NUM" "Clasificación de Activos / CSF 2.0"
echo -e "${CYAN}Esta unidad cubre: inventario de activos NIST CSF 2.0, clasificación CIA, mapeo ID.AM-01/05/07.${RESET}"
echo -e "${AMARILLO}Completarás 10 retos CORE sobre clasificación de activos.${RESET}\n"

LAB_DIR="$HOME/laboratorio/asset-classification"
mkdir -p "$LAB_DIR/fixtures"
cd "$LAB_DIR"

cat > fixtures/escenario.json << 'JSON_EOF'
{
  "organizacion": "Empresa de Servicios Financieros 'FinSecure'",
  "sector": "Financiero",
  "activos": [
    {"id":"A1","nombre":"Servidor de Base de Datos Clientes","tipo":"hardware","clasificacion":"restringido","confidencialidad":5,"integridad":5,"disponibilidad":4},
    {"id":"A2","nombre":"Aplicación Web de Banca Online","tipo":"software","clasificacion":"confidencial","confidencialidad":4,"integridad":5,"disponibilidad":5},
    {"id":"A3","nombre":"Registros de Transacciones Financieras","tipo":"data","clasificacion":"restringido","confidencialidad":5,"integridad":5,"disponibilidad":3},
    {"id":"A4","nombre":"Servicio Cloud de Proveedor Externo","tipo":"supplier-service","clasificacion":"interno","confidencialidad":3,"integridad":4,"disponibilidad":4},
    {"id":"A5","nombre":"Documentación de Políticas de Seguridad","tipo":"data","clasificacion":"interno","confidencialidad":2,"integridad":3,"disponibilidad":2}
  ]
}
JSON_EOF

cat > fixtures/asset_registry.csv << 'CSV_EOF'
id,name,type,classification,confidencialidad,integridad,disponibilidad
A1,Servidor de Base de Datos Clientes,hardware,restringido,5,5,4
A2,Aplicación Web de Banca Online,software,confidencial,4,5,5
A3,Registros de Transacciones Financieras,data,restringido,5,5,3
A4,Servicio Cloud de Proveedor Externo,supplier-service,interno,3,4,4
A5,Documentación de Políticas de Seguridad,data,interno,2,3,2
CSV_EOF

cat > fixtures/csf_mapping.md << 'CSF_EOF'
# Reference only — NIST CSF 2.0 ID.AM

- ID.AM-01: Manage inventories of hardware, software, data, and services.
- ID.AM-05: Prioritize assets based on classification, criticality, and business value.
- ID.AM-07: Map assets to roles, responsibilities, and dependencies.

This reference is not a student submission and is not evaluated directly.
CSF_EOF

cat > plantilla-clasificacion.template.md << 'TEMPLATE_EOF'
# NON-SUBMITTED EXAMPLE — Do not submit this template

Use `fixtures/escenario.json`, `fixtures/asset_registry.csv`, and
`fixtures/csf_mapping.md` only as reference. Create these student deliverables in
this directory: `scenario_summary.md`, `asset_inventory.csv` or
`asset_inventory.md`, `cia_ratings.md`, `csf_mapping_student.md`,
`asset_classification.md`, `asset_prioritization.md`, `asset_controls.md`, and
`final_report.md` or `resumen_final.md`.

## Blank example row (this file is never evaluated)
| Asset | Type | Classification | C | I | A | Justification |
|---|---|---|---|---|---|---|
| A1 | | | | | | |
TEMPLATE_EOF

echo -e "${VERDE}✅ Referencias creadas en $LAB_DIR/fixtures/${RESET}"
echo "  fixtures/escenario.json            — escenario de referencia (no evaluado)"
echo "  fixtures/asset_registry.csv        — registro de referencia (no evaluado)"
echo "  fixtures/csf_mapping.md            — referencia CSF (no evaluada)"
echo "  plantilla-clasificacion.template.md — ejemplo no entregable (no evaluado)"
echo ""
echo -e "${AMARILLO}Próximo paso: crea tus entregables explícitos y ejecuta ./test.sh${RESET}"
