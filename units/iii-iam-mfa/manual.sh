#!/bin/bash
# Unit III-iam-mfa: IAM, MFA y Control de Acceso — manual.sh

source /shared/common.sh

banner_unidad 3 "IAM, MFA y Control de Acceso"

cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║  Módulo III: Hardening e Identidades                        ║
║  Unidad III: IAM, MFA y Control de Acceso                   ║
╚══════════════════════════════════════════════════════════════╝

📚 CONCEPTOS CLAVE
══════════════════

  IAM (Identity and Access Management)
  ─────────────────────────────────────
  Gestiona identidades digitales y controla acceso a recursos.
  Componentes:
  • Usuarios y grupos
  • Roles y permisos
  • Autenticación (password, MFA, biometría)
  • Autorización (RBAC, ABAC)

  MFA (Multi-Factor Authentication)
  ──────────────────────────────────
  Combina 2+ factores:
  1. Algo que sabes (contraseña)
  2. Algo que tienes (token, smartphone)
  3. Algo que eres (huella, rostro)

  SUDOERS
  ───────
  /etc/sudoers controla quién puede ejecutar qué como root.
  Formato: usuario HOST=(runas) COMANDOS
  Ejemplo: ops_admin ALL=(ALL) NOPASSWD: /usr/bin/systemctl

  PAM (Pluggable Authentication Modules)
  ───────────────────────────────────────
  PAM permite configurar autenticación modularmente.
  google-authenticator PAM agrega TOTP (Time-based One-Time Password).

  POLÍTICA DE CONTRASEÑAS
  ────────────────────────
  /etc/login.defs define políticas:
  PASS_MAX_DAYS 90    # Expiración
  PASS_MIN_DAYS 1     # Mínimo entre cambios
  PASS_WARN_AGE 14    # Advertencia antes de expirar

🎯 RETOS DE ESTA UNIDAD
══════════════════════

  5 retos avanzados:
  1. Crear grupo sysadmins y usuario ops_admin
  2. Configurar sudoers para comandos específicos
  3. Configurar política de contraseñas
  4. Instalar Google Authenticator PAM
  5. Script de auditoría de usuarios con privilegios

💡 COMANDOS PARA EL LAB
═══════════════════════

EOF

echo -e "\n${AMARILLO}Escribe ${CYAN}'retos-unidad'${AMARILLO} para ver los retos o ${CYAN}'evaluar'${AMARILLO} para evaluar.${RESET}"
