# Design: i-asset-classification (Lab 3 — CSF 2.0 Asset Classification)

## Technical Approach

Create a new unit `i-asset-classification` following the canonical Lab 2 (`i-risk-assessment`) pattern: a setup script generating scenario artifacts under `$HOME/laboratorio/asset-classification/`, a test script with 10 validators sourced from `/shared/validators.sh`, and a manual script for student guidance. Integrate unit #21 (XXI) into all shared wiring scripts.

## Architecture Decisions

| Decision | Choice | Alternatives | Rationale |
|---|---|---|---|
| Asset registry format | CSV | JSON, YAML | CSV editable in spreadsheet apps; `jq -r` extraction still works |
| Classification scale | 1–5 CIA + 4-tier label (público/interno/confidencial/restringido) | 3-tier (high/medium/low) only | CSF 2.0 ID.AM-05 requires prioritization by classification; 4-tier + CIA gives richer exercise |
| Roman numeral for 21 | `XXI` | Dynamic calculation | Minimal change; `get_unit_num_romano` is a simple case statement — extend to 21 |
| Validator pattern | Mirror Lab 2 exactly | Custom validators | Lab 2 is validated (10/10 PASS); reuse `assert_file_exists`, `assert_file_contains` helpers |
| CSF subcategories covered | ID.AM-01, ID.AM-05, ID.AM-07 | All 8 ID.AM subcategories | Pedagogical scope: Lab 3 is Módulo I (intro); deeper mapping deferred to later labs |

## Data Flow

```
setup.sh
    │
    ├──→ $HOME/laboratorio/asset-classification/
    │       ├── escenario.json           (5 assets, CIA ratings, types)
    │       ├── data/asset_registry.csv  (5 rows × 6 cols)
    │       ├── data/csf_mapping.md      (ID.AM-01, 05, 07 references)
    │       └── plantilla-clasificacion.md (worksheet template)
    │
test.sh ──→ sources /shared/validators.sh
    │
    ├──→ reto1: scenario JSON valid + jq available
    ├──→ reto2: plantilla-clasificacion.md exists
    ├──→ reto3: CSV has 5 data rows
    ├──→ reto4: all classifications in {público,interno,confidencial,restringido}
    ├──→ reto5: all CIA ratings 1–5
    ├──→ reto6: csf_mapping.md contains ID.AM-01
    ├──→ reto7: csf_mapping.md contains ID.AM-05
    ├──→ reto8: csf_mapping.md contains ID.AM-07
    ├──→ reto9: escenario.json valid JSON with assets array
    └──→ reto10: at least one asset classified "restringido" or "confidencial"
```

## File Changes

| File | Action | Description |
|---|---|---|
| `units/i-asset-classification/setup.sh` | Create | Generates scenario, CSV, template, CSF mapping |
| `units/i-asset-classification/test.sh` | Create | 10 validators (reto1–reto10) + info functions |
| `units/i-asset-classification/manual.sh` | Create | Student guide with CSF 2.0 concepts |
| `units/i-asset-classification/data/asset_registry.csv` | Create | Embedded in setup.sh (heredoc) |
| `units/i-asset-classification/data/csf_mapping.md` | Create | Embedded in setup.sh (heredoc) |
| `units/i-asset-classification/plantilla-clasificacion.md` | Create | Embedded in setup.sh (heredoc) |
| `shared/units_manifest.sh` | Modify | Add unit #21 entry: `unit-I-asset` → `i-asset-classification`, title, 10 retos, M1 |
| `shared/evaluar-unidad.sh` | Modify | Add case `unit-I-asset` → `UNIT_DIR=i-asset-classification` |
| `shared/retos-unidad.sh` | Modify | Add case `unit-I-asset` → `UNIT_DIR=i-asset-classification` |
| `shared/interactive.sh` | Modify | Extend `get_unit_num_romano` case for 21 → `XXI` |
| `shared/common.sh` | Modify | Add 21st entry to `FRASES_OCULTAS` array |

## Interfaces / Contracts

**Unit Directory Contract** (matches Lab 2):
- Input: `setup.sh` executed by student
- Output: `$HOME/laboratorio/asset-classification/` with 4 artifacts
- Test: `test.sh` run by student → 10 retos PASS/FAIL

**Shared Wiring Contract**:
- `units_manifest.sh`: `get_unit_index "unit-I-asset" == 21`, `get_unit_dir 21 == "i-asset-classification"`
- `evaluar-unidad.sh` / `retos-unidad.sh`: `unit-I-asset` → `UNIT_DIR="i-asset-classification"`
- `interactive.sh`: `get_unit_num_romano 21 == "XXI"`
- `common.sh`: `FRASES_OCULTAS[20]` (0-indexed) exists and non-empty

## Testing Strategy

| Layer | What to Test | Approach |
|---|---|---|
| Unit (validators) | Each reto function returns 0 on valid setup | Run `test.sh` in Docker after `setup.sh`; assert 10/10 PASS |
| Integration (wiring) | Shared scripts resolve unit #21 correctly | Source each shared script; call resolution functions; assert outputs |
| E2E (student flow) | Complete student workflow | `setup.sh` → verify artifacts → `test.sh` → all PASS |

## Threat Matrix

N/A — no routing, shell subprocess, VCS/PR automation, executable-file classification, or process-integration boundary. All changes are file creation and case-statement extensions in bash scripts.

## Migration / Rollout

No migration required. New unit is additive; existing units unchanged. Shared wiring extensions are backward-compatible (new cases only).

## Open Questions

- [ ] Verify ID.AM-06 content from NIST CSF 2.0 PDF before finalizing CSF mapping (currently ID.AM-06 not captured in exploration)
- [ ] Confirm `FRASES_OCULTAS` phrase for unit 21 — use "Clasificación es la base de la seguridad" or similar
- [ ] Should `asset_registry.csv` be in `data/` subdirectory or root? Lab 2 puts everything in root; keeping CSV in `data/` for organization but test.sh must reference `$HOME/laboratorio/asset-classification/data/asset_registry.csv`

---

**Summary**
- **Approach**: Clone Lab 2 pattern with CSF 2.0 asset classification content; wire unit #21 into shared scripts
- **Key Decisions**: 5 (format, scale, numeral, validators, scope)
- **Files Affected**: 7 new, 5 modified
- **Testing**: Unit validators + wiring resolution + E2E student flow
- **Next Step**: sdd-tasks to break into implementation tasks