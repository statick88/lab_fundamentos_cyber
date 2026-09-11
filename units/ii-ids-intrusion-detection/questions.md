# Preguntas de Evaluación - IDS y Detección de Intrusos

## Pregunta 1: Configuración de Suricata para detección de intrusiones

**Escenario**:
El equipo de seguridad de SecureNet necesita implementar un sistema de detección de intrusiones (IDS) usando Suricata para monitorear la red interna. Debes configurar Suricata para detectar intentos de escaneo de puertos, tráfico C2 conocido y movimiento lateral usando las reglas ET Open. El IDS debe generar alertas en formato EVE JSON para integración con el SIEM.

**Requisitos**:
- Configurar Suricata para monitorear la interfaz de red principal
- Habilitar las reglas ET Open para detección de amenazas
- Configurar la salida EVE JSON con campos relevantes
- Verificar que las alertas se generan correctamente

**Restricciones**:
- No instalar reglas personalizadas sin validación
- El IDS no debe interferir con el tráfico legítimo
- Los logs no deben exceder 1GB por día
- Suricata debe ejecutarse como servicio

**Criterios de Validación**:
- Suricata está ejecutándose y monitoreando la interfaz
- Las reglas ET Open están cargadas
- El archivo eve.json se genera con alertas
- Las alertas contienen campos: timestamp, src_ip, dst_ip, signature

**Pregunta de Selección Múltiple**:

¿Cuál es la diferencia principal entre un IDS (Intrusion Detection System) y un IPS (Intrusion Prevention System)?

A) El IDS bloquea ataques mientras que el IPS solo detecta
B) El IDS detecta y genera alertas, el IPS detecta y bloquea activamente
C) El IDS monitorea tráfico entrante, el IPS monitorea solo saliente
D) No hay diferencia; son sinónimos

**Explicación**:
- Respuesta correcta: B) El IDS detecta y genera alertas, el IPS detecta y bloquea activamente — Un IDS opera en modo passive (promiscuo) y genera alertas cuando detecta actividad sospechosa. Un IPS opera en modo inline y puede bloquear o modificar tráfico malicioso en tiempo real antes de que alcance el destino.
- Distractor A: Está invertido; el IDS no bloquea, el IPS sí.
- Distractor C: Ambos pueden monitorear tráfico entrante y saliente; la diferencia es la capacidad de bloqueo.
- Distractor D: Son tecnologías distintas con funciones diferentes.

---

## Pregunta 2: Análisis de alertas Suricata

**Escenario**:
El SOC detectó múltiples alertas en Suricata que indican posible actividad de escaneo de puertos proveniente de una IP interna. Debes analizar el archivo `fast.log` y `eve.json` para determinar: cuántas alertas se generaron, qué firmas se activaron, y si es un escaneo legítimo o malicioso. Proporciona un reporte con los hallazgos.

**Requisitos**:
- Contar el número total de alertas en el período analizado
- Identificar las firmas más frecuentes activadas
- Determinar la IP origen de las alertas
- Clasificar la actividad como legítima o maliciosa

**Restricciones**:
- No modificar los archivos de log originales
- Usar herramientas estándar de análisis (grep, awk, sort)
- No saltar a conclusiones sin evidencia
- Documentar el proceso de análisis

**Criterios de Validación**:
- El conteo de alertas es correcto y verificable
- Las firmas identificadas son consistentes con escaneo de puertos
- La IP origen está correctamente extraída
- La clasificación está justificada con evidencia

**Pregunta de Selección Múltiple**:

¿Qué archivo genera Suricata con alertas en formato JSON estructurado para integración con SIEM?

A) `alert.log`
B) `eve.json`
C) `fast.log`
D) `suricata.log`

**Explicación**:
- Respuesta correcta: B) `eve.json` — Es el log de eventos extensible de Suricata que genera alertas, flujos, HTTP, DNS y otros eventos en formato JSON estructurado. Es el estándar para integración con sistemas SIEM porque contiene campos normalizados y buscan.
- Distractor A: `alert.log` no es un archivo estándar de Suricata.
- Distractor C: `fast.log` contiene alertas en formato de texto plano, no JSON estructurado.
- Distractor D: `suricata.log` es el log de estado del daemon, no de alertas de seguridad.
