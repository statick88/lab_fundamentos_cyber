#!/bin/bash
# Unit V: Logging, SIEM y BCP — test.sh
# Estandarizado: usa /shared/validators.sh para aserciones deterministicas
# Sin dependencias de sudo/root. Paths bajo $HOME/laboratorio.

# Support both container (/shared) and local (relative) paths
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
    source /shared/validators.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
    source "$(dirname "$0")/../../shared/validators.sh"
fi

UNIT_NAME="unit-V"
TOTAL_RETOS=10

LAB_DIR="$HOME/laboratorio/logging"

# ── Reto 1: Generar log con logger ─────────────────────────────────
# Valida que el estudiante haya generado un log personalizado con logger.
reto1() {
    # Buscar en los archivos de log del sistema la entrada del estudiante
    local found=0
    for logfile in /var/log/syslog /var/log/user.log /var/log/messages; do
        if [ -f "$logfile" ] && grep -q "test-lab-log-v-ret1" "$logfile" 2>/dev/null; then
            found=1
            break
        fi
    done
    # Fallback: verificar si el estudiante creó un archivo de log custom
    if [ "$found" -eq 0 ] && [ -f "$LAB_DIR/custom.log" ]; then
        assert_file_contains "$LAB_DIR/custom.log" "test-lab-log-v-ret1"
        return $?
    fi
    if [ "$found" -eq 1 ]; then
        return 0
    fi
    echo "FAIL: No se encontró entrada de log generada con logger" >&2
    return 1
}

# ── Reto 2: Configurar logrotate ───────────────────────────────────
# Valida que exista una configuración de logrotate para archivo custom.
reto2() {
    # Buscar en ubicaciones estándar del estudiante
    local config=""
    if [ -f "$LAB_DIR/logrotate_mi_app.conf" ]; then
        config="$LAB_DIR/logrotate_mi_app.conf"
    elif [ -f "$LAB_DIR/logrotate_custom.conf" ]; then
        config="$LAB_DIR/logrotate_custom.conf"
    elif [ -f "$LAB_DIR/logrotate.conf" ]; then
        config="$LAB_DIR/logrotate.conf"
    fi
    if [ -n "$config" ]; then
        assert_file_exists "$config"
        assert_file_contains "$config" "rotate"
        return $?
    fi
    echo "FAIL: No se encontró configuración de logrotate en $LAB_DIR" >&2
    return 1
}

# ── Reto 3: Analizar logs con grep ─────────────────────────────────
# Valida que el estudiante haya encontrado errores en mi_app.log con grep.
reto3() {
    eval_log_analysis "$LAB_DIR/mi_app.log" "error|fail|critical" 1 student
}

# ── Reto 4: Extraer campos con awk ─────────────────────────────────
# Valida que el estudiante haya extraído campos de apache_access.log.
reto4() {
    eval_log_analysis "$LAB_DIR/apache_access.log" "192.168.1" 1 student
}

# ── Reto 5: Transformar logs con sed ───────────────────────────────
# Valida que el estudiante haya enmascarado IPs en apache_access.log.
reto5() {
    eval_log_analysis "$LAB_DIR/apache_access.log" "192.168" 1 student
}

# ── Reto 6: Correlacionar logs ─────────────────────────────────────
# Valida que el estudiante haya correlacionado auth_sys.log y mi_app.log.
reto6() {
    eval_log_analysis "$LAB_DIR/auth_sys.log" "13:55:38.*systemd" 1 student
}

# ── Reto 7: Script de monitoreo de procesos ────────────────────────
# Valida que exista un script ejecutable que monitoree procesos.
reto7() {
    local script="$LAB_DIR/monitor_procesos.sh"
    assert_file_exists "$script"
    assert_command_ok test -x "$script"
    assert_file_contains "$script" "ps\|ss\|netstat\|awk\|/proc"
}

# ── Reto 8: Backup 3-2-1 ──────────────────────────────────────────
# Valida que exista un script ejecutable de backup 3-2-1.
reto8() {
    local script="$LAB_DIR/backup_script.sh"
    assert_file_exists "$script"
    assert_command_ok test -x "$script"
    assert_file_contains "$script" "tar\|rsync\|3.*2.*1\|offsite\|backup"
}

# ── Reto 9: Calcular RTO/RPO ──────────────────────────────────────
# Valida que exista un documento con definición de RTO y RPO.
reto9() {
    local file=""
    if [ -f "$LAB_DIR/rto_rpo.md" ]; then
        file="$LAB_DIR/rto_rpo.md"
    elif [ -f "$LAB_DIR/rto_rpo.txt" ]; then
        file="$LAB_DIR/rto_rpo.txt"
    else
        # Buscar archivos que contengan rto o rpo en el nombre
        file=$(find "$LAB_DIR" -maxdepth 1 -type f \( -name "*rto*" -o -name "*rpo*" \) 2>/dev/null | head -1)
    fi
    if [ -z "$file" ]; then
        echo "FAIL: No se encontró documento RTO/RPO en $LAB_DIR" >&2
        return 1
    fi
    assert_file_exists "$file"
    assert_file_contains "$file" "RTO\|Recovery Time"
    assert_file_contains "$file" "RPO\|Recovery Point"
}

# ── Reto 10: Playbook IR ───────────────────────────────────────────
# Valida que exista un playbook de Incident Response con las fases.
reto10() {
    local file=""
    if [ -f "$LAB_DIR/playbook_ir.md" ]; then
        file="$LAB_DIR/playbook_ir.md"
    elif [ -f "$LAB_DIR/playbook_ir.txt" ]; then
        file="$LAB_DIR/playbook_ir.txt"
    else
        # Buscar archivos que contengan ir o playbook en el nombre
        file=$(find "$LAB_DIR" -maxdepth 1 -type f \( -name "*ir*" -o -name "*playbook*" \) 2>/dev/null | head -1)
    fi
    if [ -z "$file" ]; then
        echo "FAIL: No se encontró playbook IR en $LAB_DIR" >&2
        return 1
    fi
    assert_file_exists "$file"
    assert_file_contains "$file" "preparación\|preparacion\|Preparación"
    assert_file_contains "$file" "contención\|contencion\|Contención"
    assert_file_contains "$file" "recuperación\|recuperacion\|Recuperación"
}

# ── Gamification arrays ────────────────────────────────────────────
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
    echo "  logger -p local0.info 'test-lab-log-v-ret1'"
    echo "  grep 'test-lab-log-v-ret1' /var/log/syslog"
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
    echo "  nano ~/laboratorio/logging/logrotate_mi_app.conf"
    echo "  logrotate -d ~/laboratorio/logging/logrotate_mi_app.conf  (modo debug)"
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

# ── Standalone execution mode ──────────────────────────────────────
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Unit V: Logging, SIEM y BCP — Retos"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    PASSED=0
    FAILED=0

    for i in $(seq 1 "$TOTAL_RETOS"); do
        validator="${validators[$((i-1))]}"
        name="${challenge_names[$((i-1))]}"
        icon="${ICONOS[$((i-1))]}"

        if $validator >/dev/null 2>&1; then
            echo "  [PASS] Reto $i: $name $icon"
            PASSED=$((PASSED + 1))
        else
            echo "  [FAIL] Reto $i: $name"
            FAILED=$((FAILED + 1))
        fi
    done

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Unit V Results: $PASSED/$TOTAL_RETOS passed, $FAILED failed"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    [ "$FAILED" -eq 0 ]
fi
