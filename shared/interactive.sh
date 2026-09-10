#!/bin/bash
# =============================================================================
# Funciones interactivas del laboratorio
# Se cargan desde .bash_aliases para que estén disponibles en cada shell
# =============================================================================

get_unit_num_romano() {
    case $1 in
        1) echo "I" ;;2) echo "II" ;;3) echo "III" ;;4) echo "IV" ;;5) echo "V" ;;
        6) echo "VI" ;;7) echo "VII" ;;8) echo "VIII" ;;9) echo "IX" ;;10) echo "X" ;;
        11) echo "XI" ;;12) echo "XII" ;;13) echo "XIII" ;;14) echo "XIV" ;;15) echo "XV" ;;16) echo "XVI" ;;17) echo "XVII" ;;18) echo "XVIII" ;;19) echo "XIX" ;;
    esac
}

menu_interactivo() {
    while true; do
        clear
        mostrar_menu_principal
        echo -n "  Selecciona una opción (1-$UNIT_COUNT, s=frase, q=salir): "
        read -r choice
        case "$choice" in
            q|Q|quit|exit)
                echo "  👋 ¡Hasta luego!"
                break
                ;;
            s|S)
                ver_frase
                ;;
            [1-9]|1[0-9])
                if [ "$choice" -ge 1 ] && [ "$choice" -le "$UNIT_COUNT" ]; then
                    local romano=$(get_unit_num_romano $choice)
                    export CURRENT_UNIT="$(get_unit_name $choice)"
                    echo "$CURRENT_UNIT" > ~/.current_unit
                    jugar_unidad "$CURRENT_UNIT"
                else
                    echo "  ❌ Opción inválida"
                fi
                ;;
            *)
                echo "  ❌ Opción inválida"
                ;;
        esac
        echo ""
        echo -n "  Presiona Enter para continuar..."
        read -r
    done
}

ver_retos_unidad() {
    if [ -z "$CURRENT_UNIT" ]; then
        if [ -f "$HOME/.current_unit" ]; then
            export CURRENT_UNIT=$(cat "$HOME/.current_unit")
        fi
    fi
    if [ -z "$CURRENT_UNIT" ]; then
        echo "  ⚠️  Primero selecciona una unidad:"
        echo ""
        for i in $(seq 1 $UNIT_COUNT); do
            echo "  [$i] $(get_unit_title $i)"
        done
        echo ""
        echo -n "  Elige (1-$UNIT_COUNT): "
        read -r choice
        if [ "$choice" -ge 1 ] && [ "$choice" -le "$UNIT_COUNT" ]; then
            export CURRENT_UNIT="$(get_unit_name $choice)"
            echo "$CURRENT_UNIT" > ~/.current_unit
        else
            return 1
        fi
    fi
    ejecutar_unidad "$CURRENT_UNIT"
}

jugar_interactivo() {
    local unit="${1:-}"

    if [ -z "$unit" ]; then
        if [ -f "$HOME/.current_unit" ]; then
            unit=$(cat "$HOME/.current_unit")
        fi
    fi

    if [ -z "$unit" ]; then
        echo ""
        echo -e "${CYAN}🎮 MODO JUGAR - Selecciona una unidad:${RESET}"
        echo ""
        for i in $(seq 1 $UNIT_COUNT); do
            local romano=$(get_unit_num_romano $i)
            local u="$(get_unit_name $i)"
            local titulo=$(get_unit_title $i)
            local completados=$(contar_completados "$u" "$(get_unit_total_retos $i)" 2>/dev/null || echo 0)
            local total=$(get_unit_total_retos $i)
            echo -e "  ${VERDE}[$i]${RESET} $titulo (${completados}/${total})"
        done
        echo ""
        echo -n "  Elige unidad (1-$UNIT_COUNT): "
        read -r choice
        if [ -z "$choice" ]; then
            return 0
        fi
        if [ "$choice" -ge 1 ] && [ "$choice" -le "$UNIT_COUNT" ]; then
            unit="$(get_unit_name $choice)"
        else
            echo "  ❌ Opción inválida"
            return 1
        fi
    fi

    export CURRENT_UNIT="$unit"
    echo "$CURRENT_UNIT" > ~/.current_unit

    local unit_path; unit_path=$(resolve_unit_path "$unit")
    if [ ! -f "$unit_path/test.sh" ]; then
        echo "  ❌ Unidad no encontrada: $unit"
        return 1
    fi
    source "$unit_path/test.sh" 2>/dev/null || true

    local total=${#challenge_names[@]}
    local unit_idx; unit_idx=$(get_unit_index "$unit")

    local core_retos=()
    local opt_retos=()
    for ((i=1; i<=total; i++)); do
        if is_reto_core "$unit_idx" "$i"; then
            core_retos+=("$i")
        else
            opt_retos+=("$i")
        fi
    done

    local reto_list=("${core_retos[@]}" "${opt_retos[@]}")
    local reto=1
    local list_idx=0

    while [ "$list_idx" -lt "${#reto_list[@]}" ]; do
        reto=${reto_list[$list_idx]}
        if esta_completado "$unit" "$reto" 2>/dev/null; then
            list_idx=$((list_idx + 1))
            continue
        fi

        jugar_reto "$unit" "$reto"
        local result=$?

        if [ $result -eq 0 ]; then
            list_idx=$((list_idx + 1))
        else
            echo ""
            echo -ne "${AMARILLO}¿Qué quieres hacer? [n] siguiente, [m] menú, [q] salir: ${RESET}"
            read -r action
            case "$action" in
                m|M) return 0 ;;
                q|Q) return 1 ;;
                *) list_idx=$((list_idx + 1)) ;;
            esac
        fi
    done

    echo ""
    echo -e "${VERDE_B}🏆 ¡UNIDAD $unit COMPLETADA!${RESET}"
    mostrar_frase_unidad "$(get_unit_index "$unit")"
}

