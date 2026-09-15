# Tasks: Lab 3 — i-asset-classification (Clasificación de activos / CSF 2.0)

## Review Workload Forecast

| Field | Value |
|-------|-------|
| Estimated changed lines | ~350 |
| 400-line budget risk | Medium |
| Chained PRs recommended | No |
| Delivery strategy | ask-on-risk |
| Decision needed before apply | No |

Decision needed before apply: No
Chained PRs recommended: No
Chain strategy: pending
400-line budget risk: Medium

### Suggested Work Units

| Unit | Goal | Likely PR | Focused test command | Runtime harness | Rollback boundary |
|------|------|-----------|----------------------|-----------------|-------------------|
| 1 | Foundation + Core scripts | PR 1 | `bash units/i-asset-classification/test.sh` | Docker: `setup.sh` → `test.sh` | Remove `units/i-asset-classification/` |
| 2 | Integration wiring + E2E | PR 2 | `grep -q unit-I-asset shared/units_manifest.sh` | `source shared/*.sh; get_unit_index unit-I-asset` | Revert 5 shared script diffs |

## Phase 1: Foundation

- [x] 1.1 Create `units/i-asset-classification/` directory and `data/` subdirectory
- [x] 1.2 Create `units/i-asset-classification/data/asset_registry.csv` with header `name,type,classification,confidencialidad,integridad,disponibilidad` and 5 asset rows
- [x] 1.3 Create `units/i-asset-classification/data/csf_mapping.md` referencing ID.AM-01, ID.AM-05, and ID.AM-07
- [x] 1.4 Create `units/i-asset-classification/plantilla-clasificacion.md` Markdown worksheet with 5-asset table and CIA columns
- [x] 1.5 Create `units/i-asset-classification/setup.sh` that generates `$HOME/laboratorio/asset-classification/escenario.json` with 5 assets (A1–A5) across hardware/software/data/supplier-service types, each with classification and CIA 1–5 ratings

## Phase 2: Core Implementation

- [x] 2.1 Create `units/i-asset-classification/test.sh` sourcing `/shared/validators.sh` with 10 validators:
  - reto1: escenario.json exists and is valid JSON
  - reto2: plantilla-clasificacion.md exists
  - reto3: asset_registry.csv has 5 data rows
  - reto4: all classifications in {público,interno,confidencial,restringido}
  - reto5: all CIA ratings 1–5
  - reto6: csf_mapping.md contains ID.AM-01
  - reto7: csf_mapping.md contains ID.AM-05
  - reto8: csf_mapping.md contains ID.AM-07
  - reto9: escenario.json valid JSON with assets array
  - reto10: at least one asset classified "restringido" or "confidencial"
- [x] 2.2 Create `units/i-asset-classification/manual.sh` student guide covering CSF 2.0 asset classification, CIA triad, and ID.AM-01/05/07 concepts

## Phase 3: Integration Wiring

- [x] 3.1 Update `shared/units_manifest.sh`: append unit #21 (`unit-I-asset`, `i-asset-classification`, "Clasificación de Activos / CSF 2.0", 10 retos, M1) to `UNIT_NAMES`, `UNIT_DIRS`, `UNIT_TITLES`, `UNIT_ICONOS`, `UNIT_RETOS`, `UNIT_CORE`, `UNIT_MODULE` arrays; increment `UNIT_COUNT` to 21
- [x] 3.2 Update `shared/evaluar-unidad.sh`: add `i-asset)` case mapping to `UNIT_DIR="i-asset-classification"`
- [x] 3.3 Update `shared/retos-unidad.sh`: add `i-asset)` case mapping to `UNIT_DIR="i-asset-classification"`
- [x] 3.4 Update `shared/interactive.sh`: extend `get_unit_num_romano` case for `21)` to echo `XXI`
- [x] 3.5 Update `shared/common.sh`: append non-empty phrase to `FRASES_OCULTAS` array for unit 21

## Phase 4: Testing / Verification

- [x] 4.1 Run `setup.sh` and verify `$HOME/laboratorio/asset-classification/` contains escenario.json, data/asset_registry.csv, data/csf_mapping.md, plantilla-clasificacion.md
- [x] 4.2 Run `test.sh` and assert all 10 retos return PASS
- [x] 4.3 Verify wiring: `get_unit_index "unit-I-asset" == 21`, `get_unit_dir 21 == "i-asset-classification"`, `get_unit_num_romano 21 == "XXI"`, `get_frase_for_unit 21` non-empty
- [x] 4.4 E2E Docker validation: `setup.sh` → `test.sh` → `manual.sh` completes without errors
