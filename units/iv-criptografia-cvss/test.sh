#!/bin/bash
# Unit IV: Criptografia y CVSS — test.sh

source /shared/common.sh
source /shared/validators.sh

UNIT_NAME="unit-IV"
TOTAL_RETOS=10

STUDENT_DIR="$HOME/laboratorio/ciberseguridad"
FIXTURES_DIR="$STUDENT_DIR/fixtures"

student_file_contains() {
    local file="$1"
    shift

    [ -f "$STUDENT_DIR/$file" ] || return 1

    local pattern
    for pattern in "$@"; do
        grep -Eqi "$pattern" "$STUDENT_DIR/$file" 2>/dev/null || return 1
    done
}

eval_cvss_deliverable() {
    local file="$1" vector="$2" score_pattern="$3" severity="$4"

    [ -f "$STUDENT_DIR/$file" ] || return 1
    grep -Fqi "$vector" "$STUDENT_DIR/$file" 2>/dev/null || return 1
    grep -Eqi "$score_pattern" "$STUDENT_DIR/$file" 2>/dev/null || return 1
    grep -Eqi "$severity" "$STUDENT_DIR/$file" 2>/dev/null
}

reto1() {
    eval_cvss_deliverable \
        "cvss_rce.txt" \
        "AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H" \
        '(^|[^0-9])9[.,]8([^0-9]|$)' \
        'critical'
}

reto2() {
    eval_cvss_deliverable \
        "cvss_xss.txt" \
        "AV:N/AC:L/PR:L/UI:R/S:C/C:L/I:L/A:N" \
        '(^|[^0-9])5[.,]4([^0-9]|$)' \
        'medium'
}

reto3() {
    eval_cvss_deliverable \
        "cvss_local_overflow.txt" \
        "AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H" \
        '(^|[^0-9])7[.,]8([^0-9]|$)' \
        'high'
}

reto4() {
    student_file_contains \
        "severity_rating.txt" \
        '(^|[^0-9])7[.,][0-9]([^0-9]|$)|(^|[^0-9])8[.,][0-9]([^0-9]|$)' \
        'high'
}

reto5() {
    student_file_contains \
        "auth_attack_analysis.txt" \
        'failed[[:space:]]+password' \
        'brute[[:space:]-]*force|fuerza[[:space:]-]*bruta' \
        'ssh'
}

reto6() {
    student_file_contains \
        "sqli_analysis.txt" \
        'union[[:space:]]+select' \
        'sql[[:space:]-]*injection|inyecci.n[[:space:]-]*sql'
}

reto7() {
    student_file_contains \
        "traversal_analysis.txt" \
        '\.\./|/etc/passwd' \
        'path[[:space:]-]*traversal|directory[[:space:]-]*traversal|traversal[[:space:]-]*de[[:space:]-]*ruta'
}

reto8() {
    student_file_contains \
        "phishing_headers_analysis.txt" \
        'reply-to' \
        'x-priority' \
        'https?://' \
        'suspicious|sospechos'
}

reto9() {
    local fixture="$FIXTURES_DIR/malware_simulado.bin"
    local expected_hash

    [ -f "$fixture" ] || return 1
    expected_hash=$(sha256sum "$fixture" 2>/dev/null | awk '{print $1}')
    [ -n "$expected_hash" ] || return 1
    student_file_contains "malware_sha256.txt" "$expected_hash"
}

reto10() {
    local fixture="$FIXTURES_DIR/malware_simulado.bin"
    local baseline="$FIXTURES_DIR/baseline_hashes.txt"
    local expected_hash baseline_hash

    [ -f "$fixture" ] && [ -f "$baseline" ] || return 1
    expected_hash=$(sha256sum "$fixture" 2>/dev/null | awk '{print $1}')
    baseline_hash=$(awk 'NF {print $1; exit}' "$baseline" 2>/dev/null)
    [ -n "$expected_hash" ] && [ -n "$baseline_hash" ] || return 1

    student_file_contains \
        "hash_baseline_comparison.txt" \
        "$expected_hash" \
        "$baseline_hash" \
        'match|mismatch|coincid|difer'
}

