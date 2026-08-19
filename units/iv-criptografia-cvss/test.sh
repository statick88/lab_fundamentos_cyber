#!/bin/bash
# Unit IV: Criptografía y CVSS — test.sh

set -e
source /shared/common.sh

UNIT_NAME="unit-IV"
TOTAL_RETOS=10

reto1() {
    local student_script="$HOME/laboratorio/ciberseguridad/cvss_calculator.py"
    if [ ! -f "$student_script" ]; then
        student_script="$HOME/laboratorio/cvss_calculator.py"
    fi
    eval_cvss "9.8" "$student_script" "0.5"
}

reto2() {
    local student_script="$HOME/laboratorio/ciberseguridad/cvss_calculator.py"
    if [ ! -f "$student_script" ]; then
        student_script="$HOME/laboratorio/cvss_calculator.py"
    fi
    eval_cvss "5.4" "$student_script" "0.5"
}

reto3() {
    local student_script="$HOME/laboratorio/ciberseguridad/cvss_calculator.py"
    if [ ! -f "$student_script" ]; then
        student_script="$HOME/laboratorio/cvss_calculator.py"
    fi
    eval_cvss "7.8" "$student_script" "0.5"
}

reto4() {
    local score_file="$HOME/laboratorio/ciberseguridad/cvss_score.txt"
    local score="7.5"
    if [ -f "$score_file" ]; then
        score=$(cat "$score_file" 2>/dev/null || echo "7.5")
    fi
    python3 -c "exit(0 if 7.0 <= $score <= 8.9 else 1)" 2>/dev/null || \
    awk -v s="$score" 'BEGIN { exit (s >= 7.0 && s <= 8.9) ? 0 : 1 }'
}

reto5() {
    if [ -f /var/log/auth.log ]; then
        eval_log_analysis /var/log/auth.log "Failed password" 1 system
    elif [ -f "$HOME/laboratorio/ciberseguridad/auth.log" ]; then
        eval_log_analysis "$HOME/laboratorio/ciberseguridad/auth.log" "Failed password" 1 student
    else
        return 1
    fi
}

reto6() {
    if [ -f /var/log/apache2/access.log ]; then
        eval_log_analysis /var/log/apache2/access.log "union.*select" 1 system
    elif [ -f "$HOME/laboratorio/ciberseguridad/access.log" ]; then
        eval_log_analysis "$HOME/laboratorio/ciberseguridad/access.log" "union.*select" 1 student
    else
        return 1
    fi
}

reto7() {
    if [ -f /var/log/apache2/access.log ]; then
        eval_log_analysis /var/log/apache2/access.log "\.\./|etc/passwd" 1 system
    elif [ -f "$HOME/laboratorio/ciberseguridad/access.log" ]; then
        eval_log_analysis "$HOME/laboratorio/ciberseguridad/access.log" "\.\./|etc/passwd" 1 student
    else
        return 1
    fi
}

reto8() {
    if [ -f /var/log/mail.log ]; then
        eval_log_analysis /var/log/mail.log "X-Priority|Reply-To|suspicious" 1 system
    elif [ -f "$HOME/laboratorio/ciberseguridad/access.log" ]; then
        eval_log_analysis "$HOME/laboratorio/ciberseguridad/access.log" "X-Priority|Reply-To|suspicious|link" 1 student
    else
        return 1
    fi
}

reto9() {
    if [ -f "$HOME/laboratorio/ciberseguridad/malware_simulado.bin" ]; then
        eval_crypto_hash "$HOME/laboratorio/ciberseguridad/malware_simulado.bin" "" sha256sum
    else
        return 1
    fi
}

reto10() {
    local actual="$HOME/laboratorio/ciberseguridad/malware_simulado.bin"
    local baseline="$HOME/laboratorio/ciberseguridad/baseline_hashes.txt"
    if [ -f "$actual" ] && [ -f "$baseline" ]; then
        sha256sum "$actual" 2>/dev/null > /tmp/actual_hash.txt
        diff <(cut -d' ' -f1 "$baseline") <(cut -d' ' -f1 /tmp/actual_hash.txt) >/dev/null 2>&1 || true
        [ -f /tmp/actual_hash.txt ]
    else
        return 1
    fi
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
    echo "Crea un script Python que calcule el score y ejecútalo."
    echo "Usa: python3 cvss_calculator.py 'AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H'"
    separador
}

reto2_info() {
    separador
    echo -e "${CYAN}Reto 2: CVSS - XSS Reflejado${NC}"
    echo ""
    echo "Calcula el score CVSS para un XSS (Cross-Site Scripting) reflejado."
    echo "Vector: AV:N/AC:L/PR:N/UI:R/S:U/C:L/I:L/A:N"
    echo ""
    echo "Crea un script Python que calcule el score y ejecútalo."
    separador
}

reto3_info() {
    separador
    echo -e "${CYAN}Reto 3: CVSS - Buffer Overflow Local${NC}"
    echo ""
    echo "Calcula el score CVSS para un buffer overflow local."
    echo "Vector: AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H"
    echo ""
    echo "Crea un script Python que calcule el score y ejecútalo."
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
    echo "  grep 'Failed password' /var/log/auth.log"
    echo "  grep -c 'Failed password' /var/log/auth.log"
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
    echo "  grep -i 'union.*select' /var/log/apache2/access.log"
    echo "  grep -iE 'union|select|insert|drop' /var/log/apache2/access.log"
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
    echo "  grep -i '\.\./' /var/log/apache2/access.log"
    echo "  grep -i 'etc/passwd' /var/log/apache2/access.log"
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
