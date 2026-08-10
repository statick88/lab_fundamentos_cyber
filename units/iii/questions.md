# Preguntas de Evaluación - Unidad III: Shell Scripting

## Pregunta 1: Creación de script con función que devuelve un valor específico

**Escenario**:
El equipo de DevOps necesita automatizar el cálculo de hashes SHA256 para archivos de configuración. Debes crear un script llamado `hash_calc.sh` en `~/laboratorio/shell/` que reciba un nombre de archivo como argumento, use una función interna para calcular el hash SHA256 con `sha256sum`, y devuelva exactamente la primera línea de la salida de `sha256sum` (el hash de 64 caracteres). Una vez creado, debes ejecutarlo contra un archivo de prueba y capturar el hash exacto generado para el reporte de verificación.

**Requisitos**:
- Crear el script `hash_calc.sh` en `~/laboratorio/shell/`
- El script debe definir una función llamada `calcular_hash`
- La función debe recibir un argumento (ruta de archivo) y ejecutar `sha256sum`
- El script debe imprimir solo el hash (primer campo de sha256sum)
- Ejecutar el script contra `/etc/hostname` y capturar el hash de 64 caracteres

**Restricciones**:
- No usar `awk`, `cut` ni `sed`; solo `read` con array en bash
- El script debe ser ejecutable (`chmod +x`)
- No modificar el archivo `/etc/hostname`
- El hash debe ser exactamente de 64 caracteres hexadecimales

**Criterios de Validación**:
- El archivo `~/laboratorio/shell/hash_calc.sh` existe y es ejecutable
- El script contiene la definición de función `calcular_hash()`
- El script usa `sha256sum` para calcular el hash
- La salida de `./hash_calc.sh /etc/hostname` es un string de 64 caracteres hexadecimales

**Pregunta de Selección Múltiple**:

¿Cuál es el valor exacto del hash SHA256 devuelto por `./hash_calc.sh /etc/hostname`?

A) `0000000000000000000000000000000000000000000000000000000000000000`
B) `d41d8cd98f00b204e9800998ecf8427e`
C) `<hash SHA256 específico de /etc/hostname>`
D) `5d41402abc4b2a76b9719d911017c592`

**Explicación**:
- Respuesta correcta: C) `<hash SHA256 específico de /etc/hostname>` - El hash SHA256 de `/etc/hostname` es un valor único de 64 caracteres hexadecimales que solo puede obtenerse ejecutando `sha256sum /etc/hostname` en el entorno del laboratorio. El estudiante debe crear el script y ejecutarlo para obtener este valor.
- Distractor A: `0000000000000000000000000000000000000000000000000000000000000000` - Es un hash de 64 ceros. Ocurriría si el archivo estuviera vacío o si el script devolviera un valor nulo incorrecto.
- Distractor B: `d41d8cd98f00b204e9800998ecf8427e` - Es el hash MD5 de un archivo vacío (32 caracteres), no SHA256. Tampoco es de 64 caracteres.
- Distractor D: `5d41402abc4b2a76b9719d911017c592` - Es el hash MD5 de "hello" (32 caracteres). No es SHA256 y no corresponde al contenido de `/etc/hostname`.

---

## Pregunta 2: Script con bucle for que genera salida numerada específica

**Escenario**:
El equipo de QA necesita un script que genere un reporte numerado del 1 al 10 con el formato exacto `Item: N` (donde N es el número). Debes crear un script llamado `reporte.sh` en `~/laboratorio/shell/` que use un bucle `for` con la secuencia `{1..10}` para imprimir cada línea. Una vez ejecutado, debes capturar la línea correspondiente al número 5 para verificar que el formato es correcto.

**Requisitos**:
- Crear el script `reporte.sh` en `~/laboratorio/shell/`
- Usar un bucle `for i in {1..10}` 
- Imprimir cada línea con el formato exacto `Item: $i`
- Ejecutar el script y capturar la línea 5 del output

**Restricciones**:
- No usar `while` ni `until`, solo `for`
- No hardcodear las líneas, el bucle debe generarlas
- El script debe ser ejecutable
- No usar `seq` ni otros comandos externos para generar la secuencia

**Criterios de Validación**:
- El archivo `~/laboratorio/shell/reporte.sh` existe y es ejecutable
- El script contiene `for i in {1..10}`
- El script contiene `echo "Item: $i"`
- La salida del script contiene exactamente 10 líneas
- La línea 5 de la salida es exactamente: `Item: 5`

**Pregunta de Selección Múltiple**:

¿Cuál es la salida exacta de la línea 5 cuando se ejecuta `./reporte.sh`?

A) `5`
B) `Item: 5`
C) `Numero: 5`
D) `item5`

**Explicación**:
- Respuesta correcta: B) `Item: 5` - El script usa `echo "Item: $i"` dentro de un bucle `for i in {1..10}`, por lo que la línea correspondiente a la quinta iteración (i=5) es exactamente `Item: 5`. Se obtiene ejecutando: `./reporte.sh | sed -n '5p'`
- Distractor A: `5` - Es solo el número sin el prefijo "Item: ". Ocurriría si el script usara `echo $i` en lugar de `echo "Item: $i"`.
- Distractor C: `Numero: 5` - Es el formato usado en el reto 4 de la unidad (`echo "Numero: $i"`). No coincide con el formato `Item: $i` requerido en este ticket.
- Distractor D: `item5` - Es un formato compacto sin espacio. No coincide con el formato `Item: 5` con espacio y dos puntos.