evaluar_interactivo() {
    if [ -z "$CURRENT_UNIT" ]; then
        if [ -f "$HOME/.current_unit" ]; then
            export CURRENT_UNIT=$(cat "$HOME/.current_unit")
        fi
    fi

    if [ -z "$CURRENT_UNIT" ]; then
        echo ""
        echo "  📊 EVALUAR - Selecciona una unidad:"
        echo ""
        for i in $(seq 1 $UNIT_COUNT); do
            local u="$(get_unit_name $i)"
            local completados=$(contar_completados "$u" "$(get_unit_total_retos $i)" 2>/dev/null || echo 0)
            echo "  [$i] $(get_unit_title $i) (${completados}/$(get_unit_total_retos $i))"
        done
        echo ""
            echo -n "  Elige (1-$UNIT_COUNT, Enter para todas): "
        read -r choice
        if [ -z "$choice" ]; then
            mostrar_progreso_global
            return 0
        fi
        if [ "$choice" -ge 1 ] && [ "$choice" -le "$UNIT_COUNT" ]; then
            export CURRENT_UNIT="$(get_unit_name $choice)"
        else
            echo "  ❌ Opción inválida"
            return 1
        fi
    fi

    local unit="$CURRENT_UNIT"
    local unit_path; unit_path=$(resolve_unit_path "$unit")

    if [ ! -f "$unit_path/test.sh" ]; then
        echo "  ❌ Unidad no encontrada: $unit"
        return 1
    fi

    source "$unit_path/test.sh" 2>/dev/null || true

    echo ""
    echo -e "${CYAN}📊 Evaluando $unit...${RESET}"
    echo ""

    local total=${#challenge_names[@]}
    local pass=0 fail=0

    for ((i=1; i<=total; i++)); do
        local name="${challenge_names[$((i-1))]:-Reto $i}"
        local validator="reto${i}"

        if declare -f "$validator" >/dev/null 2>&1; then
            if "$validator" >/dev/null 2>&1; then
                marcar_completado "$unit" "$i"
                echo -e "  ${VERDE}✔ Reto $i: $name${RESET}"
                pass=$((pass+1))
            else
                echo -e "  ${ROJO}✘ Reto $i: $name${RESET}"
                fail=$((fail+1))
            fi
        fi
    done

    echo ""
    separador
    echo -e "  Resultados: ${VERDE}${pass} pasados${RESET} | ${ROJO}${fail} fallidos${RESET}"
    echo -ne "  Progreso: "; mostrar_barra_progreso "$pass" "$total"
    separador

    if [ "$fail" -eq 0 ]; then
        celebrar "¡Todos los retos completados!"
    fi
}

ver_frase() {
    echo ""
    echo -e "${CYAN}🔑 FRASE SECRETA - Progreso por unidad:${RESET}"
    echo ""

    for i in $(seq 1 $UNIT_COUNT); do
        local u="$(get_unit_name $i)"
        local total_retos=$(get_unit_total_retos $i)
        local compl=$(contar_completados "$u" "$total_retos" 2>/dev/null || echo 0)
        local frase=$(get_frase_for_unit $i)

        if [ "$compl" -eq "$total_retos" ]; then
            echo -e "  ${VERDE}✅ Unidad $i: $frase${RESET}"
        else
            echo -e "  ${ROJO}🔒 Unidad $i: ??? ($compl/$total_retos completados)${RESET}"
        fi
    done

    echo ""
}
