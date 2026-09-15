#!/bin/bash
# Unit IV: Burp Suite Intercepción de Tráfico HTTP — manual.sh

# Support both container (/shared) and local (relative) paths
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
fi

UNIT_NUM=26

banner_unidad "$UNIT_NUM" "Burp Suite Intercepción HTTP"

echo -e "${CYAN}=== Guía de Laboratorio: Burp Suite Intercepción HTTP ===${RESET}\n"

echo -e "${AMARILLO}OBJETIVO:${RESET}"
echo "Configurar Burp Suite como proxy interceptador entre un cliente HTTP"
echo "y un servidor web Flask objetivo, capturar tráfico en tránsito y"
echo "modificar parámetros críticos (precio, rol, headers de autenticación).\n"

echo -e "${AMARILLO}PASO 1: Levantar el servidor objetivo${RESET}"
echo "  1. El servidor Flask se levanta automáticamente con: python3 server.py"
echo "  2. Escucha en http://localhost:5000"
echo "  3. Endpoints disponibles:"
echo "     • GET  /  — muestra producto y rol como parámetros de query"
echo "     • POST /compra  — envía datos de compra (producto, precio, rol)"
echo ""

echo -e "${AMARILLO}PASO 2: Configurar Burp Suite${RESET}"
echo "  1. Abre Burp Suite"
echo "  2. Ve a 'Proxy → Options'"
echo "  3. Añade el proxy listener en Port 8080"
echo "  4. habilita 'Intercept is enabled'"
echo "  5. Ve a 'Proxy → Intercept'"
echo "  6. Activa el interruptor de interceptación (en verde)"
echo ""

echo -e "${AMARILLO}PASO 3: Interceptar y modificar tráfico${RESET}"
echo "  Escenario: Petición HTTP GET con parámetros de producto y rol"
echo ""
echo "  Flujo:"
echo "  ① Cliente (curl o navegador) envía petición a través de proxy 8080"
echo " ② Burp intercepta la petición en tránsito"
echo " ③ Estudiante modifica un parámetro crítico (precio/rol/header)"
echo " ④ Burp reenvía la petición modificada al servidor"
echo " ⑤ Servidor responde con los valores modificados"
echo ""
echo "  Ejemplo con curl:"
echo "  $ curl -x localhost:8080 'http://localhost:5000?producto=laptop&rol=usuario'"
echo ""
echo -e "${AMARILLO}PASO 4: Validar la modificación${RESET}"
echo "  • Revisa la pestaña 'Logger' en Burp para ver el tráfico completo"
echo "  • Verifica que el parámetro modificado aparezca en la respuesta"
echo "  • Confirma el archivo $HOME/laboratorio/burp/modificado.txt contiene '1'"
echo ""

echo -e "${AMARILLO}PASO 5: Ejemplos de modificaciones${RESET}"
echo "  1. Modificar precio: de \$999 a \$50 en el cuerpo POST"
echo "  2. Cambiar rol: de 'usuario' a 'admin' en headers o cuerpo"
echo "  3. Añadir cabecera X-Interceptado: true"
echo ""
echo -e "${AMARILLO}PASO 6: Comandos de verificación${RESET}"
echo "  $ cat $HOME/laboratorio/burp/modificado.txt"
echo "  $ grep MODIFICADO $HOME/laboratorio/burp/proxy_log.txt"
echo ""

echo -e "${CYAN}=== Buena suerte con la intercepción HTTP ===${RESET}"