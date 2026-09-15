# Proposal: ii-arquitectura-perimetral (Lab 7)

## Intent

Implement Lab 7 (Módulo II) covering perimeter architecture, network segmentation, and DMZ design with defense-in-depth principles. This bridges asset classification (Lab 3) to firewall implementation (Lab 2) and IDS (Lab 3), providing the architectural foundation before students configure rules.

## Scope

### In Scope
- New unit: `units/ii-arquitectura-perimetral/` with `setup.sh`, `test.sh`, `manual.sh`
- 10 CORE retos (validators) using `/shared/validators.sh`
- Artifacts generated: `topology.json`, `placement-matrix.csv`, `zone-rules/` directory, `defense-in-depth.md`
- Integration into `units_manifest.sh` as unit #22 (`UNIT_NAME: unit-II-perimetral`)
- Module M2 (Módulo II: Redes y Perímetro)

### Out of Scope
- Actual firewall rule implementation (covered in `ii-firewalls-redes`)
- Suricata rule writing (covered in `ii-ids-intrusion-detection`)
- Real network interface manipulation (Docker-compatible simulation only)

## Capabilities

### New Capabilities
- `ii-arquitectura-perimetral` — perimeter architecture design, zone definition, DMZ placement, defense-in-depth documentation

### Modified Capabilities
- `units-manifest` — add unit #22 entry to `shared/units_manifest.sh`

## Approach

Follow Lab 3 (`i-asset-classification`) pattern exactly. Generate simulated artifacts under `$HOME/laboratorio/perimetral/`. Validate via file content checks (`jq`, `awk`, `grep`). No sudo/root required.

## Affected Areas

| Area | Impact | Description |
|------|--------|-------------|
| `units/ii-arquitectura-perimetral/` | New | 3 scripts + data templates (setup.sh, test.sh, manual.sh) |
| `shared/units_manifest.sh` | Modified | Add unit #22 entry |
| `shared/evaluar-unidad.sh` | Modified | Add case for `unit-II-perimetral` |
| `shared/retos-unidad.sh` | Modified | Add case for `unit-II-perimetral` |
| `shared/interactive.sh` | Modified | Extend `get_unit_num_romano` for 22/XXII |
| `shared/common.sh` | Modified | Add `FRASES_OCULTAS` entry for unit 22 |

## Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| New unit type (architecture vs implementation) | Medium | Pattern is proven (Lab 3); validators check artifacts only |
| Roman numeral extension beyond XXI | Low | Simple case-statement extension |
| Docker compatibility | Low | No root/sudo required; file-based simulation |

## Rollback

Remove `units/ii-arquitectura-perimetral/` directory. Revert 5 shared script changes (units_manifest.sh, evaluar-unidad.sh, retos-unidad.sh, interactive.sh, common.sh).

## Dependencies

- Lab 3 (`i-asset-classification`) assets reused
- Lab 2 (`ii-firewalls-redes`) implements designed rules

## Success Criteria

- [ ] All 10 retos PASS in Docker
- [ ] CI pipeline GREEN
- [ ] Unit registered and selectable in interactive menu
