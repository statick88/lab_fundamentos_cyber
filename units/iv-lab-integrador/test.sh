#!/bin/bash
# Unit IV Lab Integrador — Capstone del Curso
# Automated validation of 10 cross-module challenges

# Support both container (/shared) and local (relative) paths
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
    source /shared/validators.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
    source "$(dirname "$0")/../../shared/validators.sh"
fi

UNIT_NAME="unit-IV-lab-integrador"
TOTAL_RETOS=10

LAB_DIR="$HOME/laboratorio/integrador"

# Pure validators - no user interaction, check file state only

reto1() {
    # risk-incident.md — assert contains "Risk" or "Riesgo"
    assert_file_exists "$LAB_DIR/risk-incident.md"
    assert_file_contains "$LAB_DIR/risk-incident.md" "Risk" || assert_file_contains "$LAB_DIR/risk-incident.md" "Riesgo"
}

reto2() {
    # network-forensics.sh — assert executable, contains "Forensics" or "Forense"
    assert_file_exists "$LAB_DIR/network-forensics.sh"
    [ -x "$LAB_DIR/network-forensics.sh" ]
    assert_file_contains "$LAB_DIR/network-forensics.sh" "Forensics" || assert_file_contains "$LAB_DIR/network-forensics.sh" "Forense"
}

reto3() {
    # crypto-analysis.md — assert contains "Crypto" or "Cripto"
    assert_file_exists "$LAB_DIR/crypto-analysis.md"
    assert_file_contains "$LAB_DIR/crypto-analysis.md" "Crypto" || assert_file_contains "$LAB_DIR/crypto-analysis.md" "Cripto"
}

reto4() {
    # asset-inventory.csv — assert contains "asset", "risk"
    assert_file_exists "$LAB_DIR/asset-inventory.csv"
    assert_file_contains "$LAB_DIR/asset-inventory.csv" "asset"
    assert_file_contains "$LAB_DIR/asset-inventory.csv" "risk"
}

reto5() {
    # incident-playbook.md — assert contains "Incident" or "Incidente"
    assert_file_exists "$LAB_DIR/incident-playbook.md"
    assert_file_contains "$LAB_DIR/incident-playbook.md" "Incident" || assert_file_contains "$LAB_DIR/incident-playbook.md" "Incidente"
}

reto6() {
    # perimeter-audit.md — assert contains "Perimeter" or "Perimetral"
    assert_file_exists "$LAB_DIR/perimeter-audit.md"
    assert_file_contains "$LAB_DIR/perimeter-audit.md" "Perimeter" || assert_file_contains "$LAB_DIR/perimeter-audit.md" "Perimetral"
}

reto7() {
    # malware-integration.md — assert contains "Malware"
    assert_file_exists "$LAB_DIR/malware-integration.md"
    assert_file_contains "$LAB_DIR/malware-integration.md" "Malware"
}

reto8() {
    # defense-report.md — assert contains "Defense" or "Defensa"
    assert_file_exists "$LAB_DIR/defense-report.md"
    assert_file_contains "$LAB_DIR/defense-report.md" "Defense" || assert_file_contains "$LAB_DIR/defense-report.md" "Defensa"
}

reto9() {
    # remediation-plan.md — assert contains "Remediation" or "Remediación"
    assert_file_exists "$LAB_DIR/remediation-plan.md"
    assert_file_contains "$LAB_DIR/remediation-plan.md" "Remediation" || assert_file_contains "$LAB_DIR/remediation-plan.md" "Remediación"
}

reto10() {
    # final-assessment.md — assert contains "Assessment" or "Evaluación"
    assert_file_exists "$LAB_DIR/final-assessment.md"
    assert_file_contains "$LAB_DIR/final-assessment.md" "Assessment" || assert_file_contains "$LAB_DIR/final-assessment.md" "Evaluación"
}

# Array de funciones de evaluación (para compatibilidad con evaluación batch)
validators=(reto1 reto2 reto3 reto4 reto5 reto6 reto7 reto8 reto9 reto10)

challenge_names=(
    "Risk-Incident Correlation"
    "Network Forensics Script"
    "Cryptographic Analysis"
    "Asset Inventory + Risk Scoring"
    "Incident Response Playbook"
    "Perimeter Security Audit"
    "Cross-Module Malware Analysis"
    "Comprehensive Defense Report"
    "Remediation Plan"
    "Final Assessment"
)

# Iconos para el menú
ICONOS=(🔍 🌐 🔐 📊 🚨 🛡️ 🦠 📋 📝 🎓)

# Funciones de información para cada reto

reto1_info() {
    separador
    echo -e "${CYAN}Reto 1: Risk-Incident Correlation${NC}"
    echo ""
    echo "Correlaciona incidentes con el risk register."
    echo "Identifica qué controles fallaron y qué tratamientos habrían mitigado el impacto."
    echo ""
    echo "Archivo: risk-incident.md"
    echo "Conecta: Module I (Riesgos) ↔ Module III (IR)"
    separador
}

