# Preguntas de Evaluación - Unidad I: Fundamentos de Linux y WSL2

## Pregunta 1: Identificación del directorio FHS para archivo de configuración

**Escenario**:
El equipo de infraestructura está desplegando una aplicación empresarial que necesita guardar su archivo de configuración principal en la ubicación correcta según el Filesystem Hierarchy Standard (FHS). El archivo se llama `app.conf` y contiene parámetros de conexión a base de datos, puertos y rutas de logs. Debes identificar el directorio correcto según FHS para archivos de configuración del sistema y crear el archivo en esa ruta, luego reportar la ruta absoluta exacta donde se guardó el archivo.

**Requisitos**:
- Identificar el directorio FHS destinado a archivos de configuración del sistema
- Crear el archivo `app.conf` en ese directorio con contenido de prueba
- Verificar que el archivo existe en la ruta correcta
- Reportar la ruta absoluta del archivo creado

**Restricciones**:
- No crear el archivo en `/tmp`, `/home`, `/var` u otros directorios
- El archivo debe llamarse exactamente `app.conf`
- No modificar archivos de configuración existentes del sistema
- Usar solo comandos estándar de Linux (touch, echo, ls)

**Criterios de Validación**:
- El archivo `/etc/app.conf` existe y es legible
- El comando `ls -la /etc/app.conf` muestra el archivo con permisos
- El contenido del archivo incluye la línea `DB_HOST=localhost`
- El directorio `/etc` es el directorio de configuración según FHS

**Pregunta de Selección Múltiple**:

Según el Filesystem Hierarchy Standard (FHS), ¿en qué directorio se guardó el archivo `app.conf`?

A) `/tmp`
B) `/home`
C) `/etc`
D) `/var`

**Explicación**:
- Respuesta correcta: C) `/etc` - Según el estándar FHS, el directorio `/etc` está designado para almacenar archivos de configuración estática del sistema. El archivo `app.conf` debe crearse en `/etc/app.conf`. Se verifica ejecutando: `ls -la /etc/app.conf`
- Distractor A: `/tmp` - Es el directorio para archivos temporales que se limpian al reinicio. No es apropiado para configuraciones persistentes.
- Distractor B: `/home` - Es el directorio de los usuarios locales. No es el lugar designado para configuraciones del sistema.
- Distractor D: `/var` - Es para datos variables que persisten entre reinicios (logs, spool, cache). No es el directorio principal de configuración estática.

---

## Pregunta 2: Establecimiento de permisos 755 y verificación con stat

**Escenario**:
Un desarrollador reportó que un script de despliegue en `/opt/deploy/` no tiene permisos de ejecución para el grupo de operaciones. El equipo de DevOps emitió un ticket para establecer los permisos correctos (rwxr-xr-x) en el directorio de despliegue y verificar que se aplicaron correctamente. Debes configurar los permisos 755 en el directorio `/opt/deploy` y capturar el valor octal exacto que reporta el comando `stat` para el reporte de auditoría.

**Requisitos**:
- Crear el directorio `/opt/deploy` si no existe
- Establecer permisos 755 (rwxr-xr-x) en el directorio
- Verificar los permisos con el comando `stat`
- Capturar el valor octal exacto de los permisos

**Restricciones**:
- No modificar otros directorios en `/opt`
- No usar `chmod` con valores relativos, solo con el octal exacto 755
- No eliminar el directorio después de configurarlo
- El valor debe ser obtenido con `stat -c "%a"` o `stat -f "%A"`

**Criterios de Validación**:
- El directorio `/opt/deploy` existe
- El comando `stat -c "%a" /opt/deploy` devuelve exactamente: `755`
- El comando `ls -ld /opt/deploy` muestra permisos `drwxr-xr-x`
- El propietario del directorio es `root:root`

**Pregunta de Selección Múltiple**:

¿Cuál es el valor octal exacto de los permisos del directorio `/opt/deploy` después de aplicar `chmod 755`?

A) `644`
B) `755`
C) `777`
D) `700`

**Explicación**:
- Respuesta correcta: B) `755` - El comando `chmod 755 /opt/deploy` establece permisos de lectura, escritura y ejecución para el propietario (7 = 4+2+1), y lectura y ejecución para grupo y otros (5 = 4+0+1). El valor octal se obtiene ejecutando: `stat -c "%a" /opt/deploy`
- Distractor A: `644` - Representa permisos de lectura y escritura para el propietario, y solo lectura para grupo y otros. No incluye el bit de ejecución necesario para directorios.
- Distractor C: `777` - Representa permisos completos para todos (lectura, escritura, ejecución). Es inseguro y no corresponde a la configuración solicitada.
- Distractor D: `700` - Representa permisos completos solo para el propietario, sin acceso para grupo y otros. No coincide con el requisito 755.
