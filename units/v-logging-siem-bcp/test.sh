#!/bin/bash
# Unit V: Logging, SIEM y BCP — test.sh

source /shared/common.sh

UNIT_NAME="unit-V"
TOTAL_RETOS=10

LAB_DIR="$HOME/laboratorio/logging"

has_content() {
    [ -s "$1" ]
}

reto1() {
    has_content "$LAB_DIR/logger_evidence.log" && \
        grep -qiE "logger|local[0-7]|test-lab-log-v-ret1" "$LAB_DIR/logger_evidence.log"
}

reto2() {
    has_content "$LAB_DIR/logrotate_mi_app.conf" && \
        grep -qE '^/?[^[:space:]]*mi_app\.log[[:space:]]*\{' "$LAB_DIR/logrotate_mi_app.conf" && \
        grep -qiE '^[[:space:]]*daily' "$LAB_DIR/logrotate_mi_app.conf" && \
        grep -qiE '^[[:space:]]*rotate[[:space:]]+7' "$LAB_DIR/logrotate_mi_app.conf" && \
        grep -qiE '^[[:space:]]*compress' "$LAB_DIR/logrotate_mi_app.conf"
}

reto3() {
    has_content "$LAB_DIR/grep_errors.txt" && \
        grep -qiE 'error|fail|critical|crit' "$LAB_DIR/grep_errors.txt"
}

reto4() {
    has_content "$LAB_DIR/awk_extract.txt" && \
        grep -q '13:55' "$LAB_DIR/awk_extract.txt"
}

reto5() {
    has_content "$LAB_DIR/sed_masked.log" && \
        grep -q 'ENMASCARADA' "$LAB_DIR/sed_masked.log" && \
        ! grep -qE '192\.168\.[0-9]+\.[0-9]+' "$LAB_DIR/sed_masked.log"
}

reto6() {
    has_content "$LAB_DIR/correlation_report.md" && \
        grep -q '13:55:38' "$LAB_DIR/correlation_report.md" && \
        grep -qiE 'auth_sys\.log|mi_app\.log' "$LAB_DIR/correlation_report.md"
}

reto7() {
    [ -f "$LAB_DIR/monitor_procesos.sh" ] && [ -x "$LAB_DIR/monitor_procesos.sh" ] && \
        grep -qiE 'ps|ss|netstat|/proc' "$LAB_DIR/monitor_procesos.sh"
}

reto8() {
    [ -f "$LAB_DIR/backup_script.sh" ] && [ -x "$LAB_DIR/backup_script.sh" ] && \
        grep -qiE 'tar|rsync|3.*2.*1|offsite' "$LAB_DIR/backup_script.sh"
}

reto9() {
    has_content "$LAB_DIR/rto_rpo.md" && \
        grep -qi 'RTO' "$LAB_DIR/rto_rpo.md" && \
        grep -qi 'RPO' "$LAB_DIR/rto_rpo.md"
}

reto10() {
    has_content "$LAB_DIR/playbook_ir.md" && \
        grep -qiE 'preparación|preparacion' "$LAB_DIR/playbook_ir.md" && \
        grep -qiE 'detección|deteccion' "$LAB_DIR/playbook_ir.md" && \
        grep -qiE 'contención|contencion' "$LAB_DIR/playbook_ir.md" && \
        grep -qiE 'erradicación|erradicacion' "$LAB_DIR/playbook_ir.md" && \
        grep -qiE 'recuperación|recuperacion' "$LAB_DIR/playbook_ir.md"
}

validators=(reto1 reto2 reto3 reto4 reto5 reto6 reto7 reto8 reto9 reto10)
challenge_names=(
    "Generar log con logger"
    "Configurar logrotate"
    "Analizar logs con grep"
    "Extraer campos con awk"
    "Transformar logs con sed"
    "Correlacionar logs"
    "Script monitoreo procesos"
    "Backup 3-2-1"
    "Calcular RTO/RPO"
    "Playbook IR"
)

ICONOS=("📝" "🔄" "🔍" "🔎" "🎭" "🔗" "👁️" "💾" "⏱️" "🚨")

reto1_info() {
    separador
    echo -e "${CYAN}Reto 1: Generar log con logger${NC}"
    echo ""
    echo "Usa el comando logger para generar un log personalizado en el sistema."
    echo ""
    echo "Comandos útiles:"
    echo "  logger 'Mensaje de prueba desde lab ciberseguridad'"
    echo "  grep 'lab ciberseguridad' /var/log/syslog"
    separador
}

