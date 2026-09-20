# ODD Task: tarea5-rdd-hardening

## Goal
Harden Tarea 5 / Unit V RDD flow so logging, SIEM, BCP, backup, and IR receipts are generated only from real student deliverables, not setup scaffolds or validator-created evidence.

## Tasks
- [x] Harden `units/v-logging-siem-bcp/test.sh` so setup-only does not pass CORE retos.
- [x] Adjust `units/v-logging-siem-bcp/setup.sh` to provide fixtures/templates without satisfying validators.
- [x] Fix legacy `shared/evaluar-unidad.sh` so `unit-V` resolves through the manifest instead of legacy `units/v`.
- [x] Run focused Docker verification for setup-only failure and canonical progress behavior.
- [x] Document evidence and blockers.

## Constraints
- Do not create student answers.
- Do not fabricate RDD receipts.
- Do not commit or push without explicit user request.
- Keep progress canonical at `/var/lab-state/progress`.

## Commit Evidence
- Work-unit commit: `32f7825` (`fix: require student deliverables for unit V RDD receipts`)

## Evidence
- `bash -n shared/evaluar-unidad.sh units/v-logging-siem-bcp/test.sh units/v-logging-siem-bcp/setup.sh` passed.
- `git diff --check` passed.
- Ephemeral Docker evaluation through corrected `/shared/evaluar-unidad.sh` with `~/.current_unit=unit-V` after setup-only: `0/10` passed, exit `10`, and `/var/lab-state/progress` remained `0` bytes.
- Earlier direct validator evaluation also produced `0/10` after setup-only.
- No student deliverables, receipts, commits, or pushes were created.
