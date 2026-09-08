#!/bin/bash
# Funciones de evaluacion y progreso
STATE_DIR="${STATE_DIR:=${HOME}/.lab-state}"
PROGRESS_FILE="${PROGRESS_FILE:=${STATE_DIR}/progress}"
OLD_PROGRESS_FILE="${HOME}/.lab_state/progress"

init_state() {
    mkdir -p "$STATE_DIR" 2>/dev/null || true
    touch "$PROGRESS_FILE" 2>/dev/null || true
    chmod 0770 "$STATE_DIR" 2>/dev/null || true
    chmod 0660 "$PROGRESS_FILE" 2>/dev/null || true
    if [ -f "$OLD_PROGRESS_FILE" ] && [ ! -s "$PROGRESS_FILE" ]; then
        cp "$OLD_PROGRESS_FILE" "$PROGRESS_FILE" 2>/dev/null || true
        chmod 0660 "$PROGRESS_FILE" 2>/dev/null || true
        rm -f "$OLD_PROGRESS_FILE" 2>/dev/null || true
    fi
}

marcar_completado() {
    local key="${1}:reto:${2}"
    grep -q "^${key}$" "$PROGRESS_FILE" 2>/dev/null || echo "${key}" >> "$PROGRESS_FILE"
}

esta_completado() {
    grep -q "^${1}:reto:${2}$" "$PROGRESS_FILE" 2>/dev/null
}

contar_completados() {
    local unit=$1 total=$2 count=0 i
    for ((i=1; i<=total; i++)); do
        esta_completado "$unit" "$i" && count=$((count+1))
    done
    echo "$count"
}

