#!/bin/bash
# Checkpoint V: Evaluación Módulo V — manual.sh

source /shared/common.sh

banner_unidad 14 "Checkpoint Módulo V"

cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║  Checkpoint Módulo V: Logging y BCP                         ║
╚══════════════════════════════════════════════════════════════╝

📋 EVALUACIÓN FORMATIVA
══════════════════════

Este checkpoint evalúa tu dominio de:
  • Análisis de logs con grep/awk/sed
  • Generación de logs con logger
  • Conceptos de backup y BCP
  • Playbook de Incident Response

🎯 5 retos de evaluación
═══════════════════════

EOF

echo -e "${AMARILLO}Escribe ${CYAN}'evaluar'${AMARILLO} para comenzar la evaluación.${RESET}"
