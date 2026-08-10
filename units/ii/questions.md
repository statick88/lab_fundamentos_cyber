# Preguntas de Evaluación - Unidad II: Gestión de Paquetes

## Pregunta 1: Instalación de paquete y verificación de estado con dpkg

**Escenario**:
El servidor de aplicaciones necesita tener el editor `vim` instalado para que los administradores puedan editar archivos de configuración directamente en el servidor. El equipo de operaciones debe verificar que el paquete está correctamente instalado y obtener el estado exacto del paquete para incluirlo en el reporte de cumplimiento. Debes instalar el paquete `vim` y capturar el estado exacto que muestra `dpkg -l vim` para validar la instalación.

**Requisitos**:
- Actualizar la caché de apt (apt-get update)
- Instalar el paquete `vim` con `apt-get install`
- Verificar el estado del paquete con `dpkg -l vim`
- Capturar la línea de estado exacta de `dpkg -l`

**Restricciones**:
- No instalar otros paquetes adicionales
- No modificar archivos de configuración de vim
- No eliminar el paquete después de instalarlo
- El estado debe ser verificado con `dpkg -l vim`

**Criterios de Validación**:
- El comando `dpkg -l vim` devuelve una línea que contiene `^ii` (estado instalado)
- El paquete `vim` aparece en la salida de `dpkg -l`
- El comando `which vim` devuelve la ruta al ejecutable
- El archivo `/usr/bin/vim` existe y es ejecutable

**Pregunta de Selección Múltiple**:

¿Cuál es la primera columna del estado de `dpkg -l vim` que indica que el paquete está correctamente instalado?

A) `rc`
B) `ii`
C) `iU`
D) `pn`

**Explicación**:
- Respuesta correcta: B) `ii` - En la salida de `dpkg -l`, las primeras dos columnas indican el estado deseado y el estado actual. `ii` significa "installed" (deseado) e "installed" (actual), confirmando que el paquete está correctamente instalado. Se obtiene ejecutando: `dpkg -l vim | grep -o '^..'`
- Distractor A: `rc` - Significa "remove" (deseado) y "config-files" (actual). Indica que el paquete fue eliminado pero quedan archivos de configuración.
- Distractor C: `iU` - Significa "installed" (deseado) y "unpacked" (actual). Indica que el paquete se descargó pero no se configuró completamente.
- Distractor D: `pn` - No es un código de estado válido en `dpkg -l`. `p` significa "purge" y `n` significa "not-installed", pero esta combinación no aparece en la primera columna.

---

## Pregunta 2: Identificación del paquete propietario de un archivo binario

**Escenario**:
Un administrador de sistemas necesita actualizar el binario de `vim` pero no recuerda qué paquete de Debian/Ubuntu lo instaló originalmente. Debes identificar el paquete propietario del archivo `/usr/bin/vim.basic` y reportar el nombre exacto del paquete para proceder con la actualización. Este conocimiento es crítico para mantener el registro de software instalado y cumplir con las políticas de gestión de configuración de la organización.

**Requisitos**:
- Identificar el archivo binario exacto de vim en el sistema
- Usar `dpkg -S` para encontrar el paquete propietario
- Extraer el nombre exacto del paquete
- Verificar que el paquete está instalado

**Restricciones**:
- No usar `apt-file` (requiere instalación de paquetes adicionales)
- No buscar en documentación externa
- No modificar el archivo binario
- El comando debe ser `dpkg -S` sobre la ruta completa del binario

**Criterios de Validación**:
- El comando `dpkg -S /usr/bin/vim.basic` devuelve una línea que contiene el nombre del paquete
- El paquete identificado está instalado (`dpkg -l <paquete>` muestra `^ii`)
- El archivo `/usr/bin/vim.basic` existe y es ejecutable
- La salida de `dpkg -S` contiene al menos dos puntos (`:`) separando paquete y ruta

**Pregunta de Selección Múltiple**:

¿Qué comando devuelve el nombre exacto del paquete que instaló `/usr/bin/vim.basic`?

A) `dpkg -l /usr/bin/vim.basic`
B) `dpkg -S /usr/bin/vim.basic`
C) `apt-cache search vim.basic`
D) `which vim.basic`

**Explicación**:
- Respuesta correcta: B) `dpkg -S /usr/bin/vim.basic` - El comando `dpkg -S` (search) busca qué paquete instaló un archivo específico. Devuelve el nombre del paquete seguido de dos puntos y la ruta del archivo. Ejemplo de salida: `vim: /usr/bin/vim.basic`
- Distractor A: `dpkg -l /usr/bin/vim.basic` - El flag `-l` lista paquetes instalados, pero espera un nombre de paquete, no una ruta de archivo. No funciona para identificar el propietario de un archivo.
- Distractor C: `apt-cache search vim.basic` - Busca en los repositorios paquetes cuyo nombre o descripción coincida con "vim.basic". No identifica el paquete instalado que posee el archivo.
- Distractor D: `which vim.basic` - El comando `which` busca ejecutables en el PATH, pero `/usr/bin/vim.basic` no está en el PATH por defecto (solo `vim`). Además, `which` no devuelve el nombre del paquete.
