# Preguntas de Evaluación - Arquitectura Perimetral

## Pregunta 1: Diseño de zonas de red según modelo de defensa en profundidad

**Escenario**:
La empresa RedShield necesita rediseñar su arquitectura de red implementando el modelo de defensa en profundidad. Debes definir las zonas de red necesarias: WAN (zona no confiable), DMZ (zona intermedia para servicios públicos), LAN (zona interna confiable) y Management (zona de administración). Cada zona debe tener reglas de tráfico específicas que permitan solo el flujo necesario.

**Requisitos**:
- Definir las 4 zonas de red: WAN, DMZ, LAN, Management
- Establecer las reglas de tráfico permitido entre cada zona
- Implementar política de default-deny para todo el tráfico no especificado
- Documentar el diagrama de flujo de tráfico entre zonas

**Restricciones**:
- No permitir tráfico directo entre WAN y LAN (debe pasar por DMZ)
- La zona de Management solo debe ser accesible desde LAN
- El tráfico entre DMZ y LAN debe ser mínimo y controlado
- Todas las zonas deben tener política por defecto deny

**Criterios de Validación**:
- Las 4 zonas están correctamente definidas
- Las reglas de tráfico son coherentes y no contradictorias
- La política default-deny está implementada en cada zona
- El tráfico WAN→LAN está prohibido directamente

**Pregunta de Selección Múltiple**:

¿Cuál es el principio fundamental de la arquitectura de defensa en profundidad para zonas de red?

A) Permitir todo el tráfico interno para facilitar la productividad
B) Aplicar múltiples capas de control con política default-deny
C) Confiar en todas las zonas internas por igual
D) Usar un solo firewall para todas las zonas

**Explicación**:
- Respuesta correcta: B) Aplicar múltiples capas de control con política default-deny — La defensa en profundidad establece que cada zona debe tener sus propios controles de seguridad, y todo el tráfico no explícitamente permitido debe ser bloqueado. Esto limita el movimiento lateral si un atacante compromete una zona.
- Distractor A: Permitir todo el tráfico viola el principio de mínimo privilegio y la defensa en profundidad.
- Distractor C: Confiar en todas las zonas elimina la segmentación y el control de acceso.
- Distractor D: Un solo firewall no proporciona segmentación adecuada entre múltiples zonas.

---

## Pregunta 2: Configuración de DMZ con servicios públicos

**Escenario**:
El equipo de infraestructura necesita configurar una DMZ para alojar los servicios públicos de la empresa: servidor web (HTTP/HTTPS), servidor DNS (DNS) y servidor de correo (SMTP). Debes definir las reglas de firewall que permitan el acceso público a estos servicios mientras se protege la red interna.

**Requisitos**:
- Permitir tráfico HTTP (puerto 80) y HTTPS (puerto 443) hacia el servidor web
- Permitir tráfico DNS (puerto 53 UDP/TCP) hacia el servidor DNS
- Permitir tráfico SMTP (puerto 25) hacia el servidor de correo
- Bloquear todo el tráfico no especificado

**Restricciones**:
- No permitir acceso directo desde Internet a la red interna
- Los servidores de DMZ no deben iniciar conexiones a la red interna
- Solo los puertos especificados deben estar abiertos
- El tráfico de retorno debe ser específico y limitado

**Criterios de Validación**:
- Los puertos 80, 443, 53 y 25 están abiertos en la DMZ
- No hay reglas que permitan acceso directo DMZ→LAN
- La política default-deny está configurada
- El tráfico de retorno está limitado a conexiones establecidas

**Pregunta de Selección Múltiple**:

¿Qué tipo de tráfico debe ser permitido desde Internet hacia la DMZ para un servidor web?

A) Solo HTTPS (puerto 443)
B) HTTP (puerto 80) y HTTPS (puerto 443)
C) Todos los puertos TCP
D) SSH (puerto 22) y HTTP (puerto 80)

**Explicación**:
- Respuesta correcta: B) HTTP (puerto 80) y HTTPS (puerto 443) — Un servidor web público necesita ambos puertos para servir contenido web. HTTP redirige a HTTPS en configuraciones modernas, y HTTPS es el estándar de cifrado para tráfico web.
- Distractor A: Solo HTTPS excluye usuarios que acceden por HTTP antes de la redirección.
- Distractor C: Abrir todos los puertos TCP expone servicios innecesarios y aumenta la superficie de ataque.
- Distractor D: SSH no es un servicio web; exponer SSH en un servidor público aumenta el riesgo de compromiso.
