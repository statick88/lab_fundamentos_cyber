# Preguntas de Evaluación - Unidad VI: Gestión de Almacenamiento

## Pregunta 1: Verificación del tamaño exacto de disco virtual creado con dd

**Escenario**:
El equipo de QA necesita aprovisionar un disco virtual de 10MB para pruebas de una aplicación de logs. Debes crear el archivo de disco virtual usando `dd` con bloques de 1MB y verificar el tamaño exacto en bytes con `stat` para el reporte de provisionamiento. La precisión del tamaño es crítica porque la aplicación valida el espacio disponible antes de escribir.

**Requisitos**:
- Crear el archivo `/home/estudiante/laboratorio/storage/disco_virtual.img` usando `dd if=/dev/zero`
- Usar `bs=1M` y `count=10` como parámetros
- Verificar el tamaño exacto en bytes con `stat -c%s`
- Reportar el valor numérico exacto del tamaño

**Restricciones**:
- No usar `truncate`, `fallocate` ni otros comandos alternativos a `dd`
- El archivo debe guardarse en la ruta exacta `/home/estudiante/laboratorio/storage/disco_virtual.img`
- No modificar el archivo después de crearlo
- El valor debe obtenerse con `stat -c%s` (no con `ls -lh`)

**Criterios de Validación**:
- El archivo `/home/estudiante/laboratorio/storage/disco_virtual.img` existe
- El comando `stat -c%s /home/estudiante/laboratorio/storage/disco_virtual.img` devuelve exactamente: `10485760`
- El comando `ls -lh` muestra aproximadamente `10M` para el archivo
- El archivo fue creado con `dd if=/dev/zero of=... bs=1M count=10`

**Pregunta de Selección Múltiple**:

¿Cuál es el tamaño exacto en bytes del archivo creado con `dd if=/dev/zero of=/home/estudiante/laboratorio/storage/disco_virtual.img bs=1M count=10`?

A) `10,000,000`
B) `10,485,760`
C) `5,242,880`
D) `20,971,520`

**Explicación**:
- Respuesta correcta: B) `10,485,760` - El comando `dd` con `bs=1M count=10` crea un archivo de exactamente 10 megabytes binarios (10 × 1,048,576 bytes = 10,485,760 bytes). Se verifica ejecutando: `stat -c%s /home/estudiante/laboratorio/storage/disco_virtual.img`
- Distractor A: `10,000,000` - Asume que 1MB equivale a 1,000,000 bytes (sistema decimal), pero `dd` usa megabytes binarios donde 1M = 1,048,576 bytes.
- Distractor C: `5,242,880` - Corresponde a 5MB (5 × 1,048,576), no a 10MB. Sería el resultado si `count=5`.
- Distractor D: `20,971,520` - Corresponde a 20MB (20 × 1,048,576), no a 10MB. Sería el resultado si `count=20`.

---

## Pregunta 2: Verificación del punto de montaje activo tras formateo ext4

**Escenario**:
Un servicio de backup requiere almacenamiento temporal en un disco virtual. Ya has creado y formateado el disco con ext4. Ahora debes montarlo en el directorio de punto de montaje designado y verificar que el sistema operativo reconoce el punto de montaje activo antes de copiar los archivos de backup. Para el ticket de operaciones, debes reportar la ruta exacta del punto de montaje que aparece en la salida del comando `mount`.

**Requisitos**:
- Crear el directorio de montaje `/home/estudiante/laboratorio/storage/montaje`
- Montar `/home/estudiante/laboratorio/storage/disco_virtual.img` en el directorio de montaje
- Verificar que el punto de montaje aparece en la salida de `mount`
- Reportar la ruta absoluta exacta del punto de montaje

**Restricciones**:
- No modificar el archivo de disco virtual después de formatearlo
- El punto de montaje debe ser exactamente `/home/estudiante/laboratorio/storage/montaje`
- No usar `df -h` como único método de verificación (debe usarse `mount`)
- No desmontar el volumen después de verificar

**Criterios de Validación**:
- El directorio `/home/estudiante/laboratorio/storage/montaje` existe
- El comando `mount | grep /home/estudiante/laboratorio/storage/montaje` devuelve la línea de montaje
- El archivo `disco_virtual.img` está montado en el directorio `montaje`
- El sistema de archivos es ext4

**Pregunta de Selección Múltiple**:

Después de montar el disco virtual, ¿cuál es la ruta absoluta exacta del punto de montaje que aparece en la salida del comando `mount`?

A) `/home/estudiante/laboratorio/storage/montaje`
B) `/home/estudiante/storage/montaje`
C) `/home/estudiante/laboratorio/storage/disco`
D) `/home/estudiante/laboratorio/montaje`

**Explicación**:
- Respuesta correcta: A) `/home/estudiante/laboratorio/storage/montaje` - Esta es la ruta absoluta del punto de montaje designado en el laboratorio. Se verifica ejecutando: `mount | grep /home/estudiante/laboratorio/storage/montaje`
- Distractor B: `/home/estudiante/storage/montaje` - Omite el directorio intermedio `laboratorio`. La ruta completa del laboratorio incluye `/home/estudiante/laboratorio/`.
- Distractor C: `/home/estudiante/laboratorio/storage/disco` - Usa el nombre `disco` en lugar de `montaje`. El directorio de montaje se llama `montaje`, no `disco`.
- Distractor D: `/home/estudiante/laboratorio/montaje` - Omite el directorio intermedio `storage`. La ruta completa es `/home/estudiante/laboratorio/storage/montaje`.
