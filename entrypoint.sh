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

# ─── Detectar primer inicio y limpiar progreso anterior ──────────────────────
MARKER="$HOME/.lab_initialized"
if [ ! -f "$MARKER" ]; then
    rm -f "$HOME/laboratorio/.reto"_completado 2>/dev/null
    rm -f "$HOME/laboratorio/.reto"*"_completado" 2>/dev/null
    rm -f "/shared/.state/progress" 2>/dev/null
    touch "$MARKER"
fi

# ─── Crear .bash_aliases para que cada nuevo shell tenga los comandos ────────
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
echo "    ${VERDE}unidad <n>${RESET}    - Seleccionar unidad (1-14)"
echo ""
echo -e "  👉 Escribe ${CYAN}menu${RESET} para comenzar"
echo ""

# Mantener terminal interactiva
exec bash -i
