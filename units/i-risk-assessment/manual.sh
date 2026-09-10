#!/bin/bash
# Unit: i-risk-assessment — Evaluación de Riesgos con matriz ISO 31000 (Lab 2)
# Manual interactivo del estudiante

source /shared/common.sh

UNIT_NAME="unit-i-risk-assessment"
banner_unidad 2 "Evaluación de Riesgos ISO 31000"

cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║  Lab 2 — Evaluación de Riesgos con matriz ISO 31000        ║
║  Módulo I: Introducción a la Ciberseguridad                 ║
╚══════════════════════════════════════════════════════════════╝

📚 CONCEPTOS CLAVE
═════════════════

  ISO 31000 — Gestión de Riesgos
  ─────────────────────────────────
  Familia de estándares internacionales que define un marco para la
  gestión de riesgos. No prescribe metodologías específicas, sino
  principios y directrices aplicables a cualquier organización.

  Riesgo inherente = Probabilidad × Impacto
  Riesgo residual  = Riesgo inherente − controles aplicados

  Tratamientos de riesgo (ISO 31000):
  ┌────────────┬─────────────────────────────────────┐
  │ ACEPTAR    │ Asumir el riesgo (cuando el costo    │
  │            │ del control supera el beneficio)     │
  ├────────────┼─────────────────────────────────────┤
  │ MITIGAR    │ Reducir probabilidad o impacto       │
  ├────────────┼─────────────────────────────────────┤
  │ TRANSFERIR │ Traspasar el riesgo a otra parte     │
  │            │ (seguros, contratos, terceros)       │
  ├────────────┼─────────────────────────────────────┤
  │ EVITAR     │ Eliminar la fuente del riesgo        │
  └────────────┴─────────────────────────────────────┘

  Matriz de Probabilidad × Impacto (escala 1-5):
  ┌─────────────────────────────────────────────────┐
  │ Probabilidad: 1=rara, 2=improbable, 3=posible, │
  │               4=probable, 5=casi segura         │
  │ Impacto:      1=insignificante, 2=menor,       │
  │               3=moderato, 4=mayor, 5=crítico   │
  └─────────────────────────────────────────────────┘

  Niveles de riesgo:
  • 1-4   = BAJO
  • 5-9   = MEDIO
  • 10-15 = ALTO
  • 16-25 = CRÍTICO

🔧 HERRAMIENTAS UTILIZADAS
═══════════════════════
  • jq (procesador JSON)  — para analizar escenarios
  • awk                  — para cálculo de matrices
  • bash                 — script de análisis

📝 EJERCICIO
══════════
  1. Ejecuta setup.sh para generar el escenario de la PyME.
  2. Analiza cada activo: identifica amenazas, probabilidad e impacto.
  3. Calcula riesgo inherente y residual.
  4. Clasifica en la matriz ISO 31000.
  5. Propone un tratamiento para cada activo.
  6. Valida tu análisis con test.sh.

EOF
echo ""
echo -e "${CYAN}Comandos útiles:${RESET}"
echo "  ./setup.sh          — generar escenario"
echo "  ./test.sh           — validar análisis"
echo "  cat escenario.json  — ver escenario completo"