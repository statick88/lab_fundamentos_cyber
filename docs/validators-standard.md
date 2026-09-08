# Estándar de Validadores de Retos

## Resumen

Se estandarizó la lógica de aserciones de `test.sh` bajo un contrato común y determinista. El piloto se implementó en **Unit X (SSL/TLS)**, pasando de validadores ad-hoc a helpers reutilizables en `/shared/validators.sh`.

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

## Próximas unidades

- Unit IX (Nginx)
- Unit III (Shell Scripting)
- Unit II (Firewalls)

## Referencias

- `shared/validators.sh` — helpers compartidos
- `units/x/test.sh` — piloto refactorizado
