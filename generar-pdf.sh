#!/bin/bash
set -euo pipefail

UNIT="${1:-1}"
RESULTADOS="/home/estudiante/laboratorio/resultados"
mkdir -p "$RESULTADOS"

FECHA=$(date +%Y-%m-%d)

pandoc --from markdown --to pdf -o "$RESULTADOS/constancia_unidad${UNIT}.pdf" \
  --metadata title="Unidad ${UNIT} - Laboratorio Linux" \
  --metadata author="Estudiante" \
  --metadata date="$FECHA" \
  /dev/stdin <<EOF
# Certificado de Finalizacion

Unidad ${UNIT} completada exitosamente.
Fecha: ${FECHA}
Entregable: Laboratorio Interactivo de Administracion de Servidores Linux.
EOF

echo "PDF generado: $RESULTADOS/constancia_unidad${UNIT}.pdf"
