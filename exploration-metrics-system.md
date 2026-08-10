# Exploration: Comprehensive Metrics System for Lab-Linux

## Verdict: Approach 2 (Standalone Metrics Module)

Create `shared/metrics.sh` as an independent module that wraps validator execution with timing, records student ID/timestamps/attempts, and persists to `~/.lab_state/metrics/`. Integrates with `eval.sh` and `menu.sh` via optional hooks — no core logic changes.

## Current state

### Test validators (`units/*/test.sh`)

- Each unit has 10 `retoN()` functions (N=1..10)
- Validators return 0 (pass) or non-zero (fail)
- Source `/shared/common.sh` for utilities
- Define `challenge_names` array and `retoN_info()` functions for UI
- Define `validators` array for batch execution

### Evaluation orchestration (`shared/eval.sh`)

- `marcar_completado(unit, reto)` → writes `unit-X:reto:N` to `~/.lab_state/progress`
- `esta_completado(unit, reto)` → greps progress file
- `contar_completados(unit, total)` → counts completed retos
- `ejecutar_evaluacion(unit, total, validators[])` → runs all validators, marks completion
- `mostrar_estado_retos(unit, names[])` → displays pass/fail status

**Limitations:** No timing data, no timestamps, no student identification, no attempt counting.

### Metrics system (`metrics_test.sh` v2)

- Times each reto validator execution using `/proc/uptime` or `date +%s%N`
- Outputs CSV: `unit_num,unit_name,reto_num,reto_label,exec_time_ms,passed`
- Handles Docker-dependent units (skips if no `/var/run/docker.sock`)
- Runs validators in subshells for isolation
- Generates text summary with per-unit breakdowns

**Limitations:** No student identification, no persistence (writes to `/tmp/`), no real-time feedback.

### Student progress tracking

- File: `~/.lab_state/progress`
- Format: `unit-X:reto:N` (one line per completed reto)
- Persists via Docker volume mount (`lab-data:/home/estudiante/laboratorio`)

### Menu system (`entrypoint.sh` + `shared/menu.sh`)

1. `entrypoint.sh` loads `common.sh` → `menu.sh`
2. `mostrar_menu_principal()` shows 11 units with progress bars
3. `mostrar_menu_retos()` shows 10 retos per unit with ✔/✘ status
4. `jugar_reto()` provides interactive challenge mode:
   - Shows instructions (`retoN_info()`)
   - Interactive command execution
   - `verificar` triggers validator
   - Tracks attempts in memory (not persisted)

## Approaches

| Approach | Description | Effort | Pros | Cons |
|----------|-------------|--------|------|------|
| 1. Extend eval.sh | Add timing to `ejecutar_evaluacion()` | Low | Minimal new files, natural integration | Couples timing with evaluation, harder to run independently |
| 2. Standalone metrics.sh | New module wrapping validators with timing | Medium | Clean separation, independent or integrated use | New file to maintain |
| 3. Event-based system | Event emitter/subscriber architecture | High | Most flexible, easy to extend | Overkill, requires refactoring |

## Recommendation: Approach 2

**Rationale:**
1. Clean separation — metrics logic doesn't pollute evaluation logic
2. Three usage modes:
   - **Interactive:** `menu.sh` calls metrics on reto completion
   - **Batch:** `metrics_test.sh` uses metrics module for timing
   - **Standalone:** `metrics.sh` can be run directly for reports
3. Persistence is straightforward — write to `~/.lab_state/metrics/`
4. Real-time feedback is optional — toggled via flag

## Proposed architecture

```
shared/metrics.sh (NEW)
├── record_reto_event(student, unit, reto, status, duration_ms)
├── get_student_progress(student)
├── get_reto_history(student, unit, reto)
├── generate_csv_report(student?, output_path)
├── generate_text_report(student?, output_path)
├── generate_html_report(student?, output_path)
└── get_batch_summary(students[])

integration points:
├── eval.sh: call record_reto_event() after marcar_completado()
├── menu.sh: call record_reto_event() in jugar_reto() on verify
└── metrics_test.sh: use metrics.sh for timing + persistence
```

**Data storage:**
```
~/.lab_state/metrics/
├── {student_id}/
│   ├── events.jsonl          # Append-only event log
│   ├── unit-I.progress       # Per-unit completion (backward compatible)
│   └── unit-II.progress
└── reports/
    ├── {student_id}_report.csv
    ├── {student_id}_report.html
    └── batch_summary.csv
```

**Event format (JSONL):**
```json
{
  "timestamp": "2026-07-29T10:30:00Z",
  "student": "estudiante",
  "unit": "unit-I",
  "reto": 3,
  "event": "completed",
  "duration_ms": 1250,
  "attempt": 2,
  "metadata": {}
}
```

## Key design decisions

| Decision | Options | Recommendation |
|----------|---------|----------------|
| Student identification | Docker hostname / Prompt on first login / `$USER` | Prompt on first login, store in `~/.student_id` |
| Persistence location | Container-only / Host volume mount | Host volume mount `./metrics:/home/estudiante/.lab_state/metrics` |
| Docker-dependent challenges | Skip with标记 / Mock validators / Timeout with fallback | Timeout with fallback — 5s timeout, mark SKIP if unavailable |
| Real-time feedback | Always show / Show on `verificar` only / Batch mode only | Show on `verificar` only |
| Report generation | On-demand / Automatic after unit / Both | Both — text summary on unit completion, full reports on-demand |
| Backward compatibility | Replace progress file / Keep progress, add metrics | Keep progress file, metrics is additive |

## Risk assessment

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Breaking existing eval.sh flow | Medium | High | Add metrics as optional hook, don't modify core logic |
| Docker socket unavailability | High | Low | Graceful fallback with SKIP marking |
| Performance impact on interactive mode | Low | Medium | Metrics writing is async, non-blocking |
| Data loss on container restart | Medium | High | Volume mount for metrics directory |
| Multi-student conflicts | Low | Low | Per-student directories, unique IDs |
| JSONL file corruption | Low | Medium | Append-only with file locking |

## Ready for proposal

**Yes** — the exploration is complete. The orchestrator should:

1. Present the three approaches to the user with trade-offs
2. Ask for preferences on:
   - Student identification method
   - Persistence location (volume mount vs container-only)
   - Real-time feedback style
3. Proceed to design phase with chosen approach

**Summary for user:**
The lab has a solid foundation with 110 challenges across 11 units. The current metrics system captures timing but lacks student identification, persistence, and integration with the interactive flow. The recommended approach is to create a standalone `shared/metrics.sh` module that integrates with existing `eval.sh` and `menu.sh` without modifying their core logic. This provides flexible reporting (CSV, text, HTML) while maintaining backward compatibility.
