# Tasks: Lab 7 — ii-arquitectura-perimetral (Arquitectura Perimetral, Segmentación y DMZ)

## Review Workload Forecast

| Field | Value |
|-------|-------|
| Estimated changed lines | ~450–500 |
| 400-line budget risk | Medium-High |
| Chained PRs recommended | No (single unit, atomic) |
| Delivery strategy | ask-on-risk |
| Decision needed before apply | No |

Decision needed before apply: No
Chained PRs recommended: No
Chain strategy: pending
400-line budget risk: Medium-High

### Suggested Work Units

| Unit | Goal | Likely PR | Focused test command | Runtime harness | Rollback boundary |
|------|------|-----------|----------------------|-----------------|-------------------|
| 1 | Full unit + integration wiring | Single PR | `bash units/ii-arquitectura-perimetral/test.sh` | Docker: `setup.sh` → `test.sh` → `manual.sh` | Remove `units/ii-arquitectura-perimetral/` + revert 5 shared script diffs |

## Phase 1: Foundation / Infrastructure

- [ ] 1.1 Create `units/ii-arquitectura-perimetral/` directory with `data/` subdirectory
- [ ] 1.2 Create `units/ii-arquitectura-perimetral/data/perimetral-reference.md` — zone concepts (WAN/DMZ/LAN/Mgmt), DMZ best practices, defense-in-depth layers reference
- [ ] 1.3 Create `units/ii-arquitectura-perimetral/data/firewall-methodology.md` — rule-writing guide (default-deny, allowlisting, egress filtering, proxy chokepoint)
- [ ] 1.4 Create `units/ii-arquitectura-perimetral/data/networking-cheat-sheet.md` — CIDR notation, zone naming, CIDR/gateway/interface layout reference
- [ ] 1.5 Create `units/ii-arquitectura-perimetral/setup.sh` — generates under `$HOME/laboratorio/perimetral/`: `topology.json` (4 zones: WAN/DMZ/LAN/Mgmt, each with CIDR/gateway/interface), `placement-matrix.csv` (A1–A5 zone mapping with `asset_id`+`zone` columns), `zone-rules/` (wan-dmz.sh, dmz-lan.sh, mgmt.sh, dns-proxy.sh), `defense-in-depth.md` (≥3 layers), `diagram.txt` (ASCII zones/flows/trust boundaries)

## Phase 2: Core Implementation

- [ ] 2.1 Create `units/ii-arquitectura-perimetral/test.sh` with 10 validators (sourcing `/shared/validators.sh`):
  - reto1: topology.json valid JSON with 4 zones, each having CIDR, gateway, interface
  - reto2: placement-matrix.csv has A1–A5 each mapped to a zone (columns: asset_id, zone)
  - reto3: A2 (web), DNS, mail relay in DMZ; A1 (database) in LAN
  - reto4: zone-rules/wan-dmz.sh contains default-deny + HTTP, HTTPS, DNS allow rules
  - reto5: zone-rules/dmz-lan.sh allows only explicit app-to-DB port allowlist (no wildcard/unlisted)
  - reto6: zone-rules/mgmt.sh restricts SSH to bastion/jump-host source only
  - reto7: egress filtering — A1 (database) has no direct Internet path (no LAN→WAN egress for A1)
  - reto8: zone-rules/dns-proxy.sh places DNS resolution in DMZ + LAN egress through forward proxy
  - reto9: defense-in-depth.md documents ≥3 distinct protective layers
  - reto10: diagram.txt contains zones, flows, and trust boundaries
- [ ] 2.2 Create `units/ii-arquitectura-perimetral/manual.sh` — student guide covering perimeter architecture, DMZ segmentation, firewall rule methodology, defense-in-depth layers, and 10-reto exercise walkthrough
- [ ] 2.3 Create `units/ii-arquitectura-perimetral/data/asset-placement-guide.md` — A1–A5 asset-to-zone mapping reference (which asset belongs where and why)

## Phase 3: Integration Wiring (5 shared scripts)

- [ ] 3.1 Update `shared/units_manifest.sh` — append unit #22: `UNIT_NAMES` += `unit-II-perimetral`, `UNIT_DIRS` += `ii-arquitectura-perimetral`, `UNIT_TITLES` += `Arquitectura Perimetral, Segmentación y DMZ`, `UNIT_ICONOS` += `🔒`, `UNIT_RETOS` += `10`, `UNIT_CORE` += `1`, `UNIT_MODULE` += `2`, increment `UNIT_COUNT` to 22
- [ ] 3.2 Update `shared/evaluar-unidad.sh` — add case `unit-II-perimetral) UNIT_DIR="ii-arquitectura-perimetral" ;;` and `XXII) IDX=22 ;;` in Roman numeral mapping
- [ ] 3.3 Update `shared/retros-unidad.sh` — add case `unit-II-perimetral) UNIT_DIR="ii-arquitectura-perimetral" ;;`
- [ ] 3.4 Update `shared/interactive.sh` — extend `get_unit_num_romano` case: `22) echo "XXII" ;;`
- [ ] 3.5 Update `shared/common.sh` — append `FRASES_OCULTAS` entry for unit 22 (e.g., `"Perímetro"`)

## Phase 4: Testing / Verification

- [ ] 4.1 Run `setup.sh` and verify `$HOME/laboratorio/perimetral/` contains topology.json, placement-matrix.csv, zone-rules/{wan-dmz.sh,dmz-lan.sh,mgmt.sh,dns-proxy.sh}, defense-in-depth.md, diagram.txt
- [ ] 4.2 Run `test.sh` and assert all 10 retos return PASS (0/10 fail)
- [ ] 4.3 Verify wiring: `get_unit_index "unit-II-perimetral" == 22`, `get_unit_dir 22 == "ii-arquitectura-perimetral"`, `get_unit_num_romano 22 == "XXII"`, `get_frase_for_unit 22` non-empty, boundary safety (`get_unit_dir 23` returns empty)
- [ ] 4.4 E2E Docker validation: `setup.sh` → `test.sh` → `manual.sh` completes without errors inside the container
