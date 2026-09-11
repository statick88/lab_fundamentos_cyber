#!/bin/bash
# Checkpoint II: Evaluación Módulo II — manual.sh

# Dual-path sourcing
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
fi

banner_unidad 12 "Checkpoint Módulo II"

cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║  Checkpoint Módulo II: Redes y Firewalls                    ║
╚══════════════════════════════════════════════════════════════╝

📚 CONCEPTOS CLAVE
══════════════════

  Capturas de Red (PCAP)
  ──────────────────────
  Archivos que registran tráfico de red paquete a paquete.
  Herramientas: tcpdump, Wireshark, tshark.
  Formatos: .pcap, .pcapng.

  Protocolos y Puertos
  ────────────────────
  TCP/UDP usan números de puerto para identificar servicios:
    HTTP = 80/tcp    HTTPS = 443/tcp
    SSH   = 22/tcp   DNS   = 53/udp+tcp
    SMTP  = 25/tcp   RDP   = 3389/tcp

  UFW (Uncomplicated Firewall)
  ────────────────────────────
  Frontend simplificado para iptables en Ubuntu/Debian.
  Comandos esenciales:
    ufw status          → Ver reglas activas
    ufw allow 22/tcp    → Permitir SSH
    ufw deny 23/tcp     → Bloquear Telnet
    ufw enable          → Activar firewall

  iptables
  ────────
  Utilidad del kernel Linux para filtrado de paquetes.
  Cadenas: INPUT, OUTPUT, FORWARD.
  Tablas: filter, nat, mangle.
  Comando: iptables -L -n  → Listar reglas numéricamente.

  Análisis de Tráfico
  ───────────────────
  Técnicas para examinar capturas:
    grep    → Buscar patrones en payloads
    awk     → Extraer campos específicos
    tshark  → Decodificar campos de protocolo

🎯 RETOS DE ESTA UNIDAD
═══════════════════════

  Reto 1: Identificar HTTP en Captura
  ────────────────────────────────────
  Objetivo: Extraer y confirmar presencia de tráfico HTTP en la captura.
  Criterio: El archivo debe contener evidencia de HTTP (GET, POST, etc.).

  Reto 2: Identificar DNS en /etc/services
  ─────────────────────────────────────────
  Objetivo: Verificar que DNS aparece en /etc/services con puerto 53.
  Criterio: Confirmar entrada "domain" o "dns" apuntando a puerto 53.

  Reto 3: Identificar SSH en Captura
  ──────────────────────────────────
  Objetivo: Detectar cabecera SSH en la captura de red.
  Criterio: La captura debe contener evidencia de SSH o la cadena "SSH-2.0".

  Reto 4: Configurar UFW para SSH
  ───────────────────────────────
  Objetivo: Crear un script que configure UFW permitiendo SSH (22/tcp).
  Criterio: Script ejecutable con regla UFW para puerto 22/tcp.

  Reto 5: Listar Reglas iptables
  ──────────────────────────────
  Objetivo: Crear un script que liste reglas activas de iptables.
  Criterio: Script ejecutable que invoque iptables -L o equivalente.

💡 COMANDOS PARA EL LAB
═══════════════════════

  # Analizar captura
  grep -i "GET\|POST" captura_checkpoint.pcapng
  grep -c "HTTP" captura_checkpoint.pcapng

  # Verificar servicios
  cat /etc/services | grep -E "^domain|^ssh|^http"

  # UFW
  sudo ufw status numbered
  sudo ufw allow 22/tcp
  sudo ufw deny 23/tcp

  # iptables
  sudo iptables -L -n -v
  sudo iptables -S

  # Crear scripts
  chmod +x script.sh
  nano script.sh

📝 EJEMPLOS ÚTILES
══════════════════

  # Script UFW mínimo:
  #!/bin/bash
  sudo ufw --force reset
  sudo ufw default deny incoming
  sudo ufw default allow outgoing
  sudo ufw allow 22/tcp
  sudo ufw --force enable

  # Script iptables listado:
  #!/bin/bash
  echo "=== Reglas iptables ==="
  iptables -L -n --line-numbers
  echo "=== Contadores ==="
  iptables -L -n -v

EOF

echo -e "${AMARILLO}Escribe ${CYAN}'retos-unidad'${AMARILLO} para ver los retos o ${CYAN}'evaluar'${AMARILLO} para evaluar.${RESET}"
