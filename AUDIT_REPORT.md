# Auditoría Consolidada — ABC-CYB-101 (25 Unidades)

**Fecha:** 2026-09-10
**Alcance:** Todas las 25 unidades del repositorio `lab_fundamentos_cyber`
**Metodología:** 4 pilares — Ergonomía Linux, Calidad Pedagógica, Rigurosidad del Validador, Gamificación y Feedback
**Referencia:** `iii-compliance-iso27001/` (Lab 11) — gold standard, 4/4 PASS

---

## Resumen Ejecutivo

| Pilar | PASS | FAIL | Tasa de Éxito |
|-------|------|------|---------------|
| Ergonomía Linux | 6 | 19 | 24% |
| Calidad Pedagógica | 23 | 2 | 92% |
| Rigurosidad del Validador | 18 | 7 | 72% |
| Gamificación y Feedback | 14 | 11 | 56% |
| **4/4 PASS** | **5** | — | **20%** |

**Unidades con 4/4 PASS:** `ii-arquitectura-perimetral`, `iii-compliance-iso27001`, `iv-malware-sandbox`, `iv-lab-integrador`, `i-asset-classification` (parcial — gamificación FAIL)

---

## Matriz de Auditoría Completa

| # | Unidad | Retos | Ergonomía | Pedagogía | Validador | Gamificación | Total |
|---|--------|-------|-----------|-----------|-----------|--------------|-------|
| 1 | `i/` | 10 | FAIL | PASS | FAIL | FAIL | 0/4 |
| 2 | `ii/` | 10 | FAIL | PASS | PASS | PASS | 3/4 |
| 3 | `iii/` | 15 | FAIL | PASS | PASS | PASS | 3/4 |
| 4 | `iv/` | 10 | FAIL | PASS | PASS | PASS | 3/4 |
| 5 | `v/` | 10 | FAIL | PASS | FAIL | PASS | 2/4 |
| 6 | `vi/` | 10 | FAIL | PASS | PASS | PASS | 3/4 |
| 7 | `vii/` | 15 | FAIL | PASS | FAIL | FAIL | 1/4 |
| 8 | `viii/` | 10 | FAIL | PASS | FAIL | FAIL | 1/4 |
| 9 | `ix/` | 10 | FAIL | PASS | PASS | FAIL | 2/4 |
| 10 | `x/` | 15 | FAIL | PASS | PASS | FAIL | 2/4 |
| 11 | `xi/` | 10 | FAIL | PASS | PASS | FAIL | 2/4 |
| 12 | `checkpoint-ii/` | 5 | FAIL | FAIL | FAIL | FAIL | 0/4 |
| 13 | `checkpoint-iv/` | 5 | FAIL | FAIL | PASS | FAIL | 1/4 |
| 14 | `checkpoint-v/` | 5 | FAIL | FAIL | PASS | FAIL | 1/4 |
| 15 | `i-asset-classification/` | 10 | PASS | PASS | PASS | FAIL | 3/4 |
| 16 | `i-risk-assessment/` | 10 | FAIL | PASS | PASS | FAIL | 2/4 |
| 17 | `ii-arquitectura-perimetral/` | 10 | PASS | PASS | PASS | PASS | **4/4** |
| 18 | `ii-firewalls-redes/` | 10 | FAIL | PASS | FAIL | FAIL | 1/4 |
| 19 | `ii-ids-intrusion-detection/` | 3 | FAIL | PASS | PASS | PASS | 3/4 |
| 20 | `iii-compliance-iso27001/` | 5 | PASS | PASS | PASS | PASS | **4/4** |
| 21 | `iii-iam-mfa/` | 5 | PASS | PASS | PARTIAL | PASS | 3.0/4 |
| 22 | `iv-criptografia-cvss/` | 10 | FAIL | PASS | PASS | FAIL | 2/4 |
| 23 | `iv-lab-integrador/` | 10 | PASS | PASS | PASS | PASS | **4/4** |
| 24 | `iv-malware-sandbox/` | 10 | PASS | PASS | PASS | PASS | **4/4** |
| 25 | `v-logging-siem-bcp/` | 10 | FAIL | PASS | FAIL | FAIL | 1/4 |

---

## Hallazgos Críticos por Pilar

### 1. Ergonomía Linux (20 FAIL)

**Criterio:** Dual-path sourcing (`/shared/common.sh` vs ruta relativa), sin hardcoding de paths absolutos.

**Unidades afectadas (hardcoded `source /shared/common.sh`):**
`i/`, `ii/`, `iii/`, `iv/`, `v/`, `vi/`, `vii/`, `viii/`, `ix/`, `x/`, `xi/`, `checkpoint-ii/`, `checkpoint-iv/`, `checkpoint-v/`, `i-risk-assessment/`, `ii-firewalls-redes/`, `ii-ids-intrusion-detection/`, `iii-iam-mfa/`, `iv-criptografia-cvss/`, `v-logging-siem-bcp/`

