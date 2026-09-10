#!/bin/bash
# Unit: i-asset-classification — Clasificación de Activos / CSF 2.0 (Lab 3)
# Manual interactivo del estudiante

# Support both container (/shared) and local (relative) paths
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
fi

UNIT_NAME="unit-I-asset"
banner_unidad 21 "Clasificación de Activos / CSF 2.0"

cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║  Lab 3 — Clasificación de Activos / CSF 2.0                 ║
║  Módulo I: Introducción a la Ciberseguridad                  ║
╚══════════════════════════════════════════════════════════════╝

📚 CONCEPTOS CLAVE
══════════════════

  NIST CSF 2.0 — Cybersecurity Framework v2.0
  ────────────────────────────────────────────
  El CSF 2.0 (Febrero 2024) añade la función GOVERN y refina las
  categorías. ID.AM (Asset Management) es fundamental:

  ID.AM-01: Inventario de Activos
  ────────────────────────────────
  "Los inventarios de hardware, software, datos y servicios de la
  organización se gestionan."
  
  → No puedes proteger lo que no conoces. El inventario es la base
  → Cubre 4 tipos: hardware, software, data, supplier-service

  ID.AM-05: Priorización de Activos
  ─────────────────────────────────
  "Los activos se priorizan según su clasificación, criticidad
  y valor para la organización."
  
  → Recursos limitados → proteger lo más crítico primero
  → Clasificación: público / interno / confidencial / restringido
  → CIA triad (1-5): Confidencialidad, Integridad, Disponibilidad

  ID.AM-07: Mapeo a Roles y Dependencias
  ──────────────────────────────────────
  "Se establece un mapa de activos que muestra roles,
  responsabilidades y dependencias."
  
  → Blast radius analysis (análisis de radio de explosión)
  → Continuidad de negocio y recuperación ante desastres
  → Gestión de cambios y configuración

  Triada CIA
  ──────────
  ┌──────────────────┬─────────────────────────────────────┐
  │ Confidencialidad │ Solo autorizados acceden a la info   │
  │ Integridad       │ Datos completos, precisos, no alterados│
  │ Disponibilidad   │ Sistemas accesibles cuando se necesitan│
  └──────────────────┴─────────────────────────────────────┘
  
  Escala 1-5 por dimensión:
  1=Muy bajo  2=Bajo  3=Medio  4=Alto  5=Muy alto

  Niveles de Clasificación (4 niveles)
  ─────────────────────────────────────
  ┌──────────────┬──────────────────────────────────────┐
  │ público      │ Información de dominio público       │
  │ interno      │ Uso interno, no público              │
  │ confidencial │ Sensible, acceso por necesidad       │
  │ restringido  │ Altamente sensible, acceso mínimo    │
  └──────────────┴──────────────────────────────────────┘

🔧 HERRAMIENTAS UTILIZADAS
═════════════════════════
  • jq (procesador JSON)    — analizar escenario.json
  • cut, awk, grep          — procesar asset_registry.csv
  • bash                    — scripts de validación

📝 EJERCICIO
════════════
  1. Ejecuta setup.sh para generar el escenario FinSecure.
  2. Examina escenario.json y data/asset_registry.csv
  3. Completa plantilla-clasificacion.md:
     a) Tabla de inventario con tipos y clasificaciones
     b) Ratings CIA (1-5) para cada activo
     c) Justificación de cada clasificación
     d) Priorización por criticidad (ID.AM-05)
     e) Mapeo de dependencias (ID.AM-07)
  4. Consulta data/csf_mapping.md para entender ID.AM-01/05/07
  5. Valida tu análisis con ./test.sh

💡 PISTAS
═════════
  • A1 (Servidor BD) y A3 (Transacciones) → "restringido" (datos financieros)
  • A2 (Banca Online) → "confidencial" (acceso clientes, transacciones)
  • A4 (Cloud AWS) → "interno" (infraestructura, no datos directos)
  • A5 (Políticas) → "interno" (documentación operativa)
  • CIA ratings: piensa en impacto real si falla cada dimensión

EOF
echo ""
echo -e "${CYAN}Comandos útiles:${RESET}"
echo "  ./setup.sh                    — generar escenario"
echo "  ./test.sh                     — validar análisis (10 retos)"
echo "  cat escenario.json | jq .     — ver escenario completo"
echo "  cat data/asset_registry.csv   — ver CSV"
echo "  cat data/csf_mapping.md       — referencia CSF 2.0"
echo "  cat plantilla-clasificacion.md — worksheet"