mostrar_estado_retos() {
    local unit="$1" total i
    local -n retos_ref="$2"
    total=${#retos_ref[@]}
    completados=$(contar_completados "$unit" "$total")
    echo -e "\n${CYAN_B}Estado de retos:${RESET}"
    separador
    for ((i=0; i<total; i++)); do
        if esta_completado "$unit" "$((i+1))"; then
            echo -e "  ${VERDE}✔ Reto $((i+1)): ${retos_ref[$i]}${RESET}"
        else
            echo -e "  ${ROJO}✘ Reto $((i+1)): ${retos_ref[$i]}${RESET}"
        fi
    done
    separador
    echo -ne "  Progreso: "; mostrar_barra_progreso "$completados" "$total"
}

ejecutar_evaluacion() {
    local unit=$1 total=$2; shift 2; local -a v=("$@") pass=0 fail=0 i
    local _m_start="" _m_output="" _m_status=""
    echo ""; titulo "Evaluacion - ${unit}"
    for ((i=0; i<total; i++)); do
        [ "${METRICS_INITIALIZED:-0}" -eq 1 ] && _m_start=$(_metrics_time_ms)
        if [ -n "${v[$i]}" ] && "${v[$i]}" >/dev/null 2>&1; then
            marcar_completado "$unit" "$((i+1))"; exito "Reto $((i+1)) completado"; pass=$((pass+1))
            _m_status="PASS"
        else
            error "Reto $((i+1)) fallido"; fail=$((fail+1))
            _m_status="FAIL"
        fi
        if [ "${METRICS_INITIALIZED:-0}" -eq 1 ] && [ -n "$_m_start" ]; then
            local _m_now=$(_metrics_time_ms)
            metrics_record "$unit" "$((i+1))" "$_m_status" "$((_m_now - _m_start))" "" 2>/dev/null
        fi
    done
    echo ""; separador
    echo -e "Resultados: ${VERDE}${pass} pasados${RESET} | ${ROJO}${fail} fallidos${RESET}"
    separador
    [ "$fail" -eq 0 ] && celebrar "Todos los retos completados"
    return $fail
}

# =============================================================================
# Funciones de evaluacion especializadas para ciberseguridad
# =============================================================================

eval_multiple_choice() {
    local expected="$1"
    local answer="$2"
    [ "${expected^^}" = "${answer^^}" ]
}

eval_cvss() {
    local expected_score="$1"
    local student_script="$2"
    local tolerance="${3:-0.5}"
    local vector="${4:-}"

    if [ -z "$student_script" ]; then
        student_script="$HOME/laboratorio/cvss_calculator.py"
    fi

    if [ -z "$vector" ]; then
        return 1
    fi

    if [ ! -f "$student_script" ]; then
        return 1
    fi

    # Anti-bypass: verify script has substantive content
    local line_count
    line_count=$(wc -l < "$student_script" 2>/dev/null || echo 0)
    if [ "$line_count" -lt 10 ]; then
        return 1
    fi

    # Verify script references CVSS metrics
    local metric_count=0
    for metric in AV AC PR UI S C I A; do
        if grep -q "$metric" "$student_script" 2>/dev/null; then
            metric_count=$((metric_count + 1))
        fi
    done
    if [ "$metric_count" -lt 3 ]; then
        return 1
    fi

    # Verify script contains math operations
    if ! grep -qE '[\*\/\+\-\^]' "$student_script" 2>/dev/null; then
        return 1
    fi

    local actual_score
    actual_score=$(python3 "$student_script" "$vector" 2>/dev/null || echo "")
    if [ -z "$actual_score" ]; then
        return 1
    fi

    if ! echo "$actual_score" | grep -qE '^[0-9]+(\.[0-9]+)?$'; then
        return 1
    fi

    python3 -c "import sys; exit(0 if abs($expected_score - $actual_score) <= $tolerance else 1)" 2>/dev/null || \
python3 -c "exit(0 if abs(float('''$expected_score''') - float('''$actual_score''')) <= float('''$tolerance''') else 1)"
}

eval_log_analysis() {
    local log_file="$1"
    local pattern="$2"
    local expected_count="$3"
    local source_type="${4:-auto}"

    if [ "$source_type" = "system" ]; then
        local syslog_count=0
        if command -v journalctl >/dev/null 2>&1; then
            syslog_count=$(journalctl --since "1 hour ago" 2>/dev/null | grep -cE "$pattern" || echo 0)
        elif [ -f /var/log/syslog ]; then
            syslog_count=$(grep -cE "$pattern" /var/log/syslog 2>/dev/null || echo 0)
        elif [ -f /var/log/auth.log ]; then
            syslog_count=$(grep -cE "$pattern" /var/log/auth.log 2>/dev/null || echo 0)
        fi
        [ "$syslog_count" -ge "$expected_count" ]
        return $?
    fi

    if [ "$source_type" = "student" ] || [ "$source_type" = "auto" ]; then
        if [ ! -f "$log_file" ]; then
            return 1
        fi

        if [ "$source_type" = "student" ]; then
            local file_mtime file_ctime
            file_mtime=$(stat -c %Y "$log_file" 2>/dev/null || stat -f %m "$log_file" 2>/dev/null || echo 0)
            file_ctime=$(stat -c %W "$log_file" 2>/dev/null || stat -f %B "$log_file" 2>/dev/null || echo 0)
            local now
            now=$(date +%s)
            local age=$((now - file_mtime))
            local ctime_age=$((now - file_ctime))
            
            if [ "$age" -lt 300 ] || [ "$ctime_age" -lt 300 ]; then
                return 1
            fi
            
            local has_real_pattern=0
            if grep -qE "^(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)" "$log_file" 2>/dev/null; then
                has_real_pattern=1
            elif grep -qE "^[0-9]{4}-[0-9]{2}-[0-9]{2}T" "$log_file" 2>/dev/null; then
                has_real_pattern=1
            fi

            if [ "$has_real_pattern" -eq 0 ]; then
                return 1
            fi

            local real_log_lines
            real_log_lines=$(grep -cE "$pattern" "$log_file" 2>/dev/null || echo 0)
            [ "$real_log_lines" -ge "$expected_count" ]
            return $?
        fi

        local actual_count
        actual_count=$(grep -cE "$pattern" "$log_file" 2>/dev/null || echo 0)
        [ "$actual_count" -ge "$expected_count" ]
        return $?
    fi

    return 1
}

eval_crypto_hash() {
    local file="$1"
    local expected_hash="$2"
    local algorithm="${3:-sha256sum}"
    local actual_hash
    actual_hash=$($algorithm "$file" 2>/dev/null | awk '{print $1}')
    [ "$actual_hash" = "$expected_hash" ]
}

eval_crypto_verify() {
    local signature_file="$1"
    local data_file="$2"
    local pubkey_file="$3"
    openssl dgst -verify "$pubkey_file" -signature "$signature_file" "$data_file" >/dev/null 2>&1
}

eval_config_file() {
    local config_file="$1"
    local mode="${2:-content}"
    local pattern="${3:-}"

    if [ ! -f "$config_file" ]; then
        return 1
    fi

    case "$mode" in
        exists)
            [ -f "$config_file" ]
            ;;
        content)
            [ -n "$pattern" ] && grep -qE "$pattern" "$config_file" 2>/dev/null
            ;;
        perms)
            local expected_perms="$3"
            local actual_perms
            actual_perms=$(stat -c "%a" "$config_file" 2>/dev/null || stat -f "%Lp" "$config_file" 2>/dev/null || echo "")
            [ "$actual_perms" = "$expected_perms" ]
            ;;
        syntax)
            local config_type="${3:-generic}"
            case "$config_type" in
                sudoers)
                    visudo -c -f "$config_file" >/dev/null 2>&1
                    ;;
                sshd_config)
                    sshd -t -f "$config_file" >/dev/null 2>&1
                    ;;
                generic)
                    [ -f "$config_file" ] && [ -s "$config_file" ]
                    ;;
                *)
                    return 1
                    ;;
            esac
            ;;
        *)
            return 1
            ;;
    esac
}

celebrar() {
    echo -e "\n${VERDE_B}╔══════════════════════════════════════════════════╗"
    echo "║   🎉  $1"
    echo -e "╚══════════════════════════════════════════════════╝${RESET}"
}

# Auto-initialize state directory when sourced
init_state
