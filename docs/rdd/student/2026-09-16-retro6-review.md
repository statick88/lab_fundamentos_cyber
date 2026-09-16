# RDD Receipt — Estudiante (Revisión)

**Fecha**: 2026-09-16
**Unidad/Módulo**: Reto 6 — Correlacionar logs (M6 — Unidad V)
**Rol**: Estudiante (revisión dirigida)
**Tipo**: Receipt de REVISIÓN (debilidad identificada en receipt principal)

---

## 1. Receipt — Qué se identificó como débil

| Área débil | Evidence del receipt principal | Prioridad |
|------------|-------------------------------|-----------|
| Correlación de eventos SIEM | Reto 6: dominio 3.5/5.0, errores en cross-reference entre `auth_sys.log` + `mi_app.log` con timestamp 13:55:38 | **ALTA** |
| Timestamp normalization | Confusión sobre formatos de timestamp entre archivos de log | **MEDIA** |
| Multi-source analysis | Practicado solo con 2 archivos (auth_sys + mi_app); no con 3+ fuentes | **MEDIA** |

---

## 2. Evidence — Diagnóstico detallado

| Síntoma | Causa raíz | Ejercicios de refuerzo |
|---------|------------|------------------------|
| No encontró coincidencia 13:55:38 entre archivos | No normalizó timestamps antes de correlacionar | Ejercicio: convertir todos los timestamps al mismo formato antes de grep |
| grep sobre 2 archivos simultáneos sin estrategia | Falta de metodología: buscar primero en qué archivos existe cada evento | Ejercicio: listar primero qué archivo contiene cada patrón, luego correlacionar |
| No extendió el análisis a más fuentes | Comprensión limitada de "SIEM" como correlación multi-fuente | Ejercicio: añadir un tercer log (syslog, kern.log) y correlacionar 3 fuentes |

---

## 3. Decision — Plan de recuperación

- **Repasar AHORA**: Timestamp normalization (`date` command, `--date` flag, `awk` para extraer y reformatizar timestamps)
- **Practicar**: Correlación con metodología explícita:
  1. Identificar todas las fuentes de log disponibles (`ls *.log`)
  2. Para cada fuente, verificar qué eventos contiene (`grep -c "pattern" file`)
  3. Normalizar timestamps al mismo formato
  4. Buscar coincidencias entre fuentes normalizadas
- **Probar antes de avanzar**: Repetir Reto 6 con 3+ fuentes de log hasta lograr pass sin errores
- **NO avanzar a** Reto 7 hasta dominar Reto 6

---

## 4. Lineage

- Predecessor: `docs/rdd/student/2026-09-16-M6-logging-siem-bcp.md` (Receipt M6 principal)
- Current: Reto 6 review receipt (debilidad identificada)
- Next: Reto 6 re-attempt → luego Reto 7 (monitor_procesos.sh)
- Superseded: none
- RDD Framework: `docs/rdd-framework.md` v1.0
