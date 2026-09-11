#!/bin/bash
# Unit VIII: Docker Containers — setup.sh
# Creates the environment and 10 challenges for learning Docker

set -e

# Support both container (/shared) and local (relative) paths
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
fi

UNIT_NAME="unit-VIII"
UNIT_NUM=8
export TOTAL_RETOS=10

banner_unidad "$UNIT_NUM" "Contenedores Docker"

echo -e "${CYAN}Esta unidad ensena a crear y gestionar contenedores Docker.${RESET}"
echo -e "${AMARILLO}Completarás 10 retos progresivos.${RESET}\n"

mkdir -p "$HOME/laboratorio/docker"
cd "$HOME/laboratorio/docker"

# Reto 1: Verificar Docker instalado
cat > reto1.sh << 'EOF'
#!/bin/bash
# Reto 1: Verificar que Docker esta instalado y corriendo
docker --version
docker info 2>/dev/null | head -5
EOF
chmod +x reto1.sh

# Reto 2: Ejecutar primer contenedor
cat > reto2.sh << 'EOF'
#!/bin/bash
# Reto 2: Ejecutar un contenedor "hello-world"
docker run --rm hello-world 2>/dev/null || echo "Necesitas pull hello-world primero"
EOF
chmod +x reto2.sh

# Reto 3: Listar contenedores
cat > reto3.sh << 'EOF'
#!/bin/bash
# Reto 3: Listar todos los contenedores (activos e inactivos)
docker ps -a
EOF
chmod +x reto3.sh

# Reto 4: Ejecutar contenedor interactivo
cat > reto4.sh << 'EOF'
#!/bin/bash
# Reto 4: Ejecutar Ubuntu con shell interactivo
docker run -it --rm ubuntu bash -c "echo 'Hola desde el contenedor' && cat /etc/os-release | head -3"
EOF
chmod +x reto4.sh

# Reto 5: Crear imagen con Dockerfile
cat > reto5.sh << 'EOF'
#!/bin/bash
# Reto 5: Crear un Dockerfile simple
mkdir -p ~/laboratorio/docker/app
cat > ~/laboratorio/docker/app/Dockerfile << 'DEOF'
FROM ubuntu:latest
RUN apt-get update && apt-get install -y curl
CMD ["echo", "Imagen personalizada creada"]
DEOF
echo "Dockerfile creado en ~/laboratorio/docker/app/Dockerfile"
cat ~/laboratorio/docker/app/Dockerfile
EOF
chmod +x reto5.sh

# Reto 6: Construir imagen
cat > reto6.sh << 'EOF'
#!/bin/bash
# Reto 6: Construir una imagen Docker
cd ~/laboratorio/docker/app
docker build -t mi-app:latest . 2>&1
EOF
chmod +x reto6.sh

# Reto 7: Gestionar volumes
cat > reto7.sh << 'EOF'
#!/bin/bash
# Reto 7: Crear y usar un volume
docker volume create mi-datos 2>/dev/null
docker volume ls | grep mi-datos
EOF
chmod +x reto7.sh

# Reto 8: Redes Docker
cat > reto8.sh << 'EOF'
#!/bin/bash
# Reto 8: Listar redes Docker
docker network ls
EOF
chmod +x reto8.sh

# Reto 9: Logs de contenedor
cat > reto9.sh << 'EOF'
#!/bin/bash
# Reto 9: Ver logs de un contenedor
docker ps -a --format "{{.Names}}" | head -1 | xargs -I {} docker logs {} 2>&1 | tail -10
EOF
chmod +x reto9.sh

# Reto 10: Docker Compose
cat > reto10.sh << 'EOF'
#!/bin/bash
# Reto 10: Crear un docker-compose.yml
mkdir -p ~/laboratorio/docker/compose
cat > ~/laboratorio/docker/compose/docker-compose.yml << 'YEOF'
version: '3.8'
services:
  web:
    image: nginx:alpine
    ports:
      - "8080:80"
  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: test123
YEOF
echo "docker-compose.yml creado:"
cat ~/laboratorio/docker/compose/docker-compose.yml
EOF
chmod +x reto10.sh

exito "Entorno de Unit VIII preparado con 10 retos"
echo -e "${AMARILLO}Escribe ${CYAN}'manual'${AMARILLO} para ver las instrucciones o ${CYAN}'evaluar'${AMARILLO} para evaluar.${RESET}"
