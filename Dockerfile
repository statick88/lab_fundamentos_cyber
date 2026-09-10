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
     tshark \
     suricata \
     yara \
     jq \
     && apt-get clean \
     && rm -rf /var/lib/apt/lists/*

# Crear usuario 'estudiante' con permisos sudo limitados
RUN useradd -m -s /bin/bash estudiante && \
    echo 'estudiante:lab123' | chpasswd && \
    groupadd -f sudo && \
    echo "estudiante ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/estudiante && \
    usermod -aG sudo estudiante && \
    groupadd -f docker && \
    usermod -aG docker estudiante && \
    usermod -aG adm estudiante && \
    chown root:adm /var/log/nginx && \
    chmod 0775 /var/log/nginx

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
    chown -R estudiante:estudiante /home/estudiante && \
    sed -i 's|^user .*;|user root;|' /etc/nginx/nginx.conf && \
    mkdir -p /tmp/nginx/body /tmp/nginx/proxy /tmp/nginx/fastcgi /tmp/nginx/uwsgi /tmp/nginx/scgi && \
    chmod 1777 /tmp/nginx/body /tmp/nginx/proxy /tmp/nginx/fastcgi /tmp/nginx/uwsgi /tmp/nginx/scgi && \
    sed -i '/http {/a \    client_body_temp_path /tmp/nginx/body;\n    proxy_temp_path /tmp/nginx/proxy;\n    fastcgi_temp_path /tmp/nginx/fastcgi;\n    uwsgi_temp_path /tmp/nginx/uwsgi;\n    scgi_temp_path /tmp/nginx/scgi;' /etc/nginx/nginx.conf && \
    rm -f /var/log/nginx/error.log /var/log/nginx/access.log

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