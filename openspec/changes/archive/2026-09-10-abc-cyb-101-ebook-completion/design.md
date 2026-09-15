# Design: ABC-CYB-101 Ebook Completion — 6-Module Structure

## Technical Approach

Derive canonical .qmd structure from `modulo-01-linux-consola.qmd`, apply to 3 rewrites (M2, M3, index) + 3 new files (M4-M6). All content validated against Dockerfile tool list. No filesystem writes (engram mode).

## Architecture Decisions

### Decision 1: Canonical module template

**Choice**: Uniform structure from modulo-01 (585 lines, proven).
**Alternatives**: Free-form (inconsistent), lighter template (loses signature diagrams).
**Rationale**: Continuity reduces student cognitive load; diagrams are a voice signature.

YAML frontmatter (all modules):
```yaml
---
title: "Módulo N — <Tema>"
author: "Diego Saavedra, Mg. Sc. | Abacom"
format:
  html:
    toc: true
    toc-location: left
    code-fold: false
    theme: cosmo
---
```

Section order: (1) Introducción with hook + analogy + `{.note}` instructor note; (2) Core concept with ASCII diagram + analogy table; (3) Deeper theory + comparative table; (4) Ejercicios prácticos progresivos (E1-E3) each with expected output; (5) Notas de seguridad with `{.warning}` + ethical frame; (6) Checklist de autoevaluación (10-12 items) + closing instructor note.

Callout formats: `{.warning} **Advertencia de seguridad:**`, `{.note} **Nota del instructor:**`, `{.note} **Nota del laboratorio:**`.

Exercise pattern:
```markdown
### EjercicioN: <Title>
```bash
# step
```
Salida esperada:
```
<output>
```
```

### Decision 2: File naming

**Choice**: `modulo-0N-<tema>.qmd`, kebab-case Spanish.

Final filenames:
- `modulo-02-reconocimiento-redes.qmd` (replaces kali-linux)
- `modulo-03-git-control-versiones.qmd` (or keep modulo-03-git.qmd)
- `modulo-04-criptografia-ssl-hardening.qmd`
- `modulo-05-docker-backup.qmd`
- `modulo-06-wargames-logging-reportes.qmd`

### Decision 3: Voice/persona enforcement

**Choice**: Diego Saavedra style guide embedded in tasks.
**Alternatives**: Style-agnostic (breaks continuity).

Enforcement rules:
- Concept-first ordering: principle before command
- Construction/architecture analogies (biblioteca, caja de herramientas, edificio)
- Anti-shortcuts: explicit "no hagas X" warnings
- Spanish Latin American neutral: no regional slang, formal "usted"
- Instructor notes (`{.note}`) for encouragement + lab reality checks
- Warning boxes (`{.warning}`) for security/ethical boundaries

### Decision 4: Cross-reference strategy

**Choice**: Two-tier system — Quarto `@ref` for intra-module, relative paths for inter-module, explicit unit-path mapping for lab links.

Strategy:
- Intra-module: `@{#fig-label}`, `@{#tbl-label}`, `@{#sec-label}`
- Inter-module: `./modulo-04-criptografia-ssl-hardening.qmd`
- Lab links: `units_manifest.sh` `UNIT_MODULE` array (M1→unit-I, M2→unit-II/III, M4→unit-IV/VII/VIII/IX, M5→unit-VIII/XI, M6→unit-V/VII)

### Decision 5: Content architecture (rewrites vs. new)

