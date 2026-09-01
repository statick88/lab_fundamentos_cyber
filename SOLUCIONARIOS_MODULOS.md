# Solucionarios de Módulos — ABC-CYB-101

## Módulo 1 — Terminal, Permisos y Errores
**Archivo:** `content/ebook-guia/modulo-01-linux-consola.qmd`
**Unidad base:** I (Linux Interactivo)
**Plantilla de respuestas:** `plantilla.md` (Retos 1-10)

| Reto | Objetivo | Solución modelo | Comando clave |
|------|----------|-----------------|---------------|
| 1 | Exploración del sistema | Identificar estructura FHS | `ls -la /`, `pwd`, `tree /etc` |
| 2 | Archivos y directorios | Navegar y listar archivos | `cd`, `ls -la`, `find /home -name "*.txt"` |
| 3 | Contenido de archivos | Leer archivos del sistema | `cat /etc/passwd`, `head`, `tail` |
| 4 | Permisos y procesos | Gestionar permisos básicos | `ls -la`, `ps aux`, `chmod` |
| 5 | El desafío final | Síntesis de comandos básicos | `grep`, `find`, encadenamiento con \| |
| 6 | Permisos con chmod | Modo simbólico y octal | `chmod 755 archivo`, `chmod u+x script.sh` |
| 7 | Búsqueda de archivos | Localizar archivos en el sistema | `find / -name "flag.txt"`, `locate` |
| 8 | Tuberías y redirección | Conectar comandos y redirigir | `cmd1 \| cmd2`, `> archivo`, `>>` |
| 9 | Procesos en ejecución | Gestionar procesos del sistema | `ps aux`, `kill`, `pgrep` |
| 10 | Compresión y archivos | Comprimir y extraer archivos | `tar -czf`, `tar -xzf`, `gzip` |

**Frase oculta (Reto 1-10):** Revelada con `revelar-frase` tras completar los 10 retos.

---

## Módulo 2 — Reconocimiento de Red con Ubuntu 24.04
**Archivo:** `content/ebook-guia/modulo-02-reconocimiento-redes.qmd`
**Unidad base:** ii-firewalls-redes
**Referencia profesional:** Kali Linux (no instalado en el laboratorio)

| Reto | Objetivo | Solución modelo | Comando clave |
|------|----------|-----------------|---------------|
| 1 | Identificar protocolos y puertos | Puerto 80 TCP = HTTP | `grep -i "HTTP" captura_http.pcapng` |
| 2 | Mapear servicios a puertos | Puerto 443 TCP = HTTPS | `grep '^https' /etc/services` |
| 3 | Analizar tráfico SSH | Puerto 22 TCP = SSH | `grep -i "SSH" captura_ssh.pcapng` |
| 4 | Identificar DNS | Puerto 53 UDP/TCP = DNS | `grep '^domain' /etc/services` |
| 5 | Configurar regla UFW ACCEPT | Permitir tráfico SSH entrante | `echo '-A ufw-user-input -p tcp --dport 22 -j ACCEPT' >> /etc/ufw/user.rules` |
| 6 | Configurar regla UFW DROP | Bloquear Telnet (puerto 23) | `echo '-A ufw-user-input -p tcp --dport 23 -j DROP' >> /etc/ufw/user.rules` |
| 7 | Permitir HTTP y HTTPS | Agregar reglas ACCEPT 80/443 | `ufw allow 80/tcp`, `ufw allow 443/tcp` |
| 8 | Bloquear IP sospechosa | Rechazar tráfico de 10.0.0.99 | `sudo iptables -A INPUT -s 10.0.0.99 -j DROP` |
| 9 | Listar reglas de firewall | Ver tabla de reglas activas | `sudo iptables -L -n -v` |
| 10 | Escaneo de puertos | Identificar puertos abiertos | `nmap -sS -p- 172.20.0.10` |

**Checkpoint II (5 retos):** Síntesis de análisis de red y configuración de firewalls.

---

