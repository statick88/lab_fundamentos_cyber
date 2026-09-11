#!/bin/bash
# Unit IV: Criptografía y CVSS — manual.sh

# Support both container (/shared) and local (relative) paths
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
fi

banner_unidad 4 "Criptografía y CVSS"

cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║  Módulo IV: Amenazas, Criptografía y Vulnerabilidades       ║
║  Unidad IV: Criptografía y CVSS                             ║
╚══════════════════════════════════════════════════════════════╝

📚 CONCEPTOS CLAVE
══════════════════

  CVSS (Common Vulnerability Scoring System)
  ───────────────────────────────────────────
  Sistema estándar para clasificar severidad de vulnerabilidades.
  Versión 3.1 usa métricas:
  • Base: AV (Attack Vector), AC (Attack Complexity), PR (Privileges Required)
  • Base: UI (User Interaction), S (Scope), C/I/A (Confidentiality/Integrity/Availability)
  • Temporal: E (Exploitability), RL (Remediation Level), RC (Report Confidence)
  • Environmental: ajustes específicos de la organización

  Valores AV: Network(N)=0.85, Adjacent(A)=0.62, Local(L)=0.55, Physical(P)=0.2
  Valores AC: Low(L)=0.77, High(H)=0.44
  Valores PR: None(N)=0.85, Low(L)=0.62, High(H)=0.27
  Valores UI: None(N)=0.85, Required(R)=0.62

  Severity Rating:
  0.0 - 3.9  = Low (Bajo)
  4.0 - 6.9  = Medium (Medio)
  7.0 - 8.9  = High (Alto)
  9.0 - 10.0 = Critical (Crítico)

  HASHES CRIPTOGRÁFICOS
  ──────────────────────
  SHA-256: 256 bits, estándar actual
  SHA-3: diseño diferente (Keccak), más resistente a ciertos ataques
  Uso: verificar integridad de archivos, detectar malware

  VERIFICACIÓN DE FIRMAS
  ──────────────────────
  GPG/OpenSSL: clave privada firma, clave pública verifica.
  Garantiza: autenticidad, integridad, no repudio.

  ANÁLISIS DE AMENAZAS
  ─────────────────────
  • SQL Injection: union, select, insert, drop en logs
  • Path Traversal: ../ , /etc/passwd, cgi-bin
  • Phishing: X-Priority alto, Reply-To sospechoso, links acortados

🎯 RETOS DE ESTA UNIDAD
══════════════════════

  10 retos:
  1. Calcular CVSS base para RCE en HTTP
  2. Calcular CVSS para XSS reflejado
  3. Calcular CVSS para buffer overflow local
  4. Determinar severity rating
  5. Identificar vector de ataque en log
  6. Identificar SQL injection en log
  7. Identificar path traversal en log
  8. Analizar headers de phishing
  9. Generar hashes SHA-256
  10. Comparar hashes contra baseline

💡 COMANDOS PARA EL LAB
═══════════════════════

EOF

echo -e "\n${AMARILLO}Escribe ${CYAN}'retos-unidad'${AMARILLO} para ver los retos o ${CYAN}'evaluar'${AMARILLO} para evaluar.${RESET}"
