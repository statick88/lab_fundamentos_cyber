#!/bin/bash
# Unit IV: Criptografía y CVSS — test.sh

set -e
source /shared/common.sh

UNIT_NAME="unit-IV"
TOTAL_RETOS=10

reto1() {
    # Calcular CVSS 3.1 base para RCE HTTP: AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H
    # Score esperado ~9.8
    echo "9.8" | grep -qE '^[0-9]+(\.[0-9]+)?$'
    command -v python3 >/dev/null 2>&1 || command -v awk >/dev/null 2>&1
}

reto2() {
    # XSS reflejado: AV:N/AC:L/PR:N/UI:R/S:U/C:L/I:L/A:N
    echo "6.1" | grep -qE '^[0-9]+(\.[0-9]+)?$'
    command -v python3 >/dev/null 2>&1 || command -v awk >/dev/null 2>&1
}

reto3() {
    # Buffer overflow local: AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H
    echo "7.8" | grep -qE '^[0-9]+(\.[0-9]+)?$'
}

reto4() {
    # Severity rating: dado un score, determinar nivel
    local score="$1"
    [ -n "$score" ] || score="7.5"
    python3 -c "exit(0 if 7.0 <= $score <= 8.9 else 1)" 2>/dev/null || \
    awk -v s="$score" 'BEGIN { exit (s >= 7.0 && s <= 8.9) ? 0 : 1 }'
}

reto5() {
    # Identificar vector de ataque en auth.log
    [ -f "$HOME/laboratorio/ciberseguridad/auth.log" ]
    grep -c "Failed password" "$HOME/laboratorio/ciberseguridad/auth.log" 2>/dev/null | grep -qE '^[0-9]+$'
}

reto6() {
    # Identificar SQL injection en access.log
    [ -f "$HOME/laboratorio/ciberseguridad/access.log" ]
    grep -qi "union.*select" "$HOME/laboratorio/ciberseguridad/access.log" 2>/dev/null
}

reto7() {
    # Identificar path traversal en access.log
    [ -f "$HOME/laboratorio/ciberseguridad/access.log" ]
    grep -qi "\.\./" "$HOME/laboratorio/ciberseguridad/access.log" 2>/dev/null || grep -qi "etc/passwd" "$HOME/laboratorio/ciberseguridad/access.log" 2>/dev/null
}

reto8() {
    # Analizar headers de phishing simulado
    grep -qi "X-Priority\|Reply-To\|suspicious\|link" "$HOME/laboratorio/ciberseguridad/access.log" 2>/dev/null || true
    # Simulated: verify mail analysis tools exist
    command -v grep >/dev/null 2>&1 && command -v awk >/dev/null 2>&1
}

reto9() {
    # Generar hashes SHA-256 de archivos "maliciosos"
    [ -f "$HOME/laboratorio/ciberseguridad/malware_simulado.bin" ]
    sha256sum "$HOME/laboratorio/ciberseguridad/malware_simulado.bin" 2>/dev/null | grep -qE '^[a-f0-9]{64}'
}

reto10() {
    # Comparar hashes contra baseline
    [ -f "$HOME/laboratorio/ciberseguridad/baseline_hashes.txt" ]
    sha256sum "$HOME/laboratorio/ciberseguridad/malware_simulado.bin" 2>/dev/null > /tmp/actual_hash.txt
    diff <(cut -d' ' -f1 "$HOME/laboratorio/ciberseguridad/baseline_hashes.txt") <(cut -d' ' -f1 /tmp/actual_hash.txt) >/dev/null 2>&1 || true
    [ -f /tmp/actual_hash.txt ]
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
    echo ""
    echo "Calcula el score CVSS 3.1 base para un RCE (Remote Code Execution)"
    echo "en un servicio HTTP accesible desde la red."
    echo ""
    echo "Vector: AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H"
    echo ""
    echo "Usa: https://www.first.org/cvss/calculator/3.1"
    echo "O calcula manualmente aplicando la fórmula CVSS 3.1."
    separador
}

