# RDD Receipt — Profesor

**Fecha**: 2026-09-16
**Unidad/Módulo**: M6 — Logging, SIEM y BCP (Unidad V: `v-logging-siem-bcp`)
**Rol**: Profesor (didáctica)

---

## 1. Receipt — Qué se enseñó

| Retos asignados | Método | Duración | Material |
|-----------------|--------|----------|----------|
| Reto 1: Generar log con `logger` | Demo + práctica | 20 min | `logger -p local0.info`, grep syslog |
| Reto 2: Configurar logrotate | Demo + configuración | 25 min | `/etc/logrotate.d/mi_app` |
| Reto 3: Analizar logs con `grep` | Guided practice | 30 min | `mi_app.log` generado por setup |
| Reto 4: Extraer campos con `awk` | Guided practice | 25 min | `apache_access.log` |
| Reto 5: Transformar logs con `sed` | Guided practice | 20 min | Reuso `apache_access.log` |
| Reto 6: Correlacionar logs | Guided practice | 30 min | `auth_sys.log` + `mi_app.log` |
| Reto 7: Script monitoreo procesos | Coding exercise | 30 min | `monitor_procesos.sh` |
| Reto 8: Backup 3-2-1 | Coding exercise | 25 min | `backup_script.sh` |
| Reto 9: Calcular RTO/RPO | Individual doc | 20 min | `rto_rpo.md` |
| Reto 10: Playbook IR | Individual doc | 25 min | `playbook_ir.md` |

**Total**: 10 retos CORE | ~250 min de instrucción | M6-LOG (15% ponderación SETEC)

---

## 2. Evidence — Resultados observables

| Métrica | Valor | Evidencia |
|---------|-------|-----------|
| Tasa aprobación CORE (10/10) | **10/10 (100%)** | `RDD_TAREA5.md`: 10/10 retos con RDD OK |
| Reto más error-prone | Reto 6 (correlación) | Requiere cross-reference entre 2 archivos de log con timestamp específico |
| Reto más complejo (subjetivo) | Reto 10 (playbook IR) | Documentación subjetiva, sin validador automático (W5) |
| Tiempo promedio estimado | ~250 min total | Calculado de distribución de retos |
| Sección 3 (30 pts humanos) | Pendiente evaluación | Argumentación crítica sobre estrategia de monitorización vs. respuesta a incidentes |
| Validadores inline (W3/W4) | 10 retos con validación inline | `v-logging-siem-bcp/test.sh` — patrón legacy, no usa `assert_*` helpers |
| Alineación rúbrica | M6-LOG = 5 criterios × 2 pts = 10 pts | `RUBRICA_EVALUACION_SETEC.md` |

---

## 3. Decision — Ajuste derivado

- **Para siguiente módulo (M7)**: Refactorizar `v-logging-siem-bcp/test.sh` para usar `/shared/validators.sh` — inconsistencia con el estándar establecido en Fase 2 para las otras 25 unidades (W4 en RDD). DECISIÓN PENDIENTE.
- **Para material**: Crear `docs/troubleshooting.md` ✅ COMPLETADO — cubre Docker, validadores, evaluación, Git, permisos.
- **Para ritmo**: Los retos 3-6 comparten `eval_log_analysis()` helper — asegurar que estudiantes dominen la generación de logs base antes de esta unidad (prerrequisito: retos 1-2 de logging básico).
- **Para documentación**: Actualizar `docs/validators-standard.md`, `README.md`, `CONTRIBUTING.md`, y 26 manuales con enlaces CI/quickstart/troubleshooting ✅ COMPLETADO.

---

## 4. Lineage

- Predecessor: RDD receipt Tarea 4 (M4 — Criptografía y CVSS)
- Current: M6 — Logging, SIEM y BCP (esta recepción)
- Next: M7 — próximo módulo pendiente de asignación
- Superseded: none
- RDD Framework: `docs/rdd-framework.md` v1.0
