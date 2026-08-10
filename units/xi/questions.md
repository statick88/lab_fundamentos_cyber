# Preguntas de Evaluación - Unidad XI: Backup y Recuperación

## Pregunta 1: Respaldo y verificación de base de datos de usuarios antes de migración

**Escenario**:
El equipo de operaciones debe realizar una migración de servidor esta noche. El archivo de base de datos de usuarios ubicado en `~/laboratorio/backup/datos/usuarios/usuarios.txt` debe respaldarse, verificarse su integridad y restaurarse en un directorio de verificación para confirmar que el respaldo es válido antes de proceder con la migración.

**Requisitos**:
- Crear un respaldo comprimido con tar del directorio `~/laboratorio/backup/datos/`
- Listar el contenido del respaldo para confirmar que incluye `datos/usuarios/usuarios.txt`
- Extraer el respaldo a `~/laboratorio/backup/verificar/`
- Mostrar el contenido exacto del archivo `~/laboratorio/backup/verificar/datos/usuarios/usuarios.txt`

**Restricciones**:
- Usar `tar` con compresión gzip (`-czf`)
- No modificar ningún archivo en `datos/` antes de crear el respaldo
- El directorio de extracción debe ser exactamente `~/laboratorio/backup/verificar/`
- No usar `sudo` para esta operación

**Criterios de Validación**:
- Existe un archivo `.tar.gz` en `~/laboratorio/backup/` con tamaño mayor a 0 bytes
- El comando `tar -tzf <backup_file> | grep usuarios.txt` muestra la ruta del archivo
- El directorio `~/laboratorio/backup/verificar/datos/usuarios/` existe después de la extracción
- El archivo `~/laboratorio/backup/verificar/datos/usuarios/usuarios.txt` existe y su contenido es exactamente `usuario1:password123`

**Pregunta de Selección Múltiple**:

¿Cuál es el contenido exacto del archivo `usuarios.txt` extraído del respaldo?

A) `admin:admin123`
B) `usuario1:password123`
C) `root:root456`
D) `usuario1:password`

**Explicación**:
- Respuesta correcta: B) `usuario1:password123` - Este es el contenido exacto del archivo `datos/usuarios/usuarios.txt` creado por el laboratorio. Se obtiene ejecutando: `tar -xzf backup.tar.gz -C ~/laboratorio/backup/verificar/ && cat ~/laboratorio/backup/verificar/datos/usuarios/usuarios.txt`
- Distractor A: `admin:admin123` - Es un valor genérico común en pruebas, pero no corresponde al contenido real del archivo de usuarios del laboratorio.
- Distractor C: `root:root456` - Representa una cuenta de administrador que no existe en el archivo de usuarios del laboratorio.
- Distractor D: `usuario1:password` - Es similar al valor real pero falta el sufijo numérico `123` que sí está presente en el archivo original.

## Pregunta 2: Sincronización de respaldos con rsync y verificación de integridad

**Escenario**:
El equipo de infraestructura necesita sincronizar el directorio de datos respaldados a una ubicación de destino para su transferencia a un servidor de almacenamiento offsite. Se debe usar `rsync` para la sincronización y posteriormente verificar que todos los archivos fueron transferidos correctamente antes de eliminar el origen.

**Requisitos**:
- Usar `rsync -av` para sincronizar `~/laboratorio/backup/datos/` a `~/laboratorio/backup/destino/`
- Verificar que el directorio `destino/` existe después de la sincronización
- Contar el número exacto de archivos regulares en `destino/` después de la sincronización
- Confirmar que el archivo `destino/usuarios/usuarios.txt` existe y es legible

**Restricciones**:
- Usar `rsync` con las opciones `-av` (archive y verbose)
- La ruta de origen debe ser exactamente `~/laboratorio/backup/datos/`
- La ruta de destino debe ser exactamente `~/laboratorio/backup/destino/`
- No crear ni modificar archivos manualmente en `destino/`

**Criterios de Validación**:
- El directorio `~/laboratorio/backup/destino/` existe después de ejecutar rsync
- El comando `find ~/laboratorio/backup/destino/ -type f | wc -l` devuelve exactamente `5`
- El archivo `~/laboratorio/backup/destino/usuarios/usuarios.txt` existe
- El archivo `~/laboratorio/backup/destino/documentos/doc1.txt` existe y contiene "Documento importante"

**Pregunta de Selección Múltiple**:

¿Cuántos archivos regulares hay en el directorio `destino/` después de sincronizar con `rsync -av datos/ destino/`?

A) 3
B) 4
C) 5
D) 6

**Explicación**:
- Respuesta correcta: C) 5 - El directorio `datos/` contiene exactamente 5 archivos regulares: `usuarios/usuarios.txt`, `documentos/doc1.txt`, `documentos/doc2.txt`, `config/sistema.conf` y `config/db.conf`. Al sincronizar con `rsync -av datos/ destino/`, se transfieren los 5 archivos manteniendo la estructura de directorios. Se verifica ejecutando: `find ~/laboratorio/backup/destino/ -type f | wc -l`
- Distractor A: 3 - Representa un conteo parcial incorrecto, posiblemente contando solo los archivos en `documentos/` y `config/` sin incluir `usuarios/`.
- Distractor B: 4 - Representa un conteo que omite un archivo, comúnmente el archivo de usuarios o uno de los documentos.
- Distractor D: 6 - Representa un conteo excesivo que incluiría un archivo adicional que no existe en el directorio fuente `datos/`.
