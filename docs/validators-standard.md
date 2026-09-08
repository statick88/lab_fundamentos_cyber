# Estándar de Validadores de Retos

## Resumen

Se estandarizó la lógica de aserciones de `test.sh` bajo un contrato común y determinista. El piloto se implementó en **Unit X (SSL/TLS)**, y se extendió a Unit III, IX y XI.

## Problema resuelto

- Código duplicado en aserciones (`[ -f ... ]`, `grep -q ...`, `openssl verify | grep OK`).
- Dependencias frágiles de comandos privilegiados (`sudo`, `ufw`, `iptables`).
- Falta de mensajes de error uniformes en fallos de validación.
- Validadores no deterministas por efectos secundarios o rutas hardcodeadas.

## Contrato estándar

| Elemento | Regla |
|----------|-------|
| Retorno | `0` = PASS, `1` = FAIL |
| Stdout | Solo en fallo (mensaje de error a `stderr`) |
| Idempotencia | Ejecutable múltiples veces sin efectos secundarios |
| Privilegios | Sin `sudo`/`su`/`chmod +s`/`chown root` |
| Paths | Solo `$HOME/laboratorio/`, `/tmp/`, `/shared/` |

## Helpers disponibles

```bash
source /shared/validators.sh

assert_file_exists <ruta>
assert_file_contains <archivo> <patrón>
assert_command_ok <comando> [args...]
assert_openssl_chain <cert> <ca>
assert_openssl_subject_matches <cert> <patrón>
```

## Ejemplo de uso

```bash
reto15() {
    local workdir="$HOME/laboratorio/ssl"
    mkdir -p "$workdir" && cd "$workdir" || return 1
    assert_file_exists "ca/ca.crt"
    assert_file_exists "servidor.crt"
    assert_file_exists "servidor.key"
    assert_openssl_chain "servidor.crt" "ca/ca.crt"
    assert_openssl_subject_matches "servidor.crt" "CN.*servidor"
}
```

## Migración

1. Agregar `source /shared/validators.sh` al inicio del `test.sh`.
2. Reemplazar aserciones booleanas por helpers estandarizados.
3. Ejecutar `unidad N && evaluar` para verificar PASS total.

## Unidades migradas

- **Unit X** (SSL/TLS) — 15/15 PASS — piloto original
- **Unit III** (Shell Scripting) — 15/15 PASS
- **Unit IX** (Nginx) — 10/10 PASS — fix: `pkill` para detener nginx
- **Unit XI** (Backup & Recovery) — 10/10 PASS

## Auditoría de privilegios por unidad

| Unidad | Tema | Sudo en test.sh | Systemctl | Useradd | Clasificación |
|--------|------|-----------------|-----------|---------|---------------|
| I | — | 0 | 0 | 0 | Pendiente |
| II | Package Management | 0 | 0 | 0 | **Candidata** |
| III | Shell Scripting | 0 | 0 | 0 | Migrada ✅ |
| IV | User Management | 0 | 0 | Sí | System-Bound (diseño) |
| V | Processes & Services | 0 | Lectura | 0 | **Candidata** |
| VI | Storage Management | 3 | 0 | 0 | **System-Bound** |
| VII | Security Hardening | 3 | 0 | 0 | **System-Bound** |
| VIII | Docker | 0 | N/A | 0 | System-Bound (daemon) |
| IX | Nginx | 1 (fix) | 0 | 0 | Migrada ✅ |
| X | SSL/TLS | 0 | 0 | 0 | Migrada ✅ |
| XI | Backup & Recovery | 0 | 0 | 0 | Migrada ✅ |

### Detalle de privilegios detectados

**Unit II (Package Management)**
- `test.sh`: 0 sudo. Solo lecturas `dpkg -l`, `dpkg -L`, `dpkg -S`, `apt-cache show/search`.
- `setup.sh`: usa `sudo apt-get update/install/purge` (scope: instalación real).
- Clasificación: **Candidata** — validadores son pura lectura de estado.

**Unit V (Processes & Services)**
- `test.sh`: 0 sudo explícito. Usa `ps aux`, `kill`, `crontab -l` (usuario actual), `systemctl status/list-units` (lectura).
- `setup.sh`: `systemctl status ssh` con fallback `service ssh status`.
- Clasificación: **Candidata** — operaciones de solo lectura o scope usuario.