**Choice**: M1 untouched; M2 full rewrite (Ubuntu + nmap/tcpdump, Kali as reference only); M3 targeted update (add main/develop/fix/* from CONTRIBUTING.md); M4-M6 new files; index.qmd TOC updated to 6 modules.
**Alternatives**: Rewrite all 6 (wasteful, M1 is solid).

Continuity mechanism: shared YAML schema, consistent section ordering, cross-link "Próximo paso" footers, unified closing checklist format.

## Data Flow

```
units/*/test.sh ──read──► Dockerfile (tool validation)
                              │
                              ▼
units_manifest.sh ──map──► Module content (per UNIT_MODULE array)
                              │
                              ▼
modulo-01.qmd ──template──► 6 finalized .qmd files
                              │
                              ▼
index.qmd ◄── TOC update (6 modules + reality-check callout)
```

## File Changes

| File | Action | Description |
|------|--------|-------------|
| `content/ebook-guia/index.qmd` | Modify | TOC to 6 modules + "Ubuntu 24.04, no Kali" callout |
| `content/ebook-guia/modulo-02-kali-linux.qmd` | Replace | Rename to reconocimiento-redes; Ubuntu tooling |
| `content/ebook-guia/modulo-03-git.qmd` | Modify | Add main/develop/fix/* branch strategy |
| `content/ebook-guia/modulo-04-criptografia-ssl-hardening.qmd` | Create | Crypto, nginx, SSL/TLS, CIS hardening |
| `content/ebook-guia/modulo-05-docker-backup.qmd` | Create | Docker, Compose, backup/recovery |
| `content/ebook-guia/modulo-06-wargames-logging-reportes.qmd` | Create | Bandit theory, tcpdump logging, report writing |

## Testing Strategy

| Layer | What | Approach |
|-------|------|----------|
| Content | Tool accuracy | Every tool ref checked against Dockerfile lines 21-57 |
| Content | Branch strategy | M3 must mention main/develop/fix/* |
| Content | Ethical framing | Each module has `{.warning}` ethical/security note |
| Render | Quarto validity | `quarto render --to html` in ebook-guia/ |
| Cross-ref | Link integrity | Verify relative paths resolve; `@ref` labels exist |
| Continuity | Template adherence | Each module has intro, diagram, exercises, checklist |

## Threat Matrix

N/A — no routing, shell, subprocess, VCS/PR automation, executable-file classification, or process-integration boundary. This is a documentation-only change.

## Migration / Rollback

No migration. New modules are additive (`git rm` to remove). Modified files revertible via git. No infrastructure impact.

## Dual-Mode Execution: Docker vs Native (ADDED)

### Decision 6: Dual-mode exercise support

**Choice**: Each module SHALL present exercises in Docker mode (primary, container-native) with a `{.note} **Modo nativo (sin Docker):**` callout providing the native alternative command or setup step where it differs.

**Rationale**: Some students cannot or prefer not to use Docker. The exercises themselves use standard Linux tools (nmap, tcpdump, openssl, git, john) available natively on Ubuntu 24.04. The key differences to document:

1. **Tool installation**: Container has pre-installed tools; native mode requires `sudo apt-get install -y nmap`.
2. **sudo permissions**: Container grants NOPASSWD to `estudiante`; native mode requires the user to be in `sudo`/`wheel` group with password.
3. **Network interfaces**: Container uses `eth0`; native mode may use `enp0s3`, `wlan0`, etc.
4. **Container-specific**: M4 exercises that audit `docker inspect` of the lab container itself cannot be reproduced natively.
5. **User identity**: Exercises show `estudiante@lab:~$`; native users see their own username@hostname.

**Pattern**: Use Quarto callout blocks `{.note}` with bold header `**Modo nativo (sin Docker):**` to provide 1-2 lines of native alternative where the command differs. Exercises that work identically natively (e.g., `git commit`, `openssl req`) need no callout — the concept is what matters.

### Decision 7: index.qxd dual-mode introduction

**Choice**: Add a new section `## Modo de ejecución: Docker o nativo` before the TOC table, presenting the two options and linking to the Docker README for container setup and the apt-get install line for native.

## Open Questions

- [ ] Keep `modulo-03-git.qmd` filename or rename to `modulo-03-git-control-versiones.qmd`? (DECIDED: keep original filename per committed TOC)
- [ ] Wargames M6: theory-only + external Bandit link, OR implement `units/wargames-bandit/` for hands-on? (proposal says out of scope; recommend theory-only)
- [ ] M5 Docker content: use docker.io installed in Dockerfile, or reference external Docker Desktop? (DECIDED: reference docker.io per Dockerfile line 44)