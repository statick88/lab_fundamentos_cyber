# Preguntas de Evaluación - Unidad IV: Gestión de Usuarios

## Pregunta 1: Creación de usuario y verificación del UID asignado

**Escenario**:
El departamento de RR.HH. contrató a un nuevo administrador de sistemas llamado `opsadmin` que necesitará acceso al servidor Linux para tareas de mantenimiento. Debes crear la cuenta de usuario con directorio home y shell `/bin/bash`, luego verificar el UID asignado automáticamente por el sistema para incluirlo en el ticket de alta de personal. El UID debe ser el primer valor disponible mayor a 1000 (usuarios normales en Ubuntu).

**Requisitos**:
- Crear el usuario `opsadmin` con directorio home (`-m`)
- Asignar shell `/bin/bash` al usuario
- Verificar que el directorio home fue creado
- Obtener el UID numérico del usuario con `id -u`

**Restricciones**:
- No crear el usuario con un UID fijo (dejar que el sistema asigne el próximo disponible)
- No modificar el usuario después de crearlo
- No establecer contraseña (no es necesario para este ticket)
- No agregar el usuario a grupos adicionales

**Criterios de Validación**:
- El usuario `opsadmin` existe: `id opsadmin` devuelve información
- El directorio `/home/opsadmin` existe
- El shell de `opsadmin` es `/bin/bash` (verificar en `/etc/passwd`)
- El UID de `opsadmin` es un número mayor o igual a 1000

**Pregunta de Selección Múltiple**:

¿Cuál es el UID exacto del usuario `opsadmin` después de ser creado en un sistema Ubuntu 24.04 limpio?

A) `0`
B) `1000`
C) `1001`
D) `65534`

**Explicación**:
- Respuesta correcta: C) `1001` - En un sistema Ubuntu 24.04 limpio dentro del contenedor Docker, el usuario `estudiante` ya ocupa el UID 1000. Por lo tanto, el próximo UID disponible para `opsadmin` es 1001. Se obtiene ejecutando: `id -u opsadmin`
- Distractor A: `0` - Es el UID reservado exclusivamente para el superusuario `root`. No se asigna a usuarios normales.
- Distractor B: `1000` - Es el UID del primer usuario normal creado en el sistema (`estudiante` en este laboratorio). Ya está ocupado, por lo que `opsadmin` recibe el siguiente disponible.
- Distractor D: `65534` - Es el UID del usuario `nobody`, reservado para procesos sin privilegios. No se asigna a usuarios normales creados con `useradd`.

---

## Pregunta 2: Creación de grupo y verificación de membresía

**Escenario**:
El equipo de proyectos necesita crear un grupo llamado `devops` para compartir acceso a directorios de despliegue en `/opt/deploy/`. Debes crear el grupo, agregar el usuario existente `estudiante` a él, y verificar que la membresía se aplicó correctamente. Para el ticket de auditoría, debes reportar la lista exacta de miembros del grupo después de la modificación.

**Requisitos**:
- Crear el grupo `devops` con `groupadd`
- Agregar el usuario `estudiante` al grupo `devops`
- Verificar que el usuario `estudiante` pertenece al grupo
- Capturar la salida de `groups estudiante` o `id -Gn estudiante`

**Restricciones**:
- No crear usuarios adicionales
- No modificar otros grupos del sistema
- No usar `gpasswd` (solo `usermod -aG`)
- No eliminar el grupo después de crearlo

**Criterios de Validación**:
- El grupo `devops` existe: `getent group devops` devuelve información
- El usuario `estudiante` pertenece al grupo `devops`
- El comando `groups estudiante` incluye `devops` en su salida
- El archivo `/etc/group` contiene una línea que empieza con `devops:`

**Pregunta de Selección Múltiple**:

¿Cuál es la salida exacta de `groups estudiante` después de agregarlo al grupo `devops`?

A) `estudiante : estudiante`
B) `estudiante : estudiante devops`
C) `estudiante : devops`
D) `devops : estudiante`

**Explicación**:
- Respuesta correcta: B) `estudiante : estudiante devops` - El comando `groups` muestra todos los grupos a los que pertenece un usuario. Como `estudiante` ya pertenece a su grupo principal `estudiante` y se le agregó `devops` como grupo secundario, la salida incluye ambos grupos separados por espacio. Se obtiene ejecutando: `groups estudiante`
- Distractor A: `estudiante : estudiante` - Sería la salida si solo perteneciera a su grupo principal, sin el grupo `devops`. Ocurre si no se ejecutó `usermod -aG devops estudiante`.
- Distractor C: `estudiante : devops` - Sería la salida si `devops` fuera el grupo principal y no existiera el grupo `estudiante`. No es posible porque el grupo principal se asigna en `/etc/passwd` y el usuario ya tiene `estudiante` como grupo principal.
- Distractor D: `devops : estudiante` - Es el formato de `getent group devops`, que muestra los miembros del grupo, pero no es la salida del comando `groups estudiante`.
