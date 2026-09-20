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
- [ ] Harden compliance setup and validators.
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
- `units/iii-iam-mfa/setup.sh` now creates reference-only templates under `~/laboratorio/iam/referencias`; it no longer creates validator target files, scripts, student answers, or progress receipts.
- `units/iii-iam-mfa/test.sh` validates only explicit student deliverables under `~/laboratorio/iam`, rejects placeholders, and avoids ambient account, `/etc`, PAM, sudoers, and validator-generated evidence.
- `TOTAL_RETOS=5` and `UNIT_NAME="unit-III"` are retained. The manifest canonical name for `iii-iam-mfa` is already `unit-III`, so no routing/name change was needed for receipt consistency.

## Verification
- [x] IAM/MFA: `bash -n units/iii-iam-mfa/setup.sh units/iii-iam-mfa/test.sh` passed.
- [x] IAM/MFA: `git diff --check -- units/iii-iam-mfa/setup.sh units/iii-iam-mfa/test.sh odd/tasks/tarea3-rdd-hardening.md odd/tarea3-rdd-hardening/tasks.md` passed.
- [x] IAM/MFA Docker setup-only via `~/.current_unit=unit-III`: `0/5`, evaluator exit `5`, `/var/lab-state/progress` remained `0` bytes.

## Commit Evidence
- Pending.
