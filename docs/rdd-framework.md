# RDD Dual Framework — Fundamentos de Ciberseguridad ABC-CYB-101

**Autor**: Rol dual (Profesor + Estudiante en paralelo)
**Fecha**: 2026-09-16
**Versión**: 1.0
**Curso**: ABC-CYB-101 — Abacom / SETEC / ISO/IEC 17024

---

## 1. Concepto

RDD (Receipt-Driven Development) aplicado al curso se ejecuta en dos roles **simultáneos** que se alimentan mutuamente:

| Rol | Propósito | Gating | Frecuencia |
|-----|-----------|--------|------------|
| **Profesor** | Receipt-Driven Teaching — ajustar didáctica basada en evidencia del grupo | Receipt (qué se enseñó) → Evidence (resultados) → Decision (qué ajustar) | Por sesión/unidad |
| **Estudiante** | Receipt-Driven Learning — ajustar estudio basado en evidencia personal | Receipt (qué se practicó) → Evidence (dominio) → Decision (qué repasar) | Por reto/sesión |

**Alineación**: Los receipts del estudiante se agregan para informar los receipts del profesor. Las decisiones del profesor generan mejores rutas de aprendizaje para el estudiante. Ciclo continuo.

---

## 2. Estructura del Curso (contexto para los receipts)

| Nivel | Conteo |
|-------|--------|
| Módulos (M1–M6) | 6 |
| Competencias SETC | 6 (M1-OPS, M2-ANA, M3-GIT, M4-DOC, M5-WAR, M6-LOG) |
| Unidades | 26 |
| Retos | 243 total (60 CORE + 183 OPT) |
| Retos CORE por módulo | M1:10, M2:10, M3:15, M4:10, M5:15, M6:10 |
| Criterios evaluación | 5.0–1.0 escala, por rubrica |
| Rúbrica SETEC | 5 criterios × 2 pts = 10 pts máx (M6), por módulo |

---

## 3. Professor RDD Receipt Template

```markdown
# RDD Receipt — Profesor
**Fecha**: YYYY-MM-DD
**Unidad/Módulo**: [nombre]
**Rol**: Profesor (didáctica)

## 1. Receipt — Qué se enseñó
| Retos asignados | Método de enseñanza | Duración | Material usado |
|-----------------|---------------------|----------|----------------|
| [lista]         | [demo/practice/qc]  | [min]    | [docs/slides]  |

## 2. Evidence — Resultados observables
| Métrica | Valor | Evidencia |
|---------|-------|-----------|
| Tasa de aprobación CORE | X/Y (Z%) | [test results / rubric scores] |
| Reto con más errores | [nombre] | [error pattern] |
| Tiempo promedio | [min] | [submission timestamps] |
| Rubric score promedio | X/5.0 | [rubric per student] |
| Gap identificado | [gap description] | [specific evidence] |

## 3. Decision — Ajuste derivado
- **Para siguiente sesión**: [specific action]
- **Para material**: [content update if needed]
- **Para ritmo**: [pace adjustment]

## 4. Lineage
- Predecessor: [previous receipt ID]
- Next: [next receipt ID]
- Superseded: [if applicable]
```

---

## 4. Student RDD Receipt Template

```markdown
# RDD Receipt — Estudiante
**Fecha**: YYYY-MM-DD
**Unidad/Módulo**: [nombre]
**Rol**: Estudiante (aprendizaje)

## 1. Receipt — Qué se practicó
| Retos completados | Tiempo total | Retos pendientes |
|-------------------|--------------|------------------|
| [lista]           | [min]        | [lista]          |

## 2. Evidence — Evidencia de dominio
| Métrica | Valor | Evidencia |
|---------|-------|-----------|
| CORE pass rate | X/Y (Z%) | [challenge results] |
| Dominio concept | [concept]: [1-5.0] | [self-assessment / rubric] |
| Errores recurrentes | [error]: [count] | [attempt history] |
| Complejidad sentida | [easy/medium/hard] | [reflexión] |

## 3. Decision — Prioridad siguiente
- **Repasar**: [concept/reto a revisar]
- **Avanzar a**: [siguiente módulo/reto]
- **Profundizar en**: [tema que requiere más práctica]

## 4. Lineage
- Predecessor: [previous receipt ID]
- Next: [next receipt ID]
- Superseded: [if applicable]
```

