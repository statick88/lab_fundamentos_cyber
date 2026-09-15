# Design: III — Remediation Labs (Validators, Gamification, Manuals)

## Technical Approach

Three additive capabilities applied across existing `test.sh` and `manual.sh` files:

1. **Validators upgrade** — Replace bare `[ -f ]`, `[ -d ]`, `grep -q` with `assert_*` calls from `shared/validators.sh`. Add `source` block. Retos that check system state (not student artifacts) keep bare conditionals with inline `# no-assert:` comment per spec scenario.
2. **Gamification** — Add `retoN_info()` functions, `challenge_names=()`, `ICONOS=()` arrays. Units that already have these (i, ii-firewalls-redes, v-logging-siem-bcp, vii, viii, x, xi) keep them unchanged.
3. **Manuals restructure** — Add learning objectives, progressive difficulty ordering, verifiable deliverables, and manual-test alignment to 3 checkpoint manuals.

**Constraint**: All changes are additive. Never remove existing passing validators. `assert_file_contains` uses plain `grep -q` (no `-E`) — alternation `\|` is not supported.

## Architecture Decisions

### Decision: Which retos get `assert_*` vs bare conditionals

**Choice**: Retos checking student-created artifacts → `assert_*`. Retos checking system state (e.g., `[ -d /etc ]`, `mount | grep`, `id -u root`) → bare conditionals with `# no-assert:` comment.
**Alternatives considered**: Force `assert_*` everywhere; add new assert functions for system checks.
**Rationale**: Adding assert functions for non-file checks would expand the shared library scope. Bare conditionals with comments satisfy the spec's escape clause.

### Decision: Sourcing pattern

**Choice**: Dual-path `if [ -f "/shared/common.sh" ]` block already present in all files. Add `source /shared/validators.sh` inside the existing `if` block; add `source "$(dirname "$0")/../../shared/validators.sh"` in the `else` block.
**Alternatives considered**: Separate sourcing function; always-relative path.
**Rationale**: Follows gold standard pattern exactly. Minimal diff.

### Decision: Gamification scope — skip units that already have it

**Choice**: Only add `retoN_info()`, `challenge_names`, `ICONOS` to units that lack them. Units i, ii-firewalls-redes, v-logging-siem-bcp, vii, viii, x, xi already have all three — skip gamification for these.
**Alternatives considered**: Rebuild gamification for all units for consistency.
**Rationale**: Existing gamification is functional. Rebuilding adds risk with no benefit.

## Data Flow

```
test.sh execution
  ├── source shared/validators.sh (assert_* functions available)
  ├── retoN() calls assert_file_exists / assert_file_contains / assert_command_ok
  │     └── returns 0 (PASS) or 1 (FAIL) with diagnostic message
  ├── retoN_info() displays challenge metadata (gamification)
  └── standalone block iterates validators[] + challenge_names[] + ICONOS[]
```

## File Changes

### Validators upgrade (7 test.sh files)