## Módulo 3 — Git: Control de Versiones
**Archivo:** `content/ebook-guia/modulo-03-git.qmd`
**Unidad base:** iii-iam-mfa
**Unidad complementaria:** iii (Scripting Bash 1-10)

| Reto | Objetivo | Solución modelo | Comando clave |
|------|----------|-----------------|---------------|
| 1 | Configurar identidad Git | Establecer user.name y email | `git config user.name`, `git config user.email` |
| 2 | Crear repositorio | Inicializar repo local | `git init`, `git add`, `git commit -m` |
| 3 | Ramas y fusión | Crear rama y mergear | `git checkout -b feature/x`, `git merge` |
| 4 | Estrategia Git Flow | main + develop + fix/* | Ver CONTRIBUTING.md, diagrama de flujo |
| 5 | Conventional Commits | feat: y fix: format | `feat:`, `fix:`, `chore:` |
| 6 | Resolución de conflictos | Merge conflict manual | Editor de texto, `git add` post-resolución |
| 7 | .gitignore para seguridad | Excluir credenciales y logs | `echo "*.pem" >> .gitignore`, `echo "*.log" >>` |
| 8 | Git hooks de seguridad | Pre-commit para secrets scan | `.git/hooks/pre-commit` |
| 9 | Revisiones de código | git log + git diff | `git log --oneline`, `git diff HEAD~1` |
| 10 | Recuperación de versiones | git checkout para rollback | `git checkout <hash>`, `git reflog` |

**Conventional Commits examples:**
- `feat(security): add firewall configuration`
- `fix(auth): resolve privilege escalation issue`

---

## Módulo 4 — Docker: Contenedores y Aislamiento
**Archivo:** `content/ebook-guia/modulo-04-docker-contenedores.qmd`
**Unidad base:** viii (Docker, 10 retos)
**Unidad complementaria:** xi (Docker Compose + DB, 10 retos)

| Reto | Objetivo | Solución modelo | Comando clave |
|------|----------|-----------------|---------------|
| 1 | Concepto de aislamiento | Namespaces y cgroups | Comparar con "caja de herramientas sellada" |
| 2 | Inspeccionar compose | Analizar service, network, capabilities | `docker-compose config`, `docker inspect` |
| 3 | Backup incremental | rsync -avz para respaldo | `rsync -avz /origen/ /destino/` |
| 4 | Harden Dockerfile | Non-root user + capability dropping | `USER estudiante`, `LABEL` security tags |
| 5 | Capabilities vs CIS | SETUID/SETGID vs SYS_ADMIN | `docker inspect --format='{{.HostConfig.CapAdd}}'` |
| 6 | CIS Docker Benchmark | Verificar configuraciones | `docker-bench-security` (referencia) |
| 7 | Entrar al contenedor | Acceder con permisos limitados | `docker exec -it <container> bash` |
| 8 | Imágenes base seguras | distroless o alpine | `FROM gcr.io/distroless/static` |
| 9 | Escaneo de vulnerabilidades | Trivy para imágenes | `trivy image <image>` |
| 10 | Secrets management | No hardcodear credenciales | Docker secrets, env files |

**Docker Compose:** Referencia `docker-compose.yml` del laboratorio `lab-linux`.

---

## Módulo 5 — Wargames: minicurso Bandit (niveles 0-5)
**Archivo:** `content/ebook-guia/modulo-05-wargames.qmd`
**Unidad base:** v-logging-siem-bcp (intersección)

| Reto | Objetivo | Solución modelo | Comando clave |
|------|----------|-----------------|---------------|
| 1 | Bandit nivel 0-1 | Leer archivo de password | `ssh bandit.labs@bandit.labs.overthewire.org -p 2220` |
| 2 | Archivo oculto | Bandit nivel 1-2 | `ls -a`, `find / -name "-*" 2>/dev/null` |
| 3 | Permisos de archivo | Bandit nivel 2-3 | `cat ./-file`, `strings`, `xxd` |
| 4 | find con permisos | Bandit nivel 3-4 | `find / -perm -4000 2>/dev/null` |
| 5 | Password en archivo | John para cracking | `john --wordlist=rockyou.txt hash.txt` |
| 6 | hashcat modos | Offline cracking con hashcat | `hashcat -m 1800 -a 0 hash.txt rockyou.txt` |
| 7 | ssh key cracking | Recuperar claves SSH | `ssh2john id_rsa > hash.txt` |
| 8 | OverTheWire setup | Recrear nivel 0 localmente | `docker run --rm -it overthewire/bandit` |
| 9 | Ethical framing | Authorized testing only | Documentar autorización explícita |
| 10 | Next steps | Niveles 4-5 en OverTheWire | Referenciar sitio oficial |

**Nota ética:** Bandit se reproduce localmente. OverTheWire se usa como referencia externa profesional. No se clona ni instala en el laboratorio.

---

## Módulo 6 — Logging, SIEM y BCP
**Archivo:** `content/ebook-guia/modulo-06-logging-siem-bcp.qmd`
**Unidad base:** v-logging-siem-bcp

| Reto | Objetivo | Solución modelo | Comando clave |
|------|----------|-----------------|---------------|
| 1 | tcpdump capture | Capturar tráfico de red | `tcpdump -i eth0 -w capture.pcap` |
| 2 | Analyze capture | Analizar paquetes capturados | `tcpdump -nn -r capture.pcap`, `tcpdump -A` |
| 3 | logrotate config | Configurar rotación de logs | `/etc/logrotate.d/mi_app` con daily, rotate, compress |
| 4 | Grep en logs | Buscar patrones de amenaza | `grep -E 'error\|fail\|critical' mi_app.log` |
| 5 | Correlación de eventos | Correlacionar logs múltiples | `awk '$4 ~ /13:55/ {print $0}' apache_access.log` |
| 6 | Mascarar datos sensibles | Anonimizar logs | `sed 's/192\.168\.[0-9]\+\.[0-9]\+/ENMASCARADA/g'` |
| 7 | Script de monitoreo | Procesos y puertos activos | Script con `/proc/*/status` y `ss -tuln` |
| 8 | Backup 3-2-1 | Estrategia de respaldo | `tar -czf` + `rsync` (3-2-1) |
| 9 | BCP: RTO/RPO | Definir tiempos de recuperación | Documento RTO/RPO con definiciones y valores |
| 10 | IR Playbook | Playbook de respuesta a incidentes | Preparación → Detección → Contención → Erradicación → Recuperación |

**openssl s_client TLS analysis:** `openssl s_client -connect ejemplo.com:443`

---

## Cross-reference: Módulos ↔ Unidades ↔ Plantilla

| Módulo | Unidad(es) base | Retos en `plantilla.md` | Check ID |
|--------|-----------------|------------------------|----------|
| M1 | I | Retos 1-10 | checkpoint-ii |
| M2 | ii-firewalls-redes | Retos 1-10 del módulo | checkpoint-ii |
| M3 | iii-iam-mfa, iii | Retos 1-10 del módulo | checkpoint-iii |
| M4 | viii, xi | Retos 1-10 del módulo | checkpoint-iv |
| M5 | v-logging-siem-bcp (intersección) | Retos 1-10 del módulo | checkpoint-v |
| M6 | v-logging-siem-bcp | Retos 1-10 del módulo | checkpoint-v |

## Resolución de problemas comunes

| Problema | Causa | Solución |
|----------|-------|----------|
| tcpdump no captura | Sin permisos NET_RAW | Usar `sudo tcpdump` |
| logrotate falla | Permisos en /etc/logrotate.d | `sudo chmod 644 /etc/logrotate.d/mi_app` |
| john no crackea | Wordlist no encontrada | Descargar `rockyou.txt` |
| openssl s_client falla | DNS o puerto bloqueado | Verificar conectividad previa |
| Docker compose falla | Archivo no encontrado | Verificar `docker-compose.yml` en directorio correcto |
