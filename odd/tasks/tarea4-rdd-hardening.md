# ODD Task: tarea4-rdd-hardening

## Goal
Harden Tarea 4 / Unit IV cryptography and CVSS RDD flow so progress receipts are generated only from real student deliverables, not setup scaffolds, bundled answer tools, ambient state, or validator-created evidence.

## Tasks
- [x] Inspect `units/iv-criptografia-cvss/setup.sh` and `test.sh` for setup-only pass paths.
- [x] Harden validators so each reto requires an explicit student deliverable under `$HOME/laboratorio/ciberseguridad`.
- [x] Move analysis logs, phishing headers, fixture binary, and baseline into `$HOME/laboratorio/ciberseguridad/fixtures`.
- [x] Remove the bundled `cvss_calculator.py` setup path and validator-created `/tmp` evidence.
- [x] Run ephemeral Docker setup-only evaluation confirming 0/10 and empty progress.
- [x] Commit and push the verified work unit to `tareas` after checks pass.

## Constraints
- Do not create student answers, PDFs, or progress receipts.
- Keep progress canonical at `/var/lab-state/progress`.
- Preserve `UNIT_NAME="unit-IV"` and `TOTAL_RETOS=10` unless repository mapping requires otherwise.
- Work on branch `tareas` as requested by the user.

## Commit Evidence
- Work-unit commit: `98f67f1` (`fix: require student deliverables for unit IV RDD receipts`)

## Evidence
- `test.sh` now validates distinct student analysis files instead of setup-created files, a bundled calculator, or ambient logs.
- `setup.sh` creates only non-deliverable fixtures under `fixtures/`, including the phishing header fixture and a baseline derived from the fixture binary.
- `bash -n units/iv-criptografia-cvss/test.sh units/iv-criptografia-cvss/setup.sh` passed.
- `git diff --check -- units/iv-criptografia-cvss/test.sh units/iv-criptografia-cvss/setup.sh odd/tasks/tarea4-rdd-hardening.md odd/tarea4-rdd-hardening/tasks.md` passed.
- Ephemeral Docker setup-only evaluation through `/shared/evaluar-unidad.sh` with `~/.current_unit=unit-IV`: `0/10` passed, exit `10`, `/var/lab-state/progress` remained `0` bytes.
