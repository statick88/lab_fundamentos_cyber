#!/bin/bash
# Checkpoint IV: Evaluación Módulo IV — manual.sh

source /shared/common.sh

banner_unidad 13 "Checkpoint Módulo IV"

cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║  Checkpoint Módulo IV: Amenazas y Criptografía              ║
╚══════════════════════════════════════════════════════════════╝

📋 EVALUACIÓN FORMATIVA
══════════════════════

Este checkpoint evalúa tu dominio de:
  • Cálculo de scores CVSS
  • Generación y verificación de hashes
  • Verificación de certificados X.509
  • Análisis básico de amenazas

🎯 5 retos de evaluación
═══════════════════════

EOF

echo -e "${AMARILLO}Escribe ${CYAN}'evaluar'${AMARILLO} para comenzar la evaluación.${RESET}"