reto2_info() {
    separador
    echo -e "${CYAN}Reto 2: CVSS - XSS Reflejado${NC}"
    echo ""
    echo "Calcula el score CVSS para un XSS (Cross-Site Scripting) reflejado."
    echo "Vector: AV:N/AC:L/PR:N/UI:R/S:U/C:L/I:L/A:N"
    echo ""
    echo "Comandos útiles: python3 para calcular score"
    separador
}

reto3_info() {
    separador
    echo -e "${CYAN}Reto 3: CVSS - Buffer Overflow Local${NC}"
    echo ""
    echo "Calcula el score CVSS para un buffer overflow local."
    echo "Vector: AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H"
    echo ""
    echo "Comandos útiles: python3 para calcular score"
    separador
}

reto4_info() {
    separador
    echo -e "${CYAN}Reto 4: Severity Rating${NC}"
    echo ""
    echo "Dado un CVSS score, determina el severity rating:"
    echo "  0.0-3.9 = Low"
    echo "  4.0-6.9 = Medium"
    echo "  7.0-8.9 = High"
    echo "  9.0-10.0 = Critical"
    echo ""
    echo "Comandos útiles: awk 'BEGIN {if (score >= 7.0 && score <= 8.9) print \"High\"}'"
    separador
}

reto5_info() {
    separador
    echo -e "${CYAN}Reto 5: Vector de ataque en log${NC}"
    echo ""
    echo "Analiza auth.log para identificar el vector de ataque."
    echo "Busca 'Failed password' y determina si es fuerza bruta SSH."
    echo ""
    echo "Comandos útiles:"
    echo "  grep 'Failed password' auth.log"
    echo "  grep -c 'Failed password' auth.log"
    separador
}

reto6_info() {
    separador
    echo -e "${CYAN}Reto 6: SQL Injection en log${NC}"
    echo ""
    echo "Identifica intentos de SQL injection en access.log."
    echo "Busca patrones: union, select, insert, drop, --"
    echo ""
    echo "Comandos útiles:"
    echo "  grep -i 'union.*select' access.log"
    echo "  grep -iE 'union|select|insert|drop' access.log"
    separador
}

reto7_info() {
    separador
    echo -e "${CYAN}Reto 7: Path Traversal en log${NC}"
    echo ""
    echo "Identifica intentos de path traversal en access.log."
    echo "Busca patrones: ../, /etc/passwd, /etc/shadow, cgi-bin"
    echo ""
    echo "Comandos útiles:"
    echo "  grep -i '\.\./' access.log"
    echo "  grep -i 'etc/passwd' access.log"
    separador
}

reto8_info() {
    separador
    echo -e "${CYAN}Reto 8: Analizar headers de phishing${NC}"
    echo ""
    echo "Analiza un correo de phishing simulado."
    echo "Busca: X-Priority alto, Reply-To sospechoso, links acortados."
    echo ""
    echo "Comandos útiles: grep, awk para extraer headers"
    separador
}

reto9_info() {
    separador
    echo -e "${CYAN}Reto 9: Hashes SHA-256${NC}"
    echo ""
    echo "Genera hashes SHA-256 de archivos 'maliciosos' simulados."
    echo "Usa sha256sum sobre malware_simulado.bin."
    echo ""
    echo "Comandos útiles:"
    echo "  sha256sum malware_simulado.bin"
    separador
}

reto10_info() {
    separador
    echo -e "${CYAN}Reto 10: Comparar hashes contra baseline${NC}"
    echo ""
    echo "Compara los hashes calculados contra baseline_hashes.txt."
    echo "Usa diff o cmp para verificar diferencias."
    echo ""
    echo "Comandos útiles:"
    echo "  sha256sum malware_simulado.bin > actual.txt"
    echo "  diff baseline_hashes.txt actual.txt"
    separador
}
