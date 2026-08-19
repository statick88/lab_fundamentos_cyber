# Guía del Docente - Laboratorio de Ciberseguridad ABC-CYB-101

## Soluciones modelo por reto nuevo

### Unidad II: Filtrado de Red y Firewalls
| Reto | Solución |
|------|----------|
| 1 | `grep -i "HTTP" captura_http.pcapng` - Puerto 80 TCP |
| 2 | `grep '^https' /etc/services` - Puerto 443 TCP |
| 3 | `grep -i "SSH" captura_ssh.pcapng` - Puerto 22 TCP |
| 4 | `grep '^domain' /etc/services` - Puerto 53 UDP/TCP |
| 5 | `echo '-A ufw-user-input -p tcp --dport 22 -j ACCEPT' >> /etc/ufw/user.rules` |
| 6 | `echo '-A ufw-user-input -p tcp --dport 23 -j DROP' >> /etc/ufw/user.rules` |
| 7 | Agregar reglas ACCEPT para puertos 80 y 443 |
| 8 | `sudo iptables -A INPUT -s 10.0.0.99 -j DROP` |
| 9 | `sudo iptables -L -n -v` |
| 10 | `nmap -sS -p- 172.20.0.10` |

### Unidad III: IAM, MFA y Control de Acceso
| Reto | Solución |
|------|----------|
| 11 | `sudo groupadd sysadmins` + `sudo useradd -m -G sysadmins ops_admin` |
| 12 | `echo '%sysadmins ALL=(ALL) NOPASSWD: /usr/bin/systemctl' | sudo tee /etc/sudoers.d/lab-cyber` |
| 13 | Editar `/etc/login.defs`: PASS_MAX_DAYS 90, PASS_MIN_DAYS 1, PASS_WARN_AGE 14 |
| 14 | `sudo apt install -y libpam-google-authenticator` + editar `/etc/pam.d/common-auth` |
| 15 | Script con `awk -F: '$3 == 0 {print $1}' /etc/passwd` y grep de sudoers |

### Unidad IV: Criptografía y CVSS
| Reto | Solución |
|------|----------|
| 1 | CVSS 9.8 para AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H |
| 2 | CVSS 6.1 para XSS reflejado |
| 3 | CVSS 7.8 para buffer overflow local |
| 4 | Python/awk para clasificar: 7.0-8.9 = High |
| 5 | `grep 'Failed password' auth.log` |
| 6 | `grep -iE 'union|select|insert|drop' access.log` |
| 7 | `grep -iE '\.\./|etc/passwd' access.log` |
| 8 | Buscar X-Priority, Reply-To sospechoso |
| 9 | `sha256sum malware_simulado.bin` |
| 10 | `diff baseline_hashes.txt actual.txt` |

### Unidad V: Logging, SIEM y BCP
| Reto | Solución |
|------|----------|
| 1 | `logger 'mensaje'` + grep en /var/log/syslog |
| 2 | Crear `/etc/logrotate.d/mi_app` con daily, rotate 7, compress |
| 3 | `grep -E 'error|fail|critical' mi_app.log` |
| 4 | `awk '$4 ~ /13:55/ {print $0}' apache_access.log` |
| 5 | `sed 's/192\.168\.[0-9]\+\.[0-9]\+/ENMASCARADA/g' apache_access.log` |
| 6 | `grep '13:55:38' auth_sys.log mi_app.log` |
| 7 | Script que revise `/proc/*/status` y `ss -tuln` |
| 8 | Script con `tar -czf` + `rsync` (3-2-1) |
| 9 | Documento RTO/RPO con definiciones y valores |
| 10 | Playbook secuencial: Preparación → Detección → Contención → Erradicación → Recuperación |

### Unidad VII: Hardening y CIS Benchmarks (retos 11-15)
| Reto | Solución |
|------|----------|
| 11 | Verificar `/tmp` con `mount | grep noexec` |
| 12 | Verificar `/var` con `mount | grep nosuid` |
| 13 | Verificar `/var/log` con `mount | grep nodev` |
| 14 | `grep 'PermitRootLogin no' /etc/ssh/sshd_config` |
| 15 | `grep 'Protocol 2' /etc/ssh/sshd_config` |

### Unidad X: SSL/TLS ampliado (retos 11-15)
| Reto | Solución |
|------|----------|
| 11 | `openssl genrsa -out rsa4096.pem 4096` |
| 12 | `openssl ecparam -genkey -name secp384r1 -out ecc.key` |
| 13 | `openssl req -new -key clave_privada.pem -out request.csr` |
| 14 | `openssl verify -CAfile ca/ca.crt servidor.crt` |
| 15 | Verificar subject del certificado y existencia de archivos |

## Troubleshooting común

| Problema | Causa | Solución |
|----------|-------|----------|
| Validator reto 5 falla | No existe archivo `archivo` | `touch archivo && chmod 755 archivo` |
| UFW no guarda reglas | Permisos en /etc/ufw | `sudo chmod 644 /etc/ufw/user.rules` |
| openssl falla en reto 10 | No existe CA | Ejecutar setup.sh primero |
| grep no encuentra patrones | Archivo no existe | Verificar ruta en ~/laboratorio/ |
| iptables permission denied | No es root | Usar sudo para iptables |

