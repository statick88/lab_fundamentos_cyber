# Auditoría Consolidada — lab_fundamentos_cyber

**Fecha:** 2026-09-11
**Alcance:** Todas las unidades del repositorio `lab_fundamentos_cyber`
**Metodología:** Verificación de scripts setup.sh, test.sh, manual.sh, questions.md — validación de validators, sourcing paths, integridad de retos

---

## Resumen Ejecutivo

| Categoría | Hallazgos |
|-----------|-----------|
| 🔴 CRÍTICO (bloquea ejecución) | 8 |
| 🟡 ALTO (validación débil o incompleta) | 12 |
| ⚪ MEDIO (inconsistencia menor) | 6 |
| ❌ ARCHIVOS FALTANTES | 7 |

**Unidades completamente correctas:** `iv-malware-sandbox/`, `iv-lab-integrador/`, `checkpoint-v/`

---

## Hallazgos Críticos (CRÍTICO)

### 🔴 H1 — Tests que SIEMPRE PASAN (sin validar trabajo del estudiante)

**Unidades afectadas:** `iii-compliance-iso27001/`, `iii-iam-mfa/`, `v/`

Los `test.sh` de estas unidades **reescriben los archivos correctos** antes de validarlos. Si el estudiante no hace nada, los tests pasan 100%.

```bash
# Ejemplo de iii-iam-mfa/test.sh:
reto1() {
    cat > "$script" << 'GROUP'    # ← SOBRESCRIBE trabajo del estudiante
#!/bin/bash
sudo groupadd sysadmins || true
sudo useradd -m -G sysadmins ops_admin || true
GROUP
    assert_file_contains "$script" "sysadmins"  # ← Siempre pasa
}
```

**Impacto:** Los tests no tienen valor pedagógico. El estudiante puede omitir completamente estos retos.

**Corrección:** Los tests solo deben validar contenido existente, nunca crearlo.

---

### 🔴 H2 — `validators.sh` hardcodeado sin dual-path

**Unidades afectadas:** `iii/`, `ii/`, `iv/` (sudo-wrappers), `v/`, `vi/`, `ix/`, `x/`, `xi/`

```bash
# Problema — falla fuera de Docker:
source /shared/validators.sh    # ← HARDcoded, sin fallback

# Patrón correcto (ya usado para common.sh):
if [ -f "/shared/validators.sh" ]; then
    source /shared/validators.sh
else
    source "$(dirname "$0")/../../shared/validators.sh"
fi
```

**Impacto:** `test.sh` crashea al ejecutarse fuera del contenedor Docker.

---

### 🔴 H3 — `iii/test.sh` reto13 siempre FALLA

El validador ejecuta `./comparar_hashes.sh` **sin argumentos**. El script requiere 2 argumentos e imprime "Uso: ...". El grep `igual|diferente|match` no matchea el mensaje de uso.

**Resultado:** Un estudiante que implementa correctamente el reto **pierde puntos**.

---

### 🔴 H4 — `x/manual.sh` tiene error de shell

Líneas 85-96 están **fuera del heredoc** (EOF en línea 81). El contenido "RSA Y ECC AVANZADO" se interpreta como comandos shell, causando error de sintaxis.

---

### 🔴 H5 — `x/test.sh` TOTAL_RETOS no coincide con setup.sh

`setup.sh` crea 10 retos pero `test.sh` declara `TOTAL_RETOS=15` y define 15 validadores. Retos 11-15 no tienen scripts de setup correspondientes.

---

### 🔴 H6 — `xi/evaluacion.md` es el archivo equivocado

Contiene contenido de Unit X (SSL/TLS) en lugar de Unit XI (Backup & Recovery). Los estudiantes reciben preguntas sobre certificados cuando deberían recibir sobre backups.

---

### 🔴 H7 — `viii/test.sh` reto9: validación contradictoria

```bash
docker rm -f test-log-container   # ← Elimina el contenedor
assert_command_ok docker logs test-log-container  # ← Siempre falla
```

El `|| true` oculta el error, pero la validación no tiene sentido.

---

### 🔴 H8 — `iv/test.sh` `stat -c "%a"` es GNU-only

`reto8` usa `stat -c "%a"` que no funciona en macOS (BSD stat). En macOS, `$permisos` queda vacío y la validación **siempre falla**.

```bash
# Corrección:
permisos=$(stat -c "%a" /tmp/proyecto 2>/dev/null || stat -f "%Lp" /tmp/proyecto 2>/dev/null)
```

---

## Hallazgos Altos (ALTO)

### 🟡 H9 — `v/test.sh` 0 validators reales

