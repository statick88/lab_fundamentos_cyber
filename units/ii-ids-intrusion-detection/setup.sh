#!/bin/bash
# Unit II-ids: Detección de Intrusos con Suricata — setup.sh

set -e
# Support both container (/shared) and local (relative) paths
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
fi

UNIT_NAME="unit-II-ids"
UNIT_NUM=6
export TOTAL_RETOS=3

banner_unidad "$UNIT_NUM" "Detección de Intrusos con Suricata"

echo -e "${CYAN}Esta unidad cubre: IDS, Suricata, reglas de detección, análisis de alertas.${RESET}"
echo -e "${AMARILLO}Completarás 3 retos prácticos de detección de intrusiones.${RESET}\n"

# Crear directorio de trabajo
mkdir -p "$HOME/laboratorio/ids"
cd "$HOME/laboratorio/ids"

# Crear reglas personalizadas de prueba (local.rules)
cat > local.rules << 'EOF'
# Reglas de prueba para detección de intrusiones
# Formato: action protocol source_ip source_port -> dest_ip dest_port (opciones)

# Reto 2a: Detectar escaneo SSH desde red interna
alert tcp 192.168.1.0/24 any -> 10.0.0.10 22 (msg:"SSH Scan Detected"; sid:1000001; rev:1;)

# Reto 2b: Detectar intento de SQL injection en HTTP
alert http any any -> any any (msg:"SQL Injection Attempt"; content:"UNION SELECT"; sid:1000002; rev:1; http_uri;)

# Reto 2c: Detectar escaneo de puertos (SYN scan)
alert tcp any any -> 10.0.0.10 any (msg:"Port Scan Detected"; flags:S; threshold: type both, track by_src, count 5; sid:1000003; rev:1;)
EOF

chmod 644 local.rules

# Crear archivo de captura simulada para reto 3
# Formato hexdump simulado de tráfico de red con patrones de ataque
cat > simulated_traffic.log << 'EOF'
[2024-01-15 10:23:45] 192.168.1.100:54321 -> 10.0.0.10:22 TCP SYN
[2024-01-15 10:23:46] 192.168.1.100:54322 -> 10.0.0.10:22 TCP SYN
[2024-01-15 10:23:47] 192.168.1.100:54323 -> 10.0.0.10:22 TCP SYN
[2024-01-15 10:23:48] 192.168.1.100:54324 -> 10.0.0.10:22 TCP SYN
[2024-01-15 10:23:49] 192.168.1.100:54325 -> 10.0.0.10:22 TCP SYN
[2024-01-15 10:24:01] 192.168.1.101:45678 -> 10.0.0.10:80 TCP
[2024-01-15 10:24:02] 192.168.1.101:45678 -> 10.0.0.10:80 TCP GET /index.php?id=1 UNION SELECT
EOF

chmod 644 simulated_traffic.log

# Crear directorio para logs de Suricata
mkdir -p "$HOME/laboratorio/ids/suricata-logs"
chmod 755 "$HOME/laboratorio/ids/suricata-logs"

exito "Entorno de Unit II-ids preparado con 3 retos prácticos"
echo -e "${AMARILLO}Escribe ${CYAN}'manual'${AMARILLO} para ver la guía o ${CYAN}'evaluar'${AMARILLO} para evaluar.${RESET}"