**Unit VI (Storage Management)**
- `test.sh`: 3 sudo (`fdisk -l`, `mkfs.ext4`, `mount/umount`).
- `setup.sh`: `sudo mkfs.ext4`, `sudo mount/umount`.
- Clasificación: **System-Bound** — requiere formateo y montaje real de block devices.

**Unit VII (Security Hardening)**
- `test.sh`: 3 sudo (`cat /etc/sudoers`, `ufw status/iptables -L`, `lastb/journalctl/auth.log`).
- `setup.sh`: `sudo ufw status`.
- Clasificación: **System-Bound** — requiere lectura de logs auth y estado de firewall.

## Próximas unidades

### Candidatas a migración estándar (inmediatas)

- **Unit II** (Package Management) — reemplazar dpkg/apt-cache checks por helpers
- **Unit V** (Processes & Services) — mantener systemctl como `assert_command_ok` con fallback

### System-Bound (requiere arquitectura específica)

- **Unit IV** (User Management) — `useradd`, `groupadd`, `/etc/passwd` (diseño inherente)
- **Unit VI** (Storage Management) — `mkfs.ext4`, `mount/umount`, loop devices
- **Unit VII** (Security Hardening) — `/etc/sudoers`, `ufw/iptables`, auth logs
- **Unit VIII** (Docker) — Docker daemon socket

## Propuesta arquitectónica para System-Bound

Para unidades que inherentemente requieren privilegios, se propone un **wrapper de ejecución segura** en lugar de forzar el contrato sin-sudo:

### 1. Wrapper `/shared/sudo-wrappers.sh`

Helpers que encapsulan operaciones privilegiadas con validación de precondiciones:

```bash
source /shared/sudo-wrappers.sh

assert_sudo_ok() {
    # Valida que el comando con sudo retorne 0
    sudo "$@" >/dev/null 2>&1 && return 0
    echo "FAIL: sudo $* falló" >&2
    return 1
}

assert_file_owner() {
    local file="$1" expected_owner="$2"
    local owner
    owner=$(stat -c "%U" "$file" 2>/dev/null || stat -f "%Su" "$file" 2>/dev/null)
    [ "$owner" = "$expected_owner" ] && return 0
    echo "FAIL: Owner de $file es '$owner', esperado '$expected_owner'" >&2
    return 1
}

assert_mount_active() {
    local mountpoint="$1"
    mount | grep -q "$mountpoint" && return 0
    echo "FAIL: Mount $mountpoint no activo" >&2
    return 1
}

assert_ufw_active() {
    sudo ufw status 2>/dev/null | grep -qi "active" && return 0
    echo "FAIL: UFW no activo" >&2
    return 1
}
```

### 2. Estrategia por unidad System-Bound

| Unidad | Estrategia |
|--------|-----------|
| **Unit IV** | Usar `assert_file_owner` para `/home/practicante`, `assert_command_ok getent group` para grupos. Mantener `sudo` en setup.sh, eliminar de test.sh donde sea posible. |
| **Unit VI** | Pre-crear loop device en Dockerfile (`dd` + `mkfs.ext4`), validar montaje con `assert_mount_active`. Evitar `mkfs` en runtime. |
| **Unit VII** | Usar `assert_file_contains` para `/etc/ssh/sshd_config` (lectura pura). Para firewall, mockear estado en `/tmp/firewall_state` en setup y validar ese archivo. |
| **Unit VIII** | Fuera de scope — requiere Docker-in-Docker o privileged container. |

### 3. Principios de diseño

1. **Separación de concerns**: setup.sh ejecuta privilegios; test.sh solo valida estado.
2. **Artefactos de estado**: cuando no se puede leer el estado real (sudoers, ufw), escribir artefactos JSON en `/shared/` durante setup y validar contra ellos.
3. **Graceful degradation**: si `systemctl` no está disponible, fallback a `ps aux` (ya implementado en Unit V).

## Referencias

- `shared/validators.sh` — helpers compartidos (sin sudo)
- `shared/sudo-wrappers.sh` — helpers para unidades System-Bound (propuesto)
- `units/x/test.sh` — piloto refactorizado
- `docs/validators-standard.md` — este documento
