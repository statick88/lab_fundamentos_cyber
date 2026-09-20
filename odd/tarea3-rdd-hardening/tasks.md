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
- [x] Harden Unit VII's 15 validators to require explicit deliverables.
- [x] Run Docker setup-only verification for all canonical Tarea 3 units and progress checks.
- [ ] Commit and push verified work units to `tareas`.

## Constraints
- Do not create student answers, PDFs, or progress receipts.
- Keep progress canonical at `/var/lab-state/progress`.
- Preserve user-requested branch `tareas`.
- Prefer explicit student deliverables under each lab directory.
- Setup may create reference fixtures/templates only; those files must not pass validators.

## Unit VII Hardening Status
- `UNIT_NAME="unit-VII"` and `TOTAL_RETOS=15` remain unchanged.
- Setup creates only harmless reference inputs and placeholder-bearing `.template` files under `~/laboratorio/security/fixtures`; it creates no student deliverables, answer scripts, keys, or receipts.
- All 15 validators now check named student-owned files directly under `~/laboratorio/security`, never `/etc`, mounts, logs, sudo, SSH configuration, host services, or validator-created state.
- Retos 1, 2, and 10 require `uid0_audit.md`, `critical_files_permissions.md`, and `suid_remediation_plan.md` (with optional student `suid_remediation.sh`) respectively.
- The remaining retos require explicit process, sudo, port, SUID/SGID, SSH policy/permission, log, firewall, mount, sshd, auditd/AIDE, and summary deliverables.

## Prior Evidence
- Canonical evaluator names from `shared/units_manifest.sh`: IAM/MFA `unit-III`, compliance `unit-III-compliance`, hardening `unit-VII`.
- Manifest marks all three units as CORE; Unit VII setup-only must therefore yield `0/15`.
- IAM/MFA work-unit commit: `8a624ed` (`fix: require student deliverables for tarea 3 IAM receipts`).
- Compliance work-unit commit: `5547fca` (`fix: require student deliverables for tarea 3 compliance receipts`).

## Verification
- [x] Unit VII: `bash -n units/vii/setup.sh units/vii/test.sh` passed.
- [x] Unit VII: `git diff --check -- units/vii/setup.sh units/vii/test.sh odd/tasks/tarea3-rdd-hardening.md odd/tarea3-rdd-hardening/tasks.md` passed.
- [x] Unit VII Docker setup-only via `~/.current_unit=unit-VII`: `0/15`, evaluator exit `15`, `/var/lab-state/progress` remained `0` bytes.
