# Unit IX — Web Server (nginx)
## Evaluación: 2 preguntas prácticas

---

### Pregunta 1 — Virtual host y respuesta HTTP

**Título:** Web ops ticket — custom virtual host on port 8080

**Escenario:**  
El equipo de Plataformas necesita desplegar un sitio interno en el servidor nginx escuchando en el puerto `8080` con un `server_name` de `localhost`. Debes crear el directorio raíz, el archivo `index.html`, la configuración de virtual host y recargar nginx. Como evidencia, el validador consultará la respuesta HTTP y la configuración activa.

**Requisitos:**
- Crear `/var/www/misitio/index.html` con contenido HTML que incluya la etiqueta `<h1>`.
- Crear `/etc/nginx/sites-available/misitio` con `listen 8080`, `server_name localhost` y `root /var/www/misitio`.
- Habilitar el sitio con un enlace simbólico en `sites-enabled`.
- Ejecutar `nginx -t` y recargar con `nginx -s reload`.

**Restricciones:**
- No modificar el archivo predeterminado `/etc/nginx/sites-enabled/default` a menos que sea necesario.
- El puerto `8080` no debe entrar en conflicto con el sitio predeterminado en el puerto `80`.
- Usar `sudo` para escribir en `/etc/nginx/` y `/var/www/`.

**Criterios de validación:**
- `curl -s http://localhost:8080` devuelve un cuerpo que contiene `Bienvenido a mi sitio`.
- `ls /etc/nginx/sites-enabled/` contiene `misitio`.
- `nginx -t` reporta `successful` o `ok`.

**Pregunta de selección múltiple:**

> Después de configurar el virtual host en el puerto 8080, ¿cuál es el contenido exacto del título (`<title>`) que debe tener la página para pasar la validación del `test.sh`?

A) `Mi Servidor`  
B) `Mi Sitio`  
C) `Bienvenido a mi sitio`  
D) `Hola desde nginx`  

**Explicación de distractores:**
- A) `Mi Servidor`: coincide con el Reto 4 del `setup.sh` (`/var/www/html/index.html`), pero el validador del Reto 5 usa `/var/www/misitio/index.html` con contenido diferente.
- C) `Bienvenido a mi sitio`: es el contenido del `<h1>` en el body, no del `<title>`.
- D) `Hola desde nginx`: coincide con el ejemplo del Reto 4, no con el virtual host del Reto 5.

**Respuesta correcta:** B) `Mi Sitio`  
**Evidencia:** El `setup.sh` de Unit IX, Reto 5, define `<title>Mi Sitio</title>` en `/var/www/misitio/index.html`. Se confirma ejecutando: `curl -s http://localhost:8080 | grep -i '<title>'`.

---

### Pregunta 2 — Logs de acceso y verificación de actividad

**Título:** Monitoring ticket — access log forensics

**Escenario:**  
El equipo de Seguridad requiere confirmar que nginx está registrando tráfico de acceso para realizar auditorías. Debes generar tráfico hacia el servidor web, inspeccionar el log de acceso y reportar el número de líneas generadas después de una solicitud controlada. Como evidencia, el validador consultará la existencia y contenido del archivo de log.

**Requisitos:**
- Asegurar que nginx esté corriendo y sirviendo contenido.
- Generar al menos una solicitud HTTP con `curl -s http://localhost`.
- Inspeccionar `/var/log/nginx/access.log` y contar las líneas que contienen `localhost` o `127.0.0.1`.

**Restricciones:**
- No usar herramientas de análisis externas; solo `cat`, `grep`, `wc -l`.
- El archivo de log debe estar en la ruta estándar `/var/log/nginx/`.
- No detener nginx antes de inspeccionar el log.

**Criterios de validación:**
- `/var/log/nginx/access.log` existe.
- `grep 'localhost' /var/log/nginx/access.log | wc -l` devuelve un número mayor o igual a 1.

**Pregunta de selección múltiple:**

> Después de generar tráfico con `curl -s http://localhost` y ejecutar `grep 'localhost' /var/log/nginx/access.log | wc -l`, ¿cuál es el número mínimo de líneas esperado en el archivo de acceso?

A) 0  
B) 1  
C) 2  
D) 3  

**Explicación de distractores:**
- A) 0: indicaría que no se registró ninguna solicitud; solo ocurre si nginx no está corriendo o el log está deshabilitado.
- C) 2: podría aparecer si hubo una solicitud y posteriormente un `HEAD` de monitoreo, pero no es el mínimo garantizado.
- D) 3: número arbitrario; confunde líneas de log con múltiples solicitudes o con líneas de error.

**Respuesta correcta:** B) 1  
**Evidencia:** El `setup.sh` de Unit IX, Reto 6, crea el archivo de log y el `test.sh` valida que `ls /var/log/nginx/` contenga `access`. Se confirma ejecutando: `curl -s http://localhost >/dev/null && grep -c 'localhost' /var/log/nginx/access.log`.
