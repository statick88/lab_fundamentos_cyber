# =============================================================================
# Dockerfile - Laboratorio: Fundamentos de Ciberseguridad (ABC-CYB-101)
# =============================================================================
# Imagen basada en Ubuntu 24.04 con herramientas de ciberseguridad básicas.
# Incluye: nmap, tcpdump, openssl, john (modo educativo), iptables, ufw,
# fail2ban (solo configuración), logrotate.
# =============================================================================

FROM ubuntu:24.04

# Etiquetas del contenedor
LABEL maintainer="DevSecOps Lab"
LABEL description="Laboratorio interactivo de Ciberseguridad - ABC-CYB-101"
LABEL version="2.0"
LABEL course="Fundamentos de Ciberseguridad - Abacom"

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
    wget \
    git \
    sudo \
    openssl \
    nginx \
    rsync \
    ufw \
    iptables \
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
    nmap \
    tcpdump \
    john \
    fail2ban \
    logrotate \
    gpg \
    netcat-openbsd \
    socat \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Crear usuario 'estudiante' con permisos sudo limitados
RUN useradd -m -s /bin/bash estudiante && \
    groupadd -f sudo && \
    echo "estudiante ALL=(ALL) NOPASSWD: /usr/bin/ufw, /usr/sbin/iptables, /usr/sbin/ufw, /usr/bin/nmap, /usr/sbin/logrotate, /usr/bin/john, /usr/sbin/fail2ban-client, /usr/sbin/ufw-disable, /usr/sbin/ufw-enable" >> /etc/sudoers && \
    usermod -aG sudo estudiante && \
    groupadd -f docker && \
    usermod -aG docker estudiante

# Preparar directorios de configuración de herramientas de seguridad
RUN mkdir -p /etc/fail2ban /var/log/fail2ban && \
    mkdir -p /etc/logrotate.d && \
    touch /var/log/auth.log /var/log/ufw.log && \
    mkdir -p /var/lab-state && \
    chown root:sudo /var/lab-state && \
    chmod 0770 /var/lab-state && \
    touch /var/lab-state/progress && \
    chown root:sudo /var/lab-state/progress && \
    chmod 0660 /var/lab-state/progress && \
    chown -R estudiante:estudiante /home/estudiante

# Copiar entrypoint
COPY entrypoint.sh /entrypoint.sh

# Copiar biblioteca compartida
COPY shared/ /shared/
COPY shared/ /opt/shared/

# Copiar unidades del curso a /opt (fuera del volume mount)
COPY units/ /opt/lab-units/

# Copiar script de reset
COPY reset.sh /reset.sh

# Copiar plantilla de respuestas
COPY plantilla.md /home/estudiante/laboratorio/plantilla.md

# Copiar .bashrc personalizado para el estudiante
COPY bashrc /home/estudiante/.bashrc

# Establecer permisos de ejecución y dueño
RUN chmod +x /entrypoint.sh && \
    chmod +x /shared/*.sh && \
    chmod +x /reset.sh && \
    find /opt/lab-units -name "*.sh" -exec chmod +x {} \; && \
    chown -R estudiante:estudiante /home/estudiante/laboratorio

# Cambiar al usuario 'estudiante'
USER estudiante

# Directorio de trabajo predeterminado
WORKDIR /home/estudiante/laboratorio

# Comando de inicio del contenedor
ENTRYPOINT ["/entrypoint.sh"]