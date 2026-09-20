# ODD Task: tarea1-rdd-hardening

## Goal
Harden Tarea 1 RDD validation for risk assessment and asset classification so setup-only scaffolds do not create progress receipts.

## Scope
- `units/i-risk-assessment`
- `units/i-asset-classification`

## Tasks
- [x] Inspect setup-only pass paths in both Unit I extension validators.
- [x] Harden risk assessment validators/setup so student deliverables are required.
- [x] Harden asset classification validators/setup so student deliverables are required.
- [x] Run Docker setup-only verification for both units and canonical progress checks.
- [x] Commit and push the verified work unit to `tareas` after checks pass.

## Constraints
- Do not create student answers, PDFs, or progress receipts.
- Keep progress canonical at `/var/lab-state/progress`.
- Preserve each unit's `UNIT_NAME` and `TOTAL_RETOS=10`.
- Work on branch `tareas` as requested by the user.

## Commit Evidence
- Work-unit commit: `4a1dabc` (`fix: require student deliverables for tarea 1 RDD receipts`)

## Evidence
- `units/i-risk-assessment/setup.sh` now creates only `fixtures/escenario.json` and `plantilla-analisis.template.md`; validators require explicit student files such as `scenario_summary.md`, `risk_inventory.md`, `risk_matrix.md`, `treatment_plan.md`, `residual_risk.md`, `economic_justification.md`, and `seguimiento.md`/`followup_plan.md`.
- `units/i-asset-classification/setup.sh` now creates only `fixtures/escenario.json`, `fixtures/asset_registry.csv`, `fixtures/csf_mapping.md`, and `plantilla-clasificacion.template.md`; validators require explicit student files such as `scenario_summary.md`, `asset_inventory.*`, `cia_ratings.md`, `csf_mapping_student.md`, `asset_classification.md`, `asset_prioritization.md`, `asset_controls.md`, and `final_report.md`/`resumen_final.md`.
- `bash -n units/i-risk-assessment/test.sh units/i-risk-assessment/setup.sh units/i-asset-classification/test.sh units/i-asset-classification/setup.sh` passed.
- `git diff --check -- units/i-risk-assessment/test.sh units/i-risk-assessment/setup.sh units/i-asset-classification/test.sh units/i-asset-classification/setup.sh odd/tasks/tarea1-rdd-hardening.md odd/tarea1-rdd-hardening/tasks.md` passed.
- Ephemeral Docker setup-only evaluation through `/shared/evaluar-unidad.sh` with `~/.current_unit=unit-I-risk`: `0/10` passed, exit `10`, `/var/lab-state/progress` remained `0` bytes.
- Ephemeral Docker setup-only evaluation through `/shared/evaluar-unidad.sh` with `~/.current_unit=unit-I-asset`: `0/10` passed, exit `10`, `/var/lab-state/progress` remained `0` bytes.
