#!/bin/bash
# Unit V: Logging, SIEM y BCP — setup.sh

set -e
source /shared/common.sh

UNIT_NAME="unit-V"
UNIT_NUM=5
export TOTAL_RETOS=10

banner_unidad "$UNIT_NUM" "Logging, SIEM y BCP"

echo -e "${CYAN}Esta unidad cubre: logging, SIEM, análisis de logs, BCP, IR.${RESET}"
echo -e "${AMARILLO}Completarás 10 retos.${RESET}\n"

mkdir -p "$HOME/laboratorio/logging"
cd "$HOME/laboratorio/logging"

# Crear logs simulados para análisis
cat > apache_access.log << 'EOF'
192.168.1.1 - - [10/Oct/2024:13:55:36 +0000] "GET /index.html HTTP/1.1" 200 1234
192.168.1.2 - - [10/Oct/2024:13:55:37 +0000] "POST /login HTTP/1.1" 200 512
192.168.1.3 - - [10/Oct/2024:13:55:38 +0000] "GET /admin HTTP/1.1" 401 0
192.168.1.4 - - [10/Oct/2024:13:55:39 +0000] "GET /style.css HTTP/1.1" 200 890
192.168.1.5 - - [10/Oct/2024:13:55:40 +0000] "GET /api/users HTTP/1.1" 500 123
EOF

cat > auth_sys.log << 'EOF'
Oct 10 13:55:36 lab sshd[1234]: Failed password for invalid user admin from 192.168.1.200 port 22 ssh2
Oct 10 13:55:37 lab sshd[1235]: Accepted publickey for estudiante from 172.20.0.5 port 22 ssh2
Oct 10 13:55:38 lab systemd[1]: Started Session 123 of user estudiante.
Oct 10 13:55:39 lab CRON[1236]: (root) CMD (/usr/local/bin/backup.sh)
EOF

cat > mi_app.log << 'EOF'
2024-10-10 13:55:36 INFO  [Main] Aplicación iniciada correctamente
2024-10-10 13:55:37 WARN  [DB] Conexión a base de datos lenta (500ms)
2024-10-10 13:55:38 ERROR [API] Timeout al conectar con servicio externo
2024-10-10 13:55:39 INFO  [Cache] Cache limpiado: 45 entradas eliminadas
2024-10-10 13:55:40 CRIT  [Auth] Múltiples intentos fallidos de autenticación
EOF

exito "Entorno de Unit V preparado con 10 retos"
echo -e "${AMARILLO}Escribe ${CYAN}'manual'${AMARILLO} para ver la guía o ${CYAN}'evaluar'${AMARILLO} para evaluar.${RESET}"
