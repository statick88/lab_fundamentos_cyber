# Unit VI — Storage Management
## Evaluación: 2 preguntas prácticas

---

### Pregunta 1 — Creación y formateo de disco virtual

**Título:** Storage provisioning ticket — disco virtual ext4

**Escenario:**  
El equipo de infraestructura requiere aprovisionar un volumen de 10 MB para pruebas de despliegue en un entorno de laboratorio. Debes crear el archivo de bloque, formatearlo con ext4 y montarlo. Como evidencia, el validador consultará el tamaño exacto en bytes del archivo de disco antes de montarlo.

**Requisitos:**
- Crear un archivo de disco virtual de exactamente 10 MB en `/root/laboratorio/storage/disco_virtual.img` usando `dd`.
- Formatear el archivo con `mkfs.ext4`.
- Montar el disco en `/root/laboratorio/storage/montaje`.

**Restricciones:**
- Usar `dd` con `bs=1M count=10`.
- No usar dispositivos de bloque reales; solo archivos de loop.
- El archivo debe quedar en la ruta exacta indicada.

**Criterios de validación:**
- El archivo `/root/laboratorio/storage/disco_virtual.img` existe.
- El sistema de archivos es ext4.
- El punto de montaje `/root/laboratorio/storage/montaje` está activo.

**Pregunta de selección múltiple:**

> Después de ejecutar `dd if=/dev/zero of=/root/laboratorio/storage/disco_virtual.img bs=1M count=10`, ¿cuál es el tamaño exacto en bytes del archivo creado?

A) 10 240 000 bytes  
B) 10 485 760 bytes  
C) 10 000 000 bytes  
D) 10 486 000 bytes  

**Explicación de distractores:**
- A) 10 240 000 bytes: confunde megabytes decimales con binarios (10 × 1 024 × 1 000). Incorrecto porque `dd` con `bs=1M` usa megabytes binarios (1 MiB = 1 048 576 bytes).
- C) 10 000 000 bytes: interpreta el `count=10` como 10 millones de bytes decimales. Incorrecto porque `dd` opera en bloques de bytes, no en unidades decimales de marketing.
- D) 10 486 000 bytes: aproximación cercana pero inexacta; no coincide con el múltiplo exacto de 1 MiB.

**Respuesta correcta:** B) 10 485 760 bytes  
**Cálculo:** 10 MB × 1 048 576 bytes/MiB = 10 485 760 bytes. Este valor se obtiene ejecutando: `stat -c%s /root/laboratorio/storage/disco_virtual.img`.

---

### Pregunta 2 — Montaje y verificación de contenido

**Título:** Storage validation ticket — contenido post-montaje

**Escenario:**  
Tras aprovisionar el disco virtual, el equipo de QA debe confirmar que el volumen montado acepta escritura y que los archivos copiados persisten hasta antes del desmontaje. Debes montar el volumen, escribir un archivo de prueba y reportar el nombre exacto del archivo de validación esperado por el test.sh de la unidad.

**Requisitos:**
- Montar `/root/laboratorio/storage/disco_virtual.img` en `/root/laboratorio/storage/montaje`.
- Crear un archivo llamado `archivo_prueba.txt` dentro del punto de montaje con el contenido exacto: `Archivo de prueba`.
- Copiar `/etc/hostname` al punto de montaje.

**Restricciones:**
- Usar `mount` sin modificar `/etc/fstab`.
- El archivo de prueba debe crearse con `echo` y redirección.
- No usar `sudo` si el contenedor ya corre como root.

**Criterios de validación:**
- `/root/laboratorio/storage/montaje/archivo_prueba.txt` existe.
- El contenido de `archivo_prueba.txt` es exactamente `Archivo de prueba\n`.
- `/etc/hostname` está presente en el directorio montado.

**Pregunta de selección múltiple:**

> Después de ejecutar el flujo de montaje y copia del Reto 6, ¿cuál es el nombre exacto del archivo de validación que debe existir en el punto de montaje?

A) `test.txt`  
B) `archivo_prueba.txt`  
C) `prueba.txt`  
D) `archivo.txt`  

**Explicación de distractores:**
- A) `test.txt`: coincide con el nombre usado en `test.sh` (`/tmp/test_mount/test.txt`), pero no con el Reto 6 de la unidad, que usa `archivo_prueba.txt`.
- C) `prueba.txt`: variación truncada del nombre real; no coincide con ninguna ruta del `setup.sh` de la unidad.
- D) `archivo.txt`: nombre genérico que no aparece en el laboratorio; distractor para estudiantes que adivinan en lugar de leer el script.

**Respuesta correcta:** B) `archivo_prueba.txt`  
**Evidencia:** El `setup.sh` de Unit VI, Reto 6, crea explícitamente `~/laboratorio/storage/montaje/archivo_prueba.txt` con `echo "Archivo de prueba" >`.
