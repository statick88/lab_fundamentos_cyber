#!/bin/bash
# Unit IV Lab Integrador — Capstone del Curso
# Walkthrough interactivo del laboratorio integrador

if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
fi

UNIT_NAME="unit-IV-lab-integrador"
banner_unidad 4 "Lab Integrador — Capstone del Curso"

cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║  Capstone Integrador — Todos los Módulos del Curso          ║
║  10 Retos que cruzan fronteras entre unidades               ║
╚══════════════════════════════════════════════════════════════╝

📚 CONCEPTOS CLAVE
═══════════════════

  Este laboratorio integra TODOS los módulos del curso:

  ┌─────────────────────────────────────────────────────────┐
  │  Module I    → Riesgos + Activos                       │
  │  Module II   → Perímetro + Red                         │
  │  Module III  → Criptografía + IR                       │
  │  Module IV   → Análisis de Malware                     │
  │                                                         │
  │  Lab Integrador → Todo junto + Defense-in-Depth         │
  └─────────────────────────────────────────────────────────┘

  📌 PRINCIPIOS FUNDAMENTALES:
  • Defense-in-Depth: Validar que cada capa complementa a las demás
  • Cross-Domain Analysis: Un incidente toca múltiples dominios
  • Holistic Assessment: La seguridad no es un solo módulo
  • Risk-Driven: Cada decisión se mapea a un riesgo identificado

  🔗 PATRONES DE INTEGRACIÓN:

  Riesgo ──────► Activo ──────► Perímetro ──────► Criptografía
    │               │                │                   │
    ▼               ▼                ▼                   ▼
  Impacto       Clasificación   Detección          Protección
    │               │                │                   │
    ▼               ▼                ▼                   ▼
  Incidente ◄──── MALWARE ◄──── Forensics ◄────── Recuperación
    │
    ▼
  Lecciones ─────► Remediación ─────► Mejora Continua

🎯 RETOS — 10 Desafíos Cross-Module
═══════════════════════════════════════

  Reto 1: Risk-Incident Correlation
  ───────────────────────────────────
  Correlacionar incidentes reales con el risk register.
  Conecta: Module I (Riesgos) ↔ Module III (IR)
  Archivo: ~/laboratorio/integrador/risk-incident.md

  Reto 2: Network Forensics Script
  ───────────────────────────────────
  Crear script de análisis forense de red para detectar IOCs.
  Conecta: Module II (Perímetro/Red) ↔ Module IV (Malware)
  Archivo: ~/laboratorio/integrador/network-forensics.sh

  Reto 3: Cryptographic Analysis
  ───────────────────────────────────
  Evaluar postura criptográfica integrando malware y riesgos.
  Conecta: Module III (Cripto) ↔ Module I (Riesgos) ↔ Module IV
  Archivo: ~/laboratorio/integrador/crypto-analysis.md

  Reto 4: Asset Inventory with Risk Scoring
  ───────────────────────────────────
  Completar inventario de activos con risk scoring CUANTITATIVO.
  Conecta: Module I (Activos + Riesgos) — Base de todo
  Archivo: ~/laboratorio/integrador/asset-inventory.csv

  Reto 5: Incident Response Playbook
  ───────────────────────────────────
  Playbook que integra detección, contención y recuperación.
  Conecta: Module III (IR) ↔ Module II (Red) ↔ Module IV (Malware)
  Archivo: ~/laboratorio/integrador/incident-playbook.md

  Reto 6: Perimeter Security Audit
  ───────────────────────────────────
  Auditoría completa de seguridad perimetral con análisis de brechas.
  Conecta: Module II (Perímetro) ↔ Module I (Riesgos)
  Archivo: ~/laboratorio/integrador/perimeter-audit.md

  Reto 7: Cross-Module Malware Analysis
  ───────────────────────────────────
  Análisis de malware que incluye impacto, red, IR y técnica.
  Conecta: Module IV (Malware) ↔ Todos los módulos
  Archivo: ~/laboratorio/integrador/malware-integration.md

  Reto 8: Comprehensive Defense Report
  ───────────────────────────────────
  Informe integral para alta dirección combinando todos los hallazgos.
  Conecta: Todos los módulos → Reporting Ejecutivo
  Archivo: ~/laboratorio/integrador/defense-report.md

  Reto 9: Remediation Plan
  ───────────────────────────────────
  Plan de remediación priorizado con cronograma cross-module.
  Conecta: Todos los hallazgos → Acciones Correctivas
  Archivo: ~/laboratorio/integrador/remediation-plan.md

  Reto 10: Final Assessment
  ───────────────────────────────────
  Autoevaluación de dominio en los 4 módulos + integración.
  Conecta: Todos los módulos → Reflexión y Mejora Continua
  Archivo: ~/laboratorio/integrador/final-assessment.md

📐 METODOLOGÍA: Defense-in-Depth Validation
═══════════════════════════════════════════════

  Para CADA reto, aplica estas preguntas:

  1. DETECCIÓN  → ¿Cómo se detecta esta amenaza?
  2. PREVENCIÓN → ¿Qué controles la previenen?
  3. RESPUESTA   → ¿Cómo se responde si ocurre?
  4. RECUPERACIÓN → ¿Cómo se recupera el negocio?
  5. MEJORA      → ¿Qué cambia para el futuro?

  Si alguna respuesta es "no lo sé", ese es tu GAP.

EOF

echo -e "\n${AMARILLO}Escribe ${CYAN}'retos-unidad'${AMARILLO} para ver los retos o ${CYAN}'evaluar'${AMARILLO} para evaluar tu progreso.${RESET}"
