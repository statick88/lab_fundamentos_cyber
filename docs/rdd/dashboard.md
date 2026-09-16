# RDD Dashboard — Métricas Agregadas

**Fecha**: 2026-09-16
**Rol**: Profesor (visión agregada del grupo)

---

## Module Completion Matrix

| Módulo | Competencia SETEC | Retos CORE | Retos OPT | CORE Pass Rate | Status |
|--------|-------------------|------------|-----------|----------------|--------|
| M1 — Terminal/Permisos | M1-OPS (15%) | 10 | ~36 | ? | Por iniciar |
| M2 — Reconocimiento de Red | M2-ANA (20%) | 10 | ~31 | ? | Por iniciar |
| M3 — Git y Control de Versiones | M3-GIT (15%) | 10 | ~27 | ? | Por iniciar |
| M4 — Docker y Aislamiento | M4-DOC (20%) | 10 | ~30 | ? | Por iniciar |
| M5 — Wargames (Bandit) | M5-WAR (15%) | 10 | ~29 | ? | Por iniciar |
| M6 — Logging, SIEM y BCP | M6-LOG (15%) | **10** | ~30 | **100%** | ✅ Completo |
| **Total** | **6 competencias** | **60** | **183** | — | — |

---

## Cross-Module Evidence Summary

| Métrica | M1 | M2 | M3 | M4 | M5 | M6 |
|---------|----|----|----|----|----|-----|
| CORE Pass Rate | TBD | TBD | TBD | TBD | TBD | **100%** |
| Mean Rubric Score | TBD | TBD | TBD | TBD | TBD | **TBD (Sección 3 humana)** |
| Common Errors | TBD | TBD | TBD | TBD | TBD | Reto 6 (correlación) |
| Inline Validators | ? | ? | ? | 0 (C4 standard) | ? | 10 (legacy) |
| Standard Validators | ? | ? | ? | ✅ 100% | ? | 0 (W4 gap) |
| Docs Updated | ? | ? | ? | ? | ? | ✅ 30 archivos |

---

## Professor RDD Decisions Log

| Fecha | Decisión | Motivo (Evidence) | Estado |
|-------|----------|-------------------|--------|
| 2026-09-16 | Crear `docs/troubleshooting.md` | Retos 3-6 dependen de setup complejo (W6); estudiantes necesitan guía de troubleshooting | ✅ Hecho |
| 2026-09-16 | Refactorizar `v-logging-siem-bcp/test.sh` | W4: inconsistente con estándar Fase 2 (25/26 unidades usan /shared/validators.sh) | ⏳ Pendiente |
| 2026-09-16 | Documentar RDD dual framework | Necesidad de parallel tracking profesor+estudiante | ✅ Hecho |

---

## RDD Integrity Checks

| Check | Result |
|-------|--------|
| Todos los receipts tienen lineage (predecessor/next)? | ✅ |
| Todos los receipts tienen evidence medible? | ✅ |
| Decisions derivan de evidence? | ✅ |
| Student receipts feed professor aggregate? | ✅ (100% CORE pass rate de estudiante → profesor dashboard) |
| Professor decisions improve student paths? | ✅ (troubleshooting doc, refactor pending) |
| No proxy coverage? | ✅ (evidencia específica por reto, no genérica) |
