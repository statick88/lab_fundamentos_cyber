#!/bin/bash
# Unit: i-risk-assessment — Evaluación de Riesgos con matriz ISO 31000 (Lab 2)
# Setup: genera escenario PyME y plantilla de análisis

set -e
# Support both container (/shared) and local (relative) paths
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

mkdir -p "$HOME/laboratorio/risk-assessment"
cd "$HOME/laboratorio/risk-assessment"

# ============================================================
# Escenario: PyME con 5 activos críticos
# ============================================================
cat > escenario.json << 'JSON_EOF'
{
  "empresa": "PyME Tecnológica 'DataGuard'",
  "industria": "Servicios Financieros",
  "activos": [
    {
      "id": "A1",
      "nombre": "Servidor de Base de Datos",
      "tipo": "información",
      "criticidad": "alta",
      "valor_economico": 50000,
      "amenazas": [
        {"nombre": "Inyección SQL", "probabilidad": 3, "impacto": 5, "controles": ["WAF", "consultas parametrizadas"]},
        {"nombre": "Fuga de datos por insider", "probabilidad": 2, "impacto": 5, "controles": ["RBAC", "auditoría"]}
      ]
    },
    {
      "id": "A2",
      "nombre": "Servidor Web (nginx)",
      "tipo": "software",
      "criticidad": "media",
      "valor_economico": 10000,
      "amenazas": [
        {"nombre": "Ataque DDoS", "probabilidad": 4, "impacto": 3, "controles": ["CDN", "rate limiting"]},
        {"nombre": "Exploit de vulnerabilidad", "probabilidad": 2, "impacto": 4, "controles": ["actualizaciones automáticas"]}
      ]
    },
    {
      "id": "A3",
      "nombre": "Infraestructura de Red (firewall/switch)",
      "tipo": "hardware",
      "criticidad": "alta",
      "valor_economico": 30000,
      "amenazas": [
        {"nombre": "Configuración errónea del firewall", "probabilidad": 3, "impacto": 4, "controles": ["revisión de reglas", "documentación"]},
        {"nombre": "Ataque de saturación de red", "probabilidad": 2, "impacto": 5, "controles": ["segmentación", "QoS"]}
      ]
    },
    {
      "id": "A4",
      "nombre": "Equipo de Desarrollo (laptop)",
      "tipo": "hardware",
      "criticidad": "baja",
      "valor_economico": 2000,
      "amenazas": [
        {"nombre": "Phishing", "probabilidad": 5, "impacto": 2, "controles": ["MFA", "capacitación"]},
        {"nombre": "Robo físico", "probabilidad": 2, "impacto": 3, "controles": ["seguridad física", "cifrado"]}
      ]
    },
    {
      "id": "A5",
      "nombre": "Plan de Recuperación ante Desastres (DRP)",
      "tipo": "información",
      "criticidad": "alta",
      "valor_economico": 15000,
      "amenazas": [
        {"nombre": "Corrupción de respaldos", "probabilidad": 2, "impacto": 5, "controles": ["3-2-1 backup", "verificación periódica"]},
        {"nombre": "Ransomware", "probabilidad": 3, "impacto": 5, "controles": ["aislamiento", "respaldos inmutables"]}
      ]
    }
  ]
}
JSON_EOF

# ============================================================
# Plantilla de análisis
# ============================================================
cat > plantilla-analisis.md << 'TEMPLATE_EOF'
# Análisis de Riesgos — PyME DataGuard (ISO 31000)

## Matriz de Probabilidad × Impacto

| Amenaza | Probabilidad (1-5) | Impacto (1-5) | Riesgo Inherente | Controles Existentes | Riesgo Residual | Tratamiento |
|---------|:---:|:---:|:---:|---|:---:|---|

## Clasificación por nivel de riesgo

| Nivel | Rango | Amenazas |
|-------|-------|----------|
| BAJO | 1-4 | |
| MEDIO | 5-9 | |
| ALTO | 10-15 | |
| CRÍTICO | 16-25 | |

## Tratamientos propuestos

| Actividad | Tratamiento | Justificación |
|-----------|-------------|---------------|

## Justificación económica

Para cada tratamiento, calcular: costo del control vs. reducción de riesgo.
TEMPLATE_EOF

echo -e "${VERDE}✅ Escenario y plantilla generados en $HOME/laboratorio/risk-assessment/${RESET}"
echo ""
echo -e "${CYAN}Archivos:${RESET}"
echo "  escenario.json          — 5 activos, 10 amenazas"
echo "  plantilla-analisis.md   — Plantilla para completar"
echo ""
echo -e "${AMARILLO}Próximo paso: analiza cada activo y ejecuta ./test.sh${RESET}"
