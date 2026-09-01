#!/bin/bash
# Unit II: Filtrado de Red y Firewalls — manual.sh

source /shared/common.sh

banner_unidad 2 "Filtrado de Red y Firewalls"

cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║  Módulo II: Redes y Controles Perimetrales                 ║
║  Unidad II: Filtrado de Red y Firewalls                    ║
╚══════════════════════════════════════════════════════════════╝

📚 CONCEPTOS CLAVE
══════════════════

  PROTOCOLOS Y PUERTOS ESTÁNDAR
  ──────────────────────────────
  HTTP     80/tcp    Navegación web sin cifrar
  HTTPS    443/tcp   Navegación web cifrada (TLS)
  SSH      22/tcp    Administración remota segura
  DNS      53/udp    Resolución de nombres
  TELNET   23/tcp    Terminal remota INSEGURA (no usar)
  FTP      21/tcp    Transferencia de archivos (inseguro)
  SMTP     25/tcp    Correo electrónico

  FIREWALLS
  ─────────
  Un firewall filtra tráfico de red según reglas.
  Tipos principales:
  • iptables/nftables: firewall a nivel kernel Linux
  • ufw: interfaz simplificada de iptables
  • firewalld: usado en RHEL/CentOS

  REGLAS UFW (Ubuntu)
  ───────────────────
  sudo ufw allow 22/tcp     # Permitir SSH
  sudo ufw deny 23/tcp      # Denegar Telnet
  sudo ufw allow 80,443/tcp # Permitir HTTP/HTTPS
  sudo ufw enable           # Activar firewall
  sudo ufw status verbose   # Ver reglas

  REGLAS IPTABLES
  ───────────────
  sudo iptables -A INPUT -s 192.168.1.100 -j DROP   # Bloquear IP
  sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT # Permitir SSH
  sudo iptables -L -n -v    # Listar reglas
  sudo iptables -F          # Limpiar todas las reglas

  ANÁLISIS DE CAPTURAS DE RED
  ───────────────────────────
  tcpdump: captura y analiza paquetes
  nmap: escanea puertos y servicios
  Wireshark: análisis GUI de capturas .pcapng

🎯 RETOS DE ESTA UNIDAD
══════════════════════

  10 retos prácticos:
  1. Identificar HTTP (puerto 80) en captura
  2. Identificar HTTPS (puerto 443)
  3. Identificar SSH (puerto 22)
  4. Identificar DNS (puerto 53)
  5. Configurar regla UFW permitir SSH
  6. Configurar regla UFW denegar puerto 23
  7. Configurar regla UFW permitir HTTP/HTTPS
  8. Configurar iptables DROP a IP sospechosa
  9. Listar reglas activas de iptables
  10. Identificar escaneo de puertos en captura

💡 COMANDOS PARA EL LAB
═══════════════════════

EOF

echo -e "\n${AMARILLO}Escribe ${CYAN}'retos-unidad'${AMARILLO} para ver los retos o ${CYAN}'evaluar-unidad'${AMARILLO} para evaluar.${RESET}"