| File | Action | Changes |
|------|--------|---------|
| `units/i/test.sh` | Modify | Add `source validators.sh` block. Retos 1-4, 7-10: add `assert_file_exists`/`assert_command_ok` where applicable. Reto 5: add `assert_file_exists` + `assert_command_ok test -x`. Reto 6: keep bare `return 0` (concept check). |
| `units/ii-firewalls-redes/test.sh` | Modify | Add `source validators.sh` block. Retos 1,3,4: add `assert_file_contains`. Retos 5-9: add `assert_file_exists` + `assert_command_ok test -x`. Reto 10: add `assert_file_contains`. |
| `units/ii-ids-intrusion-detection/test.sh` | Modify | Add `source validators.sh` block. Replace bare `[ -f ]`/`grep -q` with `assert_file_exists`/`assert_file_contains` in each reto. |
| `units/iv-criptografia-cvss/test.sh` | Modify | Add `source validators.sh` block. Add `assert_file_exists`/`assert_file_contains` to retos that create files. Keep `eval_cvss` helper for CVSS calculation retos. |
| `units/ix/test.sh` | Modify | Add `source validators.sh` block. Replace `assert_file_contains` patterns using `\|` alternation with separate `assert_file_contains` calls per pattern (plain grep doesn't support `\|`). |
| `units/iv/test.sh` | Modify | Add `source validators.sh` block. Add `assert_file_exists`/`assert_command_ok` to retos that create scripts. |
| `units/v-logging-siem-bcp/test.sh` | Modify | Already sources validators. No validator changes needed. |

### Gamification addition (4 test.sh files that lack it)

| File | Action | Changes |
|------|--------|---------|
| `units/ii-ids-intrusion-detection/test.sh` | Modify | Add `challenge_names=()`, `ICONOS=()`, and `retoN_info()` functions for each reto. |
| `units/iv-criptografia-cvss/test.sh` | Modify | Add `challenge_names=()`, `ICONOS=()`, and `retoN_info()` functions for each reto. |
| `units/iv/test.sh` | Modify | Add `challenge_names=()`, `ICONOS=()`, and `retoN_info()` functions for each reto. |
| `units/v-logging-siem-bcp/test.sh` | Modify | Add `challenge_names=()`, `ICONOS=()`, and `retoN_info()` functions for each reto (already has gamification — verify and skip if present). |

### Manual restructure (3 manual.sh files)

| File | Action | Changes |
|------|--------|---------|
| `units/checkpoint-ii/manual.sh` | Modify | Add learning objectives section (3-5 items with action verbs). Reorder retos by progressive difficulty. Add deliverable paths per reto. Add manual-test alignment table. |
| `units/checkpoint-iv/manual.sh` | Modify | Same structure: objectives, progressive retos, deliverables, alignment. |
| `units/checkpoint-v/manual.sh` | Modify | Same structure: objectives, progressive retos, deliverables, alignment. |

## Interfaces / Contracts

### Sourcing block pattern (all test.sh files)

```bash
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
    source /shared/validators.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
    source "$(dirname "$0")/../../shared/validators.sh"
fi
```

### Assert usage pattern (per reto)

```bash
retoN() {
    local file="$LAB_DIR/expected_file.ext"
    assert_file_exists "$file"
    assert_file_contains "$file" "expected_pattern"
    assert_command_ok some_command --args
}
```

### Gamification arrays pattern

```bash
validators=(reto1 reto2 ... retoN)
challenge_names=("Name 1" "Name 2" ... "Name N")
ICONOS=("📋" "📑" ... "✅")

retoN_info() {
    separador
    echo -e "${CYAN}Reto N: Name N${NC}"
    echo ""
    echo "Description..."
    echo ""
    echo "Comandos útiles:"
    echo "  example_command"
    separador
}
```

### Manual structure pattern

```markdown
## Objetivos de Aprendizaje
1. [verb] [specific outcome]
2. ...

## Reto 1: [Name] — [difficulty level]
**Descripción**: ...
**Entregable**: `~/laboratorio/checkpoints/checkpoint-XX/file.ext`
**Verificación**: `bash test.sh` (reto 1)

## Reto N: ...
```

## Testing Strategy

| Layer | What to Test | Approach |
|-------|-------------|----------|
| Unit | Each modified reto still returns 0 | Run `bash test.sh` standalone in container; all retos should PASS |
| Integration | Sourcing works in both paths | Test with `/shared` present and with relative path fallback |
| Regression | No existing passing reto breaks | Run full test.sh before and after; diff pass/fail counts |
| Gamification | Info functions display correctly | Run `source test.sh && reto1_info` for each new info function |
| Manuals | Deliverable paths match test.sh validators | Cross-reference manual deliverable paths against `assert_*` file paths |

## Threat Matrix

N/A — no routing, shell, subprocess, VCS/PR automation, executable-file classification, or process-integration boundary.

## Migration / Rollout

No migration required. All changes are additive. Apply in this order:
1. Validators upgrade (7 files) — most critical, fixes spec violations
2. Gamification (4 files) — enhances student experience
3. Manuals restructure (3 files) — improves clarity

Each file change is independently testable. No database migrations, feature flags, or phased rollout needed.

## Open Questions

None — all specs are clear, gold standard is established, and constraints are defined.
