# Unit IV: Burp Suite Intercepción de Tráfico HTTP — questions.md

## Pregunta 1: Configuración del Proxy Burp

**Escenario:** Eres un profesional de seguridad que debe configurar Burp Suite como proxy interceptador en una evaluación de seguridad de aplicaciones web. El objetivo es interceptar el tráfico HTTP/HTTPS entre un cliente y un servidor web objetivo para analizar y modificar parámetros en tránsito.

**Requisitos:**
- Configurar Burp Suite con proxy en el puerto 8080
- Establecer el objetivo en http://localhost:5000 (servidor Flask)
- Habilitar la función de interceptación en la pestaña Intercept
- Verificar que las peticiones GET y POST fluyen a través del proxy

**Restricciones:**
- No se puede deshabilitar la interceptación una vez activada
- Modificar sólo los parámetros especificados en el enunciado
- Mantener la integridad de la sesión HTTP en las peticiones no objetivo

**Criterios de Validación:**
- La pestaña Intercept de Burp muestra el interruptor activado (verde)
- Petición GET a http://localhost:5000/ llega al servidor a través del proxy
- Petición POST a http://localhost:5000/compra llega al servidor a través del proxy
- El tráfico se registra en la pestaña Logger de Burp

**Pregunta multiple choice:** ¿Qué puerto debe configurarse en Burp Suite para interceptar tráfico local hacia el servidor Flask?

a) Puerto 80  
b) Puerto 8080  
c) Puerto 5000  
d) Puerto 31337

**Explicación:** El puerto 8080 es el puerto proxy estándar utilizado en configuraciones de desarrollo y laboratorio para Burp Suite. El servidor Flask escucha en el puerto 5000. El estudiante debe configurar Burp para escuchar en 8080 y reenviar al objetivo en 5000. Elegir el puerto correcto es fundamental para que el flujo de tráfico atraviese el interceptador.

---

## Pregunta 2: Intercepción y Modificación de Parámetros Críticos

**Escenario:** Durante una prueba de penetración simulada, has interceptado una petición HTTP POST con parámetros de producto y precio. El precio original del producto es $999 con rol de usuario estándar. Tu tarea es interceptar esta petición en tránsito y modificar un parámetro crítico para evaluar el impacto en la lógica del negocio.

**Requisitos:**
- Interceptar la petición POST en la pestaña Intercept de Burp Suite
- Modificar el parámetro precio de $999 a $50 (o el rol de 'usuario' a 'admin')
- Reenviar la petición modificada al servidor objetivo
- Validar que el servidor procesa la petición con los valores modificados

**Restricciones:**
- Modificar solo el parámetro especificado (precio OU rol, no ambos)
- No alterar otras partes de la petición (headers, URLs, otros parámetros)
- El modifico debe ser evidente en los logs de Burp (pestaña Logger)

**Criterios de Validación:**
- El archivo $HOME/laboratorio/burp/modificado.txt contiene el valor 1
- Los logs de Burp (pestaña Logger) reflejan la modificación realizada
- La respuesta del servidor incluye el precio modificado ($50) o el rol modificado (admin)
- La modificación es rastreable desde la petición interceptada hasta la respuesta del servidor

**Pregunta multiple choice:** ¿Qué parámetro NO debe modificarse al realizar la intercepción en Reto 2?

a) El parámetro precio (de $999 a $50)  
b) El parámetro rol (de 'usuario' a 'admin')  
c) El método HTTP (GET a POST)  
d) La URL del endpoint (/compra)

**Explicación:** En el Reto 2, el objetivo es modificar específicamente uno de los dos parámetros (precio OU rol), no el método HTTP ni la URL del endpoint. El método y la URL deben permanecer intactos para que el servidor procese correctamente la solicitud. Modificar el método o la URL provocaría que el servidor devolviera un error 405 (Method Not Allowed) o 404 (Not Found), lo que rompería el escenario de evaluación.

---