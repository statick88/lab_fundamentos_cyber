#!/bin/bash
# =============================================================================
# entrypoint.sh - Punto de entrada del contenedor del laboratorio
# Curso: Fundamentos de Ciberseguridad ABC-CYB-101
# =============================================================================

source /shared/common.sh
source /shared/interactive.sh

# ─── Copiar unidades desde /opt si no existen ────────────────────────────────
UNITS_MARKER="$HOME/.units_copied"
if [ ! -f "$UNITS_MARKER" ]; then
    info "Copiando unidades del curso al directorio de trabajo..."
    mkdir -p "$HOME/laboratorio/units"
    cp -r /opt/lab-units/* "$HOME/laboratorio/units/" 2>/dev/null || true
    touch "$UNITS_MARKER"
fi

# ─── Crear directorios de ejercicios que no vienen de setup.sh ───────────────
EXERCISES_MARKER="$HOME/.exercises_scaffolded"
if [ ! -f "$EXERCISES_MARKER" ]; then
    info "Creando directorios de ejercicios..."

    # M4 E5 — Nginx hardening (carpeta de trabajo del estudiante)
    mkdir -p "$HOME/laboratorio/nginx-hardening"
    [ -f "$HOME/laboratorio/nginx-hardening/nginx.conf" ] || cat > "$HOME/laboratorio/nginx-hardening/nginx.conf" <<'NGINXCONF'
# TODO: Configurar nginx para escuchar solo en HTTPS
# Requisitos:
#   - Escuchar únicamente en puerto 443 (HTTPS)
#   - Deshabilitar directors listing
#   - Configurar headers de seguridad
#   - Usar certificados TLS del directorio ../certificados/
server {
    listen 443 ssl;
    server_name localhost;

    ssl_certificate     /etc/nginx/certs/servidor.crt;
    ssl_certificate_key /etc/nginx/certs/servidor.key;

    # TODO: Agregar headers de seguridad
    # TODO: Deshabilitar directorio listing
}
NGINXCONF
    [ -f "$HOME/laboratorio/nginx-hardening/Dockerfile" ] || cat > "$HOME/laboratorio/nginx-hardening/Dockerfile" <<'DOCKERFILE'
FROM nginx:alpine
# TODO: Copiar nginx.conf y certificados, exponer solo 443
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY ../certificados/servidor.crt /etc/nginx/certs/servidor.crt
COPY ../certificados/servidor.key /etc/nginx/certs/servidor.key
EXPOSE 443
DOCKERFILE

    # M6 E5 — Certificados TLS (carpeta de trabajo del estudiante)
    mkdir -p "$HOME/laboratorio/certificados"
    [ -f "$HOME/laboratorio/certificados/servidor.key" ] || openssl genrsa -out "$HOME/laboratorio/certificados/servidor.key" 2048 2>/dev/null
    [ -f "$HOME/laboratorio/certificados/servidor.crt" ] || openssl req -x509 -new -nodes \
        -key "$HOME/laboratorio/certificados/servidor.key" \
        -sha256 -days 365 \
        -out "$HOME/laboratorio/certificados/servidor.crt" \
        -subj "/C=EC/ST=Loja/L=Loja/O=CyberLab/CN=localhost" 2>/dev/null

    touch "$EXERCISES_MARKER"
fi

# ─── Detectar primer inicio y limpiar progreso anterior ──────────────────────
MARKER="$HOME/.lab_initialized"
if [ ! -f "$MARKER" ]; then
    rm -f "$HOME/laboratorio/.reto"_completado 2>/dev/null
    rm -f "$HOME/laboratorio/.reto"*"_completado" 2>/dev/null
    rm -f "/shared/.state/progress" 2>/dev/null
    touch "$MARKER"
fi

# ─── Crear .bash_aliases para que cada nuevo shell tenga los comandos ────────
cp ~/.bash_aliases ~/.bash_aliases.bak 2>/dev/null || true
cat > ~/.bash_aliases <<'ALIASES'
# Cargar funciones del laboratorio
source /shared/common.sh
source /shared/interactive.sh

# Comandos principales (como funciones para compatibilidad con bash -c)
menu() { menu_interactivo "$@"; }
jugar() { jugar_interactivo "$@"; }
retos() { ver_retos_unidad "$@"; }
evaluar() { evaluar_interactivo "$@"; }
progreso() { mostrar_progreso_global "$@"; }
pista() { dar_pista "$@"; }

# Frase secreta
revelar-frase() { ver_frase "$@"; }
s() { ver_frase "$@"; }

# Wrapper para unidad
unidad() {
    source /shared/common.sh
    source /shared/unidad.sh
    bash /shared/unidad.sh "$@"
}

# Aliases específicos ciberseguridad
alias ciberseguridad='unidad 1'
alias redes='unidad 2'
alias hardening='unidad 7'
alias criptografia='unidad 4'
alias logging='unidad 5'
alias amenazas='unidad 4'
ALIASES

# ─── Script ~/bin/lab ────────────────────────────────────────────────────────
mkdir -p ~/bin
cat > ~/bin/lab <<'SCRIPT'
#!/bin/bash
source /shared/common.sh
source /shared/interactive.sh
menu_interactivo
SCRIPT
chmod 755 ~/bin/lab
export PATH="$HOME/bin:$PATH"

# ─── Mostrar banner de bienvenida ────────────────────────────────────────────
banner_bienvenida
echo ""
echo -e "  ${CYAN}Curso: Fundamentos de Ciberseguridad ABC-CYB-101${RESET}"
echo -e "  ${CYAN}14 unidades · 60 CORE + 80 optativos · 5 módulos${RESET}"
echo ""
echo -e "  ${CYAN}Comandos disponibles:${RESET}"
echo "    ${VERDE}menu${RESET}          - Menú interactivo principal"
echo "    ${VERDE}jugar${RESET}         - Modo juego interactivo"
echo "    ${VERDE}retos${RESET}         - Ver retos de la unidad"
echo "    ${VERDE}evaluar${RESET}       - Evaluar progreso"
echo "    ${VERDE}revelar-frase${RESET} - Ver frase secreta"
echo "    ${VERDE}progreso${RESET}      - Ver progreso global"
echo "    ${VERDE}reset.sh${RESET}      - Limpiar laboratorio"
echo "    ${VERDE}unidad <n>${RESET}    - Seleccionar unidad (1-$UNIT_COUNT)"
echo ""
echo -e "  👉 Escribe ${CYAN}menu${RESET} para comenzar"
echo ""

# Mantener terminal interactiva
exec bash -i
