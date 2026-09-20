# ODD Task: tarea3-rdd-hardening

## Goal
Resolve and harden Tarea 3 RDD validation so canonical units generate progress only from real student deliverables, never setup scaffolds, ambient host state, or validator-created evidence.

## Scope
- `units/iii-iam-mfa`
- `units/iii-compliance-iso27001`
- `units/vii`

## Tasks
- [x] Explore Tarea 3 canonical structure and setup-only false receipt paths.
- [x] Harden IAM/MFA setup and validators.
- [x] Harden compliance setup and validators.
- [x] Harden Unit VII's 15 validators to require explicit deliverables.
- [x] Run Docker setup-only verification for all canonical Tarea 3 units and progress checks.
- [x] Commit and push verified work units to `tareas`.

## Constraints
- Do not create student answers, PDFs, or progress receipts.
- Keep progress canonical at `/var/lab-state/progress`.
- Preserve user-requested branch `tareas`.
- Setup may create reference fixtures/templates only; those files must not pass validators.

## Canonical Structure
- IAM/MFA: `~/.current_unit=unit-III` -> `units/iii-iam-mfa`, `TOTAL_RETOS=5`.
- Compliance: `~/.current_unit=unit-III-compliance` -> `units/iii-compliance-iso27001`, `TOTAL_RETOS=5`.
- Hardening: `~/.current_unit=unit-VII` -> `units/vii`, `TOTAL_RETOS=15`.
- `RDD_TAREA3.md` describes intended academic scope as 13 retos (IAM 5 + compliance 5 + VII retos 1, 2, 10), while the manifest marks whole units as CORE, so Unit VII must be setup-only clean for all 15 retos.

## Hardening Evidence
- IAM/MFA setup now creates only reference templates under `~/laboratorio/iam/referencias`; validators require explicit deliverables under `~/laboratorio/iam` and avoid ambient `/etc`, users/groups, sudo/PAM, and echo-only audits.
- Compliance setup now creates only placeholder references under `~/laboratorio/governance/referencias`; validators require complete risk register, SoA, policy, matrix, control-check script, and student-produced results.
- Unit VII setup now creates harmless fixtures/templates only under `~/laboratorio/security/fixtures`; all 15 validators require named student deliverables and avoid host `/etc`, mounts, logs, sudo, SSH config, generated keys, or validator-created chmod/mkdir evidence.

## Verification
- [x] IAM/MFA: `bash -n units/iii-iam-mfa/setup.sh units/iii-iam-mfa/test.sh` passed.
- [x] IAM/MFA: `git diff --check -- units/iii-iam-mfa/setup.sh units/iii-iam-mfa/test.sh odd/tasks/tarea3-rdd-hardening.md odd/tarea3-rdd-hardening/tasks.md` passed.
- [x] IAM/MFA Docker setup-only via `unit-III`: `0/5`, evaluator exit `5`, progress `0` bytes.
- [x] Compliance: `bash -n units/iii-compliance-iso27001/setup.sh units/iii-compliance-iso27001/test.sh` passed.
- [x] Compliance: `git diff --check -- units/iii-compliance-iso27001/setup.sh units/iii-compliance-iso27001/test.sh odd/tasks/tarea3-rdd-hardening.md odd/tarea3-rdd-hardening/tasks.md` passed.
- [x] Compliance Docker setup-only via `unit-III-compliance`: `0/5`, evaluator exit `5`, progress `0` bytes.
- [x] Unit VII: `bash -n units/vii/setup.sh units/vii/test.sh` passed.
- [x] Unit VII: `git diff --check -- units/vii/setup.sh units/vii/test.sh odd/tasks/tarea3-rdd-hardening.md odd/tarea3-rdd-hardening/tasks.md` passed.
- [x] Unit VII Docker setup-only via `unit-VII`: `0/15`, evaluator exit `15`, progress `0` bytes.

## Commit Evidence
- IAM/MFA work-unit commit: `8a624ed` (`fix: require student deliverables for tarea 3 IAM receipts`).
- IAM/MFA evidence commit: `bd3a6a4` (`chore: record ODD evidence for tarea 3 IAM`).
- Compliance work-unit commit: `5547fca` (`fix: require student deliverables for tarea 3 compliance receipts`).
- Compliance evidence commit: `4ac54ad` (`chore: record ODD evidence for tarea 3 compliance`).
- Unit VII work-unit commit: `0183b3a` (`fix: require student deliverables for tarea 3 hardening receipts`).
- Final evidence normalization commit: `d38f295` (`chore: record ODD evidence for tarea 3 hardening`).
