---
type: gentle-ai.sdd-apply-progress/v1
schemaVersion: 1
changeName: abc-cyb-101-ebook-completion
project: lab_fundamentos_cyber
status: completed
completedAt: "2026-09-03T05:06:00Z"
phases:
  phase_1:
    status: completed
    workUnit: Foundation
    scope: "M2 rewrite, M3 update, index TOC"
    commits: [dedefc1, 26e8801, a9c62e0, 33dcd4a, cb563e9]
    budgetExceeded: true
  phase_2:
    status: completed
    workUnit: Core modules
    scope: "M4, M5, M6 new files"
    commits: [8c64417, a771c62, f9aab6d, f8d89d8]
  phase_2_5:
    status: completed
    workUnit: Dual-mode support
    scope: "Docker vs native callouts in index.qmd, M1, M2, M4, M5, M6"
---
# Apply Progress: ABC-CYB-101 Ebook Completion + Dual-Mode Support

## Phase 1: Foundation (COMPLETED)
- M2 rewritten: `modulo-02-kali-linux.qmd` → `modulo-02-reconocimiento-redes.qmd` (430 lines)
- M3 updated: `main/develop/fix/*` branch strategy + Conventional Commits
- `index.qxd` updated: TOC to 6 modules + Ubuntu reality-check callout
- Commits on `feature/cyb-01-labs`: dedefc1, 26e8801, a9c62e0, 33dcd4a, cb563e9
- Budget exceeded: 1979 lines (single-PR strategy, maintainer-approved size-exception)

## Phase 2: Core Modules (COMPLETED)
- M4 created: `modulo-04-docker-contenedores.qmd` (563 lines)
- M5 created: `modulo-05-wargames.qmd` (421 lines)
- M6 created: `modulo-06-logging-siem-bcp.qmd` (510 lines)
- Commits on main: 8c64417, a771c62, f9aab6d, f8d89d8

## Phase 2.5: Dual-Mode Support (COMPLETED)
- `index.qxd`: Added "Modo de ejecución: Docker o nativo" section with comparison table
- `modulo-01`: Added `{.note}` callout for native sudo/NOPASSWD differences
- `modulo-02`: Added `{.note}` callout for apt-get install + interface name differences
- `modulo-04`: Added `{.note}` callout for native Docker CLI alternative + limitations
- `modulo-05`: Added `{.note}` callout for native openssh-client/john prerequisites
- `modulo-06`: Added `{.note}` callout for native tcpdump permissions + logrotate install
- Changed lines: ~180 (documentation-only, within 400-line budget)

## Verification
- All 6 modules render with `quarto render --to html` (no errors)
- All tool references validated against Dockerfile lines 21-57
- Dual-mode callouts verified present in all 6 modules + index
