#!/bin/bash
# Unit V: Logging, SIEM y BCP — manual.sh

# Support both container (/shared) and local (relative) paths
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
fi

banner_unidad 5 "Logging, SIEM y BCP"

cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║  Módulo V: Logging, SIEM, IR y Continuidad                  ║
║  Unidad V: Logging, SIEM y BCP                              ║
╚══════════════════════════════════════════════════════════════╝

📚 CONCEPTOS CLAVE
══════════════════

  LOGGING
  ───────
  Registro de eventos del sistema para auditoría y diagnóstico.
  Estructura estándar: TIMESTAMP | HOST | PROCESS | MESSAGE
  Niveles: DEBUG, INFO, NOTICE, WARNING, ERR, CRIT, ALERT, EMERG

  LOGROTATE
  ─────────
  Rota, comprime y elimina logs antiguos automáticamente.
  Configuración en /etc/logrotate.d/<servicio>

  SIEM (Security Information and Event Management)
  ─────────────────────────────────────────────────
  Correlaciona eventos de múltiples fuentes para detectar amenazas.
  Componentes: agregación, normalización, correlación, alertas.

  ANÁLISIS DE LOGS
  ────────────────
  grep: filtrar líneas por patrón
  awk: extraer campos estructurados
  sed: transformar texto (enmascarar IPs, fechas)
  cut: extraer columnas delimitadas

  BCP (Business Continuity Plan)
  ───────────────────────────────
  Plan para mantener operaciones durante/después de incidentes.
  RTO (Recovery Time Objective): tiempo máximo de recuperación
  RPO (Recovery Point Objective): datos máximos perdidos

  IR (Incident Response)
  ───────────────────────
  Fases: Preparación → Detección → Contención → Erradicación → Recuperación → Lecciones

🎯 RETOS DE ESTA UNIDAD
══════════════════════

  10 retos:
  1. Generar log personalizado con logger
  2. Configurar logrotate para archivo custom
  3. Analizar logs con grep para encontrar errores
  4. Extraer campos con awk de log de Apache
  5. Transformar logs con sed (enmascarar IPs)
  6. Correlacionar logs de auth y sistema
  7. Crear script de monitoreo de procesos
  8. Implementar backup 3-2-1
  9. Calcular RTO/RPO
  10. Crear playbook IR

💡 COMANDOS PARA EL LAB
══════════════════════

EOF

echo -e "\n${AMARILLO}Escribe ${CYAN}'retos-unidad'${AMARILLO} para ver los retos o ${CYAN}'evaluar'${AMARILLO} para evaluar.${RESET}"
