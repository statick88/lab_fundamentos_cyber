# =============================================================================
# Dockerfile - Laboratorio: Fundamentos de Sistemas de Archivos y Terminal Linux
# =============================================================================
# Imagen basada en Ubuntu 24.04 con herramientas básicas para aprendizaje
# de administración de sistemas de archivos y comandos de terminal.
# =============================================================================

FROM ubuntu:24.04

# Etiquetas del contenedor
LABEL maintainer="DevSecOps Lab"
LABEL description="Laboratorio interactivo de Linux - Sistemas de Archivos y Terminal"
LABEL version="1.0"

# Evitar interacción durante la instalación de paquetes
ENV DEBIAN_FRONTEND=noninteractive

# Actualizar repositorios e instalar herramientas necesarias
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    bash-completion \
    coreutils \
    tree \
    nano \
    vim \
    curl \
    git \
    sudo \
    openssl \
    nginx \
    rsync \
    ufw \
    openssh-client \
    cron \
    procps \
    net-tools \
    iproute2 \
    fdisk \
    python3 \
    docker.io \
    pandoc \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-fonts-recommended \
    lmodern \
    shellcheck \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Crear usuario 'estudiante' con permisos sudo sin contraseña
RUN useradd -m -s /bin/bash estudiante && \
    echo "estudiante ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    groupadd -f docker && \
    usermod -aG docker estudiante

# Copiar entrypoint
COPY entrypoint.sh /entrypoint.sh

# Copiar biblioteca compartida
COPY shared/ /shared/
COPY shared/ /opt/shared/

# Copiar unidades del curso a /opt (fuera del volume mount)
COPY units/ /opt/lab-units/

# Copiar tests de métricas
COPY tests/ /opt/lab-tests/

# Copiar script de métricas principal
COPY metrics_test.sh /opt/metrics_test.sh

# Copiar script de generación de PDF
COPY generar-pdf.sh /generar-pdf.sh

# Copiar plantilla de respuestas
COPY plantilla.md /home/estudiante/laboratorio/plantilla.md

# Copiar .bashrc personalizado para el estudiante
COPY bashrc /home/estudiante/.bashrc

# Establecer permisos de ejecución y dueño
RUN chmod +x /entrypoint.sh && \
    chmod +x /shared/*.sh && \
    chmod +x /generar-pdf.sh && \
    chmod +x /opt/metrics_test.sh && \
    find /opt/lab-units -name "*.sh" -exec chmod +x {} \; && \
    find /opt/lab-tests -name "*.sh" -exec chmod +x {} \; && \
    chown -R estudiante:estudiante /home/estudiante/laboratorio

# Cambiar al usuario 'estudiante'
USER estudiante

# Directorio de trabajo predeterminado
WORKDIR /home/estudiante/laboratorio

# Comando de inicio del contenedor
ENTRYPOINT ["/entrypoint.sh"]