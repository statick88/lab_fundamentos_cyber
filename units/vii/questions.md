# Preguntas de Evaluación - Unidad VII: Hardening

## Pregunta 1: Remediación de brute force y configuracion de whitelist en Fail2ban

**Escenario**:
El servidor de la facultad está recibiendo un ataque de fuerza bruta contra SSH desde múltiples IPs en el rango 203.0.113.0/24. El equipo de seguridad decide activar Fail2ban para bloquear las IPs atacantes, pero necesitan que el personal de sistemas que trabaja desde la red 10.0.0.0/24 no sea bloqueado. Debes configurar fail2ban para que aplique el baño por defecto de 10 minutos, pero excluya las IPs de la red confiable.

**Requisitos**:
- Asegurar que el servicio fail2ban esté instalado y activo
- Configurar la acción de baneo por defecto con una duración de 600 segundos (10 minutos)
- Crear una regla en la jail de sshd que bloquee IPs después de 3 intentos fallidos
- Agregar la red 10.0.0.0/24 a la lista de IPs confiables (ignoreip)
- Reiniciar el servicio fail2ban para aplicar cambios

**Restricciones**:
- No modificar el archivo jail.conf original (usar jail.local para overrides)
- No usar iptables directamente, solo la configuración de fail2ban
- No eliminar el archivo de log de fail2ban después de la configuración
- La duración del baneo debe ser exactamente 600 segundos

**Criterios de Validación**:
- El comando `systemctl is-active fail2ban` devuelve: `active`
- El archivo `/etc/fail2ban/jail.local` existe y contiene la directiva `bantime = 600`
- El comando `fail2ban-client status sshd` muestra el número de cárceles activas
- El archivo `/etc/fail2ban/jail.local` contiene `ignoreip = 10.0.0.0/24`
- El comando `fail2ban-client get sshd banip` muestra al menos una IP en la lista de baneados

**Pregunta de Selección Múltiple**:

¿Cuál es el valor exacto de la directiva `bantime` en la configuración de fail2ban para la jail de sshd?

A) `3600`
B) `600`
C) `86400`
D) `0`

**Explicación**:
- Respuesta correcta: B) `600` - Corresponde a 10 minutos (600 segundos), que es el valor configurado en `/etc/fail2ban/jail.local` con la directiva `bantime = 600`. Este valor se obtiene ejecutando: `grep -E '^bantime' /etc/fail2ban/jail.local`
- Distractor A: `3600` - Representa 1 hora, un valor común por defecto en algunas distribuciones, pero no es el configurado en el laboratorio.
- Distractor C: `86400` - Representa 24 horas, un valor demasiado agresivo para el escenario de 10 minutos solicitado.
- Distractor D: `0` - En algunas versiones de fail2ban, `0` significa baneo permanente, lo cual no coincide con el requisito de 10 minutos.

---

## Pregunta 2: Bloqueo de login root y hardening de SSH

**Escenario**:
Una auditoría de seguridad detectó que el servidor permite login directo como root por SSH y usa autenticación solo con contraseña. El equipo de seguridad emitió un ticket para remediar estos hallazgos: debes deshabilitar el login root, forzar autenticación por claves SSH, y cambiar el puerto SSH a 2222. Una vez aplicados los cambios, debes validar que el servicio sigue funcionando y capturar el hash MD5 del archivo de configuración modificado para el reporte de auditoría.

**Requisitos**:
- Modificar `/etc/ssh/sshd_config` para deshabilitar `PermitRootLogin`
- Modificar `/etc/ssh/sshd_config` para forzar `PubkeyAuthentication yes`
- Cambiar el puerto SSH a 2222 modificando la directiva `Port`
- Recargar el servicio sshd para aplicar cambios sin interrumpir conexiones existentes
- Generar el hash MD5 del archivo `/etc/ssh/sshd_config` modificado

**Restricciones**:
- No reiniciar el servicio sshd (solo recargar con `systemctl reload`)
- No eliminar el archivo de configuración original
- No modificar otros archivos de configuración de SSH
- El hash debe ser generado con `md5sum`

**Criterios de Validación**:
- El comando `grep -E '^PermitRootLogin' /etc/ssh/sshd_config` devuelve exactamente: `PermitRootLogin no`
- El comando `grep -E '^PubkeyAuthentication' /etc/ssh/sshd_config` devuelve exactamente: `PubkeyAuthentication yes`
- El comando `grep -E '^Port' /etc/ssh/sshd_config` devuelve exactamente: `Port 2222`
- El comando `systemctl is-active sshd` devuelve: `active`
- El hash MD5 del archivo `/etc/ssh/sshd_config` es un valor hexadecimal de 32 caracteres

**Pregunta de Selección Múltiple**:

¿Cuál es el hash MD5 del archivo `/etc/ssh/sshd_config` después de aplicar las tres modificaciones de hardening?

A) `d41d8cd98f00b204e9800998ecf8427e`
B) `5d41402abc4b2a76b9719d911017c592`
C) `<valor MD5 específico del archivo modificado>`
D) `098f6bcd4621d373cade4e832627b4f6`

**Explicación**:
- Respuesta correcta: C) `<valor MD5 específico del archivo modificado>` - El hash MD5 se obtiene ejecutando `md5sum /etc/ssh/sshd_config`. Dado que el contenido exacto del archivo depende de la configuración base del sistema y las modificaciones aplicadas (PermitRootLogin no, PubkeyAuthentication yes, Port 2222), el valor específico solo puede determinarse ejecutando el laboratorio. El estudiante debe calcularlo durante el lab.
- Distractor A: `d41d8cd98f00b204e9800998ecf8427e` - Es el hash MD5 de un archivo vacío. Ocurriría si el estudiante vaciara el archivo de configuración, lo cual es incorrecto y destructivo.
- Distractor B: `5d41402abc4b2a76b9719d911017c592` - Es el hash MD5 de la cadena "hello". No tiene relación con el archivo de configuración de SSH.
- Distractor D: `098f6bcd4621d373cade4e832627b4f6` - Es el hash MD5 de la cadena "test". Es un valor genérico que no corresponde al contenido real del archivo modificado.
