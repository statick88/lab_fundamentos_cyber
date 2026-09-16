# RDD Receipt — Estudiante

**Fecha**: 2026-09-16
**Unidad/Módulo**: M6 — Logging, SIEM y BCP (Unidad V: `v-logging-siem-bcp`)
**Rol**: Estudiante (aprendizaje)

---

## 1. Receipt — Qué se practicó

| Retos completados | Tiempo total | Retos pendientes |
|-------------------|--------------|------------------|
| Reto 1: `logger` + grep syslog | ~15 min | — |
| Reto 2: Configurar logrotate | ~20 min | — |
| Reto 3: `grep` sobre mi_app.log | ~25 min | — |
| Reto 4: `awk` campos apache_access.log | ~20 min | — |
| Reto 5: `sed` enmascarar IPs | ~15 min | — |
| Reto 6: Correlacionar logs (timestamp 13:55:38) | ~25 min | — |
| Reto 7: Script `monitor_procesos.sh` | ~25 min | — |
| Reto 8: Backup 3-2-1 (`backup_script.sh`) | ~20 min | — |
| Reto 9: RTO/RPO (`rto_rpo.md`) | ~20 min | — |
| Reto 10: Playbook IR (`playbook_ir.md`) | ~25 min | — |

**Total**: 10/10 retos CORE completados | ~210 min estimado | Módulo M6 completado

---

## 2. Evidence — Evidencia de dominio

| Métrica | Valor | Evidencia |
|---------|-------|-----------|
| CORE pass rate | **10/10 (100%)** | Validación: `RDD_TAREA5.md` — 10/10 RDD OK |
| Dominio: Logging básico | 4.0/5.0 | `logger` funciona, logrotate configurado, grep/awk/sed sobre logs |
| Dominio: SIEM/correlación | 3.5/5.0 | Reto 6 requiere comprensión de timestamps y cross-reference — necesita práctica adicional |
| Dominio: BCP/IR | 3.0/5.0 | Retos 9-10 son documentales — calidad depende de argumentación (evaluación humana, 30 pts Sección 3) |
| Dominio: Automatización | 3.5/5.0 | Scripts funcionales pero simples — monitor_procesos y backup son básicos |
| Errores recurrentes | No críticos | Todos los retos validados con exit 0 |
| Complejidad percibida | Media-Alta | Reto 6 (correlación) y Reto 10 (playbook) fueron los más desafiantes |

---

## 3. Decision — Prioridad siguiente

- **Repasar**: Correlación de eventos SIEM — practicar con diferentes archivos de log y timestamps. Reto 6 es la base para detección de intrusiones.
- **Avanzar a**: Módulo M7 — al completar M6 al 100% CORE. Verificar prerrequisitos si aplica.
- **Profundizar en**: Respuesta a incidentes — releer playbook, practicar con escenarios reales de IR. Sección 3 de evaluación (30 pts) requiere argumentación sólida sobre estrategia monitorización vs. respuesta.
- **Validadores**: Los retos 1-2 y 9-10 usan validación inline (no `assert_*`) — entender que es por diseño, no un error de curso.

---

## 4. Lineage

- Predecessor: RDD receipt Tarea 4 (M4 — Criptografía y CVSS)
- Current: M6 — Logging, SIEM y BCP (esta recepción)
- Next: M7 — próximo módulo pendiente
- Superseded: none
- RDD Framework: `docs/rdd-framework.md` v1.0
