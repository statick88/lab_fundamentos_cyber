#!/bin/bash
# Unit: i-asset-classification — Clasificación de Activos / CSF 2.0 (Lab 3)
# Setup: genera escenario con 5 activos, plantilla de clasificación, CSV y mapeo CSF

set -e
# Support both container (/shared) and local (relative) paths
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

mkdir -p "$HOME/laboratorio/asset-classification/data"
cd "$HOME/laboratorio/asset-classification"

# ============================================================
# Escenario: 5 activos con tipos hardware/software/data/supplier-service
# ============================================================
cat > escenario.json << 'JSON_EOF'
{
  "organizacion": "Empresa de Servicios Financieros 'FinSecure'",
  "sector": "Financiero",
  "activos": [
    {
      "id": "A1",
      "nombre": "Servidor de Base de Datos Clientes",
      "tipo": "hardware",
      "clasificacion": "restringido",
      "confidencialidad": 5,
      "integridad": 5,
      "disponibilidad": 4
    },
    {
      "id": "A2",
      "nombre": "Aplicación Web de Banca Online",
      "tipo": "software",
      "clasificacion": "confidencial",
      "confidencialidad": 4,
      "integridad": 5,
      "disponibilidad": 5
    },
    {
      "id": "A3",
      "nombre": "Registros de Transacciones Financieras",
      "tipo": "data",
      "clasificacion": "restringido",
      "confidencialidad": 5,
      "integridad": 5,
      "disponibilidad": 3
    },
    {
      "id": "A4",
      "nombre": "Servicio Cloud de Proveedor Externo (AWS)",
      "tipo": "supplier-service",
      "clasificacion": "interno",
      "confidencialidad": 3,
      "integridad": 4,
      "disponibilidad": 4
    },
    {
      "id": "A5",
      "nombre": "Documentación de Políticas de Seguridad",
      "tipo": "data",
      "clasificacion": "interno",
      "confidencialidad": 2,
      "integridad": 3,
      "disponibilidad": 2
    }
  ]
}
JSON_EOF

# ============================================================
# CSV: Registro de activos (name,type,classification,confidencialidad,integridad,disponibilidad)
# ============================================================
cat > data/asset_registry.csv << 'CSV_EOF'
name,type,classification,confidencialidad,integridad,disponibilidad
Servidor de Base de Datos Clientes,hardware,restringido,5,5,4
Aplicación Web de Banca Online,software,confidencial,4,5,5
Registros de Transacciones Financieras,data,restringido,5,5,3
Servicio Cloud de Proveedor Externo (AWS),supplier-service,interno,3,4,4
Documentación de Políticas de Seguridad,data,interno,2,3,2
CSV_EOF

# ============================================================
# Plantilla de clasificación (worksheet para estudiantes)
# ============================================================
cat > plantilla-clasificacion.md << 'TEMPLATE_EOF'
# Plantilla de Clasificación de Activos — FinSecure (CSF 2.0)

## Inventario y Clasificación de Activos (ID.AM-01)

| Activo | Tipo | Clasificación | Confidencialidad (1-5) | Integridad (1-5) | Disponibilidad (1-5) | Justificación |
|--------|------|---------------|:---------------------:|:----------------:|:---------------------:|---------------|
| A1     |      |               |                       |                  |                       |               |
| A2     |      |               |                       |                  |                       |               |
| A3     |      |               |                       |                  |                       |               |
| A4     |      |               |                       |                  |                       |               |
| A5     |      |               |                       |                  |                       |               |

**Escalas de clasificación:**
- **público**: Información de acceso general
- **interno**: Uso interno de la organización
- **confidencial**: Información sensible, acceso restringido por necesidad
- **restringido**: Información altamente sensible, acceso muy limitado

**Escalas CIA (1-5):**
- 1 = Muy bajo | 2 = Bajo | 3 = Medio | 4 = Alto | 5 = Muy alto

## Priorización por Criticidad (ID.AM-05)

| Activo | Prioridad (1-5) | Criterio de priorización |
|--------|:---------------:|--------------------------|
| A1     |                 |                          |
| A2     |                 |                          |
| A3     |                 |                          |
| A4     |                 |                          |
| A5     |                 |                          |

