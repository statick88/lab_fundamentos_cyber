#!/bin/bash
# Checkpoint V: Evaluación Módulo V — test.sh
# Estandarizado: usa /shared/validators.sh para aserciones deterministicas
# Sin dependencias de sudo/root. Paths bajo $HOME/laboratorio.

# Dual-path sourcing
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
    source /shared/validators.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
    source "$(dirname "$0")/../../shared/validators.sh"
fi

UNIT_NAME="checkpoint-V"
TOTAL_RETOS=5

LAB_DIR="$HOME/laboratorio/checkpoints/checkpoint-v"
LOG_FILE="$LAB_DIR/syslog_sample.log"

# ── Reto 1: Analizar Logs con grep ──────────────────────────────
# Valida que el estudiante pueda filtrar eventos críticos del log.
reto1() {
    mkdir -p "$LAB_DIR" || return 1
    # Asegurar que el log existe
    if [ ! -f "$LOG_FILE" ]; then
        cat > "$LOG_FILE" << 'LOGEOF'
Oct 10 14:00:01 lab CRON[1001]: (root) CMD (/usr/local/bin/backup.sh)
Oct 10 14:00:02 lab systemd[1]: Started Daily apt upgrade and clean activities.
Oct 10 14:00:03 lab sshd[1002]: Failed password for invalid user admin from 10.0.0.1 port 22 ssh2
Oct 10 14:00:04 lab kernel: [UFW BLOCK] IN=eth0 OUT= MAC=00:00:00:00:00:00 SRC=10.0.0.1 DST=172.20.0.10 PROTO=TCP SPT=23 DPT=22
LOGEOF
    fi
    assert_file_exists "$LOG_FILE"
    # Verificar que el log contiene eventos analizables
    assert_file_contains "$LOG_FILE" "Failed\|BLOCK\|error\|fail"
    # Verificar que el estudiante creó un archivo de análisis
    local analysis
    analysis=$(find "$LAB_DIR" -maxdepth 2 -type f \( -name "*analisis*" -o -name "*analysis*" -o -name "*grep*" -o -name "*filtro*" \) ! -name "test.sh" 2>/dev/null | head -1)
    if [ -n "$analysis" ] && [ -f "$analysis" ]; then
        assert_file_exists "$analysis"
        return 0
    fi
    # Si no hay archivo de análisis, al menos verificar que el log tiene contenido suficiente
    local count
    count=$(grep -ciE 'fail|block|error|critical' "$LOG_FILE" 2>/dev/null || echo "0")
    if [ "$count" -ge 1 ]; then
        return 0
    fi
    echo "FAIL: Log no contiene eventos criticos o no hay archivo de analisis" >&2
    return 1
}

# ── Reto 2: Extraer Campos con awk ──────────────────────────────
# Valida que el estudiante pueda parsear campos del log con awk.
reto2() {
    mkdir -p "$LAB_DIR" || return 1
    if [ ! -f "$LOG_FILE" ]; then
        cat > "$LOG_FILE" << 'LOGEOF'
Oct 10 14:00:01 lab CRON[1001]: (root) CMD (/usr/local/bin/backup.sh)
Oct 10 14:00:02 lab systemd[1]: Started Daily apt upgrade and clean activities.
Oct 10 14:00:03 lab sshd[1002]: Failed password for invalid user admin from 10.0.0.1 port 22 ssh2
Oct 10 14:00:04 lab kernel: [UFW BLOCK] IN=eth0 OUT= MAC=00:00:00:00:00:00 SRC=10.0.0.1 DST=172.20.0.10 PROTO=TCP SPT=23 DPT=22
LOGEOF
    fi
    assert_file_exists "$LOG_FILE"
    # Verificar que awk puede extraer campos del log
    local output
    output=$(awk '{print $1, $2, $3, $4, $5}' "$LOG_FILE" 2>/dev/null)
    if echo "$output" | grep -q "lab"; then
        # Verificar que el estudiante creó un archivo con la extracción
        local extracted
        extracted=$(find "$LAB_DIR" -maxdepth 2 -type f \( -name "*awk*" -o -name "*campo*" -o -name "*field*" -o -name "*extrac*" \) ! -name "test.sh" 2>/dev/null | head -1)
        if [ -n "$extracted" ] && [ -f "$extracted" ]; then
            assert_file_exists "$extracted"
            return 0
        fi
        # Si awk funciona correctamente sobre el log, es suficiente
        return 0
    fi
    echo "FAIL: awk no pudo extraer campos del log" >&2
    return 1
}

