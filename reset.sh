#!/bin/bash
# reset.sh - Restaura el laboratorio a estado limpio
# Uso: bash reset.sh [--progreso]

set -e
source /shared/common.sh 2>/dev/null || true

echo -e "${CYAN}🔄 Reseteando laboratorio...${RESET}"

# Detener servicios si están corriendo
echo -e "${AMARILLO}Deteniendo servicios...${RESET}"
sudo ufw disable 2>/dev/null || true
sudo systemctl stop fail2ban 2>/dev/null || true
sudo systemctl stop ufw 2>/dev/null || true

# Limpiar reglas iptables
echo -e "${AMARILLO}Limpiando reglas iptables...${RESET}"
sudo iptables -F 2>/dev/null || true
sudo iptables -X 2>/dev/null || true
sudo iptables -t nat -F 2>/dev/null || true
sudo iptables -t mangle -F 2>/dev/null || true

# Restaurar archivos de configuración modificados
echo -e "${AMARILLO}Restaurando configuraciones...${RESET}"
# UFW
sudo cp /etc/ufw/user.rules /etc/ufw/user.rules.bak 2>/dev/null || true
sudo sed -i '/# checkpoint/d' /etc/ufw/user.rules 2>/dev/null || true
sudo sed -i '/lab-cyber/d' /etc/ufw/user.rules 2>/dev/null || true
sudo sed -i '/ufw-user-input/d' /etc/ufw/user.rules 2>/dev/null || true
sudo sed -i '/CYBER_LAB/d' /etc/ufw/user.rules 2>/dev/null || true

# Sudoers
sudo rm -f /etc/sudoers.d/lab-cyber 2>/dev/null || true

# Limpiar archivos de prueba creados por retos
echo -e "${AMARILLO}Eliminando archivos de prueba...${RESET}"
rm -f /root/laboratorio/ssl/clave_privada.pem 2>/dev/null || true
rm -f /root/laboratorio/ssl/key.pem /root/laboratorio/ssl/cert.pem 2>/dev/null || true
rm -f /root/laboratorio/ssl/request.csr /root/laboratorio/ssl/key_csr.pem 2>/dev/null || true
rm -f /root/laboratorio/ssl/rsa4096.pem /root/laboratorio/ssl/ecc.key 2>/dev/null || true
rm -rf /root/laboratorio/ssl/ca 2>/dev/null || true
rm -f /root/laboratorio/shell/*.sh 2>/dev/null || true
rm -f /root/laboratorio/shell/registro.txt 2>/dev/null || true
rm -rf /root/laboratorio/redes/*.pcapng 2>/dev/null || true
rm -rf /root/laboratorio/ciberseguridad/*.log 2>/dev/null || true
rm -rf /root/laboratorio/ciberseguridad/*.bin 2>/dev/null || true
rm -rf /root/laboratorio/ciberseguridad/*.txt 2>/dev/null || true
rm -rf /root/laboratorio/iam/*.sh 2>/dev/null || true
rm -rf /root/laboratorio/logging/*.sh 2>/dev/null || true
rm -rf /root/laboratorio/logging/*.log 2>/dev/null || true
rm -rf /root/laboratorio/logging/*.md 2>/dev/null || true
rm -rf /root/laboratorio/logging/*.txt 2>/dev/null || true
rm -rf /root/laboratorio/checkpoints 2>/dev/null || true
rm -f /tmp/test_key /tmp/test_key.pub 2>/dev/null || true
rm -f /tmp/test.sig /tmp/actual_hash.txt 2>/dev/null || true
rm -f /tmp/test_logrotate.conf 2>/dev/null || true

# Limpiar logs generados
echo -e "${AMARILLO}Limpiando logs generados...${RESET}"
sudo journalctl --rotate 2>/dev/null || true
sudo journalctl --vacuum-time=1s 2>/dev/null || true

# Reiniciar contadores de progreso si se solicita
if [ "${1:-}" = "--progreso" ] || [ "${1:-}" = "-p" ]; then
    echo -e "${AMARILLO}Reiniciando progreso...${RESET}"
    rm -f "$HOME/.lab_state/progress" 2>/dev/null || true
    rm -f "$HOME/.current_unit" 2>/dev/null || true
    rm -f "$HOME/.unit_"*"_initialized" 2>/dev/null || true
    rm -f "$HOME/.units_copied" 2>/dev/null || true
    exito "Progreso reiniciado"
fi

echo ""
exito "Laboratorio reseteado correctamente"
echo -e "${CYAN}Qué se restauró:${RESET}"
echo "  ✓ Servicios detenidos (ufw, fail2ban)"
echo "  ✓ Reglas iptables limpiadas"
echo "  ✓ Configuraciones modificadas restauradas"
echo "  ✓ Archivos de prueba eliminados"
echo ""
echo -e "${CYAN}Qué NO se restauró:${RESET}"
echo "  ✗ Imágenes de Docker"
echo "  ✗ Volúmenes persistentes (lab-data)"
echo "  ✗ Paquetes instalados en la imagen base"
echo ""
echo -e "${AMARILLO}Para reset completo, usa: docker compose down && docker compose up -d${RESET}"