## Mapeo CSF 2.0 (ID.AM-07)

| Subcategoría CSF | Descripción | Activos relacionados |
|------------------|-------------|---------------------|
| ID.AM-01         | Inventario de activos de hardware, software, datos y servicios | A1, A2, A3, A4, A5 |
| ID.AM-05         | Priorización de activos según criticidad y clasificación | A1, A2, A3, A4, A5 |
| ID.AM-07         | Mapeo de activos a roles, responsabilidades y dependencias | A1, A2, A3, A4, A5 |

## Entregables del Estudiante

1. Completar la tabla de inventario y clasificación
2. Asignar prioridad de criticidad a cada activo
3. Justificar cada clasificación con criterios CIA
4. Identificar dependencias entre activos (ID.AM-07)
TEMPLATE_EOF

# ============================================================
# CSF Mapping Reference
# ============================================================
cat > data/csf_mapping.md << 'CSF_EOF'
# Mapeo NIST CSF 2.0 — ID.AM (Asset Management)

## Subcategorías Cubiertas en esta Unidad

### ID.AM-01: Inventario de Activos
> **Los inventarios de hardware, software, datos y servicios de la organización se gestionan.**

Esta subcategoría establece que la organización debe mantener un inventario completo y actualizado de todos los activos:
- **Hardware**: Servidores, estaciones de trabajo, dispositivos de red, IoT
- **Software**: Aplicaciones, sistemas operativos, firmware, contenedores
- **Datos**: Bases de datos, archivos, flujos de datos, backups
- **Servicios**: Servicios cloud, SaaS, proveedores externos, APIs

En este laboratorio, el archivo `escenario.json` y `data/asset_registry.csv` representan el inventario de 5 activos que cubren las 4 categorías.

### ID.AM-05: Priorización de Activos
> **Los activos se priorizan según su clasificación, criticidad y valor para la organización.**

La priorización permite enfocar los recursos de protección en los activos más críticos:
- Clasificación de confidencialidad (público/interno/confidencial/restringido)
- Ratings CIA (Confidencialidad, Integridad, Disponibilidad) en escala 1-5
- Valor de negocio y criticidad operacional
- Impacto regulatorio y contractual

En este laboratorio, la plantilla incluye una tabla de priorización donde el estudiante asigna prioridad basada en CIA y clasificación.

### ID.AM-07: Mapeo de Activos a Roles y Dependencias
> **Se establece un mapa de activos que muestra roles, responsabilidades y dependencias.**

El mapeo de dependencias es crítico para:
- Análisis de impacto de incidentes (blast radius)
- Planificación de continuidad de negocio
- Gestión de cambios y configuración
- Respuesta a incidentes y recuperación

En este laboratorio, la plantilla incluye una sección para documentar dependencias entre los 5 activos.

## Referencias

- **NIST CSF 2.0** — *Cybersecurity Framework Version 2.0* (Febrero 2024)
- **ID.AM** — *Asset Management* (Gestión de Activos)
- **CIA Triad** — *Confidentiality, Integrity, Availability* (Confidencialidad, Integridad, Disponibilidad)

## Archivos Relacionados

- `escenario.json` — Escenario completo con 5 activos y ratings CIA
- `data/asset_registry.csv` — Registro CSV para análisis en hojas de cálculo
- `plantilla-clasificacion.md` — Worksheet para completar por el estudiante
CSF_EOF

echo -e "${VERDE}✅ Escenario y artefactos generados en $HOME/laboratorio/asset-classification/${RESET}"
echo ""
echo -e "${CYAN}Archivos:${RESET}"
echo "  escenario.json            — 5 activos (A1–A5) con tipos, clasificación y CIA"
echo "  data/asset_registry.csv   — 5 filas × 6 columnas (name,type,classification,CIA)"
echo "  data/csf_mapping.md       — Referencia ID.AM-01, ID.AM-05, ID.AM-07"
echo "  plantilla-clasificacion.md — Worksheet para completar"
echo ""
echo -e "${AMARILLO}Próximo paso: completa la plantilla y ejecuta ./test.sh${RESET}"