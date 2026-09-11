#!/bin/bash
# Checkpoint V: Evaluación Módulo V — manual.sh

# Dual-path sourcing
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
fi

banner_unidad 14 "Checkpoint Módulo V"

cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║  Checkpoint Módulo V: Logging y BCP                         ║
╚══════════════════════════════════════════════════════════════╝

📚 CONCEPTOS CLAVE
══════════════════

  Análisis de Logs con grep/awk/sed
  ──────────────────────────────────
  grep: Buscar patrones en líneas de log.
    -E  → Extended regex (|, +, ?)
    -i  → Ignorar mayúsculas/minúsculas
    -c  → Contar coincidencias
    -v  → Invertir (excluir líneas)

  awk: Procesamiento de campos columnados.
    awk '{print $1, $3}' → Columnas 1 y 3
    awk '/patrón/ {acción}' → Filtrar por patrón

  sed: Edición de flujo de texto.
    sed 's/antiguo/nuevo/g' → Reemplazar texto
    sed -n '1,5p' → Imprimir líneas 1-5

  Generación de Logs con logger
  ─────────────────────────────
  logger: Envía mensajes al syslog desde la línea de comandos.
    logger "mensaje"              → Envía a syslog local
    logger -p local0.info "msg"  → Prioridad específica
    logger -t mi-script "msg"    → Con tag personalizado

  Backup y Business Continuity Plan (BCP)
  ────────────────────────────────────────
  RTO (Recovery Time Objective):
    Tiempo máximo aceptable para restaurar el servicio.
  RPO (Recovery Point Objective):
    Máxima cantidad de datos perdidos aceptable.
  Tipos de backup:
    Full    → Copia completa (más lento, más espacio)
    Incremental → Solo cambios desde último backup
    Differential → Cambios desde último backup full

  Plan de Incident Response (IR)
  ──────────────────────────────
  Fases del ciclo IR (NIST SP 800-61):
    1. Preparación
    2. Detección y Análisis
    3. Contención
    4. Erradicación
    5. Recuperación
    6. Lecciones Aprendidas

🎯 RETOS DE ESTA UNIDAD
═══════════════════════

  Reto 1: Analizar Logs con grep
  ───────────────────────────────
  Objetivo: Filtrar syslog_sample.log para eventos críticos.
  Criterio: Encontrar al menos 1 línea con error/fail/critical/block.

  Reto 2: Extraer Campos con awk
  ──────────────────────────────
  Objetivo: Extraer timestamp, hostname y proceso del log.
  Criterio: Salida awk que contenga campos del log parseados.

  Reto 3: Generar Log con logger
  ──────────────────────────────
  Objetivo: Crear una entrada de log personalizada en el sistema.
  Criterio: Logger ejecutado exitosamente (verificable en syslog).

  Reto 4: Calcular RTO/RPO
  ─────────────────────────
  Objetivo: Definir RTO y RPO para un escenario de negocio.
  Criterio: Archivo con valores de RTO y RPO documentados.

  Reto 5: Playbook de Incident Response
  ──────────────────────────────────────
  Objetivo: Crear un playbook IR secuencial con las 5 fases.
  Criterio: Documento con al menos 3 fases del ciclo IR.

💡 COMANDOS PARA EL LAB
═══════════════════════

  # Análisis con grep
  grep -E 'error|fail|critical|block' syslog_sample.log
  grep -ci 'fail' syslog_sample.log
  grep -v '^#' syslog_sample.log | grep -v '^$'

  # Extracción con awk
  awk '{print $1, $2, $3, $4, $5}' syslog_sample.log
  awk -F: '/sshd/ {print $1, $NF}' syslog_sample.log

  # Generación con logger
  logger -p local0.info "test-mensaje"
  logger -t mi-lab "evento de prueba"

  # Verificar logs generados
  grep "mi-lab" /var/log/syslog
  journalctl --since "5 minutes ago" | grep "mi-lab"

📝 EJEMPLOS ÚTILES
══════════════════

  # Análisis completo de syslog:
  #!/bin/bash
  LOG="syslog_sample.log"
  echo "=== Eventos críticos ==="
  grep -iE 'error|fail|critical|block' "$LOG"
  echo ""
  echo "=== Conteo por tipo ==="
  echo "Errores: $(grep -ci 'error' "$LOG")"
  echo "Fallos: $(grep -ci 'fail' "$LOG")"
  echo "Bloqueos: $(grep -ci 'block' "$LOG")"

  # Script de RTO/RPO:
  #!/bin/bash
  cat << BCP
  Escenario: Servidor de correo electrónico
  RTO: 4 horas (tiempo máximo sin servicio)
  RPO: 1 hora (máxima pérdida de datos aceptable)
  Estrategia: Backup incremental cada hora + snapshot diario
  BCP

EOF

echo -e "${AMARILLO}Escribe ${CYAN}'retos-unidad'${AMARILLO} para ver los retos o ${CYAN}'evaluar'${AMARILLO} para evaluar.${RESET}"
