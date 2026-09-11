# Proposal: iii-remediacion-labs

## Intent

Close remaining post-remediation gaps across ABC-CYB-101's 25 units: superficial/missing validators in 7 test.sh files, missing gamification elements in 11 units, and unstructured manuals in 3 checkpoint units. Target: 25/25 units at 4/4 PASS (gold standard: `iii-compliance-iso27001/`).

## Scope

### In Scope
- Add real validators (`assert_file_exists`, `assert_file_contains`, `assert_command_ok`) to 7 units' test.sh
- Add `retoN_info()`, `ICONOS[]`, `challenge_names[]` to 11 units missing gamification
- Improve structured manuals (objetivos, retos progresivos, entregables verificables) for 3 checkpoint units

### Out of Scope
- Dual-path sourcing (Fase 2 complete, 75/75 files)
- Units already at 4/4 PASS (5 units confirmed)
- Setup.sh rewrites (Fase 1 complete)

## Capabilities

### New Capabilities
None — all units exist; this is quality remediation.

### Modified Capabilities
- `lab-validators` — upgrade 7 units' test.sh from superficial checks to `assert_*` validators
- `lab-gamification` — add reto_info/ICONOS/challenge_names to 11 units
- `lab-manuals` — restructure 3 checkpoint manuals with objectives and progressive challenges

## Approach

Use `iii-compliance-iso27001/test.sh` as the gold standard pattern. For each unit:
1. Read existing test.sh, identify gaps vs gold standard
2. Add `assert_*` validators that check concrete artifacts (files, content, commands)
3. Add `ICONOS[]`, `challenge_names[]`, `retoN_info()` functions
4. For checkpoints: restructure manual.sh with objetivos, retos progresivos, entregables

## Affected Areas

| Area | Impact | Description |
|------|--------|-------------|
| `units/i/test.sh` | Modified | Add `assert_*` validators (currently 0) |
| `units/ii-firewalls-redes/test.sh` | Modified | Add `assert_*` validators (currently 0) |
| `units/ii-ids-intrusion-detection/test.sh` | Modified | Add `assert_*` validators (currently 0) |
| `units/iv-criptografia-cvss/test.sh` | Modified | Add `assert_*` validators (currently 0) |
| `units/iv/test.sh` | Modified | Add `assert_*` validators (currently 0) |
| `units/v-logging-siem-bcp/test.sh` | Modified | Add `assert_*` validators (currently 0) |
| `units/viii/test.sh` | Modified | Add `assert_*` validators (currently 0) |
| `units/{i,vii,viii,ix,x,xi}/test.sh` | Modified | Add gamification arrays + info functions |
| `units/checkpoint-{ii,iv,v}/test.sh` | Modified | Add gamification + restructure manual |
| `units/i-asset-classification/test.sh` | Modified | Add gamification elements |
| `units/i-risk-assessment/test.sh` | Modified | Add gamification elements |

## Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| Breaking existing passing validators | Low | Additive only — append `assert_*` calls, never remove |
| Checkpoint manual restructure breaks narrative | Medium | Preserve existing content, add structure around it |
| Gamification arrays conflict with evaluar-unidad.sh | Low | Pattern proven in 14 existing units |

## Rollback Plan

All changes are in individual unit directories. Revert per-unit with `git checkout HEAD~1 -- units/<name>/`. No shared scripts affected.

## Dependencies

- Gold standard reference: `iii-compliance-iso27001/`
- `shared/validators.sh` (assert_* functions already defined)
- `shared/common.sh` (separador, CYAN color codes)

## Success Criteria

- [ ] All 25/25 units pass `verificar_laboratorios.sh`
- [ ] 7 units' test.sh contain ≥1 `assert_*` call per reto (vs 0 before)
- [ ] 11 units have `ICONOS[]`, `challenge_names[]`, `retoN_info()` functions
- [ ] 3 checkpoint units have structured manuals with objetivos + entregables
- [ ] Gold standard parity: all units match `iii-compliance-iso27001/` structural pattern
