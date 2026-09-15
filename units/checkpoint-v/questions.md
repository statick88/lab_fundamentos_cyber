# Preguntas de Evaluación - Checkpoint V: Logging y BCP

## Pregunta 1: Análisis de logs con herramientas de texto

**Escenario**:
El equipo de SOC de DataCorp necesita analizar los logs del sistema para identificar intentos de acceso fallidos durante las últimas 24 horas. El archivo `/var/log/auth.log` contiene registros de autenticación. Debes usar herramientas de línea de comandos para filtrar, contar y extraer información relevante sobre los intentos fallidos, incluyendo las IPs más frecuentes.

**Requisitos**:
- Filtrar las líneas que contengan "Failed password" del archivo de logs
- Contar el número total de intentos fallidos
- Extraer las 5 direcciones IP más frecuentes que aparecen en los fallos
- Presentar los resultados en un formato legible

**Restricciones**:
- No modificar el archivo de logs original
- Usar solo herramientas estándar de Linux (`grep`, `awk`, `sort`, `cut`)
- No instalar paquetes adicionales
- Los resultados deben ser reproducibles

**Criterios de Validación**:
- Se contaron correctamente los intentos fallidos de autenticación
- Se identificaron las IPs más frecuentes con su conteo
- El comando utilizado es eficiente y correcto
- La salida es clara y estandarizada

**Pregunta de Selección Múltiple**:

¿Qué combinación de comandos permite contar las direcciones IP más frecuentes en un archivo de logs?

A) `grep "pattern" log | sort | uniq`
B) `grep "pattern" log | awk '{print $1}' | sort | uniq -c | sort -rn`
C) `cat log | find "pattern" | count`
D) `tail -f log | grep "pattern"`

**Explicación**:
- Respuesta correcta: B) `grep "pattern" log | awk '{print $1}' | sort | uniq -c | sort -rn` — Extrae el campo IP con `awk`, ordena con `sort`, cuenta con `uniq -c`, y reordena por frecuencia con `sort -rn`. Es la pipeline estándar para análisis de frecuencia.
- Distractor A: `sort | uniq` solo elimina duplicados consecutivos sin contar frecuencias.
- Distractor C: `find` no es herramienta de análisis de texto; no existe el comando `count`.
- Distractor D: `tail -f` sigue el archivo en tiempo real, no analiza contenido existente.

---

## Pregunta 2: Configuración de rotación de logs con logrotate

**Escenario**:
El servidor de bases de datos genera archivos de log muy grandes que consumen disco rápidamente. Debes configurar `logrotate` para rotar el archivo `/var/log/database/custom.log` diariamente, manteniendo solo los últimos 7 archivos rotados, y comprimiendo los archivos antiguos. La configuración debe ser validada ejecutando logrotate en modo debug.

**Requisitos**:
- Crear un archivo de configuración en `/etc/logrotate.d/`
- Configurar rotación diaria del log especificado
- Mantener un máximo de 7 archivos rotados
- Habilitar compresión de logs antiguos
- Validar la configuración con `logrotate -d`

**Restricciones**:
- No modificar configuraciones existentes de logrotate
- El archivo de configuración debe seguir el formato estándar de logrotate
- No usar opciones experimentales o no documentadas
- La validación debe pasar sin errores

**Criterios de Validación**:
- El archivo de configuración existe en `/etc/logrotate.d/`
- `logrotate -d` muestra la configuración sin errores
- Se especifica rotación diaria (`daily`)
- Se configura `rotate 7` y `compress`
- El path del log coincide con el solicitado

**Pregunta de Selección Múltiple**:

¿Qué directiva en logrotate configura la retención de solo los 7 archivos rotados más recientes?

A) `maxage 7`
B) `rotate 7`
C) `keep 7`
D) `retain 7`

**Explicación**:
- Respuesta correcta: B) `rotate 7` — Indica a logrotate que mantenga un máximo de 7 archivos de log rotados. Cuando se supera el límite, el más antiguo se elimina automáticamente.
- Distractor A: `maxage` especifica cuántos días conservar los archivos, no la cantidad máxima.
- Distractor C: `keep` no es una directiva válida en logrotate.
- Distractor D: `retain` no es una directiva válida en logrotate.
