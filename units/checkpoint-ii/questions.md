# Preguntas de Evaluación - Checkpoint II: Redes y Firewalls

## Pregunta 1: Análisis de tráfico de red con filtros de paquetes

**Escenario**:
El equipo de seguridad de RedCorp detectó tráfico sospechoso en la interfaz `eth0`. Se capturaron paquetes con `tcpdump` durante 30 segundos y se guardaron en un archivo PCAP. Debes analizar el archivo para identificar qué protocolo generó más tráfico y qué puerto de destino fue más utilizado, luego reportar los hallazgos al equipo de respuesta a incidentes.

**Requisitos**:
- Leer el archivo PCAP generado por `tcpdump`
- Identificar el protocolo con mayor volumen de paquetes
- Identificar el puerto de destino más frecuente
- Reportar ambos hallazgos en el formato esperado por `eval_log_analysis`

**Restricciones**:
- No modificar el archivo PCAP original
- Usar solo herramientas estándar de análisis de red (`tcpdump`, `tshark`, o `grep` sobre salida legible)
- No instalar paquetes adicionales sin autorización
- Los resultados deben ser reproducibles con los mismos datos de entrada

**Criterios de Validación**:
- El archivo PCAP existe y es legible
- Se identificó correctamente el protocolo dominante
- Se identificó correctamente el puerto de destino más frecuente
- La salida coincide con los datos del archivo de captura

**Pregunta de Selección Múltiple**:

¿Qué herramienta se utiliza para capturar y filtrar paquetes de red en tiempo real en Linux?

A) `netstat`
B) `tcpdump`
C) `ss`
D) `ifconfig`

**Explicación**:
- Respuesta correcta: B) `tcpdump` — Es la herramienta estándar en Linux para capturar y filtrar tráfico de red en tiempo real. Permite aplicar filtros BPF (Berkeley Packet Filter) para seleccionar paquetes específicos por protocolo, puerto, dirección IP, etc.
- Distractor A: `netstat` — Muestra conexiones de red activas y estadísticas, pero no captura paquetes individuales.
- Distractor C: `ss` — Herramienta moderna para inspeccionar sockets, pero no realiza captura de paquetes.
- Distractor D: `ifconfig` — Configura y muestra interfaces de red, pero no tiene capacidades de captura.

---

## Pregunta 2: Configuración de reglas de firewall con UFW

**Escenario**:
El administrador de seguridad necesita configurar el firewall del servidor web `web01` para permitir solo tráfico HTTP (puerto 80), HTTPS (puerto 443) y SSH (puerto 22). Todo el demás tráfico debe ser bloqueado por defecto. Debes configurar UFW con las reglas correctas y verificar que el firewall está activo con la política por defecto configurada.

**Requisitos**:
- Establecer la política por defecto a `deny` para entrante y `allow` para saliente
- Permitir tráfico SSH en puerto 22
- Permitir tráfico HTTP en puerto 80
- Permitir tráfico HTTPS en puerto 443
- Activar UFW y verificar su estado

**Restricciones**:
- No bloquear la conexión SSH actual (puerto 22 debe estar abierto)
- No permitir puertos adicionales a los especificados
- UFW debe estar activo al finalizar la configuración
- No instalar firewalls alternativos (iptables directamente)

**Criterios de Validación**:
- El comando `ufw status verbose` muestra `Status: active`
- La política por defecto entrante es `deny (incoming)`
- La política por defecto saliente es `allow (outgoing)`
- Las reglas listan 22/tcp, 80/tcp y 443/tcp como permitidos

**Pregunta de Selección Múltiple**:

¿Cuál es el comando correcto para establecer la política por defecto de UFW a bloquear todo el tráfico entrante?

A) `ufw default allow incoming`
B) `ufw default deny incoming`
C) `ufw default deny outgoing`
D) `ufw deny all`

**Explicación**:
- Respuesta correcta: B) `ufw default deny incoming` — Establece la política por defecto para conexiones entrantes como `deny`, lo que bloquea todo tráfico no explícitamente permitido. Es la primera regla de hardening de firewall.
- Distractor A: `ufw default allow incoming` — Permitiría todo el tráfico entrante por defecto, lo cual es inseguro.
- Distractor C: `ufw default deny outgoing` — Bloquearía todo tráfico saliente, lo que rompería conectividad del servidor.
- Distractor D: `ufw deny all` — No es un comando válido; `ufw deny` bloquea un servicio específico, no establece políticas por defecto.
