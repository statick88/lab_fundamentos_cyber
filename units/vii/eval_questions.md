# Preguntas de Evaluación — Unidad VII: Security Hardening

---

**ID:** VII-1
**Dificultad:** Fácil
**Reto:** 1
---

### Escenario

Tu equipo de operaciones detectó que un servidor de producción (Ubuntu 24.04) podría tener usuarios con privilegios de superusuario adicionales al usuario `root`. Como parte de la auditoría de seguridad, debes verificar cuántos usuarios tienen UID 0 (superuser) en el sistema, ya que cualquier cuenta adicional con UID 0 representa una amenaza de seguridad crítica.

### Requisitos

Ejecuta un comando que liste el nombre de todos los usuarios que tienen UID 0 utilizando `awk` sobre el archivo `/etc/passwd`. No modifiques ningún archivo del sistema.

### Restricciones

- No uses `sudo` ni modifiques `/etc/passwd`.
- No desesperes al encontrar múltiples resultados: en Ubuntu 24.04 el estado esperado es un solo usuario.
- No utilices comandos interactivos ni editores de texto.

### Criterios de Validación

El comando `awk -F: '$3 == 0 {print $1}' /etc/passwd` debe devolver exactamente:

```
root
```

Es decir, **un único resultado**: `root`. Cualquier otro nombre de usuario con UID 0 indica una cuenta privilegiada no autorizada.

### Pregunta de Selección Múltiple

¿Cuál es el único usuario que debería tener UID 0 (superusuario) en una instalación estándar de Ubuntu 24.04?

- **A)** root
- **B)** ubuntu
- **C)** daemon
- **D)** www-data

### Explicación

El UID 0 asigna privilegios de superusuario completos en Linux. En una instalación estándar de Ubuntu 24.04, **ún unicamente `root`** tiene UID 0. Las opciones B (`ubuntu`), C (`daemon`) y D (`www-data`) son cuentas de servicio con UIDs distintos a 0 (1000, 1, 33 respectivamente). Si `awk -F: '$3 == 0 {print $1}' /etc/passwd` devuelve más de un resultado, al menos una cuenta ha sido creada o modificada con intención maliciosa para escalar privilegios — esto es una indicación de compromiso del sistema y requiere investigación inmediata.

---

**ID:** VII-2
**Dificultad:** Media
**Reto:** 2
---

### Escenario

Como parte de un escaneo de vulnerabilidades en los archivos críticos del sistema, debes verificar los permisos y la propiedad de `/etc/passwd` y `/etc/shadow` en un servidor Ubuntu 24.04. Un administrador anterior habría podido modificar los permisos de forma incorrecta, exponiendo credenciales o permitiendo escritura no autorizada.

### Requisitos

Ejecuta comandos para inspeccionar los permisos en formato octal, el propietario y el grupo de `/etc/passwd` y `/etc/shadow`. Usa `stat -c "%a %U %G"` o `ls -la` para obtener la información. No modifiques los archivos ni sus permisos.

### Restricciones

- No uses `chmod`, `chown` ni `chgrp` bajo ninguna circunstancia.
- No reveles el contenido de `/etc/shadow` — solo verifica metadatos de permisos.
- No utilices `sudo` para leer los archivos.

### Criterios de Validación

En Ubuntu 24.04, los permisos esperados son:

| Archivo          | Permisos (octal) | Propietario | Grupo   |
|------------------|------------------|-------------|---------|
| `/etc/passwd`    | `644`            | `root`      | `root`  |
| `/etc/shadow`    | `640`            | `root`      | `shadow`|

El comando `stat -c "%a %U %G" /etc/passwd /etc/shadow` debe devolver:

```
644 root root
640 root shadow
```

### Pregunta de Selección Múltiple

¿Cuál es el permiso octal correcto que debe tener el archivo `/etc/shadow` para equilibrar la seguridad con la funcionalidad en Ubuntu 24.04?

- **A)** 644
- **B)** 640
- **C)** 600
- **D)** 755

### Explicación

El archivo `/etc/shadow` almacena contraseñas en hash (o hashes) y políticas de cuenta. Debe ser legible únicamente por `root` y por miembros del grupo `shadow` (por ejemplo, el demonio `shadow-utils`). El permiso octal **`640`** (propietario: lectura/escritura; grupo: lectura; otros: nada) satisface este requisito. La opción A (`644`) es incorrecta porque permite lectura a **cualquier usuario** del sistema — una exposición de seguridad. La opción C (`600`) es excesivamente restrictiva: impide que el grupo `shadow` funcione correctamente con utilidades que necesitan inspeccionar hashes. La opción D (`755`) es peligrosa: añade permisos de ejecución y lectura global a un archivo sensible. En contraste, `/etc/passwd` (que solo contiene información no sensible) usa `644 root root`, permitiendo lectura pública pero escritura exclusiva para `root`.

---