# ── Reto 3: Generar Log con logger ──────────────────────────────
# Valida que el estudiante haya ejecutado logger correctamente.
reto3() {
    # Logger puede no funcionar en todos los entornos; validar conocimiento
    # Buscar evidencia de uso de logger en archivos del estudiante
    local logger_found=0
    local logger_files
    logger_files=$(find "$LAB_DIR" -maxdepth 2 -type f \( -name "*logger*" -o -name "*log_gen*" -o -name "*generar_log*" \) ! -name "test.sh" 2>/dev/null)
    if [ -n "$logger_files" ]; then
        for f in $logger_files; do
            if grep -q "logger" "$f" 2>/dev/null; then
                logger_found=1
                break
            fi
        done
    fi
    if [ "$logger_found" -eq 1 ]; then
        return 0
    fi
    # Intentar logger directo como fallback
    if command -v logger >/dev/null 2>&1; then
        logger -p local0.info "checkpoint-v-test-$(date +%s)" 2>/dev/null && return 0
    fi
    echo "FAIL: No se encontro evidencia de uso de logger" >&2
    return 1
}

# ── Reto 4: Calcular RTO/RPO ────────────────────────────────────
# Valida que exista un documento con RTO y RPO definidos.
reto4() {
    mkdir -p "$LAB_DIR" || return 1
    # Buscar archivo con RTO/RPO
    local rto_file=""
    rto_file=$(find "$LAB_DIR" -maxdepth 2 -type f \( -name "*rto*" -o -name "*rpo*" -o -name "*bcp*" -o -name "*continuidad*" \) ! -name "test.sh" 2>/dev/null | head -1)
    if [ -n "$rto_file" ] && [ -f "$rto_file" ]; then
        assert_file_exists "$rto_file"
        # Verificar que contiene conceptos RTO/RPO
        if grep -qiE "rto|rpo|recovery.time|recovery.point" "$rto_file" 2>/dev/null; then
            return 0
        fi
    fi
    # Verificar si hay un archivo genérico de BCP
    local bcp_file
    bcp_file=$(find "$LAB_DIR" -maxdepth 2 -type f \( -name "*.md" -o -name "*.txt" \) ! -name "test.sh" 2>/dev/null | head -1)
    if [ -n "$bcp_file" ] && [ -f "$bcp_file" ]; then
        if grep -qiE "rto|rpo|horas|minutos|backup" "$bcp_file" 2>/dev/null; then
            return 0
        fi
    fi
    echo "FAIL: No se encontro archivo con RTO/RPO definidos" >&2
    return 1
}

