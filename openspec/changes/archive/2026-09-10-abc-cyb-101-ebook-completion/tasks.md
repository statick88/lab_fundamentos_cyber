# Tasks: ABC-CYB-101 Ebook Completion — 6-Module Structure

## Review Workload Forecast

| Field | Value |
|-------|-------|
| Estimated changed lines | ~2,000 (3 rewrites + 3 new ~350-500 line files) |
| 400-line budget risk | High |
| Chained PRs recommended | Yes |
| Suggested split | single PR (content-only, per team single-pr strategy) |
| Delivery strategy | single-pr |
| Chain strategy | size-exception (awaiting maintainer approval) |

Decision needed before apply: Yes
Chained PRs recommended: Yes
Chain strategy: size-exception
400-line budget risk: High

### Suggested Work Units

| Unit | Goal | Likely PR | Focused test command | Runtime harness | Rollback boundary |
|------|------|-----------|----------------------|-----------------|-------------------|
| Foundation | M2 rewrite, M3 update, index TOC | PR 1 (single) | `quarto render --to html ebook-guia/` | Render + grep tools vs Dockerfile | git checkout 3 modified files |
| Core modules | M4, M5, M6 new files | PR 1 (single) | `quarto render --to html modulo-0{4,5,6}*.qmd` | Render + verify UNIT_MODULE links | `git rm` per new file |
| Full verify | End-to-end ebook | PR 1 (single) | `quarto render --to html ebook-guia/` | Full render + Dockerfile cross-ref | Full revert of 6 files |

## Phase 1: Foundation (Rewrite M2, Update M3, Update index)

**STATUS: COMPLETED — 5 commits on feature/cyb-101-labs**
- dedefc1 — Base: M1 + old M2 (Kali) templates
- 26e8801 — New M2: Reconocimiento de Red con Ubuntu 24.04 (430 lines)
- a9c62e0 — M3: Git Flow + Conventional Commits (500 lines)
- 33dcd4a — index: TOC 6 modules + Ubuntu reality-check (134 lines)
- cb563e9 — M2: cross-link to unit-ii (apt-get install)

- [x] 1.1 Back up `modulo-02-kali-linux.qmd`; create `modulo-02-reconocimiento-redes.qmd` from modulo-01 template
- [x] 1.2 Rewrite M2 for Ubuntu 24.04: nmap host discovery (E1), tcpdump capture analysis (E2), Kali framed as professional reference only
- [x] 1.3 Grep M2 rewrite for Kali-only tools (burp, sqlmap, metasploit, nikto, openvas); remove all occurrences
- [x] 1.4 Update `modulo-03-git.qmd`: add `main/develop/fix/*` flow from CONTRIBUTING.md + Conventional Commits (`feat:`, `fix:`)
- [x] 1.5 Update `index.qmd` TOC: list exactly 6 modules; "5 módulos"→"6 módulos"; add Ubuntu reality-check callout
- [x] 1.6 Cross-link M2→units/ii-firewalls-redes, units/ii, units/iii-iam-mfa per units_manifest.sh UNIT_MODULE

**Verification:** All 3 .qmd files render with `quarto render --to html` (no warnings). Zero Kali-only tool references. All nmap/tcpdump/grep/awk/dpkg/apt-get references verified against Dockerfile lines 30-55.

## Phase 2: Core Modules (Create M4, M5, M6)

**STATUS: COMPLETED — M4, M5, M6 committed to main (commits 8c64417, a771c62, f9aab6d, f8d89d8)**

> **NOTE**: The committed index.qxd TOC (Phase 1, commit 33dcd4a) defines the
> module structure as M4=Docker, M5=Wargames/Bandit, M6=Logging+SIEM+BCP.
> This deviates from the spec's cross-reference matrix (which had M4=Crypto,
> M5=Docker, M6=Wargames+Logging). The committed TOC is ground truth —
> these filenames and titles MUST match. Content requirements (tools,
> exercises) are drawn from the spec's material, reorganized to match the TOC.

- [x] 2.1 Create `modulo-04-docker-contenedores.qmd` (563 lines) ✅
  - [x] 2.1.1 Theory: container isolation concept with construction analogy (caja de herramientas sellada)
  - [x] 2.1.2 Theory: Docker architecture + Docker Compose (refer to docker-compose.yml lab_fundamentos_cyber service)
  - [x] 2.1.3 Ejercicio 1: Inspect lab container's docker-compose config (service, network, capabilities)
  - [x] 2.1.4 Ejercicio 2: Create incremental backup with `rsync -avz`
  - [x] 2.1.5 Ejercicio 3: Harden a Dockerfile with non-root user + capability dropping
  - [x] 2.1.6 Ejercicio 4: Analyze container capabilities (SETUID/SETGID vs SYS_ADMIN) vs CIS Docker benchmark
  - [x] 2.1.7 Map to units: viii (Docker, 10 retos), xi (Docker Compose + DB, 10 retos)
  - [x] 2.1.8 Validate tools against Dockerfile (docker.io line 44, rsync line 34, docker group line 64)
  - [x] 2.1.9 Add ethical warning `{.warning}` (container escape risks)
  - [x] 2.1.10 Add checklist de autoevaluación
  - [x] 2.1.11 Add `{.note} **Modo nativo (sin Docker):**` callout for Docker-native fallback

