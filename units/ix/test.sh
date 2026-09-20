#!/bin/bash
# Unit IX: Web Server (nginx) — test.sh
# Refactorizado (C4): usa /shared/validators.sh + /shared/sudo-wrappers.sh

source /shared/common.sh
source /shared/validators.sh
source /shared/sudo-wrappers.sh

UNIT_NAME="unit-IX"
TOTAL_RETOS=10

reto1() {
    assert_command_ok nginx -v
}

reto2() {
    nginx 2>/dev/null || true
    sleep 1
    local output
    output=$(curl -s http://localhost 2>/dev/null)
    [ -n "$output" ]
}

reto3() {
    assert_file_contains /etc/nginx/nginx.conf "server\|events\|http"
}

reto4() {
    local webdir="$HOME/laboratorio/web"
    mkdir -p "$webdir"
    cat > "$webdir/index.html" << 'HTML'
<!DOCTYPE html><html><body><h1>Test Page</h1></body></html>
HTML
    local output
    output=$(curl -s http://localhost 2>/dev/null)
    [ -n "$output" ]
}

reto5() {
    local output
    output=$(ls /etc/nginx/sites-available/ 2>/dev/null)
    [ -n "$output" ]
}

reto6() {
    local output
    output=$(ls /var/log/nginx/ 2>/dev/null)
    assert_file_contains /dev/stdin "access\|error" <<< "$output"
}

reto7() {
    local output
    output=$(ls /etc/nginx/sites-enabled/ 2>/dev/null)
    [ -n "$output" ]
}

reto8() {
    local output
    output=$(nginx -t 2>&1)
    assert_file_contains /dev/stdin "successful\|ok\|syntax" <<< "$output"
}

reto9() {
    nginx -s reload 2>/dev/null || true
    sleep 1
    local output
    output=$(nginx -t 2>&1)
    assert_file_contains /dev/stdin "successful\|ok\|syntax" <<< "$output"
}

reto10() {
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
    echo "Confirma que nginx esta instalado y accesible en el PATH."
    echo ""
    echo "Comandos utiles:"
    echo "  nginx -v"
    separador
}

reto2_info() {
    separador
    echo -e "${CYAN}Reto 2: Iniciar nginx${NC}"
    echo ""
    echo "Inicia el servidor nginx y verifica que responda peticiones HTTP."
    echo ""
    echo "Comandos utiles:"
    echo "  nginx"
    echo "  curl http://localhost"
    separador
}

reto3_info() {
    separador
    echo -e "${CYAN}Reto 3: Ver configuracion${NC}"
    echo ""
    echo "Inspecciona el archivo de configuracion principal de nginx."
    echo ""
    echo "Comandos utiles:"
    echo "  cat /etc/nginx/nginx.conf"
    separador
}

reto4_info() {
    separador
    echo -e "${CYAN}Reto 4: Crear pagina personalizada${NC}"
    echo ""
    echo "Crea una pagina HTML personalizada en el directorio del estudiante."
    echo "Configura nginx para servir ese contenido."
    echo ""
    echo "Comandos utiles:"
    echo "  mkdir -p ~/laboratorio/web"
    echo "  echo '<h1>Mi pagina</h1>' > ~/laboratorio/web/index.html"
    separador
}

reto5_info() {
    separador
    echo -e "${CYAN}Reto 5: Configurar virtual host${NC}"
    echo ""
    echo "Crea un bloque server en sites-available para un virtual host."
    echo "Un virtual host permite servir multiples sitios en un mismo servidor."
    echo ""
    echo "Comandos utiles:"
    echo "  ls /etc/nginx/sites-available/"
    echo "  touch /etc/nginx/sites-available/mi-sitio"
    separador
}

reto6_info() {
    separador
    echo -e "${CYAN}Reto 6: Ver logs de nginx${NC}"
    echo ""
    echo "Explora los archivos de log de nginx para ver trafico y errores."
    echo ""
    echo "Comandos utiles:"
    echo "  ls /var/log/nginx/"
    echo "  tail -f /var/log/nginx/access.log"
    separador
}

reto7_info() {
    separador
    echo -e "${CYAN}Reto 7: Verificar sitios activos${NC}"
    echo ""
    echo "Comprueba que sitios estan habilitados en sites-enabled."
    echo "Solo los sitios con symlink en sites-enabled estan activos."
    echo ""
    echo "Comandos utiles:"
    echo "  ls -la /etc/nginx/sites-enabled/"
    separador
}

reto8_info() {
    separador
    echo -e "${CYAN}Reto 8: Probar configuracion${NC}"
    echo ""
    echo "Valida la sintaxis del archivo de configuracion de nginx."
    echo "Siempre prueba la configuracion antes de recargar el servicio."
    echo ""
    echo "Comandos utiles:"
    echo "  nginx -t"
    separador
}

reto9_info() {
    separador
    echo -e "${CYAN}Reto 9: Recargar nginx${NC}"
    echo ""
    echo "Recarga la configuracion de nginx sin detener el servicio."
    echo "Util cuando aplicas cambios en configuracion o virtual hosts."
    echo ""
    echo "Comandos utiles:"
    echo "  nginx -s reload"
    echo "  nginx -t && nginx -s reload"
    separador
}

reto10_info() {
    separador
    echo -e "${CYAN}Reto 10: Detener nginx${NC}"
    echo ""
    echo "Detiene todos los procesos de nginx que esten ejecutandose."
    echo ""
    echo "Comandos utiles:"
    echo "  pkill nginx"
    echo "  nginx -s stop"
    separador
}

# ── Standalone execution mode ────────────────────────
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Unit IX: Web Server (nginx) — Retos"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    PASSED=0
    FAILED=0

    for i in $(seq 1 "$TOTAL_RETOS"); do
        validator="${validators[$((i-1))]}"
        name="${challenge_names[$((i-1))]}"

        if $validator >/dev/null 2>&1; then
            echo "  [PASS] Reto $i: $name"
            PASSED=$((PASSED + 1))
        else
            echo "  [FAIL] Reto $i: $name"
            FAILED=$((FAILED + 1))
        fi
    done

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Unit IX Results: $PASSED/$TOTAL_RETOS passed, $FAILED failed"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    [ "$FAILED" -eq 0 ]
fi