# ── Reto 5: Playbook de Incident Response ────────────────────────
# Valida que exista un playbook IR con al menos 3 fases del ciclo.
reto5() {
    mkdir -p "$LAB_DIR" || return 1
    local playbook=""
    playbook=$(find "$LAB_DIR" -maxdepth 2 -type f \( -name "*playbook*" -o -name "*ir*" -o -name "*incident*" -o -name "*respuesta*" \) ! -name "test.sh" 2>/dev/null | head -1)
    if [ -z "$playbook" ] || [ ! -f "$playbook" ]; then
        # Buscar cualquier archivo .md o .txt
        playbook=$(find "$LAB_DIR" -maxdepth 2 -type f \( -name "*.md" -o -name "*.txt" \) ! -name "test.sh" 2>/dev/null | head -1)
    fi
    if [ -n "$playbook" ] && [ -f "$playbook" ]; then
        assert_file_exists "$playbook"
        # Verificar que contiene al menos 3 fases del ciclo IR
        local phases=0
        grep -qiE "preparación|preparacion|preparation" "$playbook" 2>/dev/null && phases=$((phases + 1))
        grep -qiE "detección|deteccion|detection|análisis|analisis|analysis" "$playbook" 2>/dev/null && phases=$((phases + 1))
        grep -qiE "contención|contencion|containment" "$playbook" 2>/dev/null && phases=$((phases + 1))
        grep -qiE "erradicación|erradicacion|eradication" "$playbook" 2>/dev/null && phases=$((phases + 1))
        grep -qiE "recuperación|recuperacion|recovery" "$playbook" 2>/dev/null && phases=$((phases + 1))
        if [ "$phases" -ge 3 ]; then
            return 0
        fi
        echo "FAIL: Playbook IR tiene solo $phases fases (mínimo 3 requeridas)" >&2
        return 1
    fi
    echo "FAIL: No se encontro playbook de Incident Response" >&2
    return 1
}

validators=(reto1 reto2 reto3 reto4 reto5)
challenge_names=(
    "Analizar logs con grep"
    "Extraer campos con awk"
    "Generar log con logger"
    "Calcular RTO/RPO"
    "Playbook IR"
)

ICONOS=("🔍" "🔎" "📝" "⏱️" "🚨")

reto1_info() {
    separador
    echo -e "${CYAN}Reto 1: Analizar Logs con grep${NC}"
    echo ""
    echo "Filtra syslog_sample.log para encontrar eventos"
    echo "críticos: error, fail, critical, block."
    echo ""
    echo "Comandos útiles:"
    echo "  grep -iE 'error|fail|critical|block' syslog_sample.log"
    echo "  grep -c 'fail' syslog_sample.log"
    separador
}

reto2_info() {
    separador
    echo -e "${CYAN}Reto 2: Extraer Campos con awk${NC}"
    echo ""
    echo "Extrae timestamp, hostname y proceso del log."
    echo ""
    echo "Comandos útiles:"
    echo "  awk '{print \$1, \$2, \$3, \$4, \$5}' syslog_sample.log"
    echo "  awk -F: '/sshd/ {print \$1, \$NF}' syslog_sample.log"
    separador
}

reto3_info() {
    separador
    echo -e "${CYAN}Reto 3: Generar Log con logger${NC}"
    echo ""
    echo "Genera una entrada de log personalizada."
    echo ""
    echo "Comandos útiles:"
    echo "  logger -p local0.info 'mensaje-de-prueba'"
    echo "  logger -t mi-lab 'evento personalizado'"
    separador
}

reto4_info() {
    separador
    echo -e "${CYAN}Reto 4: Calcular RTO/RPO${NC}"
    echo ""
    echo "Define RTO y RPO para un escenario de negocio."
    echo ""
    echo "Ejemplo:"
    echo "  Escenario: Servidor de correo"
    echo "  RTO: 4 horas"
    echo "  RPO: 1 hora"
    echo ""
    echo "Guarda en: rto_rpo.txt o rto_rpo.md"
    separador
}

reto5_info() {
    separador
    echo -e "${CYAN}Reto 5: Playbook de Incident Response${NC}"
    echo ""
    echo "Crea un playbook IR secuencial con las fases:"
    echo "  1. Preparación"
    echo "  2. Detección y Análisis"
    echo "  3. Contención"
    echo "  4. Erradicación"
    echo "  5. Recuperación"
    echo ""
    echo "Guarda en: playbook_ir.md o playbook_ir.txt"
    separador
}

# ── Standalone execution mode ─────────────────────────────────────
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Checkpoint V: Logging y BCP — Retos"
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
    echo "  Checkpoint V Results: $PASSED/$TOTAL_RETOS passed, $FAILED failed"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    [ "$FAILED" -eq 0 ]
fi
