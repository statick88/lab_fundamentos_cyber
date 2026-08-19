#!/bin/bash
# shared/units_manifest.sh — Manifiesto centralizado de unidades ABC-CYB-101
# Este archivo elimina la duplicación de mapeos en common.sh, unidad.sh, menu.sh e interactive.sh

# === MANIFIESTO DE UNIDADES ===
# Índices: 1..18 (cada directorio en units/ tiene su propia entrada)
# Total: 175 retos (60 CORE + 115 OPTATIVOS) — alineado con test.sh reales

UNIT_NAMES=(
  "unit-I"            "unit-II"            "unit-ii"            "unit-III"           "unit-iii"
  "unit-IV"           "unit-iv"            "unit-V"             "unit-V-processes"   "unit-VI"
  "unit-VII"          "unit-VIII"          "unit-IX"            "unit-X"             "unit-XI"
  "checkpoint-II"     "checkpoint-IV"      "checkpoint-V"
)

UNIT_DIRS=(
  "i"                 "ii-firewalls-redes" "ii"                 "iii-iam-mfa"        "iii"
  "iv-criptografia-cvss" "iv"              "v-logging-siem-bcp" "v"                  "vi"
  "vii"               "viii"              "ix"                 "x"                  "xi"
  "checkpoint-ii"     "checkpoint-iv"     "checkpoint-v"
)

UNIT_TITLES=(
  "Principios y Gestión de Riesgo"
  "Filtrado de Red y Firewalls"
  "Redes y Protocolos"
  "IAM, MFA y Control de Acceso"
  "Scripting Bash"
  "Criptografía y CVSS"
  "Criptografía Aplicada"
  "Logging, SIEM y BCP"
  "Procesos y Servicios"
  "Almacenamiento y LVM"
  "Hardening y CIS Benchmarks"
  "Docker"
  "Nginx"
  "SSL/TLS y Criptografía Aplicada"
  "Docker Compose + DB"
  "Checkpoint Módulo II"
  "Checkpoint Módulo IV"
  "Checkpoint Módulo V"
)

UNIT_ICONOS=(
  "🛡️" "🔥" "🌐" "👤" "💻"
  "🔐" "🔬" "📊" "⚙️" "💾"
  "🛡️" "🐳" "🌐" "🔒" "🐘"
  "✅" "✅" "✅"
)

# Cantidad de retos por unidad (175 total, alineado con test.sh reales)
UNIT_RETOS=(
  10   10   10   5   15
  10   10   10   10  10
  15   10   10  15  10
   5    5    5
)

# Clasificación pedagógica: 1 = CORE obligatorio, 0 = OPTATIVO/exploratorio
# Total CORE: 60 retos. Total OPT: 115 retos.
# CORE: unit-I(10)+unit-II(10)+unit-III-iam-mfa(5)+unit-IV(10)+unit-V(10)+checkpoints(15) = 60
UNIT_CORE=(
  1   1   0    1    0
  1   0    1    0    0
  0    0    0    0    0
  1    1    1
)

# Módulo curricular al que pertenece cada unidad
# M1: unit-I(1), unit-ii(3), unit-VI(9)
# M2: unit-II(2), unit-III(4), unit-iii(5), checkpoint-II(16)
# M3: unit-IV(6), unit-iv(7), unit-VII(10), unit-VIII(11)
# M4: unit-V(8), unit-IX(12), unit-X(13), checkpoint-IV(17)
# M5: unit-XI(14), unit-V-processes(18), checkpoint-V(18)
# OPT sin módulo específico: unit-ii(3→M1), unit-iii(5→M2), unit-iv(7→M3), unit-IX(12→M4)
UNIT_MODULE=(
  1   2   1    2    2
  3   3    4    0    3
  0    4    5    4    2
  4    5    5
)

UNIT_COUNT=18

# === FUNCIONES DE CONSULTA ===

get_unit_index() {
    local unit="$1"
    for ((i=0; i<UNIT_COUNT; i++)); do
        if [ "${UNIT_NAMES[$i]}" = "$unit" ]; then
            echo $((i+1))
            return
        fi
    done
    echo 0
}

get_unit_dir() {
    local idx="$1"
    if [ "$idx" -ge 1 ] && [ "$idx" -le "$UNIT_COUNT" ]; then
        echo "${UNIT_DIRS[$((idx-1))]}"
    else
        echo ""
    fi
}

get_unit_name() {
    local idx="$1"
    if [ "$idx" -ge 1 ] && [ "$idx" -le "$UNIT_COUNT" ]; then
        echo "${UNIT_NAMES[$((idx-1))]}"
    else
        echo ""
    fi
}

get_unit_title() {
    local idx="$1"
    if [ "$idx" -ge 1 ] && [ "$idx" -le "$UNIT_COUNT" ]; then
        echo "${UNIT_TITLES[$((idx-1))]}"
    else
        echo "Unidad $1"
    fi
}

get_unit_icon() {
    local idx="$1"
    if [ "$idx" -ge 1 ] && [ "$idx" -le "$UNIT_COUNT" ]; then
        echo "${UNIT_ICONOS[$((idx-1))]}"
    else
        echo "📄"
    fi
}

get_unit_total_retos() {
    local idx="$1"
    if [ "$idx" -ge 1 ] && [ "$idx" -le "$UNIT_COUNT" ]; then
        echo "${UNIT_RETOS[$((idx-1))]}"
    else
        echo "0"
    fi
}

is_reto_core() {
    local unit_idx="$1"
    local reto_num="$2"
    if [ "$unit_idx" -lt 1 ] || [ "$unit_idx" -gt "$UNIT_COUNT" ]; then
        echo 0
        return
    fi
    local core_flag="${UNIT_CORE[$((unit_idx-1))]}"
    if [ "$core_flag" = "1" ]; then
        echo 1
    else
        echo 0
    fi
}

get_unit_module() {
    local idx="$1"
    if [ "$idx" -ge 1 ] && [ "$idx" -le "$UNIT_COUNT" ]; then
        echo "${UNIT_MODULE[$((idx-1))]}"
    else
        echo "0"
    fi
}

resolve_unit_path() {
    local unit="$1"
    local idx; idx=$(get_unit_index "$unit")
    local dir; dir=$(get_unit_dir "$idx")
    if [ -n "$dir" ]; then
        echo "$HOME/laboratorio/units/$dir"
    else
        echo ""
    fi
}