## Recomendaciones pedagógicas por módulo

### Módulo I (Unidad I + ii + VI)
- Enfocarse en FHS, navegación básica, redes y protocolos
- Usar `ls -la` frecuentemente para mostrar estructura de archivos
- Unidad VI (LVM) es exploratoria: permitir que estudiantes avanzados profundicen

### Módulo II (Unidad II + III-iam + iii + Checkpoint II)
- Empezar con identificación de protocolos antes de configurar firewalls
- Usar capturas simuladas para análisis sin riesgo
- Checkpoint después de dominar UFW básico e iptables
- Scripting Bash (15 retos) complementa IAM/MFA con automatización

### Módulo III (Unidad IV + iv + VII + VIII)
- CVSS es teórico, usar calculadora online como referencia
- Hashing es práctico, verificar archivos reales del sistema
- Criptografía aplicada (10 retos) complementa la unidad base de CVSS
- Hardening (15 retos) requiere configuración del sistema
- Docker (10 retos) es exploratorio: containers como complemento de hardening

### Módulo IV (Unidad V + V-processes + IX + X + Checkpoint IV)
- Logging/SIEM/BCP (10 retos) es extremadamente práctico: generar logs en tiempo real
- Procesos y Servicios (10 retos, legacy) es exploratorio
- Nginx (10 retos) es exploratorio: complementa logging con análisis de access logs
- SSL/TLS (15 retos): RSA 4096, ECC secp384r1, verificación de cadena
- Checkpoint valida comprensión de análisis de logs y configuración TLS

### Módulo V (Unidad XI + Checkpoint V)
- Docker Compose + DB (10 retos) integración de servicios con orquestación
- Checkpoint evalúa síntesis de configuración TLS y despliegue de servicios

## Cómo evaluar con los checkpoints

1. Los checkpoints son evaluaciones formativas (no sumativas)
2. Ejecutar: `unidad 12` (o 13, 14) → `evaluar`
3. Puntaje mínimo recomendado: 3/5 retos aprobados
4. Si falla, el estudiante puede reintentar
5. Registrar resultados para seguimiento pedagógico

## Clasificación pedagógica CORE / OPTATIVO

| Tipo | Retos | Descripción |
|------|:-----:|-------------|
| CORE | 60 | Obligatorios para certificación. Cubren competencias mínimas del módulo. |
| OPTATIVO | 115 | Exploratorios. Permiten profundizar en tópicos avanzados. |

- Las sesiones de 24h se diseñan alrededor de los 60 retos CORE.
- Los retos OPTATIVO se pueden asignar como tarea adicional o para estudiantes avanzados.
- La clasificación está centralizada en `shared/units_manifest.sh`.
- **Distribución CORE por unidad**: I(10)+II-firewalls(10)+III-iam(5)+IV(10)+V-logging(10)+checkpoint-II(5)+checkpoint-IV(5)+checkpoint-V(5) = 60 retos.

## Anti-tampering y progreso

- El progreso se almacena en `/var/lab-state/progress` (root-owned, permisos 0660).
- El estudiante no puede modificar ni eliminar el archivo de progreso.
- Los validadores leen el estado desde `/var/lab-state`, no desde `~/.lab_state`.
- Al migrar desde versiones anteriores, el progreso se copia automáticamente y se protege.

## Validadores estrictos

- **CVSS**: requiere un script Python (`cvss_calculator.py`) con al menos 10 líneas, referencias a métricas AV/AC/PR/UI/S/C/I/A y operaciones matemáticas. El score se compara con tolerancia configurable.
- **Logs**: verifica archivos reales con antigüedad mínima (300s) y patrones de timestamp válidos (syslog o ISO8601).
- **Firewall**: valida estado real de `ufw` e `iptables` via sudo, con fallback a scripts del estudiante.
- **IAM**: verifica grupos, usuarios, sudoers y configuraciones PAM directamente en el sistema.

## Aislamiento de red

- Red bridge `lab-cyber` en subnet `172.20.0.0/24`.
- `driver_opts` deshabilita IP masquerade (`com.docker.network.bridge.enable_ip_masquerade: "false"`).
- Bind de la red solo a `127.0.0.1` (`com.docker.network.bridge.host_binding_ipv4: "127.0.0.1"`).
- El contenedor usa capabilities mínimas: `NET_ADMIN`, `NET_RAW`, `SETUID`, `SETGID`.

## Viabilidad de sesión 24h

- El entorno está diseñado para sesiones de 24 horas continuas.
- `restart: unless-stopped` asegura que el contenedor se recupere ante reinicios.
- Los archivos de estudiante persisten en el volumen `lab-data`.
- El progreso en `/var/lab-state` sobrevive a reinicios del contenedor.

## Cómo usar reset.sh entre clases

```bash
# Reset básico (sin progreso)
bash reset.sh

# Reset completo (con progreso)
bash reset.sh --progreso
```

El script:
- Detiene ufw y fail2ban
- Limpia reglas iptables
- Elimina archivos de prueba
- No elimina imágenes Docker ni volúmenes
- No desinstala paquetes del sistema
