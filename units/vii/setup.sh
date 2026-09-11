#!/bin/bash
# Unit VII: Security Hardening — setup.sh
# Creates the environment and 15 challenges for learning security

set -e

# Support both container (/shared) and local (relative) paths
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
fi

UNIT_NAME="unit-VII"
UNIT_NUM=7
export TOTAL_RETOS=15

banner_unidad "$UNIT_NUM" "Seguridad del Sistema"

echo -e "${CYAN}Esta unidad ensena a proteger un servidor Linux.${RESET}"
echo -e "${AMARILLO}Completarás 15 retos progresivos.${RESET}\n"

mkdir -p "$HOME/laboratorio/security"
cd "$HOME/laboratorio/security"

# Reto 1: Verificar usuarios del sistema
cat > reto1.sh << 'EOF'
#!/bin/bash
# Reto 1: Verificar usuarios con UID 0 (solo root debe tenerlo)
awk -F: '$3 == 0 {print $1}' /etc/passwd
EOF
chmod +x reto1.sh

# Reto 2: Verificar permisos de archivos criticos
cat > reto2.sh << 'EOF'
#!/bin/bash
# Reto 2: Verificar permisos de /etc/passwd y /etc/shadow
ls -la /etc/passwd /etc/shadow
stat -c "%a %U %G" /etc/passwd /etc/shadow
EOF
chmod +x reto2.sh

# Reto 3: Verificar usuarios sin contraseña
cat > reto3.sh << 'EOF'
#!/bin/bash
# Reto 3: Buscar usuarios con campos de contraseña vacios
awk -F: '($2 == "" || $2 == "!") {print $1}' /etc/shadow
EOF
chmod +x reto3.sh

# Reto 4: Verificar sudoers
cat > reto4.sh << 'EOF'
#!/bin/bash
# Reto 4: Verificar el archivo sudoers
cat /etc/sudoers 2>/dev/null | grep -v "^#" | grep -v "^$" | head -20
EOF
chmod +x reto4.sh

# Reto 5: Verificar servicios abiertos
cat > reto5.sh << 'EOF'
#!/bin/bash
# Reto 5: Verificar puertos abiertos
ss -tuln 2>/dev/null || netstat -tuln 2>/dev/null
EOF
chmod +x reto5.sh

# Reto 6: Verificar firewall
cat > reto6.sh << 'EOF'
#!/bin/bash
# Reto 6: Verificar estado del firewall
sudo ufw status 2>/dev/null || sudo iptables -L 2>/dev/null || echo "Firewall no configurado"
EOF
chmod +x reto6.sh

# Reto 7: Verificar clave SSH
cat > reto7.sh << 'EOF'
#!/bin/bash
# Reto 7: Generar par de claves SSH si no existe
if [ ! -f ~/.ssh/id_rsa ]; then
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N "" 2>/dev/null
    echo "Clave SSH generada"
else
    echo "Clave SSH ya existe"
fi
ls -la ~/.ssh/id_rsa.pub
EOF
chmod +x reto7.sh

# Reto 8: Verificar permisos de directorio SSH
cat > reto8.sh << 'EOF'
#!/bin/bash
# Reto 8: Verificar permisos del directorio .ssh
mkdir -p ~/.ssh
chmod 700 ~/.ssh
ls -la ~ | grep ".ssh"
stat -c "%a" ~/.ssh
EOF
chmod +x reto8.sh

# Reto 9: Verificar intentos de login fallidos
cat > reto9.sh << 'EOF'
#!/bin/bash
# Reto 9: Ver intentos de login fallidos
lastb 2>/dev/null | head -10 || journalctl -u ssh 2>/dev/null | grep -i "fail" | tail -10
EOF
chmod +x reto9.sh

# Reto 10: Verificar archivos SUID
cat > reto10.sh << 'EOF'
#!/bin/bash
# Reto 10: Encontrar archivos con permisos SUID
find / -perm -4000 -type f 2>/dev/null | head -15
EOF
chmod +x reto10.sh

# Reto 11: CIS 1.1.1.1 — Verificar /tmp montado con noexec,nosuid,nodev
cat > reto11.sh << 'EOF'
#!/bin/bash
# Reto 11: Verificar opciones de montaje de /tmp (CIS 1.1.1.1)
echo "Verificando montaje de /tmp..."
echo "Opciones esperadas: noexec, nosuid, nodev"
mount | grep /tmp
grep /tmp /etc/fstab
EOF
chmod +x reto11.sh

# Reto 12: CIS 1.1.1.2 — Verificar /var montado con nosuid,nodev
cat > reto12.sh << 'EOF'
#!/bin/bash
# Reto 12: Verificar opciones de montaje de /var (CIS 1.1.1.2)
echo "Verificando montaje de /var..."
echo "Opciones esperadas: nosuid, nodev"
mount | grep " /var "
grep " /var " /etc/fstab
EOF
chmod +x reto12.sh

# Reto 13: CIS 1.1.1.3 — Verificar /var/log montado con nodev
cat > reto13.sh << 'EOF'
#!/bin/bash
# Reto 13: Verificar opciones de montaje de /var/log (CIS 1.1.1.3)
echo "Verificando montaje de /var/log..."
echo "Opciones esperadas: nodev"
mount | grep "/var/log"
grep "/var/log" /etc/fstab
EOF
chmod +x reto13.sh

# Reto 14: CIS 3.4.1.1 — PermitRootLogin deshabilitado
cat > reto14.sh << 'EOF'
#!/bin/bash
# Reto 14: Verificar PermitRootLogin en sshd_config (CIS 3.4.1.1)
echo "Verificando configuracion SSH..."
echo "PermitRootLogin debe estar en 'no'"
grep -i "PermitRootLogin" /etc/ssh/sshd_config 2>/dev/null
EOF
chmod +x reto14.sh

# Reto 15: CIS 3.4.2.1 — SSH Protocol 2
cat > reto15.sh << 'EOF'
#!/bin/bash
# Reto 15: Verificar Protocol 2 en sshd_config (CIS 3.4.2.1)
echo "Verificando Protocol SSH..."
echo "Protocol debe ser 2"
grep -i "Protocol" /etc/ssh/sshd_config 2>/dev/null
EOF
chmod +x reto15.sh

exito "Entorno de Unit VII preparado con 15 retos"
echo -e "${AMARILLO}Escribe ${CYAN}'manual'${AMARILLO} para ver las instrucciones o ${CYAN}'evaluar'${AMARILLO} para evaluar.${RESET}"
