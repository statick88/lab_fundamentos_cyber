#!/bin/bash
# Unit VIII: Docker Containers — manual.sh
# Interactive guide for learning Docker

# Support both container (/shared) and local (relative) paths
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
fi

UNIT_NAME="unit-VIII"
banner_unidad 8 "Contenedores Docker"

cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║  Guia de Contenedores Docker                               ║
║  Aprende a crear, gestionar y orquestar contenedores       ║
╚══════════════════════════════════════════════════════════════╝

📚 CONCEPTOS CLAVE
═══════════════════

  Docker permite empaquetar aplicaciones en contenedores:
  • Contenedor — instancia de una imagen en ejecución
  • Imagen — plantilla de solo lectura con el código y dependencias
  • Dockerfile — instrucciones para construir una imagen
  • Volume — almacenamiento persistente fuera del contenedor
  • Network — comunicación entre contenedores
  • Docker Compose — orquestación multi-contenedor

🔧 COMANDOS DE DOCKER
══════════════════════════════

  Contenedores
  ──────────────
  docker run -it ubuntu bash    # Ejecutar contenedor interactivo
  docker run -d nginx           # Ejecutar en background (detached)
  docker run --rm alpine echo hi # Ejecutar y eliminar al salir
  docker ps                     # Ver contenedores activos
  docker ps -a                  # Ver todos los contenedores
  docker stop <id>              # Detener contenedor
  docker rm <id>                # Eliminar contenedor
  docker exec -it <id> bash     # Entrar a un contenedor

  Imagenes
  ──────────
  docker images                 # Listar imagenes
  docker pull ubuntu            # Descargar imagen
  docker build -t mi-app:1.0 .  # Construir desde Dockerfile
  docker rmi <imagen>           # Eliminar imagen
  docker tag <img> <nuevo-tag>  # Renombrar imagen

  Volumes
  ─────────
  docker volume create datos    # Crear volume
  docker volume ls              # Listar volumes
  docker volume rm <nombre>     # Eliminar volume
  docker run -v datos:/data img # Montar volume en contenedor

  Redes
  ──────
  docker network ls             # Listar redes
  docker network create mi-red  # Crear red
  docker run --network mi-red img # Conectar a red

  Docker Compose
  ────────────────
  docker-compose up -d          # Levantar servicios
  docker-compose down           # Detener servicios
  docker-compose ps             # Ver estado
  docker-compose logs -f        # Ver logs
  docker-compose pull           # Actualizar imagenes

🎯 RETOS
══════════

  Los retos estan en ~/laboratorio/docker/reto[1-10].sh
  Ejecuta cada reto con: bash reto1.sh
  Usa 'evaluar' para verificar tu progreso.

💡 EJEMPLOS UTILES
════════════════════

  # Crear Dockerfile
  FROM ubuntu:latest
  RUN apt-get update && apt-get install -y curl
  COPY ./app /app
  WORKDIR /app
  CMD ["python", "app.py"]

  # docker-compose.yml
  version: '3.8'
  services:
    web:
      image: nginx:alpine
      ports:
        - "8080:80"
    db:
      image: mysql:8.0
      environment:
        MYSQL_ROOT_PASSWORD: secret

📌 BUENAS PRACTICAS
════════════════════

  • Usar imagenes oficiales de Docker Hub
  • No ejecutar contenedores como root cuando sea posible
  • Usar multi-stage builds para reducir tamaño de imagenes
  • No almacenar datos sensibles en variables de entorno
  • Usar docker-compose para apps multi-servicio
  • Configurar healthchecks en los servicios
  • Limpiar contenedores e imagenes no usadas (docker system prune)

EOF

echo -e "\n${AMARILLO}Escribe ${CYAN}'evaluar'${AMARILLO} para verificar tu progreso o ${CYAN}'retos'${AMARILLO} para ver los retos.${RESET}"
