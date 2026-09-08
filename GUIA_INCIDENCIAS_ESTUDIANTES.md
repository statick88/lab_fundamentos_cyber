# Guía de Resolución de Incidencias — Fundamentos de Ciberseguridad (ABC-CYB-101)

> **Importante:** Esta guía corrige inexactitudes comunes sobre el entorno de laboratorio.  
> Verificado contra el código fuente: `Dockerfile`, `docker-compose.yml`, `entrypoint.sh`, y `shared/*.sh`.

---

## 1. Resolución de Incidencias Técnicas Iniciales

### 1.1 Verificación de usuario y contraseña predeterminada

| Concepto | Valor real |
|----------|-----------|
| **Usuario** | `estudiante` (UID 1000) |
| **Contraseña** | `changeme` |
| **Base del sistema** | Ubuntu 24.04 (no Kali Linux) |

El usuario `estudiante` es creado en el `Dockerfile` (línea 60):

```dockerfile
RUN useradd -m -s /bin/bash estudiante
```

La contraseña proviene de `docker-compose.yml` (línea 27):

```yaml
STUDENT_PASS=${STUDENT_PASS:-changeme}
```

> Si el docente proporcionó una credencial individual con otra contraseña, usa ese valor. Si usas `docker compose up` sin definir `STUDENT_PASS`, la contraseña es **`changeme`**.

### 1.2 Solución al fallo de contraseña o bloqueo de sesión

#### Opción A — Resetear la contraseña desde el host (recomendado)

Si el login falla por una contraseña olvidada o modificada, sal del contenedor y ejecuta desde tu máquina host:

```bash
# 1. Ingresa al contenedor como root (UID 0)
docker compose exec -u 0 lab-linux bash

# 2. Cambia la contraseña del usuario estudiante — NO pide la actual
passwd estudiante

# 3. Presiona Ctrl+D o escribe 'exit' para salir
```

Luego vuelve a entrar normalmente:

```bash
docker compose exec lab-linux bash
```

#### Opción B — Usar el script `reset.sh`

Dentro del contenedor, el script `reset.sh` limpia configuraciones, reglas de firewall y archivos de prueba:

```bash
bash reset.sh                # Limpieza básica (sin borrar progreso)
bash reset.sh --progreso     # Limpieza completa (también reinicia progreso)
```

> `reset.sh` se encuentra en la raíz del proyecto y se copia a `/reset.sh` dentro del contenedor. **No** requiere `sudo` para ejecutarse.

### 1.3 Comandos del laboratorio (sin `sudo` ni `validate_all.sh`)

| Comando | Qué hace | Nota |
|---------|----------|------|
| `menu` | Muestra el menú principal de 18 unidades | Es una **función**, no un binario. No uses `sudo menu`. |
| `jugar` | Inicia el modo interactivo de retos | |
| `unidad N` | Selecciona la unidad N (1-18) | Ejemplo: `unidad 4` |
| `retos` | Lista los retos de la unidad actual | |
| `evaluar` | Ejecuta todos los validadores y muestra ✓/✗ | Reemplaza a la inexistente `validate_all.sh` |
| `pista` | Muestra una pista para el reto actual | |
| `revelar-frase` / `s` | Muestra las palabras reveladas por unidad | |
| `progreso` | Barra de progreso global (CORE + total) | |
| `ayuda` | Lista todos los comandos disponibles | |

> **¿Por qué no funciona `sudo menu`?**  
> `menu` es una función bash definida en `~/.bash_aliases` (generada dinámicamente por `entrypoint.sh`). El comando `sudo` solo ejecuta binarios en el disco, **nunca funciones shell**. Si ejecutas `sudo menu`, obtendrás:  
> `sudo: menu: command not found`  
> La corrección es sencilla: escribe `menu` sin `sudo`.

### 1.4 Solución de problemas comunes

| Problema | Causa | Solución |
|----------|-------|----------|
| `Permission denied` al ejecutar un comando | El comando requiere privilegios de root | Usa `sudo` + el comando. El usuario `estudiante` tiene NOPASSWD para: `ufw`, `iptables`, `nmap`, `logrotate`, `john`, `fail2ban-client` |
| `sudo: passwd: command not found` o pide contraseña actual | `passwd` no está en la lista de sudoers NOPASSWD | Resetea desde el host con `docker compose exec -u 0 lab-linux bash` → `passwd estudiante` |
| Las reglas de UFW no persisten | El archivo `/etc/ufw/user.rules` fue sobreescrito | Ejecuta `bash reset.sh` y reconfigura |
| El contador de progreso no avanza | El progreso se almacena en `/var/lab-state/progress` (root, modo 0660) | El estudiante no puede modificarlo directamente. Usa `evaluar` para validar. |
| El contenedor no inicia | La imagen está desactualizada | `docker compose build --no-cache && docker compose up -d` |

---

## 2. Guía Paso a Paso para Principiantes

### Paso 1: Orientación en la Terminal

La consola de Linux es tu herramienta principal. No necesitas memorizar comandos complejos; usa siempre que lo necesites:

