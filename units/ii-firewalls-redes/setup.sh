#!/bin/bash
# Unit II: Filtrado de Red y Firewalls — setup.sh

set -e
# Support both container (/shared) and local (relative) paths
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
fi

UNIT_NAME="unit-II"
UNIT_NUM=2
export TOTAL_RETOS=10

banner_unidad "$UNIT_NUM" "Filtrado de Red y Firewalls"

echo -e "${CYAN}Esta unidad cubre: protocolos de red, firewalls, iptables/ufw.${RESET}"
echo -e "${AMARILLO}Completarás 10 retos prácticos.${RESET}\n"

mkdir -p "$HOME/laboratorio/redes"
cd "$HOME/laboratorio/redes"

# Crear archivos de captura simulada (formato hex/ASCII)
cat > captura_http.pcapng << 'EOF'
0000  00 00 00 00 00 00 00 00  00 00 00 00 45 00 00 3c  ..............E..<
0010  1c 46 40 00 40 06 b0 02  0a 00 02 01 0a 00 02 02  .F@.@...........
0020  00 50 00 50 00 00 00 00  00 00 00 00 50 02 20 00  .P.P......... ...
0030  7a 1c 00 00 47 45 54 20  2f 20 48 54 54 50 2f 31  z...GET / HTTP/1
0040  2e 31 0d 0a 48 6f 73 74  3a 20 65 78 61 6d 70 6c  .1..Host: exampl
0050  65 2e 63 6f 6d 0d 0a 0d  0a                        e.com....
EOF

cat > captura_ssh.pcapng << 'EOF'
0000  00 00 00 00 00 00 00 00  00 00 00 00 45 00 00 28  ..............E..(
0010  00 01 00 00 ff 06 0a 00  0a 00 02 01 0a 00 02 02  ................
0020  00 16 00 16 00 00 00 00  00 00 00 00 50 02 20 00  .............. ..
0030  7a 1c 00 00 53 53 48 2d  32 2e 30 2d 4f 70 65 6e  z...SSH-2.0-Open
0040  53 53 48 5f 38 2e 39 70  31 0d 0a                SSH_8.9p1..
EOF

cat > captura_dns.pcapng << 'EOF'
0000  00 00 00 00 00 00 00 00  00 00 00 00 45 00 00 2c  ..............E..,
0010  00 01 00 00 ff 06 0a 00  0a 00 02 01 0a 00 02 02  ................
0020  00 35 00 35 00 00 00 00  00 00 00 00 50 02 20 00  .5.5. ..........
0030  7a 1c 00 00 85 a4 01 00  00 01 00 00 00 00 00 00  z...............
0040  03 77 77 77 06 67 6f 6f  67 6c 65 03 63 6f 6d 00  www.google.com.
0050  00 01 00 01                                        ....
EOF

cat > captura_scan.pcapng << 'EOF'
0000  00 00 00 00 00 00 00 00  00 00 00 00 45 00 00 28  ..............E..(
0010  40 01 40 00 ff 06 00 00  0a 00 02 02 0a 00 02 01  @.@.............
0020  00 00 00 00 00 00 00 00  00 00 00 00 50 02 20 00  .............. ..
0030  7a 1c 00 00 00 00 00 00  00 00 00 00 00 00 00 00  z...............
0040  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  ................
EOF

exito "Entorno de Unit II preparado con 10 retos prácticos"
echo -e "${AMARILLO}Escribe ${CYAN}'manual'${AMARILLO} para ver la guía o ${CYAN}'evaluar'${AMARILLO} para evaluar.${RESET}"

# Crear scaffolds de scripts para retos de firewall (estudiante los completa)
cat > ufw_ssh.sh << 'EOF'
#!/bin/bash
# Reto 5: Permitir SSH con UFW
echo "sudo ufw allow 22/tcp" > /dev/null
EOF
chmod +x ufw_ssh.sh

cat > ufw_telnet.sh << 'EOF'
#!/bin/bash
# Reto 6: Denegar Telnet con UFW
echo "sudo ufw deny 23/tcp" > /dev/null
EOF
chmod +x ufw_telnet.sh

cat > ufw_web.sh << 'EOF'
#!/bin/bash
# Reto 7: Permitir HTTP y HTTPS con UFW
echo "sudo ufw allow 80/tcp" > /dev/null
echo "sudo ufw allow 443/tcp" > /dev/null
EOF
chmod +x ufw_web.sh

cat > iptables_block.sh << 'EOF'
#!/bin/bash
# Reto 8: Bloquear IP sospechosa con iptables
echo "sudo iptables -A INPUT -s 10.0.0.99 -j DROP" > /dev/null
EOF
chmod +x iptables_block.sh

cat > iptables_list.sh << 'EOF'
#!/bin/bash
# Reto 9: Listar reglas de iptables
echo "sudo iptables -L -n -v" > /dev/null
EOF
chmod +x iptables_list.sh
