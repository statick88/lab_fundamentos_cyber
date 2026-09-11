#!/bin/bash
# ==============================================================================
# Script de Verificación Manual — Lab Fundamentos Ciberseguridad (ABC-CYB-101)
# ==============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}================================================================${NC}"
echo -e "${YELLOW}   INICIANDO AUDITORÍA Y VERIFICACIÓN MANUAL DE UNIDADES        ${NC}"
echo -e "${YELLOW}================================================================${NC}"

total_unidades=0
unidades_ok=0
sintaxis_ok=0
sintaxis_fail=0

# Buscar directorios de unidades (excluyendo shared y openspec)
for unidad in units/*/; do
    [ -d "$unidad" ] || continue
    total_unidades=$((total_unidades + 1))
    nombre_unidad=$(basename "$unidad")
    
    echo -e "\n----------------------------------------------------------------"
    echo -e "Analizando unidad: ${YELLOW}$nombre_unidad${NC}"
    echo -e "----------------------------------------------------------------"

    # 1. Verificar archivos obligatorios
    missing_files=0
    for archivo in setup.sh manual.sh test.sh; do
        if [ ! -f "${unidad}${archivo}" ]; then
            echo -e "  [${RED}FAIL${NC}] Falta archivo obligatorio: $archivo"
            missing_files=1
        else
            echo -e "  [${GREEN}PASS${NC}] Existe: $archivo"
        fi
    done

    # 2. Verificar sintaxis Bash con bash -n
    syntax_error=0
    for sh_file in "${unidad}"*.sh; do
        [ -f "$sh_file" ] || continue
        if bash -n "$sh_file" 2>/dev/null; then
            sintaxis_ok=$sintaxis_ok
        else
            echo -e "  [${RED}SYNTAX FAIL${NC}] Error de sintaxis en: $(basename "$sh_file")"
            syntax_error=1
            sintaxis_fail=$sintaxis_fail
        fi
    done

    if [ $syntax_error -eq 0 ]; then
        echo -e "  [${GREEN}PASS${NC}] Sintaxis Bash válida (bash -n)"
        sintaxis_ok=$((sintaxis_ok + 1))
    fi

    # 3. Estado general de la unidad
    if [ $missing_files -eq 0 ] && [ $syntax_error -eq 0 ]; then
        echo -e "  Resultado Unidad: ${GREEN}VERIFICADA CORRECTAMENTE${NC}"
        unidades_ok=$((unidades_ok + 1))
    else
        echo -e "  Resultado Unidad: ${RED}CON OBSERVACIONES${NC}"
    fi
done

echo -e "\n================================================================"
echo -e "${YELLOW}                 RESUMEN DE AUDITORÍA                           ${NC}"
echo -e "================================================================"
echo -e "Total de unidades analizadas : $total_unidades"
echo -e "Unidades íntegras y sin errores: ${GREEN}$unidades_ok${NC}"
echo -e "Unidades con observaciones   : $((total_unidades - unidades_ok))"
echo -e "================================================================"
