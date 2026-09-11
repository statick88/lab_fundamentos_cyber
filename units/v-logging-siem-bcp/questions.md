# V — Logging, SIEM y BCP

---

## Pregunta 1: Análisis de Logs con grep y awk

**Escenario:**

Tu equipo SOC ha recibido una alerta de un posible intento de fuerza bruta contra el servidor SSH de la empresa. Tienes acceso a los archivos `apache_access.log` y `auth_sys.log` generados por el sistema. Debes analizar ambos logs para identificar actividad sospechosa y extraer evidencia para el reporte de incidente.

**Requisitos:**

1. Del `apache_access.log`, extraer todas las peticiones que retornaron código HTTP 4xx o 5xx, mostrando la IP, el método HTTP y la ruta solicitada.
2. Del `auth_sys.log`, extraer los intentos de autenticación fallidos con el timestamp y la IP de origen.
3. Correlacionar ambas fuentes para determinar si las IPs de los intentos fallidos de SSH también realizaron peticiones HTTP sospechosas.
4. Documentar los hallazgos en formato de tabla para el reporte de incidente.

**Restricciones:**

- El análisis debe hacerse exclusivamente con herramientas CLI: `grep`, `awk`, `cut`, `sort`, `uniq`.
- NO utilizar herramientas gráficas ni SIEM externo para este análisis.
- Los resultados deben ser reproducibles con los mismos comandos en cualquier sistema Linux.

**Criterios de Validación:**

1. Se filtran correctamente las líneas con códigos HTTP 4xx/5xx del `apache_access.log` usando patrones regex.
2. Se extraen los intentos fallidos de `auth_sys.log` con formato legible (timestamp, usuario, IP).
3. Se correlacionan las IPs entre ambos logs identificando coincidencias.
4. Los resultados se presentan en tabla con columnas claramente definidas.

**Pregunta de Opción Múltiple:**

¿Cuál es la diferencia principal entre `grep` y `awk` para el análisis de logs?

a) `grep` extrae campos específicos de una línea, mientras que `awk` filtra líneas completas por patrón
b) `grep` filtra líneas completas que coinciden con un patrón, mientras que `awk` permite procesar campos estructurados y realizar operaciones sobre ellos
c) `grep` es más rápido que `awk` para cualquier tipo de análisis de logs
d) `awk` solo funciona con archivos de log de Apache, mientras que `grep` es universal

**Explicación:**

La respuesta correcta es **b) `grep` filtra líneas completas que coinciden con un patrón, mientras que `awk` permite procesar campos estructurados y realizar operaciones sobre ellos**.

- `grep` se especializa en buscar y filtrar líneas que contienen un patrón específico (regex), devolviendo las líneas completas que coinciden.
- `awk` es un lenguaje de procesamiento de texto que divide cada línea en campos (por defecto por espacios) y permite realizar operaciones como extracción de columnas, cálculos, formateo y agregación.
- Ambos son rápidos pero para diferentes tareas: `grep` para filtrado rápido, `awk` para procesamiento estructurado.
- `awk` funciona con cualquier tipo de archivo de texto, no solo con logs de Apache.

---

## Pregunta 2: BCP, Cálculo de RTO/RPO y Fases de IR

**Escenario:**

La dirección de tu empresa ha solicitado un plan de continuidad de negocio para el departamento de TI. El sistema de procesamiento de transacciones opera de lunes a viernes de 8:00 a 18:00. Se realizan backups completos cada domingo a las 02:00 y backups incrementales de lunes a viernes a las 18:30. En caso de desastre, el sistema debe restaurarse usando la infraestructura de respaldo en el数据中心 alternativo.

**Requisitos:**

1. Calcular el RTO (Recovery Time Objective) si el sistema debe restaurarse antes del inicio del día hábil siguiente al desastre.
2. Calcular el RPO (Recovery Point Objective) considerando la frecuencia de backups incrementales.
3. Definir las 6 fases del proceso de respuesta a incidentes (IR) según NIST SP 800-61.
4. Explicar cómo el BCP se relaciona con el plan de respuesta a incidentes.

**Restricciones:**

- El RTO y RPO deben expresarse en horas y justificarse con los datos del escenario.
- Las fases IR deben seguir el marco NIST SP 800-61r3.
- La relación BCP-IR debe explicarse en términos de continuidad operativa, no solo teoría.

**Criterios de Validación:**

1. RTO calculado correctamente: máximo ~14 horas (desde las 18:00 del viernes hasta las 8:00 del lunes siguiente).
2. RPO calculado correctamente: máximo ~12 horas (último backup incremental a las 18:30 del día anterior al desastre).
3. Las 6 fases IR documentadas: Preparación, Detección y Análisis, Contención, Erradicación, Recuperación, Lecciones Aprendidas.
4. Se explica que el BCP define CÓMO mantener las operaciones, mientras que el IR define CÓMO responder cuando un incidente interrumpe esas operaciones.

**Pregunta de Opción Múltiple:**

Si un ransomware cifra los datos del sistema a las 14:00 del martes y el último backup incremental fue el lunes a las 18:30, ¿cuántos horas de datos se perderían al restaurar desde el backup?

a) 12.5 horas (desde las 18:30 del lunes hasta las 14:00 del martes)
b) 24 horas (un día completo de datos)
c) 43.5 horas (desde el backup completo del domingo)
d) 19.5 horas (desde las 18:30 del lunes hasta las 14:00 del martes)

**Explicación:**

La respuesta correcta es **a) 12.5 horas (desde las 18:30 del lunes hasta las 14:00 del martes)**.

- El RPO define la máxima cantidad de datos que se pueden perder. Con backups incrementales a las 18:30 de cada día, el último punto de restauración conocido es las 18:30 del lunes.
- Si el incidente ocurre a las 14:00 del martes, los datos generados entre las 18:30 del lunes y las 14:00 del martes (12.5 horas) se perderían al restaurar desde el último backup incremental.
- El backup completo del domingo no es relevante para este cálculo porque existe un backup incremental más reciente (el del lunes).
- El RPO efectivo en este escenario es de 12.5 horas, lo que significa que la empresa acepta perder como máximo ese volumen de datos en caso de incidente.
