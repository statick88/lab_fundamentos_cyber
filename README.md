# RDD Dual — Fundamentos de Ciberseguridad ABC-CYB-101

**Rama**: `tareas` · **Cambio**: `tarea-5` · **Fase**: 5 (Documentación/Limpieza)
**Rol dual**: Profesor (didáctica) + Estudiante (aprendizaje) en paralelo

---

## Las 5 tareas

| # | Tarea | Estado | Artefacto |
|---|-------|--------|-----------|
| 1 | Commit RDD framework artifacts | ✅ | `docs/rdd-framework.md`, `docs/rdd/professor/`, `docs/rdd/student/`, `docs/rdd/dashboard.md` |
| 2 | Student review receipt — Reto 6 (SIEM correlation) | ✅ | `docs/rdd/student/2026-09-16-retro6-review.md` |
| 3 | Dashboard update | ✅ | `docs/rdd/dashboard.md` |
| 4 | Lineage chain verification | ✅ | Todos los receipts referencian predecessor/current/next |
| 5 | Next-step scheduling | ✅ | Reto 6 re-attempt → M7 (pendiente asignación) |

---

## ¿Qué es el RDD dual?

RDD (Receipt-Driven Development) aplicado al curso en dos roles simultáneos que se alimentan mutuamente:

| Rol | Ciclo | Frecuencia |
|-----|-------|------------|
| **Profesor** | Receipt → Evidence → Decision (ajuste didáctico) | Por sesión/unidad |
| **Estudiante** | Receipt → Evidence → Decision (prioridad de estudio) | Por reto/sesión |

Los receipts del estudiante se agregan para informar los del profesor. Las decisiones del profesor generan mejores rutas para el estudiante. Ciclo continuo.

---

## Artefactos RDD

```
docs/rdd/
├── framework.md                          # Diseño del marco dual (templates, reglas, mapping)
├── dashboard.md                          # Métricas agregadas, decisiones log, integridad checks
├── professor/
│   └── 2026-09-16-M6-logging-siem-bcp.md # Receipt didáctico M6
└── student/
    ├── 2026-09-16-M6-logging-siem-bcp.md # Receipt de aprendizaje M6
    └── 2026-09-16-retro6-review.md       # Receipt de revisión Reto 6 (debilidad identificada)
```

---

## Receipt M6 — Resumen

### Profesor
| Métrica | Valor |
|---------|-------|
| Retos enseñados | 10 CORE (v-logging-siem-bcp) |
| Duración | ~250 min |
| Tasa aprobación | 10/10 (100%) |
| Decisión pendiente | Refactorizar test.sh para usar /shared/validators.sh (W4) |

### Estudiante
| Métrica | Valor |
|---------|-------|
| Retos completados | 10/10 CORE |
| Dominio SIEM (Reto 6) | **3.5/5.0** — revisión activa |
| Dominio BCP/IR (Retos 9-10) | 3.0/5.0 — evaluación humana pendiente |
| Bloqueo | NO avanzar a Reto 7 hasta dominar Reto 6 |

---

## Fase 5 — Documentación y Limpieza

### 5.1 Links de documentación ✅
30 archivos actualizados con enlaces a CI, quickstart, API y troubleshooting:
- `docs/troubleshooting.md` — Creado (217 líneas)
- `docs/validators-standard.md` — Actualizado
- `units/*/manual.sh` (26 archivos) — Actualizado
- `CONTRIBUTING.md` — Actualizado
- `README.md` — Actualizado

### 5.2 Verificación de fallbacks ✅
| Check | Resultado |
|-------|-----------|
| Bare sudo | 0 |
| Código fallback temporal | Ninguno |
| `bash verify.sh` | 14 PASS / 2 FAIL (esperados: /var/lab-state solo en container) |
| Inline validadores v-logging-siem-bcp | Intentionales (assertions de desafío) |

---

## Línea de receipts

```
RDD Tarea 4 (M4) → Receipt M6 → Receipt Reto 6 review → Reto 6 re-attempt → Reto 7 → M7
```

## Enlaces clave

| Recurso | Descripción |
|---------|-------------|
| [RDD Framework](docs/rdd-framework.md) | Diseño del marco dual |
| [Dashboard](docs/rdd/dashboard.md) | Métricas agregadas |
| [Profesor M6](docs/rdd/professor/2026-09-16-M6-logging-siem-bcp.md) | Receipt didáctico |
| [Estudiante M6](docs/rdd/student/2026-09-16-M6-logging-siem-bcp.md) | Receipt de aprendizaje |
| [Revisión Reto 6](docs/rdd/student/2026-09-16-retro6-review.md) | Receipt de revisión |
| [CI Pipeline](.github/workflows/ci.yml) | 26 unidades · 9 CORE fail-fast |
| [Validadores](docs/validators-standard.md) | Contrato `assert_*` |
| [Troubleshooting](docs/troubleshooting.md) | Solución de problemas |
