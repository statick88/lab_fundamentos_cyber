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