reto2_info() {
    separador
    echo -e "${CYAN}Reto 2: Configurar logrotate${NC}"
    echo ""
    echo "Crea una configuración de logrotate para un archivo de log custom."
    echo "Especifica rotación diaria, compresión y retención de 7 archivos."
    echo ""
    echo "Comandos útiles:"
    echo "  sudo nano /etc/logrotate.d/mi_app"
    echo "  logrotate -d /etc/logrotate.conf  (modo debug)"
    separador
}

reto3_info() {
    separador
    echo -e "${CYAN}Reto 3: Analizar logs con grep${NC}"
    echo ""
    echo "Usa grep para encontrar errores en mi_app.log."
    echo "Busca líneas que contengan: error, fail, critical."
    echo ""
    echo "Comandos útiles:"
    echo "  grep -E 'error|fail|critical' fixtures/mi_app.log > grep_errors.txt"
    echo "  grep -ciE 'error|fail|critical' fixtures/mi_app.log  (contar)"
    separador
}

reto4_info() {
    separador
    echo -e "${CYAN}Reto 4: Extraer campos con awk${NC}"
    echo ""
    echo "Usa awk para extraer campos específicos de apache_access.log."
    echo "Muestra solo las líneas del rango horario 13:55."
    echo ""
    echo "Comandos útiles:"
    echo "  awk '\$4 ~ /13:55/ {print \$0}' fixtures/apache_access.log > awk_extract.txt"
    echo "  awk '{print \$1, \$7}' fixtures/apache_access.log"
    separador
}

reto5_info() {
    separador
    echo -e "${CYAN}Reto 5: Transformar logs con sed${NC}"
    echo ""
    echo "Usa sed para enmascarar direcciones IP en apache_access.log."
    echo "Reemplaza 192.168.x.x por ENMASCARADA."
    echo ""
    echo "Comandos útiles:"
    echo "  sed 's/192\\.168\\.[0-9]\\+\\.[0-9]\\+/ENMASCARADA/g' fixtures/apache_access.log > sed_masked.log"
    separador
}

reto6_info() {
    separador
    echo -e "${CYAN}Reto 6: Correlacionar logs${NC}"
    echo ""
    echo "Correlaciona eventos entre auth_sys.log y mi_app.log."
    echo "Busca eventos que ocurrieron en el mismo timestamp (13:55:38)."
    echo ""
    echo "Comandos útiles:"
    echo "  grep '13:55:38' fixtures/auth_sys.log fixtures/mi_app.log > correlation_report.md"
    echo "  join -j 1 <(sort fixtures/auth_sys.log) <(sort fixtures/mi_app.log)"
    separador
}

reto7_info() {
    separador
    echo -e "${CYAN}Reto 7: Script de monitoreo de procesos${NC}"
    echo ""
    echo "Crea un script monitor_procesos.sh que revise /proc y liste"
    echo "procesos sospechosos (ej: conexiones de red inusuales)."
    echo ""
    echo "Comandos útiles:"
    echo "  ps aux | grep -v grep | grep -v PID"
    echo "  ss -tuln"
    separador
}

reto8_info() {
    separador
    echo -e "${CYAN}Reto 8: Backup 3-2-1${NC}"
    echo ""
    echo "Crea un script backup_script.sh que implemente la regla 3-2-1:"
    echo "3 copias, 2 medios diferentes, 1 copia offsite."
    echo ""
    echo "Comandos útiles:"
    echo "  tar -czf backup.tar.gz /ruta/importante"
    echo "  rsync -av /ruta/ backup:/ruta/"
    separador
}

reto9_info() {
    separador
    echo -e "${CYAN}Reto 9: Calcular RTO/RPO${NC}"
    echo ""
    echo "Define RTO y RPO para un escenario de negocio dado."
    echo "RTO = tiempo máximo de recuperación aceptable."
    echo "RPO = datos máximos perdidos aceptables."
    echo ""
    echo "Crea un documento rto_rpo.md o rto_rpo.txt con tus cálculos."
    separador
}

reto10_info() {
    separador
    echo -e "${CYAN}Reto 10: Playbook IR${NC}"
    echo ""
    echo "Crea un playbook de Incident Response (IR) secuencial:"
    echo "Preparación → Detección → Contención → Erradicación → Recuperación"
    echo ""
    echo "Crea un documento playbook_ir.md o playbook_ir.txt."
    separador
}
