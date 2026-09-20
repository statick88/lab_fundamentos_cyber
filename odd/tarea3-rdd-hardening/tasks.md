# ODD Task: tarea3-rdd-hardening

## Goal
Resolve and harden Tarea 3 RDD validation so canonical units generate progress only from real student deliverables, never setup scaffolds, ambient host state, or validator-created evidence.

## Scope
- `units/iii-iam-mfa`
- `units/iii-compliance-iso27001`
- `units/vii`
- Manifest/evaluator touchpoints only if required for canonical routing or receipt naming.

## Tasks
- [x] Explore Tarea 3 canonical structure and setup-only false receipt paths.
- [x] Harden IAM/MFA setup and validators (student-deliverable-only; canonical `unit-III` retained).
- [x] Harden compliance setup and validators.
- [ ] Harden hardening/unit VII validators for Tarea 3 scope.
- [ ] Run Docker setup-only verification for canonical Tarea 3 units and progress checks.
- [ ] Commit and push verified work units to `tareas`.

## Constraints
- Do not create student answers, PDFs, or progress receipts.
- Keep progress canonical at `/var/lab-state/progress`.
- Preserve user-requested branch `tareas`.
- Prefer explicit student deliverables under each lab directory.
- Setup may create reference fixtures/templates only; those files must not pass validators.

## Exploration Evidence
- Canonical evaluator names from `shared/units_manifest.sh`:
  - IAM/MFA: `unit-III` -> `units/iii-iam-mfa`
  - Compliance: `unit-III-compliance` -> `units/iii-compliance-iso27001`
  - Hardening: `unit-VII` -> `units/vii`
- `RDD_TAREA3.md` describes intended scope as 13 retos: IAM/MFA 5 + compliance 5 + VII retos 1, 2, 10.
- Manifest currently marks all three units as CORE, which counts 25 retos because CORE is unit-level, not reto-level.
- Known risks:
  - `iii-iam-mfa` has ambient-state validators and setup-created audit script can pass.
  - `iii-compliance-iso27001` validators are content-weak and can pass superficial edits.
  - `vii` validators rely heavily on ambient state, create their own evidence in retos 7/8, and do not inspect setup scripts.
  - Naming mismatch: compliance test `UNIT_NAME` differs from manifest name; legacy `iii` also uses `unit-III` and can collide with IAM receipts.

## IAM/MFA Hardening Evidence
- `units/iii-iam-mfa/setup.sh` creates only reference-only templates under `~/laboratorio/iam/referencias`; no validator target, student answer, or receipt is created.
- `units/iii-iam-mfa/test.sh` requires explicit deliverables under `~/laboratorio/iam` and rejects placeholders, ambient host state, and echo-only audit scripts.
- The manifest already identifies `iii-iam-mfa` as `unit-III`; `TOTAL_RETOS=5` and canonical evaluator routing remain unchanged.

## Compliance Hardening Evidence
- `iii-compliance-iso27001/setup.sh` creates only placeholder-bearing references under `~/laboratorio/governance/referencias`; it creates no validator target, student answer, result evidence, or receipt.
- `iii-compliance-iso27001/test.sh` retains `TOTAL_RETOS=5`, routes receipts through `unit-III-compliance`, and requires explicit student deliverables rather than setup scaffolds.
- The hardened checks require complete distinct risk records, substantive SoA controls, mandatory policy sections, explicit mapped matrix criteria, and a real student-written control checker with student-produced PASS/FAIL evidence.

## Verification
- [x] Compliance: `bash -n units/iii-compliance-iso27001/setup.sh units/iii-compliance-iso27001/test.sh` passed.
- [x] Compliance: `git diff --check -- units/iii-compliance-iso27001/setup.sh units/iii-compliance-iso27001/test.sh odd/tasks/tarea3-rdd-hardening.md odd/tarea3-rdd-hardening/tasks.md` passed.
- [x] Compliance Docker setup-only via `~/.current_unit=unit-III-compliance`: `0/5`, evaluator exit `5`, `/var/lab-state/progress` remained `0` bytes.
- [x] IAM/MFA: `bash -n units/iii-iam-mfa/setup.sh units/iii-iam-mfa/test.sh` passed.
- [x] IAM/MFA: `git diff --check -- units/iii-iam-mfa/setup.sh units/iii-iam-mfa/test.sh odd/tasks/tarea3-rdd-hardening.md odd/tarea3-rdd-hardening/tasks.md` passed.
- [x] IAM/MFA Docker setup-only via `~/.current_unit=unit-III`: `0/5`, evaluator exit `5`, `/var/lab-state/progress` remained `0` bytes.

## Commit Evidence
- IAM/MFA work-unit commit: `8a624ed` (`fix: require student deliverables for tarea 3 IAM receipts`)
- Compliance work-unit commit: Pending.
