# Preguntas de Evaluación - Firewalls y Redes

## Pregunta 1: Clasificación de firewalls y filtrado de paquetes

**Escenario**:
El equipo de seguridad de NetCorp necesita seleccionar la tecnología de firewall apropiada para proteger la red interna. Debes evaluar los diferentes tipos de firewalls (filtrado de paquetes, inspección stateful, proxy de aplicación y firewall de próxima generación) y recomendar el más adecuado para un entorno empresarial con servicios web, correo y bases de datos.

**Requisitos**:
- Clasificar los tipos de firewalls disponibles
- Evaluar las ventajas y desventajas de cada tipo
- Recomendar la tecnología más adecuada para el escenario
- Justificar la selección basada en los requisitos de seguridad

**Restricciones**:
- Considerar el presupuesto y recursos disponibles
- Evaluar la escalabilidad de cada solución
- No recomendar soluciones que no cumplan los requisitos mínimos
- Documentar los criterios de selección

**Criterios de Validación**:
- Los tipos de firewall están correctamente clasificados
- La recomendación es coherente con los requisitos del escenario
- Se evaluaron al menos 3 tipos de firewall
- La justificación considera costo, escalabilidad y seguridad

**Pregunta de Selección Múltiple**:

¿Qué tipo de firewall mantiene el estado de las conexiones de red y toma decisiones basadas en el contexto completo de la conexión?

A) Firewall de filtrado de paquetes
B) Firewall de inspección stateful
C) Proxy de aplicación
D) Firewall de próxima generación (NGFW)

**Explicación**:
- Respuesta correcta: B) Firewall de inspección stateful — Mantiene una tabla de estado que rastrea las conexiones activas. Puede tomar decisiones basadas en si un paquete pertenece a una conexión existente establecida, lo que proporciona mejor seguridad que el filtrado simple de paquetes.
- Distractor A: El filtrado de paquetes solo examina encabezados individuales sin contexto de conexión.
- Distractor C: Los proxies de aplicación operan a nivel de aplicación pero no necesariamente rastrean estado de conexión de red.
- Distractor D: Los NGFW incluyen inspección stateful pero son una categoría más amplia que incluye inspección de aplicaciones.

---

## Pregunta 2: Configuración de reglas iptables para servidor web

**Escenario**:
El administrador de seguridad necesita configurar iptables en un servidor web para permitir tráfico HTTP y HTTPS entrante, bloquear todo lo demás excepto SSH para administración, y registrar los intentos de acceso bloqueados. Debes crear las reglas iptables necesarias y verificar que funcionan correctamente.

**Requisitos**:
- Permitir tráfico SSH (puerto 22) solo desde la red de administración (10.0.0.0/24)
- Permitir tráfico HTTP (puerto 80) y HTTPS (puerto 443) desde cualquier origen
- Bloquear y registrar todo el tráfico no especificado
- Establecer política por defecto DROP para cadenas INPUT

**Restricciones**:
- No bloquear la conexión SSH actual
- Las reglas deben persistir después del reinicio
- Los logs no deben saturar el disco (rate limiting)
- No modificar reglas de cadenas OUTPUT o FORWARD

**Criterios de Validación**:
- Las reglas SSH, HTTP y HTTPS están en la cadena INPUT
- La política por defecto de INPUT es DROP
- Los paquetes bloqueados se registran en syslog
- Las reglas persisten con `iptables-save` o servicio equivalente

**Pregunta de Selección Múltiple**:

¿Qué comando iptables establece la política por defecto de la cadena INPUT a bloquear todos los paquetes?

A) `iptables -A INPUT DROP`
B) `iptables -P INPUT DROP`
C) `iptables -F INPUT`
D) `iptables -X INPUT`

**Explicación**:
- Respuesta correcta: B) `iptables -P INPUT DROP` — Establece la política por defecto (Policy) de la cadena INPUT a DROP, lo que bloquea cualquier paquete que no coincida con una regla explícita. Es el primer paso para configurar un servidor seguro.
- Distractor A: `-A` agrega una regla al final de la cadena, no cambia la política por defecto.
- Distractor C: `-F` elimina todas las reglas de la cadena, no establece políticas.
- Distractor D: `-X` elimina una cadena personalizada, no modifica políticas de cadenas built-in.
