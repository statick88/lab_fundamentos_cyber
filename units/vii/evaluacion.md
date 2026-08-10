# Unit VII — Security Hardening
## Evaluación: 2 preguntas prácticas

---

### Pregunta 1 — Fail2ban brute force remediation and whitelisting

**Título:** SOC ticket — SSH brute force ban and admin whitelist

**Escenario:**  
El SOC reporta que el servidor Linux está recibiendo ataques de fuerza bruta contra SSH desde una IP externa. Se debe activar la protección de fail2ban para sshd, verificar que la jaula (jail) esté activa, y asegurar que la IP del administrador (10.0.0.5) esté en la whitelist para no ser bloqueada. Como evidencia, el validador consultará el estado de la jail y el recuento de reglas de iptables asociadas.

**Requisitos:**
- Instalar y habilitar `fail2ban`.
- Configurar una jail para `sshd` en `/etc/fail2ban/jail.local` o `/etc/fail2ban/jail.d/defaults-debian.conf`.
- Asegurar que la IP `10.0.0.5` esté en `ignoreip`.
- Reiniciar el servicio y verificar que la jail esté activa con `fail2ban-client status sshd`.

**Restricciones:**
- No modificar `/etc/fail2ban/jail.conf` directamente; usar `.local` o archivos en `jail.d/`.
- El puerto SSH debe permanecer accesible para `10.0.0.5`.
- No bloquear la interfaz de loopback (`127.0.0.1`).

**Criterios de validación:**
- `fail2ban-client status sshd` muestra la jail como `active`.
- `iptables -L` contiene reglas de `f2b-sshd`.
- `ignoreip` incluye `10.0.0.5`.

**Pregunta de selección múltiple:**

> Después de configurar fail2ban para sshd y verificar el estado, ¿cuál es el valor exacto del parámetro `maxretry` recomendado por defecto en la plantilla de fail2ban para sshd?

A) 3  
B) 5  
C) 10  
D) 15  

**Explicación de distractores:**
- A) 3: valor común en configuraciones personalizadas de alta seguridad, pero no es el default de la plantilla estándar de fail2ban para sshd.
- C) 10: valor demasiado permisivo; algunos administradores lo usan en entornos de prueba, pero no aparece en la configuración por defecto.
- D) 15: valor alejado de cualquier recomendación oficial; distractor para estudiantes que confunden `maxretry` con `bantime`.

**Respuesta correcta:** B) 5  
**Evidencia:** La plantilla `/etc/fail2ban/jail.conf` define `maxretry = 5` para la sección `[sshd]`. Este valor se obtiene ejecutando: `grep -E 'maxretry' /etc/fail2ban/jail.conf /etc/fail2ban/jail.d/*.conf 2>/dev/null`.

---

### Pregunta 2 — SSH hardening and root login blocking

**Título:** Infosec ticket — disable root SSH and enforce key-based auth

**Escenario:**  
El equipo de seguridad emitió una directiva: ningún servidor de producción debe permitir autenticación de root por SSH ni contraseñas. Debes aplicar el hardening en `/etc/ssh/sshd_config`, generar un par de claves RSA de 4096 bits para el usuario `estudiante` y asegurar que el directorio `~/.ssh` tenga permisos `700`. Como evidencia, el validador consultará la configuración activa de sshd y los permisos del directorio.

**Requisitos:**
- Modificar `/etc/ssh/sshd_config` para establecer `PermitRootLogin no` y `PasswordAuthentication no`.
- Recargar el servicio con `systemctl reload sshd` o `service ssh reload`.
- Generar claves SSH RSA 4096 para `estudiante` en `~/.ssh/id_rsa` y `~/.ssh/id_rsa.pub`.
- Establecer permisos `700` en `~/.ssh`.

**Restricciones:**
- No eliminar la configuración existente de sshd_config; comentar líneas con `#`.
- No usar algoritmos débiles (DSA, RSA < 2048).
- No exponer la clave privada a otros usuarios (`chmod 600` al menos).

**Criterios de validación:**
- `sshd -T | grep -E 'permitrootlogin|passwordauthentication'` muestra `no` para ambos parámetros.
- `~/.ssh/id_rsa` y `~/.ssh/id_rsa.pub` existen.
- `stat -c "%a" ~/.ssh` devuelve `700`.

**Pregunta de selección múltiple:**

> Después de aplicar el hardening de SSH, ¿cuál es el permiso octal correcto que debe tener el directorio `~/.ssh` para que sshd acepte la autenticación por clave sin advertencias?

A) 755  
B) 750  
C) 700  
D) 644  

**Explicación de distractores:**
- A) 755: permiso demasiado abierto; sshd rechaza autenticación por clave si el directorio `.ssh` es legible por grupo u otros, generando `Bad owner or permissions`.
- B) 750: permite lectura al grupo; sigue siendo inseguro para `~/.ssh` y sshd lo rechaza en implementaciones estrictas.
- D) 644: aplica permisos de archivo a un directorio y elimina el bit de ejecución; sshd no puede acceder al contenido.

**Respuesta correcta:** C) 700  
**Evidencia:** El `setup.sh` de Unit VII, Reto 8, aplica `chmod 700 ~/.ssh`, y el `test.sh` valida que `stat -c "%a" ~/.ssh` sea exactamente `700`.
