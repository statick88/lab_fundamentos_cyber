#!/bin/bash
# shared/units_manifest.sh — Manifiesto centralizado de unidades ABC-CYB-101
# Este archivo elimina la duplicación de mapeos en common.sh, unidad.sh, menu.sh e interactive.sh

# === MANIFIESTO DE UNIDADES ===
# Índices: 1..21 (cada directorio en units/ tiene su propia entrada)
# Total: 198 retos (83 CORE + 115 OPTATIVOS) — alineado con test.sh reales
#
# Orden de unidades (índices 1..21):
#   1  i                        unit-I            Principios y Gestión de Riesgo          M1
#   2  ii-firewalls-redes       unit-II           Filtrado de Red y Firewalls            M2
#   3  ii-ids-intrusion-detect  unit-II-ids       Detección de Intrusos con Suricata     M2
#   4  ii                       unit-ii           Redes y Protocolos (legacy)            M1
#   5  iii-iam-mfa              unit-III          IAM, MFA y Control de Acceso           M2
#   6  iii                      unit-iii          Scripting Bash (legacy)                M2
#   7  iv-criptografia-cvss     unit-IV           Criptografía y CVSS                    M3
#   8  iv                       unit-iv           Criptografía Aplicada (legacy)         M3
#   9  v-logging-siem-bcp       unit-V            Logging, SIEM y BCP                    M4
#  10  v                        unit-v            Procesos y Servicios (legacy)          M4
#  11  vi                       unit-VI           Almacenamiento y LVM                  M1
#  12  vii                      unit-VII          Hardening y CIS Benchmarks            M3
#  13  viii                     unit-VIII         Docker                                 M3
#  14  ix                       unit-IX           Nginx                                  M4
#  15  x                        unit-X            SSL/TLS y Criptografía Aplicada       M4
#  16  xi                       unit-XI           Backup y Recuperación                 M4
#  17  checkpoint-ii            checkpoint-II     Checkpoint Módulo II                   M2
#  18  checkpoint-iv            checkpoint-IV     Checkpoint Módulo IV                   M4
#  19  checkpoint-v             checkpoint-V      Checkpoint Módulo V                    M5
#  20  i-risk-assessment        unit-I-risk       Evaluación de Riesgos (ISO 31000)      M1
#  21  i-asset-classification   unit-I-asset      Clasificación de Activos / CSF 2.0    M1
#   21  i-asset-classification   unit-I-asset      Clasificación de Activos / CSF 2.0    M1

UNIT_NAMES=(
  "unit-I"            "unit-II"            "unit-II-ids"        "unit-ii"            "unit-III"
  "unit-iii"          "unit-IV"            "unit-iv"            "unit-V"             "unit-v"
  "unit-VI"           "unit-VII"           "unit-VIII"          "unit-IX"            "unit-X"
  "unit-XI"           "checkpoint-II"      "checkpoint-IV"      "checkpoint-V"       "unit-I-risk"
  "unit-I-asset"
)

UNIT_DIRS=(
  "i"                 "ii-firewalls-redes" "ii-ids-intrusion-detection" "ii"                 "iii-iam-mfa"
  "iii"               "iv-criptografia-cvss" "iv"              "v-logging-siem-bcp" "v"
  "vi"                "vii"               "viii"              "ix"                 "x"
  "xi"                "checkpoint-ii"     "checkpoint-iv"     "checkpoint-v"       "i-risk-assessment"
  "i-asset-classification"
)

UNIT_TITLES=(
  "Principios y Gestión de Riesgo"
  "Filtrado de Red y Firewalls"
  "Detección de Intrusos con Suricata"
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
  "Backup y Recuperación"
  "Checkpoint Módulo II"
  "Checkpoint Módulo IV"
  "Checkpoint Módulo V"
  "Evaluación de Riesgos (ISO 31000)"
  "Clasificación de Activos / CSF 2.0"
)

UNIT_ICONOS=(
  "🛡️" "🔥" "🔍" "🌐" "👤"
  "💻" "🔐" "🔬" "📊" "⚙️"
  "💾" "🛡️" "🐳" "🌐" "🔒"
  "🐘" "✅" "✅" "✅" "📋"
  "🏷️"
)

# Cantidad de retos por unidad (198 total, alineado con test.sh reales)
# CORE: unit-I(10)+unit-II(10)+unit-II-ids(3)+unit-III(5)+unit-IV(10)+unit-V(10)+checkpoints(15)+i-risk-assessment(10)+i-asset-classification(10) = 83
# OPT: 198 - 83 = 115
UNIT_RETOS=(
  10   10    3   10    5
  15   10   10   10   10
  10   15   10   10   15
  10    5    5    5   10
  10
)

# Clasificación pedagógica: 1 = CORE obligatorio, 0 = OPTATIVO/exploratorio
# Total CORE: 83 retos. Total OPT: 115 retos.
# CORE: unit-I(10)+unit-II(10)+unit-II-ids(3)+unit-III-iam-mfa(5)+unit-IV(10)+unit-V(10)+checkpoints(15)+i-risk-assessment(10)+i-asset-classification(10) = 83
UNIT_CORE=(
  1   1   1   0   1
  0   1   0   1   0
  0   0   0   0   0
  0   1   1   1   1
  1
)

# Módulo curricular al que pertenece cada unidad
# M1: unit-I(1), unit-ii(4), unit-VI(11), i-risk-assessment(20), i-asset-classification(21)
# M2: unit-II(2), unit-II-ids(3), unit-III(5), unit-iii(6), checkpoint-II(17)
# M3: unit-IV(7), unit-iv(8), unit-VII(12), unit-VIII(13)
# M4: unit-V(9), unit-v(10), unit-IX(14), unit-X(15), unit-XI(16), checkpoint-IV(18)
# M5: checkpoint-V(19)
UNIT_MODULE=(
  1   2   2   1   2
  2   3   3   4   4
  1   3   3   4   4
  4   2   4   5   1
  1
)

UNIT_COUNT=21

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
        return 1
    fi
    local core_flag="${UNIT_CORE[$((unit_idx-1))]}"
    if [ "$core_flag" = "1" ]; then
        return 0
    else
        return 1
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
