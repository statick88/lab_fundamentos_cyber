#!/bin/bash
# Unit IV: Burp Suite Intercepcion de Trafico HTTP — test.sh
# Refactorizado (C4): usa /shared/validators.sh + /shared/sudo-wrappers.sh

source /shared/common.sh
source /shared/validators.sh
source /shared/sudo-wrappers.sh

UNIT_NAME="unit-IV-burp"
TOTAL_RETOS=3

reto1() {
    local config="$HOME/laboratorio/burp/intercept_config.conf"
    assert_file_exists "$config" || return 1
    assert_file_contains "$config" "localhost:8080" || return 1
    assert_file_contains "$config" "http://localhost:5000" || return 1
}

reto2() {
    local modificado="$HOME/laboratorio/burp/modificado.txt"
    assert_file_contains "$modificado" "1" || return 1
    local log_modif="$HOME/laboratorio/burp/proxy_log.txt"
    assert_file_contains "$log_modif" "MODIFICADO" || return 1
}

reto3() {
    local modificado="$HOME/laboratorio/burp/modificado.txt"
    local log_modif="$HOME/laboratorio/burp/proxy_log.txt"
    local count=0
    assert_file_contains "$modificado" "1" && count=$((count+1)) || true
    assert_file_contains "$log_modif" "MODIFICADO" && count=$((count+1)) || true
    [ "$count" -ge 2 ]
}

validators=(reto1 reto2 reto3)

challenge_names=(
    "Configurar proxy Burp interceptando trafico GET basico"
    "Interceptar y modificar parametro precio en peticion POST"
    "Validar bypass/modificacion exitosa mediante logs"
)

ICONOS=("📡" "🔧" "✅")

reto1_info() {
    separador
    echo -e "${CYAN}Reto 1: Configurar proxy Burp interceptando trafico${NC}"
    echo ""
    echo "Configura el proxy upstream en Burp Suite:"
    echo "  • Host: localhost"
    echo "  • Puerto: 8080"
    echo "  • Target: http://localhost:5000"
    echo ""
    echo "Verifica interceptando una peticion GET a http://localhost:5000/"
    echo "y observa los detalles en la pestana Intercept"
    separador
}

reto2_info() {
    separador
    echo -e "${CYAN}Reto 2: Interceptar y modificar parametro critico${NC}"
    echo ""
    echo "Realiza una peticion POST al endpoint /compra"
    echo "Modifica el parametro precio (ej. de \$999 a \$50)"
    echo "o el rol (de 'usuario' a 'admin')"
    echo ""
    echo "Validacion: el script cliente debe detectar la modificacion"
    separador
}

reto3_info() {
    separador
    echo -e "${CYAN}Reto 3: Validar bypass/modificacion exitosa${NC}"
    echo ""
    echo "Confirma que los logs del proxy reflejan la modificacion"
    echo "y que el archivo modificado.txt contiene el estado 1"
    echo "Inspecciona la pestana 'Intercept' y 'Logger' en Burp"
    separador
}

# ── Standalone execution mode ────────────────────────────────────────
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Unit IV Burp Suite Intercepcion HTTP — Retos"
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
    echo "  Unit IV Burp Results: $PASSED/$TOTAL_RETOS passed, $FAILED failed"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    [ "$FAILED" -eq 0 ]
fi