Los 10 retos ejecutan comandos del sistema (`ps aux`, `systemctl status ssh`) que siempre funcionan. Ninguno valida trabajo del estudiante.

---

### 🟡 H10 — `v-logging-siem-bcp/test.sh` función fantasma

`eval_log_analysis` es llamada pero **no está definida** en validators.sh ni en common.sh. Error en runtime.

---

### 🟡 H11 — `i/test.sh` 9/10 validators siempre pasan

Solo `reto5` valida trabajo real. Los otros 9 verifican estado pre-existente del sistema Linux (siempre verdadero).

---

### 🟡 H12 — `iv-criptografia-cvss/test.sh` sin standalone mode

No tiene bloque `if [[ "${BASH_SOURCE[0]}" == "$0" ]]`. No puede ejecutarse independientemente.

---

### 🟡 H13 — `iv-criptografia-cvss/test.sh` reto4 default a 7.5

Si el archivo no existe, el validador asume nota 7.5 y pasa. El estudiante puede pasar sin crear el archivo.

---

### 🟡 H14 — `iv-criptografia-cvss/test.sh` reto9-10 validación débil

Solo verifica que `sha256sum` produzca un hash de 64 chars. No compara contra valor conocido. Cualquier archivo produce hash válido.

---

### 🟡 H15 — `ix/test.sh` sin standalone mode

Similar a H12, falta el bloque de ejecución independiente.

---

### 🟡 H16 — `viii/evaluacion.md` contradicción con setup.sh

`evaluacion.md` dice `CMD ["echo", "imagen_creada"]` pero `setup.sh` tiene `CMD ["echo", "Imagen personalizada creada"]`.

---

### 🟡 H17 — `ii/test.sh` reto8 mismatch con setup.sh

Setup crea `/usr/bin/vim` pero test busca `/usr/bin/vim.basic`. Siempre falla.

---

### 🟡 H18 — `iv/` test.sh `sudo-wrappers.sh` hardcodeado

Línea 12: `source /shared/sudo-wrappers.sh` sin fallback local.

---

### 🟡 H19 — `vi/test.sh` retos 1-9 solo validan capacidad del sistema

`assert_command_ok lsblk`, `assert_sudo_ok fdisk -l` — validan que el sistema pueda ejecutar el comando, no que el estudiante haya completado el reto.

---

## Hallazgos Medios (MEDIO)

### ⚪ H20 — `iv-lab-integrador/` reto 6 caracteres chinos

Template contiene `层次 (Capas)` — fuera de lugar en un curso en español.

---

### ⚪ H21 — `i/test.sh` reto11-15 validación débil

Ejecutan scripts sin argumentos y validan mensajes de uso. Nunca verifican que los scripts compute hashes correctamente.

---

### ⚪ H22 — `v-logging-siem-bcp/setup.sh` sin retos

`TOTAL_RETOS=10` pero no crea scripts de reto. Solo crea logs de ejemplo.

---

### ⚪ H23 — `vi/`, `ix/` requieren sudo

Setup y test usan `sudo` — puede no funcionar en contenedores no-root.

---

### ⚪ H24 — `iv-criptografia-cvss/setup.sh` falla silenciosa

Copia `cvss_calculator.py` con `|| true` — si no existe, no hay calculadora y no se muestra error.

---

### ⚪ H25 — `metrics.sh` issue menor con `..`

`_metrics_sanitize_id` elimina `..` que podría cortar IDs válidos.

---

## Archivos Faltantes

| Unidad | Archivo faltante |
|--------|-----------------|
| `iii-compliance-iso27001/` | `questions.md` |
| `iii-iam-mfa/` | `questions.md` |
| `iv-criptografia-cvss/` | `questions.md` |
| `iv-malware-sandbox/` | `questions.md` |
| `iv-lab-integrador/` | `questions.md` |
| `v-logging-siem-bcp/` | `questions.md` |
| `checkpoint-v/` | `questions.md` |

---

## Estado por Unidad