reto2_info() {
    separador
    echo -e "${CYAN}Reto 2: Network Forensics Script${NC}"
    echo ""
    echo "Crea un script ejecutable de análisis forense de red."
    echo "Detecta conexiones sospechosas, patrones de beaconing, y correlaciona con IOCs."
    echo ""
    echo "Archivo: network-forensics.sh"
    echo "Conecta: Module II (Perímetro/Red) ↔ Module IV (Malware)"
    separador
}

reto3_info() {
    separador
    echo -e "${CYAN}Reto 3: Cryptographic Analysis${NC}"
    echo ""
    echo "Evalúa la postura criptográfica de la organización."
    echo "Integra hallazgos de criptografía, malware y riesgos."
    echo ""
    echo "Archivo: crypto-analysis.md"
    echo "Conecta: Module III (Cripto) ↔ Module I (Riesgos) ↔ Module IV"
    separador
}

reto4_info() {
    separador
    echo -e "${CYAN}Reto 4: Asset Inventory + Risk Scoring${NC}"
    echo ""
    echo "Completa el inventario de activos con risk scoring cuantitativo."
    echo "Base de todo el framework de seguridad."
    echo ""
    echo "Archivo: asset-inventory.csv"
    echo "Conecta: Module I (Activos + Riesgos)"
    separador
}

reto5_info() {
    separador
    echo -e "${CYAN}Reto 5: Incident Response Playbook${NC}"
    echo ""
    echo "Crea un playbook que integra las 5 fases del IR."
    echo "Incluye detección, contención, erradicación, recuperación y lecciones."
    echo ""
    echo "Archivo: incident-playbook.md"
    echo "Conecta: Module III (IR) ↔ Module II (Red) ↔ Module IV (Malware)"
    separador
}

reto6_info() {
    separador
    echo -e "${CYAN}Reto 6: Perimeter Security Audit${NC}"
    echo ""
    echo "Auditoría completa de la seguridad perimetral."
    echo "Incluye superficie de ataque, controles, brechas y mapa de defensa en profundidad."
    echo ""
    echo "Archivo: perimeter-audit.md"
    echo "Conecta: Module II (Perímetro) ↔ Module I (Riesgos)"
    separador
}

reto7_info() {
    separador
    echo -e "${CYAN}Reto 7: Cross-Module Malware Analysis${NC}"
    echo ""
    echo "Análisis de malware que integra 4 módulos:"
    echo "Impacto en activos + Efecto en red + IR + Análisis técnico."
    echo ""
    echo "Archivo: malware-integration.md"
    echo "Conecta: Module IV (Malware) ↔ Todos los módulos"
    separador
}

reto8_info() {
    separador
    echo -e "${CYAN}Reto 8: Comprehensive Defense Report${NC}"
    echo ""
    echo "Informe integral para alta dirección."
    echo "Combina riesgos, activos, perímetro, cripto, IR y malware."
    echo ""
    echo "Archivo: defense-report.md"
    echo "Conecta: Todos los módulos → Reporting Ejecutivo"
    separador
}

reto9_info() {
    separador
    echo -e "${CYAN}Reto 9: Remediation Plan${NC}"
    echo ""
    echo "Plan de remediación priorizado con cronograma."
    echo "Integra hallazgos de todos los módulos en acciones correctivas."
    echo ""
    echo "Archivo: remediation-plan.md"
    echo "Conecta: Todos los hallazgos → Acciones Correctivas"
    separador
}

reto10_info() {
    separador
    echo -e "${CYAN}Reto 10: Final Assessment${NC}"
    echo ""
    echo "Autoevaluación de dominio en los 4 módulos."
    echo "Reflexión sobre integración cross-module y plan de mejora continua."
    echo ""
    echo "Archivo: final-assessment.md"
    echo "Conecta: Todos los módulos → Reflexión y Mejora Continua"
    separador
}

# ── Standalone execution mode ────────────────────────────────
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Unit IV Lab Integrador — Capstone del Curso"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    PASSED=0
    FAILED=0

    for i in $(seq 1 "$TOTAL_RETOS"); do
        validator="${validators[$((i-1))]}"
        name="${challenge_names[$((i-1))]}"

        if $validator >/dev/null 2>&1; then
            echo "  [PASS] Reto $i: $name"
            PASSED=$((PASSED + 1))
        else
            echo "  [FAIL] Reto $i: $name"
            FAILED=$((FAILED + 1))
        fi
    done

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Unit IV Lab Integrador Results: $PASSED/$TOTAL_RETOS passed, $FAILED failed"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    [ "$FAILED" -eq 0 ]
fi
