# ODD Task: tarea1-rdd-infra

## Goal
Fix Tarea 1 RDD infrastructure so progress receipts are canonical, persistent, and generated only through real validators, while preserving student authorship.

## Tasks
- [x] Make `/var/lab-state/progress` the canonical progress file and expose `~/.lab-state/progress` compatibly.
- [x] Persist `/var/lab-state` through Docker Compose and align container naming without breaking existing service access.
- [x] Fix menu rendering error caused by missing `count_core_retos`.
- [x] Harden Tarea 1 validators so setup-generated templates do not pass as student work.
- [x] Add/adjust verification scripts or focused checks for RDD behavior.

## Constraints
- Do not auto-mark retos from `menu`.
- Do not generate student PDF content or complete student answers.
- Keep technical artifacts in English unless existing project Spanish text requires preserving Spanish UI copy.
- No commits without explicit user request.

## Commit Evidence
- Work-unit commit: `95eb78d` (`fix: harden tarea 1 RDD progress infrastructure`)

## Evidence
- `bash -n entrypoint.sh shared/eval.sh shared/units_manifest.sh shared/menu.sh units/i-risk-assessment/test.sh units/i-asset-classification/test.sh` passed.
- `docker-compose config` renders `STATE_DIR=/var/lab-state`, `PROGRESS_FILE=/var/lab-state/progress`, and named volume `lab-state:/var/lab-state`.
- `git diff --check` passed.
- Ephemeral Docker validator test with setup-generated files only:
  - `i-risk-assessment`: `3/10 passed, 7 failed`, exit `1`.
  - `i-asset-classification`: `5/10 passed, 5 failed`, exit `1`.
  - `/tmp/lab-state/progress` remained `0` bytes.
  - `$HOME/.lab-state/progress` symlinked to `/tmp/lab-state/progress`.
- Menu helper check in ephemeral Docker:
  - `count_core_retos 1` => `10`
  - `count_core_retos 2` => `10`
  - `count_core_retos 999` => `0`

## Commit Evidence
- Not committed: user constraint says no commits without explicit request.
