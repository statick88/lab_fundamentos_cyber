#!/bin/bash
# Unit IV: Criptografía y CVSS — setup.sh

set -e
# Support both container (/shared) and local (relative) paths
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
fi

UNIT_NAME="unit-IV"
UNIT_NUM=4
export TOTAL_RETOS=10

banner_unidad "$UNIT_NUM" "Criptografía y CVSS"

echo -e "${CYAN}Esta unidad cubre: CVSS, criptografía, análisis de amenazas, hashing.${RESET}"
echo -e "${AMARILLO}Completarás 10 retos.${RESET}\n"

mkdir -p "$HOME/laboratorio/ciberseguridad"
cd "$HOME/laboratorio/ciberseguridad"

cat > access.log << 'ACCESSLOG'
192.168.1.100 - - [10/Oct/2024:13:55:36 +0000] "GET / HTTP/1.1" 200 1234
192.168.1.101 - - [10/Oct/2024:13:55:37 +0000] "GET /admin.php?id=1 UNION SELECT NULL,NULL,NULL-- HTTP/1.1" 200 567
192.168.1.102 - - [10/Oct/2024:13:55:38 +0000] "POST /login.php HTTP/1.1" 401 0
192.168.1.103 - - [10/Oct/2024:13:55:39 +0000] "GET /../../../etc/passwd HTTP/1.1" 200 1234
192.168.1.104 - - [10/Oct/2024:13:55:40 +0000] "GET /cgi-bin/../../etc/shadow HTTP/1.1" 200 0
ACCESSLOG

cat > auth.log << 'AUTHLOG'
Oct 10 13:55:36 lab sshd[1234]: Failed password for invalid user admin from 192.168.1.200 port 22 ssh2
Oct 10 13:55:37 lab sshd[1235]: Failed password for root from 192.168.1.200 port 23 ssh2
Oct 10 13:55:38 lab sshd[1236]: Failed password for invalid user test from 192.168.1.200 port 24 ssh2
Oct 10 13:55:39 lab sshd[1237]: Accepted publickey for estudiante from 172.20.0.5 port 22 ssh2
AUTHLOG

cat > malware_simulado.bin << 'MALWARESIM'
FAKE-MALWARE-SIMULADO-HEADER-XXXX-INNOCUO-PARA-EDUCACION
MALWARESIM

cat > baseline_hashes.txt << 'HASHES'
e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855  /tmp/vacio.txt
da39a3ee5e6b4b0d3255bfef95601890afd80709  /etc/hostname
HASHES

cp /shared/cvss_calculator.py "$HOME/laboratorio/cvss_calculator.py" 2>/dev/null || true

exito "Entorno de Unit IV preparado con 10 retos"
echo -e "${AMARILLO}Escribe ${CYAN}'manual'${AMARILLO} para ver la guía o ${CYAN}'evaluar'${AMARILLO} para evaluar.${RESET}"