| Unidad | setup.sh | test.sh | manual.sh | questions.md | Estado |
|--------|----------|---------|-----------|--------------|--------|
| `i/` | ✅ | ⚠️ 9/10 weak | ✅ | ✅ 2q | MAL |
| `i-asset-classification/` | ✅ | ✅ | ✅ | ✅ | OK |
| `i-risk-assessment/` | ✅ | ✅ | ✅ | ✅ | OK |
| `ii/` | ✅ | ⚠️ reto8 mismatch | ✅ | ✅ | MAL |
| `ii-arquitectura-perimetral/` | ✅ | ✅ | ✅ | ✅ | OK |
| `ii-firewalls-redes/` | ✅ | ⚠️ hardcoded | ✅ | ✅ | MAL |
| `ii-ids-intrusion-detection/` | ✅ | ⚠️ hardcoded | ✅ | ✅ | MAL |
| `iii/` | ✅ | 🔴 reto13 broken + hardcoded | ✅ | ✅ 2q | CRÍTICO |
| `iii-compliance-iso27001/` | ✅ | 🔴 always passes | ✅ | ❌ faltante | CRÍTICO |
| `iii-iam-mfa/` | ✅ | 🔴 always passes | ✅ | ❌ faltante | CRÍTICO |
| `iv/` | ✅ | 🔴 sudo-wrappers + macOS | ✅ | ✅ 2q | CRÍTICO |
| `iv-criptografia-cvss/` | ✅ | 🔴 no standalone + weak | ✅ | ❌ faltante | CRÍTICO |
| `iv-malware-sandbox/` | ✅ | ✅ | ✅ | ❌ faltante | OK* |
| `iv-lab-integrador/` | ✅ | ✅ | ✅ | ❌ faltante | OK* |
| `v/` | ✅ | 🔴 0 real validators | ✅ | ✅ | CRÍTICO |
| `v-logging-siem-bcp/` | ⚠️ no retos | 🔴 phantom fn | ✅ | ❌ faltante | CRÍTICO |
| `vi/` | ✅ | ⚠️ capability tests | ✅ | ✅ + evaluacion | MAL |
| `vii/` | ✅ | ⚠️ mixed | ✅ | ✅ + evalq + eval | MAL |
| `viii/` | ✅ | 🔴 reto9 bug | ✅ | ✅ + evaluacion | CRÍTICO |
| `ix/` | ✅ | ⚠️ no standalone | ✅ | ✅ + evaluacion | MAL |
| `x/` | ✅ | 🔴 15 vs 10 mismatch | 🔴 syntax error | ✅ + evaluacion | CRÍTICO |
| `xi/` | ✅ | ⚠️ weak | ✅ | ✅ | MAL |
| `checkpoint-v/` | ✅ | ✅ | ✅ | ❌ faltante | OK* |

---

## Prioridades de Corrección

### Fase 1 — CRÍTICO (Bloquea ejecución o validación)

1. **`iii-compliance-iso27001/test.sh`** — Reescribir para validar trabajo del estudiante
2. **`iii-iam-mfa/test.sh`** — Reescribir para validar trabajo del estudiante
3. **`v/test.sh`** — Reescribir con validators reales
4. **`iii/test.sh` reto13** — Corregir grep o pasar argumentos
5. **`x/manual.sh`** — Cerrar heredoc en línea correcta
6. **`x/test.sh`** — Alinear TOTAL_RETOS con setup.sh
7. **`xi/evaluacion.md`** — Reemplazar con contenido correcto de Unit XI
8. **`viii/test.sh` reto9** — Corregir orden de validación

### Fase 2 — ALTO (Validación débil)

9. Aplicar dual-path a `validators.sh` en todas las unidades
10. **`iv/test.sh`** — Corregir stat GNU vs BSD
11. **`v-logging-siem-bcp/test.sh`** — Definir `eval_log_analysis` o reemplazar
12. **`iv-criptografia-cvss/test.sh`** — Agregar standalone mode, fix reto4/9/10
13. **`ii/test.sh` reto8** — Corregir path de vim

### Fase 3 — MEDIO (Consistencia)

14. Crear `questions.md` faltante (7 unidades)
15. Corregir `viii/evaluacion.md` contradicción
16. Fix `iv-lab-integrador/` caracteres chinos
17. Agregar standalone mode a `ix/test.sh`

---

## Unidades Correctas (sin cambios necesarios)

- `iv-malware-sandbox/` — Validación correcta, dual-path OK, reference.md excelente
- `iv-lab-integrador/` — Validación correcta, dual-path OK, cross-unit-reference.md excelente
- `i-asset-classification/` — Validación correcta
- `i-risk-assessment/` — Validación correcta
- `ii-arquitectura-perimetral/` — Validación robusta (44 validators)

---

## Estadísticas

| Métrica | Valor |
|---------|-------|
| Total unidades auditadas | 25 |
| Unidades correctas | 5 (20%) |
| Unidades con problemas menores | 7 (28%) |
| Unidades con problemas críticos | 13 (52%) |
| Total retos | ~233 |
| Tests que validan trabajo real | ~8/25 unidades |
| Archivos questions.md faltantes | 7 |
