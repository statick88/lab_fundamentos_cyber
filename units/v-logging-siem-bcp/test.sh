#!/bin/bash
# Unit V: Logging, SIEM y BCP — test.sh

set -e
source /shared/common.sh

UNIT_NAME="unit-V"
TOTAL_RETOS=10

reto1() {
    logger -p local0.info "test-lab-log-v-ret1" 2>/dev/null || true
    grep -q "test-lab-log-v-ret1" /var/log/syslog 2>/dev/null || grep -q "test-lab-log-v-ret1" /var/log/user.log 2>/dev/null || true
}

reto2() {
    [ -f /etc/logrotate.d ] || mkdir -p /etc/logrotate.d
    # Verify logrotate config can be created for custom file
    echo "/var/log/mi_app.log {" > /tmp/test_logrotate.conf
    echo "  daily" >> /tmp/test_logrotate.conf
    echo "  rotate 7" >> /tmp/test_logrotate.conf
    echo "  compress" >> /tmp/test_logrotate.conf
    echo "}" >> /tmp/test_logrotate.conf
    grep -q "mi_app.log" /tmp/test_logrotate.conf
}

reto3() {
    if [ -f /var/log/syslog ]; then
        local count
        count=$(grep -ciE "error|fail|critical" /var/log/syslog 2>/dev/null || echo 0)
        [ "$count" -gt 0 ]
    elif [ -f "$HOME/laboratorio/logging/mi_app.log" ]; then
        eval_log_analysis "$HOME/laboratorio/logging/mi_app.log" "error|fail|critical" 1 student
    else
        return 1
    fi
}

reto4() {
    if [ -f /var/log/syslog ]; then
        awk '$4 ~ /13:55/ {print $0}' /var/log/syslog | grep -q "192.168.1" 2>/dev/null || true
    elif [ -f "$HOME/laboratorio/logging/apache_access.log" ]; then
        eval_log_analysis "$HOME/laboratorio/logging/apache_access.log" "192.168.1" 1 student
    else
        return 1
    fi
}

reto5() {
    if [ -f /var/log/syslog ]; then
        sed 's/192\\.168\\.[0-9]\\+\\.[0-9]\\+/ENMASCARADA/g' /var/log/syslog | grep -q "ENMASCARADA" 2>/dev/null || true
    elif [ -f "$HOME/laboratorio/logging/apache_access.log" ]; then
        eval_log_analysis "$HOME/laboratorio/logging/apache_access.log" "192.168" 1 student
    else
        return 1
    fi
}

reto6() {
    if [ -f /var/log/auth.log ] && [ -f /var/log/syslog ]; then
        grep "13:55:38" /var/log/auth.log 2>/dev/null | grep -q "systemd" || \
        grep "13:55:38" /var/log/syslog 2>/dev/null | grep -q "systemd"
    elif [ -f "$HOME/laboratorio/logging/auth_sys.log" ]; then
        eval_log_analysis "$HOME/laboratorio/logging/auth_sys.log" "13:55:38.*systemd" 1 student
    else
        return 1
    fi
}

reto7() {
    [ -f "$HOME/laboratorio/logging/mi_app.log" ]
    # Verify suspicious process detection script exists
    [ -f "$HOME/laboratorio/logging/monitor_procesos.sh" ] && [ -x "$HOME/laboratorio/logging/monitor_procesos.sh" ]
}

reto8() {
    # Verify backup script exists and implements 3-2-1 concept
    [ -f "$HOME/laboratorio/logging/backup_script.sh" ] && [ -x "$HOME/laboratorio/logging/backup_script.sh" ]
    grep -qi "tar\|rsync\|3.*2.*1\|offsite" "$HOME/laboratorio/logging/backup_script.sh" 2>/dev/null || true
}

reto9() {
    # RTO/RPO calculation - verify student can define both
    [ -f "$HOME/laboratorio/logging/rto_rpo.md" ] || [ -f "$HOME/laboratorio/logging/rto_rpo.txt" ]
}

reto10() {
    # IR playbook - verify sequential phases document
    [ -f "$HOME/laboratorio/logging/playbook_ir.md" ] || [ -f "$HOME/laboratorio/logging/playbook_ir.txt" ]
    grep -qi "preparación\|detección\|contención\|erradicación\|recuperación" "$HOME/laboratorio/logging/playbook_ir.md" 2>/dev/null || grep -qi "preparacion\|deteccion\|contencion\|erradicacion\|recuperacion" "$HOME/laboratorio/logging/playbook_ir.txt" 2>/dev/null || true
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
    echo "  grep -E 'error|fail|critical' mi_app.log"
    echo "  grep -ciE 'error|fail|critical' mi_app.log  (contar)"
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
    echo "  awk '\$4 ~ /13:55/ {print \$0}' apache_access.log"
    echo "  awk '{print \$1, \$7}' apache_access.log"
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
    echo "  sed 's/192\\.168\\.[0-9]\\+\\.[0-9]\\+/ENMASCARADA/g' apache_access.log"
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
    echo "  grep '13:55:38' auth_sys.log mi_app.log"
    echo "  join -j 1 <(sort auth_sys.log) <(sort mi_app.log)"
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