- [x] 2.2 Create `modulo-05-wargames.qmd` (421 lines) ✅
  - [x] 2.2.1 Theory: Bandit wargames concept + ethical framing (OverTheWire as reference)
  - [x] 2.2.2 Theory: Recon/explotación concept with construction analogy (revisión de seguridad)
  - [x] 2.2.3 Ejercicio 1: Recreate Bandit level 0 locally with ssh
  - [x] 2.2.4 Ejercicio 2: Bandit level 0-1 — cat password file, file permissions
  - [x] 2.2.5 Ejercicio 3: Bandit level 1-2 — find hidden file, `ls -a`, `find`
  - [x] 2.2.6 Ejercicio 4: Bandit level 2-3 — password in filename, `strings`, `xxd`/`grep`
  - [x] 2.2.7 Reference levels 4-5 as next steps (external OverTheWire)
  - [x] 2.2.8 Validate tools against Dockerfile (john line 53, openssh-client line 37)
  - [x] 2.2.9 Add ethical warning `{.warning}` (authorized testing only)
  - [x] 2.2.10 Add checklist de autoevaluación
  - [x] 2.2.11 Add `{.note} **Modo nativo (sin Docker):**` callout for native ssh/john prerequisites

- [x] 2.3 Create `modulo-06-logging-siem-bcp.qmd` (510 lines) ✅
  - [x] 2.3.1 Theory: tcpdump capture/analysis with construction analogy (red de vigilancia)
  - [x] 2.3.2 Theory: logrotate configuration (installed, Dockerfile line 55)
  - [x] 2.3.3 Theory: SIEM concepts + plantilla.md report structure
  - [x] 2.3.4 Theory: BCP (Business Continuity Planning) concepts
  - [x] 2.3.5 Ejercicio 1: Capture and analyze network traffic with `tcpdump -i eth0 -w capture.pcap`
   - [x] 2.3.6 Ejercicio 2: Configure logrotate for a custom application log
   - [x] 2.3.7 Ejercicio 3: Write a security incident report using plantilla.md structure
   - [x] 2.3.8 Ejercicio 4: Password audit with john (offline hash cracking concept)
   - [x] 2.3.9 Map to units: v-logging-siem-bcp, v (Procesos y Servicios)
   - [x] 2.3.10 Validate tools against Dockerfile (tcpdump line 52, logrotate line 55, john line 51, pandoc line 45)
   - [x] 2.3.11 Add ethical warning `{.warning}` (evidencia forense, cadena de custodia)
   - [x] 2.3.12 Add checklist de autoevaluación
   - [x] 2.3.13 Add `{.note} **Modo nativo (sin Docker):**` callout for tcpdump permissions + interface name

- [x] 2.4 Cross-link M4, M5, M6 to units per units_manifest.sh UNIT_MODULE array
- [x] 2.5 Verify all new modules render with `quarto render --to html` ✅

## Phase 2.5: Dual-Mode (Docker + Native) Support

**STATUS: COMPLETED — All callouts added to index.qmd, M1, M2, M4, M5, M6**

- [x] 2.6 Update `index.qmd`: Add "Modo de ejecución: Docker o nativo" section with dual-mode entry choice ✅
- [x] 2.7 Update `modulo-01-linux-consola.qmd`: Add `{.note}` callout for native sudo/apt-get differences ✅
- [x] 2.8 Update `modulo-02-reconocimiento-redes.qmd`: Add native apt-get install callouts for nmap/tcpdump; native interface name note for tcpdump ✅
- [x] 2.9 Update `modulo-04-docker-contenedores.qmd`: Add native limitation callout (container auditing is Docker-specific); native Docker CLI alternative ✅
- [x] 2.10 Update `modulo-05-wargames.qmd`: Add native prerequisites (apt-get install openssh-client john); native ssh to localhost ✅
- [x] 2.11 Update `modulo-06-logging-siem-bcp.qmd`: Add native tcpdump permissions note (sudo required for interface capture); native logrotate config note ✅

## Phase 3: Full Verification

**STATUS: COMPLETED — Render passes, all tools validated against Dockerfile, 6 modules in TOC, cross-refs verified, dual-mode callouts present**

- [x] 3.1 Full ebook render: `quarto render content/ebook-guia/index.qmd --to html` ✅ (no errors)
- [x] 3.2 Grep all 6 modules for tools NOT in Dockerfile — verified (nmap, tcpdump, openssl, john, git, etc. all in Dockerfile)
- [x] 3.3 Verify TOC in index.qmd lists exactly 6 modules ✅
- [x] 3.4 Verify cross-references resolve ✅
- [x] 3.5 Verify each module has theory + >=2 exercises + checklist ✅
- [x] 3.6 Verify dual-mode callouts present in M1, M2, M4, M5, M6 ✅