```bash
man <comando>    # Documentación oficial: man grep, man chmod
<comando> --help # Ayuda rápida: grep --help
```

**Concepto fundamental (Ebook Unidad 1 — FHS):**  
El sistema de archivos sigue el estándar FHS (Filesystem Hierarchy Standard). Recordatorio rápido:
- `/etc` — archivos de configuración del sistema
- `/var` — datos variables que **persisten** (logs, bases de datos)
- `/tmp` — archivos temporales (se borran al reinicio)
- `/home` — directorios personales de usuarios

### Paso 2: Técnica Pomodoro en Prácticas

Trabaja en bloques de **25 minutos de enfoque absoluto** en la consola, luego **descansa 5 minutos**. Después de 4 ciclos, toma un descanso largo de 15-30 minutos.

**Por qué funciona:** La fatiga cognitiva es el enemigo #1 de la resolución de retos. Al limitar el tiempo de foco, mantienes la concentración en la sintaxis y los patrones de salida. Si un comando falla, no intentes 10 cosas a la vez — anota el error, toma un descanso de 5 minutos, y vuelve con mente fresca.

### Paso 3: Análisis de Errores Comunes

#### Error `Permission denied`

**Teoría (Ebook — Control de Acceso):** En Linux, todo archivo y directorio tiene dueño y permisos. El superusuario (`root`) puede acceder a todo, pero los usuarios normales están restringidos.

**Diagnóstico:**
```bash
ls -l /ruta/al/archivo        # Muestra propietario y permisos
whoami                        # ¿Qué usuario eres?
sudo -l                       # ¿Qué puedes hacer con sudo?
```

**Solución:** Si el comando necesita root, antepón `sudo`:
```bash
sudo ufw status               # Ver reglas de firewall
sudo iptables -L              # Listar reglas iptables
sudo nmap -sS 172.20.0.10     # Escaneo (está en la lista NOPASSWD)
```

#### Errores de sintaxis en scripts Bash

**Teoría (Ebook — Scripting):** Un script Bash es una secuencia de comandos ejecutados por intérprete. Los errores más comunes:
- `command not found` → nombre mal escrito o comando no instalado
- `syntax error near unexpected token` → falta un `fi`, `done`, `}`, o comilla sin cerrar
- `No such file or directory` → la ruta no existe

**Diagnóstico:**
```bash
bash -n script.sh             # Verifica sintaxis sin ejecutar
shellcheck script.sh          # Analizador estático de scripts (instalado en el contenedor)
```

#### Errores en retos tipo Wargame

Si estás trabajando en retos de captura de bandas (wargames) como Bandit (OverTheWire):

1. **Documenta cada contraseña encontrada** en tu bloc de notas antes de avanzar al siguiente nivel. Un error común es sobrescribir el portapapeles y perder la contraseña del nivel actual.
2. Usa el **Principio de Mínimos Privilegios:** no ejecutes comandos con `sudo` si no es necesario.
3. **Verifica dos veces, ejecuta una:** antes de presionar Enter, comprueba que la sintaxis sea correcta con `bash -n`.

---

## 3. Criterio de Integridad y Uso Ético de la Inteligencia Artificial

**Regla de oro:** las herramientas de IA deben usarse para **explicar conceptos complejos**, no para copiar respuestas de forma ciega.

### ¿Cómo usar la IA correctamente en este laboratorio?

| Uso ético ✅ | Uso no ético ❌ |
|-------------|-----------------|
| "Explícame qué hace `chmod 755`" | Pegar el reto completo y pedir la respuesta |
| "¿Cuál es la diferencia entre `du` y `df`?" | "Dame el comando para el reto 5" sin intentar resolverlo |
| "¿Qué significa esta salida de `nmap`?" | Usar IA para generar hashes durante evaluaciones |

### Canarios técnicos en las evaluaciones

**¡Atención!** Los retos tipo pregunta múltiple (Unidad I, retos 1-10) incluyen **canarios técnicos**: distractores diseñados para detectar respuestas copiadas sin comprensión. Siempre razona los fundamentos teóricos antes de marcar una opción:

- **Antes de responder:** ¿Recuerdas *por qué* esa opción es correcta?
- **Después de responder:** ¿La IA te explicó el concepto o solo te dio la letra?

### Principio de no sobre-confianza

La IA no reemplaza a la teoría. Si un comando "funciona" pero no entiendes **por qué**, dilo: investiga, consulta el Ebook, pregunta al instructor. En ciberseguridad, **comprender el fundamento** es tan importante como el resultado correcto.

---

## 4. Frase Secreta del Laboratorio

Cada unidad completada revela una palabra. Completa las 18 unidades para descubrir la frase completa:

```
Toda revolution comienza con un pass
Los administradores nunca duermen !
Ciberseguridad es todos
```

Usa `evaluar` para validar cada unidad y `revelar-frase` para ver el progreso de la frase.

---

*Documentación verificada contra el código fuente el 2026-09-01.*  
*Laboratorio: Fundamentos de Ciberseguridad — ABC-CYB-101*  
*Base del contenedor: Ubuntu 24.04*
