#!/bin/bash
# Unit IV: Burp Suite Intercepción de Tráfico HTTP — setup.sh

set -e
# Support both container (/shared) and local (relative) paths
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
fi

UNIT_NAME="unit-IV-burp"
UNIT_NUM=26
export TOTAL_RETOS=3

banner_unidad "$UNIT_NUM" "Burp Suite Intercepción HTTP"
echo -e "${CYAN}Escenario Docker local con servidor web Flask como objetivo${RESET}"
echo -e "${AMARILLO}Configurarás Burp Suite para interceptar tráfico HTTP/HTTPS${RESET}\n"

mkdir -p "$HOME/laboratorio/burp"
cd "$HOME/laboratorio/burp"

# Iniciar servidor web Flask en segundo plano
python3 -c "
from flask import Flask, request
app = Flask(__name__)

@app.route('/')
def index():
    producto = request.args.get('producto', 'laptop')
    rol = request.args.get('rol', 'usuario')
    return f'Hola! Producto: {producto}, Rol: {rol}'

@app.route('/compra', methods=['POST'])
def compra():
    producto = request.form.get('producto', 'desconocido')
    precio = request.form.get('precio', '0')
    rol = request.form.get('rol', 'usuario')
    # Simulación: precio original $999, rol 'usuario' normal
    if precio == '999' and rol == 'usuario':
        # Modificar precio a $50 en tránsito (intercepción Burp)
        pass
    return f'Compra registrada: {producto} - \${precio} - Rol: {rol}'
"

SERVER_PID=$!
echo "Servidor Flask iniciado PID=$SERVER_PID en http://localhost:5000"
echo "Servidor listo para interceptación con Burp Suite"

cat > intercept_config.conf << 'INTERCEPTCFG'
# Configuración de interceptación Burp Suite
# Proxy configuración: localhost:8080
# Target: http://localhost:5000
# Modo: interceptar y modificar headers/cuerpo
INTERCEPTCFG

exito "Entorno Burp Suite preparado con 3 retos"
echo -e "${AMARILLO}Intercepta, modifica y valida en tránsito${RESET}"
echo -e "${AMARILLO}Usa: burp config → localhost:8080 → proxy HTTP${RESET}"