---

## 5. Parallel Flow — How Both Roles Interact

```
┌─────────────────────────────────────────────────────────────┐
│                    PARALELO RDD                              │
│                                                             │
│  PROFESOR                                      ESTUDIANTE   │
│  ┌─────────────┐                           ┌─────────────┐  │
│  │ Receipt     │                           │ Receipt     │  │
│  │ (sesión)    │                           │ (reto)      │  │
│  └──────┬──────┘                           └──────┬──────┘  │
│         │                                        │          │
│         ▼                                        ▼          │
│  ┌─────────────┐    agregación     ┌─────────────┐        │
│  │ Evidence    │◄─────────────────│ Evidence    │        │
│  │ (grupo)     │   (aggregate)    │ (persona)   │        │
│  └──────┬──────┘                   └──────┬──────┘        │
│         │                                │                │
│         ▼                                ▼                │
│  ┌─────────────┐                   ┌─────────────┐        │
│  │ Decision    │                   │ Decision    │        │
│  │ (ajuste     │──────────────────►│ (prioridad  │        │
│  │  didáctico) │   ruta mejorada   │  del estud.)│        │
│  └─────────────┘                   └─────────────┘        │
│                                                             │
│  ◄─── retroalimentación continua ───►                       │
└─────────────────────────────────────────────────────────────┘
```

---

## 6. Mapping to Course Structure

### Professor RDD por Módulo

| Módulo | Receipt Focus | Key Evidence Metrics |
|--------|---------------|---------------------|
| M1 — Terminal/Permisos | FHS navigation, permissions muscle memory | Time-to-solve, error rate on chmod/find |
| M2 — Redes/Firewalls | Protocol identification, firewall config | Packet analysis accuracy, UFW rule success |
| M3 — Git/Hardening | Version control discipline, user management | Branch hygiene, sudo usage patterns |
| M4 — Docker/Crypto | Container isolation, CVSS calculation | Dockerfile hardening score, CVSS accuracy |
| M5 — Wargames/Threats | Vulnerability analysis, ethical analysis | Bandit completion, log pattern detection |
| M6 — Logging/IR | Log analysis, incident response quality | Log correlation accuracy, playbook completeness |

### Student RDD por Unidad

| Unidad | Receipt Focus | Key Decision Trigger |
|--------|---------------|---------------------|
| u1–u10 | Core mastery per unit | CORE pass rate < 80% → repaso |
| u11–u26 | OPT exploration depth | OPT completion → avanzar |
| Any | Rubric threshold | Score < 3.0 → remediation path |

---

## 7. RDD Lifecycle Rules

1. **Receipt antes de Evidence**: No se puede decidir sin primero registrar qué se hizo
2. **Evidence es medible**: Cada entry debe tener una métrica o artefacto verificable
3. **Decision deriva de Evidence**: La decisión debe justificarse con la evidence, no con intuición
4. **Lineage obligatorio**: Cada receipt referencia al anterior y siguiente (cadena ininterrumpida)
5. **Parallel sync**: Cada receipt del profesor incorpora al menos 1 métrica agregada de receipts de estudiantes
6. **No proxy**: Un receipt genérico ("terminé el módulo") no cuenta; debe haber evidence específica

---

## 8. File Conventions

| Artefacto | Ubicación | Propósito |
|-----------|-----------|-----------|
| Framework | `docs/rdd-framework.md` | Este documento |
| Professor receipts | `docs/rdd/professor/YYYY-MM-DD-unit.md` | Receipts docentes |
| Student receipts | `docs/rdd/student/YYYY-MM-DD-unit.md` | Receipts de aprendizaje |
| Aggregate dashboard | `docs/rdd/dashboard.md` | Métricas agregadas para profesor |
| Reto results | `units/*/results/` | Evidencia de ejecución (resultados de retos) |
