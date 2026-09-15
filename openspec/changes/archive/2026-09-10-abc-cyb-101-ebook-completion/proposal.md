# Proposal: ABC-CYB-101 Ebook Completion — 6-Module Structure

## Intent

Complete the ABC-CYB-101 ebook by resolving the module-count discrepancy (research identified 5 content modules; user specified 6), rewriting the factually misaligned Module 2, and creating the 3 missing content modules to cover all 18 lab units with the actual Ubuntu 24.04 toolchain.

## Scope

### In Scope
- Rewrite `modulo-02-kali-linux.qmd` → `modulo-02-reconocimiento-redes.qmd` (Ubuntu 24.04 + nmap/tcpdump; Kali as professional reference only)
- Update `modulo-03-git.qmd` to reflect actual `main/develop/fix/*` branch strategy from CONTRIBUTING.md
- Create `modulo-04-criptografia-ssl-hardening.qmd` (cryptography, nginx config, SSL/TLS with openssl, CIS hardening)
- Create `modulo-05-docker-backup.qmd` (Docker, Docker Compose, backup/recovery)
- Create `modulo-06-wargames-logging-reportes.qmd` (Bandit theory, tcpdump log analysis, SIEM concepts, report writing)
- Update `index.qmd` TOC and navigation for 6-module structure
- Validate all module content against actual lab tools

### Out of Scope
- Implementing `units/wargames-bandit/` hands-on CTF infrastructure
- Adding new security tools to the Dockerfile
- Changing the 18-unit lab structure

## Capabilities

### New Capabilities
- `modulo-04-criptografia-ssl-hardening`: Crypto basics, nginx hardening, SSL/TLS analysis, CIS benchmarks
- `modulo-05-docker-backup`: Container isolation, Docker Compose, backup strategies
- `modulo-06-wargames-logging-reportes`: Bandit theory, tcpdump log analysis, report writing with plantilla.md

### Modified Capabilities
- `modulo-02-reconocimiento-redes`: Reframed from "Kali Linux" to Ubuntu 24.04 reconnaissance
- `modulo-03-git-control-versiones`: Branch strategy aligned with CONTRIBUTING.md

## Approach

Hybrid continuation: keep M1 (complete), rewrite M2 to match lab reality, update M3 for branch conventions, add M4-M6 covering remaining units. Each module follows established template: theory → ASCII diagrams → exercises → checklist. Tone matches Diego Saavedra voice (Spanish, concept-first, anti-shortcuts, construction analogies).

## Affected Areas

| Area | Impact | Description |
|------|--------|-------------|
| `content/ebook-guia/index.qmd` | Modified | TOC to 6 modules, reality-check callout |
| `content/ebook-guia/modulo-02-kali-linux.qmd` | Replaced | Factual error fixed |
| `content/ebook-guia/modulo-03-git.qmd` | Modified | Branch strategy updated |
| `content/ebook-guia/modulo-04-criptografia-ssl-hardening.qmd` | New | Crypto, nginx, SSL/TLS, hardening |
| `content/ebook-guia/modulo-05-docker-backup.qmd` | New | Docker, Compose, backup |
| `content/ebook-guia/modulo-06-wargames-logging-reportes.qmd` | New | Bandit theory, logging, reports |

## Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| Factual mismatch with lab | Low | Validate every tool ref against Dockerfile |
| Module length drift | Medium | Target 350-500 lines; reuse modulo-01 template |
| Wargames module lacks hands-on component | Medium | Theory + external Bandit link + local tcpdump/john alternatives |
| Tone inconsistency | Low | Review against modulo-01 style (diagrams, analogies, warnings) |

## Rollback Plan

Revert 3 modified files via git. New modules (M4-M6) are additive; removal is single `git rm` per file. No infrastructure changes.

## Dependencies

- None external. Content derives from `units/` directories and `shared/units_manifest.sh`.

## Success Criteria

- [ ] All 6 content modules render without Quarto errors
- [ ] Every tool mentioned exists in the Dockerfile
- [ ] `modulo-02` contains no references to Burp, sqlmap, metasploit, or uninstalled tools
- [ ] `modulo-03` references `main/develop/fix/*` branching
- [ ] `index.qmd` TOC lists exactly 6 content modules
- [ ] Each module has: theory section, ≥2 exercises, checklist de autoevaluación