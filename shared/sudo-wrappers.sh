#!/bin/bash
# /shared/sudo-wrappers.sh — Helpers para validadores System-Bound
# Contrato: retorna 0 en PASS, 1 en FAIL. Sin efectos secundarios.
# Usar SOLO en unidades que inherentemente requieren privilegios elevados.
# source /shared/sudo-wrappers.sh

assert_sudo_ok() {
    # Ejecuta comando con sudo y valida retorno 0.
    # Uso: assert_sudo_ok useradd practicante
    sudo "$@" >/dev/null 2>&1 && return 0
    echo "FAIL: sudo $* falló" >&2
    return 1
}

assert_file_owner() {
    # Verifica que el archivo pertenece al usuario esperado.
    # Uso: assert_file_owner /home/practicante practicante
    local file="$1" expected_owner="$2"
    local owner
    owner=$(stat -c "%U" "$file" 2>/dev/null || stat -f "%Su" "$file" 2>/dev/null)
    [ "$owner" = "$expected_owner" ] && return 0
    echo "FAIL: Owner de $file es '$owner', esperado '$expected_owner'" >&2
    return 1
}

assert_mount_active() {
    # Verifica que un mount point está activo en el sistema.
    # Uso: assert_mount_active /tmp/test_mount
    local mountpoint="$1"
    mount | grep -q "$mountpoint" && return 0
    echo "FAIL: Mount $mountpoint no activo" >&2
    return 1
}

assert_ufw_active() {
    # Verifica que UFW está activo (requiere sudo).
    # Uso: assert_ufw_active
    sudo ufw status 2>/dev/null | grep -qi "active" && return 0
    echo "FAIL: UFW no activo" >&2
    return 1
}

assert_user_exists() {
    # Verifica que un usuario existe en el sistema.
    # Uso: assert_user_exists practicante
    local username="$1"
    id "$username" >/dev/null 2>&1 && return 0
    echo "FAIL: Usuario $username no existe" >&2
    return 1
}

assert_group_exists() {
    # Verifica que un grupo existe en el sistema.
    # Uso: assert_group_exists desarrolladores
    local groupname="$1"
    getent group "$groupname" >/dev/null 2>&1 && return 0
    echo "FAIL: Grupo $groupname no existe" >&2
    return 1
}

assert_user_in_group() {
    # Verifica que un usuario pertenece a un grupo.
    # Uso: assert_user_in_group practicante desarrolladores
    local username="$1" groupname="$2"
    groups "$username" 2>/dev/null | grep -qw "$groupname" && return 0
    echo "FAIL: Usuario $username no está en grupo $groupname" >&2
    return 1
}
