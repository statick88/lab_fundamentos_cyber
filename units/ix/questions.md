# Preguntas de Evaluación - Unidad IX: nginx

## Pregunta 1: Puerto del Virtual Host en Producción

**Escenario**:
Recibes un ticket de producción donde el sitio web "misitio" no responde en el puerto esperado. El equipo de desarrollo deployó un nuevo virtual host pero olvidó documentar en qué puerto escucha. Debes investigar la configuración actual de nginx para identificar el puerto antes de abrir un cambio en el firewall.

**Requisitos**:
- Leer el archivo de configuración del virtual host "misitio" en `/etc/nginx/sites-available/`
- Identificar el valor exacto de la directiva `listen`
- No modificar ningún archivo de configuración

**Restricciones**:
- No editar `/etc/nginx/sites-available/misitio`
- No usar `nano`, `vim` ni ningún editor de texto
- No recargar ni reiniciar nginx

**Criterios de Validación**:
- El comando `grep 'listen' /etc/nginx/sites-available/misitio` devuelve exactamente `listen 8080;`
- El puerto identificado es un número entero entre 1 y 65535

**Pregunta de Selección Múltiple**:

¿En qué puerto está configurado el virtual host "misitio"?

A) 80
B) 8000
C) 443
D) 8080

**Explicación**:
- Respuesta correcta: D) 8080 - El archivo `/etc/nginx/sites-available/misitio` contiene la línea `listen 8080;`, que se puede verificar con `grep 'listen' /etc/nginx/sites-available/misitio`. Este puerto fue configurado explícitamente en el archivo de virtual host durante el reto de configuración.
- Distractor A: 80 es el puerto HTTP predeterminado, pero el virtual host "misitio" no está configurado en este puerto.
- Distractor B: 8000 es un puerto alternativo común, pero no coincide con la configuración actual del archivo.
- Distractor C: 443 es el puerto HTTPS predeterminado, pero este virtual host no tiene configuración SSL/TLS.

---

## Pregunta 2: Validación de Configuración en Pipeline de Deployment

**Escenario**:
El pipeline de CI/CD falló al intentar recargar nginx después de un deploy. Como medida de contingencia, debes verificar manualmente que la configuración actual de nginx sea sintácticamente válida antes de abrir un incidente crítico. Necesitas capturar la salida exacta del comando de validación para incluirla en el reporte del ticket.

**Requisitos**:
- Ejecutar el comando de validación de configuración de nginx
- Capturar la salida estándar y de error combinada
- Reportar la línea exacta que indica éxito

**Restricciones**:
- No modificar ningún archivo de configuración
- No recargar ni reiniciar el servicio nginx
- No usar `tail` ni `cat` sobre archivos de log como método de verificación

**Criterios de Validación**:
- El comando `sudo nginx -t 2>&1` devuelve exactamente: `nginx: configuration file /etc/nginx/nginx.conf test is successful`
- La salida contiene la palabra "successful"

**Pregunta de Selección Múltiple**:

¿Cuál es la salida exacta de `sudo nginx -t 2>&1` cuando la configuración de nginx es válida?

A) `nginx: configuration file /etc/nginx/nginx.conf test is ok`
B) `nginx: configuration file /etc/nginx/nginx.conf test is successful`
C) `nginx: [emerg] "listen" directive is not allowed here`
D) `nginx: configuration file /etc/nginx/nginx.conf syntax is ok`

**Explicación**:
- Respuesta correcta: B) `nginx: configuration file /etc/nginx/nginx.conf test is successful` - Cuando la configuración de nginx es válida, el comando `nginx -t` devuelve exactamente esta línea. El mensaje "test is successful" es la salida estándar de nginx en versiones compatibles con Ubuntu 24.04 cuando no hay errores de sintaxis.
- Distractor A: Usa "is ok" en lugar de "is successful", lo cual no corresponde a la salida real de nginx; podría confundirse con la salida de otros servicios como Apache.
- Distractor C: Es un mensaje de error de nginx que indica una directiva mal ubicada, no una validación exitosa.
- Distractor D: Usa "syntax is ok", que no es el formato de mensaje de nginx; podría confundirse con la salida de `apachectl -t` o con mensajes de otros servidores web.
