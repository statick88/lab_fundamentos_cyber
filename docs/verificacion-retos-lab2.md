# Verificación de Retos — Unidad i-risk-assessment (Lab 2)

**Fecha:** 2026-09-10
**Alcance:** Unidad `i-risk-assessment` — Evaluación de Riesgos con matriz ISO 31000
**Metodología:** Ejecución de cada validador (`reto1` … `reto10`) en el entorno Docker canónico del laboratorio (`lab-ciberseguridad`), tras regenerar el escenario con `setup.sh`.

---

## 1. Resultado resumen

| Reto | Validador | Estado |
|------|-----------|:------:|
| 1 | Escenario JSON válido | ✅ PASS |
| 2 | Plantilla de análisis existe | ✅ PASS |
| 3 | 5 activos en escenario | ✅ PASS |
| 4 | Cada activo tiene amenazas | ✅ PASS |
| 5 | A1 criticidad alta | ✅ PASS |
| 6 | A4 criticidad baja | ✅ PASS |
| 7 | A5 criticidad alta | ✅ PASS |
| 8 | A2 criticidad media | ✅ PASS |
| 9 | A3 criticidad alta | ✅ PASS |
| 10 | Riesgo calculable | ✅ PASS |

**Total: 10/10 pasados, 0 fallados.**

## 2. Entorno de ejecución

- Contenedor: `lab-ciberseguridad` (imagen `lab_fundamentos_cyber-lab-linux`)
- Unidad bajo prueba: `/home/estudiante/laboratorio/units/i-risk-assessment/`
- Escenario regenerado: `bash setup.sh` → `$HOME/laboratorio/risk-assessment/escenario.json` + `plantilla-analisis.md`
- Validadores ejecutados: `source test.sh && retoN` (N = 1..10), cada uno con `source /shared/common.sh` y `source /shared/validators.sh`

## 3. Alineación del escenario con los validadores

| Validador | Atributo del escenario | Valor esperado | Estado |
|-----------|------------------------|----------------|:------:|
| reto3 | `activos \| length` | 5 | ✅ |
| reto5 | A1 `criticidad` | `"alta"` | ✅ |
| reto6 | A4 `criticidad` | `"baja"` | ✅ |
| reto7 | A5 `criticidad` | `"alta"` | ✅ |
| reto8 | A2 `criticidad` | `"media"` | ✅ |
| reto9 | A3 `criticidad` | `"alta"` | ✅ |
| reto4 | cada activo con al menos 1 amenaza | `>= 1` | ✅ |
| reto10 | `[.activos[].amenazas[] \| (.probabilidad \* .impacto)] \| add` | calculable | ✅ |

## 4. Correcciones aplicadas en esta unidad (consolidadas)

- `units/i-risk-assessment/manual.sh:8` — añadido `banner_unidad 2 "Evaluación de Riesgos ISO 31000"`, colocando la unidad 20 (índice del manifiesto) en el mismo lugar que las otras 19 unidades, después de `UNIT_NAME=...` y antes del `cat << 'EOF'`.
- `units/i-risk-assessment/test.sh` — validador `reto4` corregido: `jq -e` devuelve exit 4 cuando no hay coincidencia (caso de paso); la lógica captura la salida y prueba que esté vacía en lugar de fallar por el código 4.
- `shared/evaluar-unidad.sh:34` — mapeo `i-risk → i-risk-assessment` (case-insensitive).
- `shared/retos-unidad.sh:33` — mapeo `i-risk → i-risk-assessment`.

## 5. Correcciones de runtime compartidas (fuera de alcance de esta unidad, verificadas como contexto)

- `shared/units_manifest.sh` `is_reto_core()` — usaba `echo 0`/`echo 1` en lugar de `return 0`/`return 1`; ahora devuelve códigos de salida adecuados.
- `shared/menu.sh:93` `ejecutar_unidad()` — pasaba `UNIT_ICONOS` (20 iconos de unidad) en lugar del array `ICONOS` de la unidad (10 iconos por reto); alineación de iconos corregida.

## 6. Estado del entorno local

La verificación se ejecutó en el contenedor Docker porque el mountpoint `/shared` no es montable en el host (filesystem de solo lectura). El contenedor `lab-ciberseguridad` mantiene copias de los archivos de la unidad; estos se sincronizaron con `docker cp` desde el host antes de ejecutar `setup.sh` y los validadores.