#!/bin/bash
# Unit III-compliance-iso27001: Cumplimiento ISO 27001 / NIST CSF 2.0 — manual.sh

# Support both container (/shared) and local (relative) paths
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
fi

banner_unidad 0 "Cumplimiento ISO 27001 / NIST CSF 2.0"

cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║  Módulo III: Hardening e Identidades                        ║
║  Unidad: Cumplimiento ISO 27001 / NIST CSF 2.0              ║
╚══════════════════════════════════════════════════════════════╝

📚 CONCEPTOS CLAVE
══════════════════

  ISO 27001:2022
  ──────────────
  Estándar internacional para Sistemas de Gestión de Seguridad
  de la Información (ISMS). Define 93 controles en 4 temas:
  • Organizacionales (37)
  • Personas (8)
  • Físicos (14)
  • Tecnológicos (34)

  NIST Cybersecurity Framework (CSF) 2.0
  ──────────────────────────────────────
  Marco de referencia voluntary para gestión de ciberseguridad.
  6 Funciones: Govern → Identify → Protect → Detect → Respond → Recover
  Niveles de madurez: Tier 1 (Parcial) → Tier 4 (Adaptativo)

  ISMS (Information Security Management System)
  ──────────────────────────────────────────────
  Sistema de gestión que incluye políticas, procedimientos,
  controles y recursos para proteger la información.

  Statement of Applicability (SoA)
  ─────────────────────────────────
  Documento que lista todos los controles del estándar e indica
  cuáles son aplicables, no aplicables y su justificación.

  Risk Register (Registro de Riesgos)
  ────────────────────────────────────
  Documento que captura todos los riesgos identificados,
  incluyendo: probabilidad, impacto, propietario y estado.

  Matriz de Severidad
  ────────────────────
  Herramienta para clasificar riesgos según likelihood × impact.
  Niveles: Acceptable → Tolerable → Intolerable.

🎯 RETOS DE ESTA UNIDAD
═══════════════════════

  5 retos prácticos:
  1. Risk Register CSV — Crear registro de riesgos en formato CSV
  2. Statement of Applicability JSON — Definir SoA en JSON
  3. Policy Compliance MD — Documentar política de cumplimiento
  4. Severity Matrix — Crear matriz de severidad de riesgos
  5. Controls Compliance Check — Verificar controles ISO 27001

💡 COMANDOS PARA EL LAB
══════════════════════

EOF

echo -e "\n${AMARILLO}Escribe ${CYAN}'retos-unidad'${AMARILLO} para ver los retos o ${CYAN}'evaluar'${AMARILLO} para evaluar.${RESET}"