validators=(reto1 reto2 reto3 reto4 reto5 reto6 reto7 reto8 reto9 reto10)
challenge_names=(
    "CVSS RCE en HTTP"
    "CVSS XSS reflejado"
    "CVSS buffer overflow"
    "Severity rating"
    "Vector de ataque en log"
    "SQL injection en log"
    "Path traversal en log"
    "Headers phishing"
    "Hashes SHA-256"
    "Comparar hashes baseline"
)

ICONOS=("📐" "📊" "💣" "🏷️" "🔍" "💉" "📁" "📧" "🔒" "🔎")

reto1_info() {
    separador
    echo -e "${CYAN}Reto 1: CVSS - RCE en HTTP${NC}"
    echo "Escribí el vector, score 9.8 y Critical en $STUDENT_DIR/cvss_rce.txt."
    echo "Vector: AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H"
    separador
}

reto2_info() {
    separador
    echo -e "${CYAN}Reto 2: CVSS - XSS Reflejado${NC}"
    echo "Escribí el vector, score 5.4 y Medium en $STUDENT_DIR/cvss_xss.txt."
    echo "Vector: AV:N/AC:L/PR:L/UI:R/S:C/C:L/I:L/A:N"
    separador
}

reto3_info() {
    separador
    echo -e "${CYAN}Reto 3: CVSS - Buffer Overflow Local${NC}"
    echo "Escribí el vector, score 7.8 y High en $STUDENT_DIR/cvss_local_overflow.txt."
    echo "Vector: AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H"
    separador
}

reto4_info() {
    separador
    echo -e "${CYAN}Reto 4: Severity Rating${NC}"
    echo "Explicá en $STUDENT_DIR/severity_rating.txt que un score entre 7.0 y 8.9 es High."
    separador
}

reto5_info() {
    separador
    echo -e "${CYAN}Reto 5: Vector de ataque en log${NC}"
    echo "Analizá $FIXTURES_DIR/auth.log y escribí hallazgos en $STUDENT_DIR/auth_attack_analysis.txt."
    echo "Identificá Failed password, fuerza bruta y SSH."
    separador
}

reto6_info() {
    separador
    echo -e "${CYAN}Reto 6: SQL Injection en log${NC}"
    echo "Analizá $FIXTURES_DIR/access.log y escribí hallazgos en $STUDENT_DIR/sqli_analysis.txt."
    echo "Identificá UNION SELECT y SQL injection."
    separador
}

reto7_info() {
    separador
    echo -e "${CYAN}Reto 7: Path Traversal en log${NC}"
    echo "Analizá $FIXTURES_DIR/access.log y escribí hallazgos en $STUDENT_DIR/traversal_analysis.txt."
    echo "Identificá ../ o /etc/passwd y path traversal."
    separador
}

reto8_info() {
    separador
    echo -e "${CYAN}Reto 8: Analizar headers de phishing${NC}"
    echo "Analizá $FIXTURES_DIR/phishing_headers.eml y escribí hallazgos en $STUDENT_DIR/phishing_headers_analysis.txt."
    echo "Identificá Reply-To, X-Priority, un link y por qué son sospechosos."
    separador
}

reto9_info() {
    separador
    echo -e "${CYAN}Reto 9: Hashes SHA-256${NC}"
    echo "Calculá sha256sum de $FIXTURES_DIR/malware_simulado.bin y guardá la línea en $STUDENT_DIR/malware_sha256.txt."
    separador
}

reto10_info() {
    separador
    echo -e "${CYAN}Reto 10: Comparar hashes contra baseline${NC}"
    echo "Compará el hash calculado con $FIXTURES_DIR/baseline_hashes.txt."
    echo "Guardá ambos hashes y la explicación de match o mismatch en $STUDENT_DIR/hash_baseline_comparison.txt."
    separador
}
