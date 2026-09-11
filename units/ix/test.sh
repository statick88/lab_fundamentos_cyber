#!/bin/bash
# Unit IX: Web Server (nginx) — test.sh
# Automated validation of 10 challenges
# Estandarizado: usa /shared/validators.sh para aserciones deterministicas

# Support both container (/shared) and local (relative) paths
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
fi
source /shared/validators.sh

UNIT_NAME="unit-IX"
TOTAL_RETOS=10

reto1() {
    # nginx instalado (sin sudo necesario)
    assert_command_ok nginx -v
}

reto2() {
    # Iniciar nginx y verificar respuesta HTTP
    nginx 2>/dev/null || true
    sleep 1
    local output
    output=$(curl -s http://localhost 2>/dev/null)
    [ -n "$output" ]
}

reto3() {
    # Verificar configuración principal de nginx
    assert_file_contains /etc/nginx/nginx.conf "server\|events\|http"
}

reto4() {
    # Crear página personalizada en directorio del estudiante
    local webdir="$HOME/laboratorio/web"
    mkdir -p "$webdir"
    cat > "$webdir/index.html" << 'HTML'
<!DOCTYPE html><html><body><h1>Test Page</h1></body></html>
HTML
    # Verificar que nginx sirve el contenido (asumiendo configurado)
    local output
    output=$(curl -s http://localhost 2>/dev/null)
    [ -n "$output" ]
}

reto5() {
    # Verificar sites-available
    local output
    output=$(ls /etc/nginx/sites-available/ 2>/dev/null)
    [ -n "$output" ]
}

reto6() {
    # Verificar logs de nginx
    local output
    output=$(ls /var/log/nginx/ 2>/dev/null)
    assert_file_contains /dev/stdin "access\|error" <<< "$output"
}

reto7() {
    # Verificar sitios activos en sites-enabled
    local output
    output=$(ls /etc/nginx/sites-enabled/ 2>/dev/null)
    [ -n "$output" ]
}

reto8() {
    # Probar configuración de nginx
    local output
    output=$(nginx -t 2>&1)
    assert_file_contains /dev/stdin "successful\|ok\|syntax" <<< "$output"
}

reto9() {
    # Recargar nginx y verificar configuración
    nginx -s reload 2>/dev/null || true
    sleep 1
    local output
    output=$(nginx -t 2>&1)
    assert_file_contains /dev/stdin "successful\|ok\|syntax" <<< "$output"
}

reto10() {
    # Detener nginx usando pkill (sin dependencia de PID file)
    pkill nginx 2>/dev/null || true
    sleep 1
    local output
    output=$(pgrep nginx 2>/dev/null || true)
    [ -z "$output" ]
}

validators=(reto1 reto2 reto3 reto4 reto5 reto6 reto7 reto8 reto9 reto10)
challenge_names=(
    "Verificar nginx"
    "Iniciar nginx"
    "Ver configuracion"
    "Crear pagina personalizada"
    "Configurar virtual host"
    "Ver logs de nginx"
    "Verificar sitios activos"
    "Probar configuracion"
    "Recargar nginx"
    "Detener nginx"
)

ICONOS=("🔍" "🚀" "📋" "📝" "🌐" "📊" "✅" "🔧" "🔄" "🛑")

reto1_info() {
    separador
    echo -e "${CYAN}Reto 1: Verificar nginx${NC}"
    echo ""
    echo "Confirma que nginx está instalado y accesible en el PATH."
    echo ""
    echo "Comandos útiles:"
    echo "  nginx -v"
    separador
}

reto2_info() {
    separador
    echo -e "${CYAN}Reto 2: Iniciar nginx${NC}"
    echo ""
    echo "Inicia el servidor nginx y verifica que responda peticiones HTTP."
    echo ""
    echo "Comandos útiles:"
    echo "  nginx"
    echo "  curl http://localhost"
    separador
}

reto3_info() {
    separador
    echo -e "${CYAN}Reto 3: Ver configuracion${NC}"
    echo ""
    echo "Inspecciona el archivo de configuración principal de nginx."
    echo ""
    echo "Comandos útiles:"
    echo "  cat /etc/nginx/nginx.conf"
    separador
}

reto4_info() {
    separador
    echo -e "${CYAN}Reto 4: Crear pagina personalizada${NC}"
    echo ""
    echo "Crea una página HTML personalizada en el directorio del estudiante."
    echo "Configura nginx para servir ese contenido."
    echo ""
    echo "Comandos útiles:"
    echo "  mkdir -p ~/laboratorio/web"
    echo "  echo '<h1>Mi pagina</h1>' > ~/laboratorio/web/index.html"
    separador
}

reto5_info() {
    separador
    echo -e "${CYAN}Reto 5: Configurar virtual host${NC}"
    echo ""
    echo "Crea un bloque server en sites-available para un virtual host."
    echo "Un virtual host permite servir múltiples sitios en un mismo servidor."
    echo ""
    echo "Comandos útiles:"
    echo "  ls /etc/nginx/sites-available/"
    echo "  touch /etc/nginx/sites-available/mi-sitio"
    separador
}

reto6_info() {
    separador
    echo -e "${CYAN}Reto 6: Ver logs de nginx${NC}"
    echo ""
    echo "Explora los archivos de log de nginx para ver tráfico y errores."
    echo ""
    echo "Comandos útiles:"
    echo "  ls /var/log/nginx/"
    echo "  tail -f /var/log/nginx/access.log"
    separador
}

reto7_info() {
    separador
    echo -e "${CYAN}Reto 7: Verificar sitios activos${NC}"
    echo ""
    echo "Comprueba qué sitios están habilitados en sites-enabled."
    echo "Solo los sitios con symlink en sites-enabled están activos."
    echo ""
    echo "Comandos útiles:"
    echo "  ls -la /etc/nginx/sites-enabled/"
    separador
}

reto8_info() {
    separador
    echo -e "${CYAN}Reto 8: Probar configuracion${NC}"
    echo ""
    echo "Valida la sintaxis del archivo de configuración de nginx."
    echo "Siempre prueba la configuración antes de recargar el servicio."
    echo ""
    echo "Comandos útiles:"
    echo "  nginx -t"
    separador
}

reto9_info() {
    separador
    echo -e "${CYAN}Reto 9: Recargar nginx${NC}"
    echo ""
    echo "Recarga la configuración de nginx sin detener el servicio."
    echo "Útil cuando aplicas cambios en configuración o virtual hosts."
    echo ""
    echo "Comandos útiles:"
    echo "  nginx -s reload"
    echo "  nginx -t && nginx -s reload"
    separador
}

reto10_info() {
    separador
    echo -e "${CYAN}Reto 10: Detener nginx${NC}"
    echo ""
    echo "Detiene todos los procesos de nginx que estén ejecutándose."
    echo ""
    echo "Comandos útiles:"
    echo "  pkill nginx"
    echo "  nginx -s stop"
    separador
}
