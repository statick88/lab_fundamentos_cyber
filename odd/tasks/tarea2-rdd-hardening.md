# ODD Task: tarea2-rdd-hardening

## Goal
Harden Tarea 2 / Unit II firewall and network filtering RDD flow so progress receipts are generated only from explicit student deliverables, never setup scaffolds, ambient system state, or validator-created evidence.

## Tasks
- [x] Inspect `units/ii-firewalls-redes/setup.sh` and `test.sh` for setup-only pass paths.
- [x] Harden all ten validators to require student deliverables under `$HOME/laboratorio/redes`.
- [x] Move source captures to `$HOME/laboratorio/redes/fixtures` and remove executable firewall scaffolds.
- [x] Update manual helper text to name fixtures and required output files.
- [x] Run syntax and allowed-diff validation.
- [x] Run ephemeral Docker setup-only 0/10 evaluation and canonical progress check.

## Constraints
- Do not create student answers, PDFs, or progress receipts.
- Preserve `UNIT_NAME="unit-II"` and `TOTAL_RETOS=10`.
- Fixtures and templates must not satisfy validators.
- Validators must not depend on `/etc/services`, ambient UFW/iptables state, or evidence generated during validation.
- Work on branch `tareas` as requested by the user.

## Evidence
- Setup now creates only `fixtures/captura_{http,https,ssh,dns,scan}.pcapng` and a non-executable `fixtures/README.template`.
- Retos 1–4 and 10 require dedicated student analysis files; firewall retos require real, command-anchored UFW/iptables deliverables.
- Retos 5–9 no longer check ambient firewall state.
- `bash -n units/ii-firewalls-redes/test.sh units/ii-firewalls-redes/setup.sh` passed.
- `git diff --check -- units/ii-firewalls-redes/test.sh units/ii-firewalls-redes/setup.sh odd/tasks/tarea2-rdd-hardening.md odd/tarea2-rdd-hardening/tasks.md` passed.
- Ephemeral Docker setup-only evaluation through `/shared/evaluar-unidad.sh` with `~/.current_unit=unit-II`: `0/10` passed, exit `10`, `/var/lab-state/progress` remained `0` bytes.
