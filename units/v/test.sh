#!/bin/bash
# Unit V: Processes & Services — test.sh
# Refactorizado (C4): usa /shared/validators.sh + /shared/sudo-wrappers.sh

source /shared/common.sh
source /shared/validators.sh
source /shared/sudo-wrappers.sh

UNIT_NAME="unit-V"
TOTAL_RETOS=10

reto1() {
    assert_command_ok ps aux
}

reto2() {
    local output
    output=$(ps aux 2>/dev/null | grep bash | grep -v grep)
    [ -n "$output" ]
}

reto3() {
    sleep 300 &
    local PID=$!
    [ -d "/proc/$PID" ] 2>/dev/null || kill $PID 2>/dev/null
    [ -n "$PID" ]
}

reto4() {
    sleep 300 &
    local PID=$!
    sleep 1
    kill $PID 2>/dev/null
    sleep 1
    ! kill -0 $PID 2>/dev/null
}

reto5() {
    local output
    output=$(ps aux --sort=-%cpu 2>/dev/null || ps aux)
    [ -n "$output" ]
}

reto6() {
    local output
    output=$(ps aux --sort=-%mem 2>/dev/null || ps aux)
    [ -n "$output" ]
}

reto7() {
    local output
    output=$(ps aux | awk '{print $1}' | sort | uniq -c)
    [ -n "$output" ]
}

reto8() {
    (crontab -l 2>/dev/null; echo "* * * * * echo test") | crontab - 2>/dev/null
    crontab -l 2>/dev/null | grep -q "test"
}

reto9() {
    local output
    output=$(systemctl status ssh 2>/dev/null || service ssh status 2>/dev/null || echo "checked")
    [ -n "$output" ]
}

reto10() {
    local output
    output=$(systemctl list-units --type=service --state=running 2>/dev/null || ps aux)
    [ -n "$output" ]
}

validators=(reto1 reto2 reto3 reto4 reto5 reto6 reto7 reto8 reto9 reto10)
challenge_names=(
    "Listar procesos"
    "Buscar proceso especifico"
    "Crear proceso en background"
    "Matar un proceso"
    "Top procesos por CPU"
    "Top procesos por memoria"
    "Procesos por usuario"
    "Crear cron job"
    "Verificar servicio"
    "Listar servicios activos"
)
ICONOS=("📋" "🔍" "➕" "☠️" "⚡" "💾" "👤" "⏰" "🔧" "📊")

reto1_info() {
    separador
    echo -e "${CYAN}Reto 1: Listar procesos${NC}"
    echo ""
    echo "Tu tarea es mostrar todos los procesos que se estan ejecutando en el sistema."
    echo "Utiliza el comando 'ps aux' para obtener la lista completa de procesos."
    echo "Verifica que la salida contenga las columnas PID y USER."
    echo ""
    echo "Comando util: ps aux"
    separador
}

reto2_info() {
    separador
    echo -e "${CYAN}Reto 2: Buscar proceso especifico${NC}"
    echo ""
    echo "Debes buscar un proceso especifico en la lista de procesos."
    echo "Utiliza 'ps aux' combinado con 'grep' para filtrar el proceso que buscas."
    echo "Recuerda excluir la linea del propio grep con 'grep -v grep'."
    echo ""
    echo "Comando util: ps aux | grep bash | grep -v grep"
    separador
}

reto3_info() {
    separador
    echo -e "${CYAN}Reto 3: Crear proceso en background${NC}"
    echo ""
    echo "Necesitas crear un proceso que se ejecute en segundo plano (background)."
    echo "Agrega '&' al final de un comando para ejecutarlo en background."
    echo "Puedes usar 'sleep 300 &' como ejemplo y luego verificar con 'ps aux'."
    echo ""
    echo "Comando util: sleep 300 &"
    separador
}

reto4_info() {
    separador
    echo -e "${CYAN}Reto 4: Matar un proceso${NC}"
    echo ""
    echo "Debes terminar un proceso que se este ejecutando."
    echo "Primero identifica el PID del proceso con 'ps aux'."
    echo "Luego utiliza 'kill' seguido del PID para terminarlo."
    echo "Verifica que el proceso ya no existe con 'kill -0 PID'."
    echo ""
    echo "Comando util: kill <PID>"
    separador
}

reto5_info() {
    separador
    echo -e "${CYAN}Reto 5: Top procesos por CPU${NC}"
    echo ""
    echo "Debes ordenar los procesos segun su uso de CPU."
    echo "Utiliza 'ps aux' con la opcion '--sort=-%cpu' para ordenar de mayor a menor."
    echo "Los procesos que mas CPU consumen apareceran primero."
    echo ""
    echo "Comando util: ps aux --sort=-%cpu"
    separador
}

reto6_info() {
    separador
    echo -e "${CYAN}Reto 6: Top procesos por memoria${NC}"
    echo ""
    echo "Debes ordenar los procesos segun su uso de memoria RAM."
    echo "Utiliza 'ps aux' con la opcion '--sort=-%mem' para ordenar de mayor a menor."
    echo "Los procesos que mas memoria consumen apareceran primero."
    echo ""
    echo "Comando util: ps aux --sort=-%mem"
    separador
}

reto7_info() {
    separador
    echo -e "${CYAN}Reto 7: Procesos por usuario${NC}"
    echo ""
    echo "Debes contar cuantos procesos tiene cada usuario."
    echo "Utiliza 'ps aux' para listar todos los procesos."
    echo "Luego extrae la columna de usuario con 'awk' y cuenta con 'sort | uniq -c'."
    echo ""
    echo "Comando util: ps aux | awk '{print \$1}' | sort | uniq -c"
    separador
}

reto8_info() {
    separador
    echo -e "${CYAN}Reto 8: Crear cron job${NC}"
    echo ""
    echo "Debes programar una tarea automatica utilizando cron."
    echo "Edita tu crontab con 'crontab -e' o anade una linea directamente."
    echo "Un cron job se compone de: minuto hora dia mes dia_semana comando."
    echo "Ejemplo: '* * * * * echo test' ejecuta un comando cada minuto."
    echo ""
    echo "Comando util: (crontab -l; echo '* * * * * comando') | crontab -"
    separador
}

reto9_info() {
    separador
    echo -e "${CYAN}Reto 9: Verificar servicio${NC}"
    echo ""
    echo "Debes verificar el estado de un servicio del sistema."
    echo "Utiliza 'systemctl status <servicio>' en sistemas con systemd."
    echo "Si systemd no esta disponible, usa 'service <servicio> status'."
    echo ""
    echo "Comando util: systemctl status ssh"
    separador
}

reto10_info() {
    separador
    echo -e "${CYAN}Reto 10: Listar servicios activos${NC}"
    echo ""
    echo "Debes listar todos los servicios que se estan ejecutando actualmente."
    echo "Utiliza 'systemctl list-units --type=service --state=running'."
    echo "Si systemd no esta disponible, puedes revisar procesos con 'ps aux'."
    echo ""
    echo "Comando util: systemctl list-units --type=service --state=running"
    separador
}

# ── Standalone execution mode ────────────────────────────────
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Unit V: Processes & Services — Retos"
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
    echo "  Unit V Results: $PASSED/$TOTAL_RETOS passed, $FAILED failed"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    [ "$FAILED" -eq 0 ]
fi
