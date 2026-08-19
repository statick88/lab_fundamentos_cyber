#!/bin/bash
# Funciones de evaluacion y progreso
STATE_DIR="${HOME}/.lab_state"
PROGRESS_FILE="${STATE_DIR}/progress"

init_state() { mkdir -p "$STATE_DIR"; touch "$PROGRESS_FILE" 2>/dev/null; }

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
    local actual_score="$2"
    local tolerance="${3:-0.5}"
    local diff
    diff=$(echo "$expected_score $actual_score" | awk '{print ($1-$2)>0?($1-$2):($2-$1)}')
    [ "$(echo "$diff <= $tolerance" | bc -l)" -eq 1 ]
}

eval_log_analysis() {
    local log_file="$1"
    local pattern="$2"
    local expected_count="$3"
    local actual_count
    actual_count=$(grep -cE "$pattern" "$log_file" 2>/dev/null || echo 0)
    [ "$actual_count" -ge "$expected_count" ]
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
    local pattern="$2"
    [ -f "$config_file" ] && grep -qE "$pattern" "$config_file" 2>/dev/null
}

celebrar() {
    echo -e "\n${VERDE_B}╔══════════════════════════════════════════════════╗"
    echo "║   🎉  $1"
    echo -e "╚══════════════════════════════════════════════════╝${RESET}"
}