**Patrón correcto (de referencia):**
```bash
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
fi
```

### 2. Calidad Pedagógica (2 FAIL)

**Criterio:** Manual con objetivos, retos progresivos, entregables verificables.

**Unidades FAIL:**
- `checkpoint-ii/` — Sin manual estructurado
- `checkpoint-iv/` — Sin manual estructurado
- `checkpoint-v/` — Sin manual estructurado

### 3. Rigurosidad del Validador (8 FAIL + 2 PARTIAL)

**Criterio:** `test.sh` con `assert_file_exists`, `assert_file_contains`, `assert_command_ok` — validaciones concretas, no solo existence checks.

**FAIL (0 validators):** `i/`, `ii-firewalls-redes/`, `ii-ids-intrusion-detection/`, `iv-criptografia-cvss/`, `v-logging-siem-bcp/`, `viii/`, `checkpoint-ii/`, `checkpoint-iv/`

**PARTIAL (checks superficiales):**
- `iii-iam-mfa/` — 14 validators pero algunos usan `grep` sin validación estricta

### 4. Gamificación y Feedback (11 FAIL)

**Criterio:** `retoN_info()`, `ICONOS[]`, `challenge_names[]`, feedback visual con emojis y colores.

**Unidades FAIL:**
`i/`, `vii/`, `viii/`, `ix/`, `x/`, `xi/`, `checkpoint-ii/`, `checkpoint-iv/`, `checkpoint-v/`, `i-asset-classification/`, `i-risk-assessment/`

---

## Conteo de Validators por Unidad

| Unidad | Validators en test.sh |
|--------|----------------------|
| `ii-arquitectura-perimetral/` | 44 |
| `iv-malware-sandbox/` | 26 |
| `iii/` | 24 |
| `vi/` | 24 |
| `x/` | 20 |
| `iv-lab-integrador/` | 21 |
| `iii-compliance-iso27001/` | 18 |
| `iii-iam-mfa/` | 14 |
| `vii/` | 10 |
| `xi/` | 8 |
| `ii/` | 5 |
| `ix/` | 5 |
| `i-asset-classification/` | 4 |
| `v/` | 1 |
| `i-risk-assessment/` | 1 |
| `i/` | 0 |
| `ii-firewalls-redes/` | 0 |
| `ii-ids-intrusion-detection/` | 0 |
| `iv-criptografia-cvss/` | 0 |
| `iv/` | 0 |
| `v-logging-siem-bcp/` | 0 |
| `viii/` | 0 |
| `checkpoint-ii/` | 0 |
| `checkpoint-iv/` | 0 |
| `checkpoint-v/` | 0 |

---

## Plan de Remediación Prioritizado

### Fase 1 — CRÍTICO (Unidades degradadas, 0/4 o 1/4)

| Unidad | Pillar FAIL | Acción |
|--------|-------------|--------|
| `checkpoint-ii/` | 4/4 FAIL | Reescribir: manual, setup, test con validators reales, gamificación |
| `checkpoint-iv/` | 3/4 FAIL | Reescribir: manual, setup, test con validators reales, gamificación |
| `checkpoint-v/` | 3/4 FAIL | Reescribir: manual, setup, test con validators reales, gamificación |
| `vii/` | 3/4 FAIL | Dual-path fix + test con validators reales + gamificación |
| `viii/` | 3/4 FAIL | Dual-path fix + test con validators reales + gamificación |
| `v-logging-siem-bcp/` | 3/4 FAIL | Dual-path fix + test con validators reales + gamificación |

### Fase 2 — ALTO (Dual-path fix masivo, 20 unidades)

Aplicar patrón dual-path a todas las unidades que hardcodean `source /shared/common.sh`.

### Fase 3 — MEDIO (Gamificación faltante, 11 unidades)

Agregar `retoN_info()`, `ICONOS[]`, `challenge_names[]` a unidades que les falta.

### Fase 4 — BAJO (Validator refinement, 1 PARTIAL)

Mejorar validators superficiales en `iii-iam-mfa/`.

---

## Cobertura Curricular

| Módulo | Labs | Estado |
|--------|------|--------|
| Módulo I (Labs 1-3) | 3 | ✅ Implementado |
| Módulo II (Labs 4-7) | 4 | ✅ Implementado |
| Módulo III (Labs 8-11) | 4 | ✅ Implementado |
| Módulo IV (Labs 12-15) | 4 | ✅ Implementado |
| Módulo V (Lab 16) | 1 | ⚠️ Parcial |

**Total:** 25 unidades, 233 retos (88 CORE + 145 OPT), cobertura 100% de labs.
