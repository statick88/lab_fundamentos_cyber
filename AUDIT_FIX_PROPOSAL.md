# Proposal: Fix Critical Audit Findings

## Intent

9 verified critical bugs across 12 files break lab validation (tests that always pass), block student setups (missing functions, syntax errors), and deliver wrong content (Unit X content in Unit XI). These findings came from a systematic audit of all 25 lab units and directly affect student experience and course correctness.

## Scope

### In Scope
- Fix H1: Rewrite `units/iii-compliance-iso27001/test.sh`, `units/iii-iam-mfa/test.sh`, `units/v/test.sh` to validate setup-created artifacts instead of creating-then-validating
- Fix H2: Add dual-path resolution (`/shared/validators.sh` + relative) in `units/iii/`, `units/ii/`, `units/vi/`, `units/ix/`, `units/x/`, `units/xi/` test.sh files
- Fix H4: Correct heredoc syntax in `units/x/manual.sh` (lines 81-96 misplaced)
- Fix H5: Correct `TOTAL_RETOS` in `units/x/test.sh` (15→10)
- Fix H6: Replace `units/xi/evaluacion.md` with correct Backup & Recovery content
- Fix H7: Reorder container operations in `units/viii/test.sh` reto9 (logs before delete)
- Fix H8: Replace `stat -c "%a"` with cross-platform alternative in `units/iv/test.sh`
- Fix H10: Define `eval_log_analysis` function or fix call in `units/v-logging-siem-bcp/test.sh`

### Out of Scope
- H3 was verified as FALSE POSITIVE — no action needed
- Structural refactor of shared/ directory architecture
- New unit creation or content redesign
- Test framework migration

## Approach

**Phase 1 — Test Integrity (H1):** Rewrite 3 test files to validate artifacts that `setup.sh` creates. Each test must check file existence, content correctness, and permission state without creating the files itself.

**Phase 2 — Portability (H2, H8):** Add dual-path validator resolution to 6 test files. Replace GNU `stat` with `ls -la` + `awk` parsing for macOS compatibility.

**Phase 3 — Syntax & Config (H4, H5):** Fix heredoc boundary in `units/x/manual.sh`. Correct retos count in `units/x/test.sh`.

**Phase 4 — Content & Logic (H6, H7, H10):** Replace wrong evaluation content. Reorder Docker operations. Fix undefined function reference.

## Affected Areas

| Area | Impact | Description |
|------|--------|-------------|
| `units/iii-compliance-iso27001/test.sh` | Modified | H1 — rewrite validators |
| `units/iii-iam-mfa/test.sh` | Modified | H1 — rewrite validators |
| `units/v/test.sh` | Modified | H1 — add real validators |
| `units/x/manual.sh` | Modified | H4 — fix heredoc |
| `units/x/test.sh` | Modified | H5 — fix retos count |
| `units/xi/evaluacion.md` | Modified | H6 — replace content |
| `units/viii/test.sh` | Modified | H7 — reorder operations |
| `units/iv/test.sh` | Modified | H8 — cross-platform stat |
| `units/v-logging-siem-bcp/test.sh` | Modified | H10 — define function |
| 6 test.sh files (H2) | Modified | Add dual-path resolution |

## Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| H1 rewrite breaks hidden dependencies | Medium | Run `test.sh` after each unit fix; diff old vs new validator logic |
| H2 dual-path masks actual failures | Low | Log which path resolved; fail clearly if neither exists |
| H6 content replacement misses course alignment | Low | Cross-reference with `ESPECIFICACION_CIBERSEGURIDAD.md` |
| H8 cross-platform change introduces regressions | Low | Test on both Linux and macOS |

## Rollback Plan

All changes are file-level edits within individual unit directories. Revert via `git checkout HEAD~1 -- units/<unit>/` for any affected unit. No shared infrastructure changes, so rollback is unit-scoped with zero blast radius.

## Dependencies

- `shared/validators.sh` must remain stable (not modified in this change)
- No new dependencies introduced

## Success Criteria

- [ ] H1: All 3 rewritten test files FAIL when setup.sh artifacts are absent
- [ ] H2: All 6 test files resolve validators on both `/shared/` and relative paths
- [ ] H4: `units/x/manual.sh` passes `bash -n` syntax check
- [ ] H5: `units/x/test.sh` TOTAL_RETOS matches setup.sh reto count (10)
- [ ] H6: `units/xi/evaluacion.md` contains Backup & Recovery questions
- [ ] H7: `units/viii/test.sh` reto9 reads logs before container deletion
- [ ] H8: `units/iv/test.sh` runs on macOS without error
- [ ] H10: `units/v-logging-siem-bcp/test.sh` executes without "command not found"
