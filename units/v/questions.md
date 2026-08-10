# Preguntas de Evaluación - Unidad V: Procesos y Servicios

## Pregunta 1: Identificación del PID de un proceso en background

**Escenario**:
Un servicio de monitoreo automatizado dejó de funcionar y el equipo de soporte necesita identificar rápidamente el PID del proceso `sleep` que se ejecuta en background para verificar su estado y consumo de recursos. Debes iniciar un proceso `sleep 300` en background, capturar su PID, y verificar que el proceso existe en `/proc`. Para el ticket de incidencia, debes reportar el PID numérico exacto.

**Requisitos**:
- Iniciar un proceso `sleep 300` en background
- Capturar el PID del proceso con `$!`
- Verificar que el proceso existe en `/proc/<PID>`
- Reportar el PID numérico exacto

**Restricciones**:
- No usar `ps aux` para buscar el PID (debe usarse `$!`)
- No matar el proceso después de crearlo (debe seguir ejecutando)
- No crear más de un proceso `sleep`
- El proceso debe ejecutarse por al menos 300 segundos

**Criterios de Validación**:
- El comando `sleep 300 &` inicia un proceso en background
- La variable `$!` captura un PID numérico mayor a 0
- El directorio `/proc/<PID>` existe y es legible
- El proceso `sleep` aparece en la salida de `ps aux | grep sleep`

**Pregunta de Selección Múltiple**:

Después de ejecutar `sleep 300 &` y capturar `PID=$!`, ¿cuál es el valor exacto de `$!`?

A) `1`
B) `0`
C) `<PID numérico específico del proceso>`
D) `sleep`

**Explicación**:
- Respuesta correcta: C) `<PID numérico específico del proceso>` - La variable especial de bash `$!` expande al PID del último proceso ejecutado en background. Este valor es único por cada ejecución y solo puede obtenerse ejecutando el comando en el entorno del laboratorio. El estudiante debe capturarlo con `PID=$!` y reportarlo.
- Distractor A: `1` - Es el PID del proceso `init` (systemd) en algunos sistemas, pero no es el valor de `$!` para un nuevo proceso background.
- Distractor B: `0` - En bash, `$!` nunca devuelve 0 para un proceso en background exitoso. El PID 0 está reservado para el scheduler del kernel.
- Distractor D: `sleep` - Es el nombre del comando, no un PID. Un PID siempre es un número entero positivo asignado por el kernel.

---

## Pregunta 2: Verificación de estado de un servicio systemd

**Escenario**:
El servidor de base de datos dejó de aceptar conexiones. El equipo de operaciones necesita verificar el estado del servicio `ssh` para determinar si el servicio está activo y corriendo antes de proceder con el diagnóstico de red. Debes ejecutar el comando de verificación de systemd y capturar la línea exacta que indica el estado activo del servicio para el reporte de incidencia.

**Requisitos**:
- Verificar el estado del servicio `ssh` con `systemctl`
- Capturar la línea que indica si el servicio está `active (running)`
- Determinar si el servicio está operativo
- Reportar el estado exacto encontrado

**Restricciones**:
- No usar `service ssh status` (solo `systemctl status ssh`)
- No iniciar ni detener el servicio (solo verificar)
- No modificar la configuración del servicio
- No filtrar la salida con `grep` para eliminar información

**Criterios de Validación**:
- El comando `systemctl status ssh` devuelve información del servicio
- La salida contiene la palabra `Active:` seguida del estado
- Si el servicio está activo, la línea contiene `active (running)`
- El servicio `ssh` existe en el sistema

**Pregunta de Selección Múltiple**:

¿Cuál es la salida exacta de `systemctl status ssh` cuando el servicio está operativo?

A) `Active: inactive (dead)`
B) `Active: active (running)`
C) `Active: failed`
D) `Unit ssh.service could not be found`

**Explicación**:
- Respuesta correcta: B) `Active: active (running)` - Cuando el servicio SSH está operativo, `systemctl status ssh` muestra exactamente esta línea en la sección de estado. Indica que el servicio está activo y ejecutándose correctamente. Se obtiene ejecutando: `systemctl status ssh | grep 'Active:'`
- Distractor A: `Active: inactive (dead)` - Indica que el servicio está detenido. Ocurre si el servicio no se inició o se detuvo manualmente.
- Distractor C: `Active: failed` - Indica que el servicio intentó iniciar pero falló. Ocurre si hay errores de configuración o dependencias incumplidas.
- Distractor D: `Unit ssh.service could not be found` - Indica que el servicio no existe en el sistema. En Ubuntu, el servicio suele llamarse `ssh` o `sshd`, pero si no está instalado, aparece este mensaje.
