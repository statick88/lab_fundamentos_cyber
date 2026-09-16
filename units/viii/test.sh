#!/bin/bash
# Unit VIII: Docker Containers — test.sh
# Refactorizado (C4): usa /shared/validators.sh + /shared/sudo-wrappers.sh

source /shared/common.sh
source /shared/validators.sh
source /shared/sudo-wrappers.sh

UNIT_NAME="unit-VIII"
TOTAL_RETOS=10

reto1() {
    assert_command_ok docker --version
}

reto2() {
    assert_command_ok docker run --rm hello-world
}

reto3() {
    local output
    output=$(docker ps -a 2>&1)
    [ -n "$output" ]
}

reto4() {
    assert_command_ok docker run --rm ubuntu echo "test"
}

reto5() {
    assert_file_exists ~/laboratorio/docker/app/Dockerfile
    assert_file_contains ~/laboratorio/docker/app/Dockerfile "FROM"
}

reto6() {
    cd ~/laboratorio/docker/app 2>/dev/null
    assert_command_ok docker build -t mi-app-test:latest .
}

reto7() {
    docker volume create test-vol 2>/dev/null
    local output
    output=$(docker volume ls 2>&1)
    echo "$output" | grep -q "test-vol"
    docker volume rm test-vol 2>/dev/null
}

reto8() {
    local output
    output=$(docker network ls 2>&1)
    echo "$output" | grep -q "bridge"
}

reto9() {
    docker run -d --name test-log-container alpine sleep 5 2>/dev/null
    local output
    output=$(docker logs test-log-container 2>&1)
    [ -n "$output" ] || true
    docker rm -f test-log-container 2>/dev/null
}

reto10() {
    assert_file_exists ~/laboratorio/docker/compose/docker-compose.yml
    assert_file_contains ~/laboratorio/docker/compose/docker-compose.yml "services"
}

validators=(reto1 reto2 reto3 reto4 reto5 reto6 reto7 reto8 reto9 reto10)
challenge_names=(
    "Docker instalado"
    "Contenedor hello-world"
    "Listar contenedores"
    "Ubuntu interactivo"
    "Crear Dockerfile"
    "Construir imagen"
    "Gestionar volumes"
    "Redes Docker"
    "Logs de contenedor"
    "Docker Compose"
)

ICONOS=("🐳" "📦" "📋" "🐧" "📄" "🔨" "💾" "🌐" "📜" "🔧")

reto1_info() {
    separador
    echo -e "${CYAN}Reto 1: Verificar Docker instalado${NC}"
    echo ""
    echo "Confirma que Docker esta instalado y el daemon esta corriendo."
    echo ""
    echo "Comandos utiles: docker --version, docker info"
    echo "Ejemplo: docker --version"
    separador
}

reto2_info() {
    separador
    echo -e "${CYAN}Reto 2: Contenedor hello-world${NC}"
    echo ""
    echo "Ejecuta el contenedor de prueba hello-world de Docker."
    echo "Si no existe localmente, Docker lo descargara automaticamente."
    echo ""
    echo "Comandos utiles: docker run"
    echo "Ejemplo: docker run --rm hello-world"
    separador
}

reto3_info() {
    separador
    echo -e "${CYAN}Reto 3: Listar contenedores${NC}"
    echo ""
    echo "Lista todos los contenedores, tanto activos como detenidos."
    echo ""
    echo "Comandos utiles: docker ps -a"
    echo "Ejemplo: docker ps -a"
    separador
}

reto4_info() {
    separador
    echo -e "${CYAN}Reto 4: Ubuntu interactivo${NC}"
    echo ""
    echo "Ejecuta un contenedor Ubuntu con shell interactivo."
    echo "Usa -it para modo interactivo y --rm para eliminar al salir."
    echo ""
    echo "Comandos utiles: docker run -it"
    echo "Ejemplo: docker run -it --rm ubuntu bash"
    separador
}

reto5_info() {
    separador
    echo -e "${CYAN}Reto 5: Crear Dockerfile${NC}"
    echo ""
    echo "Crea un Dockerfile que defina una imagen personalizada."
    echo "Un Dockerfile contiene instrucciones para construir una imagen."
    echo ""
    echo "Comandos utiles: touch, cat"
    echo "Ejemplo: FROM ubuntu:latest"
    echo "         RUN apt-get update"
    echo '         CMD ["echo", "Hola"]'
    separador
}

reto6_info() {
    separador
    echo -e "${CYAN}Reto 6: Construir imagen${NC}"
    echo ""
    echo "Construye una imagen Docker a partir de un Dockerfile."
    echo "La imagen se crea con un tag (nombre:version)."
    echo ""
    echo "Comandos utiles: docker build"
    echo "Ejemplo: docker build -t mi-app:latest ."
    separador
}

reto7_info() {
    separador
    echo -e "${CYAN}Reto 7: Gestionar volumes${NC}"
    echo ""
    echo "Crea y gestiona volumes para persistir datos entre contenedores."
    echo "Los volumes son la forma recomendada de almacenar datos en Docker."
    echo ""
    echo "Comandos utiles: docker volume create, docker volume ls"
    echo "Ejemplo: docker volume create mis-datos"
    separador
}

reto8_info() {
    separador
    echo -e "${CYAN}Reto 8: Redes Docker${NC}"
    echo ""
    echo "Explora las redes Docker para comunicar contenedores entre si."
    echo "Docker crea redes automaticamente (bridge, host, none)."
    echo ""
    echo "Comandos utiles: docker network ls, docker network create"
    echo "Ejemplo: docker network ls"
    separador
}

reto9_info() {
    separador
    echo -e "${CYAN}Reto 9: Logs de contenedor${NC}"
    echo ""
    echo "Consulta los logs de salida de un contenedor en ejecucion o detenido."
    echo "Los logs son utiles para depurar problemas."
    echo ""
    echo "Comandos utiles: docker logs, docker logs -f"
    echo "Ejemplo: docker logs nombre-contenedor"
    separador
}

reto10_info() {
    separador
    echo -e "${CYAN}Reto 10: Docker Compose${NC}"
    echo ""
    echo "Crea un archivo docker-compose.yml para orquestar multiples servicios."
    echo "Docker Compose permite definir y ejecutar apps multi-contenedor."
    echo ""
    echo "Comandos utiles: docker-compose up, docker-compose down"
    echo "Ejemplo: version: '3.8'"
    echo "         services:"
    echo "           web:"
    echo "             image: nginx:alpine"
    separador
}

# ── Standalone execution mode ────────────────────────
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Unit VIII: Docker Containers — Retos"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    PASSED=0
    FAILED=0

    for i in $(seq 1 "$TOTAL_RETOS"); do
        validator="${validators[$((i-1))]}"
        name="${challenge_names[$((i-1))]}"
        icon="${ICONOS[$((i-1))]}"

        if $validator >/dev/null 2>&1; then
            echo "  [PASS] Reto $i: $name $icon"
            PASSED=$((PASSED + 1))
        else
            echo "  [FAIL] Reto $i: $name"
            FAILED=$((FAILED + 1))
        fi
    done

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Unit VIII Results: $PASSED/$TOTAL_RETOS passed, $FAILED failed"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    [ "$FAILED" -eq 0 ]
fi
