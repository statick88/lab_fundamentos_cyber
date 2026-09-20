# ODD Task: interactive-menu-login

## Goal
Ensure students can enter the `lab_fundamentos_cyber` container with a login shell and run the interactive `menu` command without `sudo`, while preserving canonical progress at `/var/lab-state/progress`.

## Tasks
- [x] Make login shells load lab functions.
- [x] Document standard container entry.
- [x] Verify syntax and shell-loading contract.
- [x] Fix residual plain interactive shell doc reference.

## Constraints
- Keep `menu` as a student command executed without `sudo`.
- Preserve canonical progress file: `/var/lab-state/progress`.
- Do not weaken container hardening or `no-new-privileges`.
- Do not commit or push without explicit user request.

## Commit Evidence
- Pending: user did not authorize a commit.

## Evidence
- Added `bash_profile` and copied it into `/home/estudiante/.bash_profile` in `Dockerfile`.
- `entrypoint.sh` now regenerates `~/.bash_profile` so login shells source `~/.bashrc`, which then loads `~/.bash_aliases`.
- `docker-compose.yml` documents `bash -l` entry and sets direct container name to `lab_ciberseguridad`.
- `README.md`, `CONTRIBUTING.md`, and `GUIA_INCIDENCIAS_ESTUDIANTES.md` now use `docker compose exec lab_fundamentos_cyber bash -l` and warn to run `menu` without `sudo`.
- `SOLUCIONARIOS_MODULOS.md` now uses `docker exec -it <container> bash -l` for the interactive student entry.
- `bash -n bash_profile bashrc entrypoint.sh shared/*.sh` passed.
- `docker-compose config >/tmp/lab_fundamentos_compose_config.out` passed.
- `git diff --check` passed.
- Static contract check passed for `bash_profile`, `entrypoint.sh`, README entry command, and `lab_ciberseguridad` container name.
- Static top-level markdown scan passed: no residual plain interactive student `docker ... bash` entries without `-l`.
- `docker compose config` remains skipped because this host only exposes legacy `docker-compose` (`docker: unknown command: docker compose`).
