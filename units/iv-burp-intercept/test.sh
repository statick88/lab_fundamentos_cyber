#!/bin/bash
# Unit IV: Burp Suite Intercepción de Tráfico HTTP — test.sh

# Support both container (/shared) and local (relative) paths
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
fi

UNIT_NAME="unit-IV-burp"
TOTAL_RETOS=3

source /shared/eval.sh

echo -e "${CYAN}=== Evaluación Burp Suite Intercepción HTTP ===${RESET}\n"

# Reto 1: Configurar proxy Burp interceptando tráfico básico
reto1() {
    # Verificar que el archivo de configuración existe
    local config="$HOME/laboratorio/burp/intercept_config.conf"
    if [ -f "$config" ]; then
        # Verificar que contiene las configuraciones básicas
        grep -q "localhost:8080" "$config" 2>/dev/null && \
        grep -q "http://localhost:5000" "$config" 2>/dev/null && \
        return 0
    fi
    return 1
}

# Reto 2: Interceptar petición HTTP y modificar parámetro crítico
reto2() {
    # Verificar que se interceptó una petición y modificó el parámetro
    local modificado="$HOME/laboratorio/burp/modificado.txt"
    if [ -f "$modificado" ] && [ "$(cat "$modificado" 2>/dev/null)" = "1" ]; then
        return 0
    fi
    # Alternativa: verificar log de modificaciones
    local log_modif="$HOME/laboratorio/burp/proxy_log.txt"
    if [ -f "$log_modif" ] && grep -q "MODIFICADO" "$log_modif" 2>/dev/null; then
        return 0
    fi
    return 1
}

# Reto 3: Validar bypass o modificación exitosa
reto3() {
    # Verificar ambos indicadores de éxito
    local modificado="$HOME/laboratorio/burp/modificado.txt"
    local log_modif="$HOME/laboratorio/burp/proxy_log.txt"
    
    local count=0
    [ -f "$modificado" ] && [ "$(cat "$modificado" 2>/dev/null)" = "1" ] && count=$((count+1))
    [ -f "$log_modif" ] && grep -q "MODIFICADO" "$log_modif" 2>/dev/null && count=$((count+1))
    
    [ "$count" -ge 2 ]
}

validators=(reto1 reto2 reto3)

challenge_names=(
    "Configurar proxy Burp interceptando tráfico GET básico"
    "Interceptar y modificar parámetro precio en petición POST"
    "Validar bypass/modificación exitosa mediante logs"
)

ICONOS=("📡" "🔧" "✅")

reto1_info() {
    separador
    echo -e "${CYAN}Reto 1: Configurar proxy Burp interceptando tráfico${NC}"
    echo ""
    echo "Configura el proxy upstream en Burp Suite:"
    echo "  • Host: localhost"
    echo "  • Puerto: 8080"
    echo "  • Target: http://localhost:5000"
    echo ""
    echo "Verifica interceptando una petición GET a http://localhost:5000/"
    echo "y observa los detalles en la pestaña Intercept"
    separador
}

reto2_info() {
    separador
    echo -e "${CYAN}Reto 2: Interceptar y modificar parámetro crítico${NC}"
    echo ""
    echo "Realiza una petición POST al endpoint /compra"
    echo "Modifica el parámetro precio (ej. de \$999 a \$50)"
    echo "o el rol (de 'usuario' a 'admin')"
    echo ""
    echo "Validación: el script cliente debe detectar la modificación"
    separador
}

reto3_info() {
    separador
    echo -e "${CYAN}Reto 3: Validar bypass/modificación exitosa${NC}"
    echo ""
    echo "Confirma que los logs del proxy reflejan la modificación"
    echo "y que el archivo modificado.txt contiene el estado 1"
    echo "Inspecciona la pestaña 'Intercept' y 'Logger' en Burp"
    separador
}

echo -e "${CYUNIT}Ejecutando evaluación de 3 retos...${RESET}"
echo ""

pass_count=0
fail_count=0

for i in "${!validators[@]}"; do
    echo -n "Ejecutando ${challenge_names[$i]}... "
    if "${validators[$i]}" >/dev/null 2>&1; then
        echo -e "${VERDE}✔ PASADO${RESET}"
        pass_count=$((pass_count+1))
    else
        echo -e "${ROJO}✘ FALLIDO${RESET}"
        # Intentar mostrar razón
        case $i in
            0) echo "  Razón: Configuración de proxy Burp incompleta" ;;
            1) echo "  Razón: No se detectó modificación de parámetro" ;;
            2) echo "  Razón: Fallo en validación de logs" ;;
        esac
        fail_count=$((fail_count+1))
    fi
done

echo ""
separador
echo -e "Resultados: ${VERDE}${pass_count} pasados${RESET} | ${ROJO}${fail_count} fallidos${RESET}"
separador
[ "$fail_count" -eq 0 ] && celebrar "Todos los retos Burp completados"
echo -e "\n${AMARILHO}Revisa los logs en $HOME/laboratorio/burp/ para detalles${RESET}"