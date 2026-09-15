# Delta Specs: ABC-CYB-101 Ebook Completion

## MODIFIED Requirements

### Requirement: M2 — Reconocimiento y Redes con Ubuntu

The ebook Module 2 SHALL frame reconnaissance using Ubuntu 24.04 tools (nmap, tcpdump) rather than Kali Linux, with Kali presented only as professional reference. The module MUST NOT reference tools absent from the Dockerfile (burpsuite, metasploit, sqlmap, nikto, openvas).

(Previously: "Kali Linux: Entorno y Gestión de Sesiones" — taught Kali menus and 600+ tools not installed in lab)

#### Scenario: Tool alignment validation

- GIVEN the Dockerfile installs nmap, tcpdump, openssl, john, fail2ban, iptables, ufw, logrotate
- WHEN a student reads Module 2
- THEN every tool mentioned MUST exist in the Dockerfile package list
- AND no Kali-specific tool (burpsuite, metasploit, sqlmap) appears as "installed"

#### Scenario: Lab exercise execution

- GIVEN a student is in the Ubuntu 24.04 container as `estudiante`
- WHEN they follow Module 2 exercises
- THEN each exercise MUST run with the NOPASSWD sudoers permissions granted to `estudiante`
- AND exercises MUST reference units/ii-firewalls-redes or units/ii content

#### Scenario: Kali reference framing

- GIVEN Kali Linux is mentioned in Module 2
- WHEN the text describes Kali tools or menu structure
- THEN the text MUST frame Kali as "professional reference" or "industry standard"
- AND MUST redirect to the Ubuntu tools actually available in the lab

---

### Requirement: M3 — Git Control de Versiones (branch strategy update)

The ebook Module 3 SHALL document the branch strategy defined in CONTRIBUTING.md: `main` (releases), `develop` (features), `fix/*` (bugfixes). Commit messages SHALL follow Conventional Commits (`feat:`, `fix:`) as specified in CONTRIBUTING.md lines 29, 39.

(Previously: Generic Git workflow without referencing the repo's actual branch model)

#### Scenario: Branch model accuracy

- GIVEN CONTRIBUTING.md defines main/develop/fix/* branching
- WHEN Module 3 describes branch strategy
- THEN it MUST name `main`, `develop`, and `fix/*` explicitly
- AND MUST show the merge flow: fix/* → main, develop → main

#### Scenario: Commit convention alignment

- GIVEN CONTRIBUTING.md mandates Conventional Commits
- WHEN Module 3 shows commit examples
- THEN examples MUST use `feat:` and `fix:` prefixes
- AND MUST match the style `feat: agregar reto de awk` from CONTRIBUTING.md

---

## ADDED Requirements

### Requirement: M4 — Criptografía, SSL/TLS y Hardening

The ebook SHALL include Module 4 covering symmetric/asymmetric cryptography concepts, OpenSSL certificate generation, SSL/TLS analysis, nginx hardening, and CIS benchmark principles. Content MUST map to units: iv-criptografia-cvss, iv, vii, ix, x.

#### Scenario: OpenSSL lab exercise

- GIVEN a student has openssl installed (Dockerfile line 32)
- WHEN Module 4 asks to generate a self-signed certificate
- THEN the exercise MUST use `openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem -days 365`
- AND the exercise MUST be completable as `estudiante` without root

#### Scenario: nginx hardening content

- GIVEN nginx is installed (Dockerfile line 33) and unit-ix covers nginx retos
- WHEN Module 4 addresses web server hardening
- THEN it MUST reference nginx configuration paths and security headers
- AND MUST align with unit-ix test.sh validation patterns

#### Scenario: CIS benchmark mapping

- GIVEN unit-vii covers "Hardening y CIS Benchmarks"
- WHEN Module 4 discusses hardening
- THEN it MUST reference at least 3 CIS-style controls (e.g., file permissions, service disabling, firewall rules)
- AND exercises MUST be runnable with `estudiante`'s limited sudoers permissions

**Tools covered:** openssl, nginx, ufw, iptables, chmod, chown, systemctl/service commands
**Lab units:** iv-criptografia-cvss (10 retos), iv (10 retos), vii (15 retos), ix (10 retos), x (15 retos)
**Exercises:** (1) Generate self-signed cert with openssl, (2) Configure nginx security headers, (3) Audit file permissions against CIS baseline, (4) Analyze TLS handshake with openssl s_client
**Estimated lines:** 400-500

---

### Requirement: M5 — Docker, Backup y Hardening de Contenedores

The ebook SHALL include Module 5 covering container isolation, Docker Compose architecture, backup strategies with restic/rsync, and container hardening. Content MUST map to units: viii, xi, and docker-compose patterns.

#### Scenario: Docker architecture explanation

- GIVEN docker.io is installed (Dockerfile line 44) and the lab itself runs in Docker
- WHEN Module 5 explains containerization
- THEN it MUST reference the lab's own docker-compose.yml (lab_fundamentos_cyber service, lab-cyber network, NET_ADMIN capability)
- AND MUST explain why the lab uses SETUID/SETGID but NOT SYS_ADMIN

#### Scenario: Backup exercise with rsync

- GIVEN rsync is installed (Dockerfile line 34)
- WHEN Module 5 covers backup strategies
- THEN it MUST include a practical rsync exercise (e.g., `rsync -avz /source/ /backup/`)
- AND MAY reference restic as conceptual backup tool (not required to be installed)

#### Scenario: Container hardening alignment

- GIVEN unit-viii covers Docker (10 retos)
- WHEN Module 5 addresses container security
- THEN it MUST cover: non-root containers, capability dropping, image minimization
- AND exercises MUST be conceptual or use `docker` group permissions granted to `estudiante`

**Tools covered:** docker, docker compose, rsync, tar, gzip, chown, chmod
**Lab units:** viii (10 retos), xi (10 retos)
**Exercises:** (1) Inspect lab container's docker-compose config, (2) Create incremental backup with rsync, (3) Harden a Dockerfile with non-root user, (4) Analyze container capabilities vs CIS Docker benchmark
**Estimated lines:** 350-450

---

### Requirement: M6 — Wargames, Logging y Reportes de Seguridad

The ebook SHALL include Module 6 covering Bandit wargames theory (levels 0-3 reproducible locally), log analysis with tcpdump/logrotate, SIEM concepts, and security report writing using plantilla.md structure. Content MUST map to units: v-logging-siem-bcp, v, and checkpoint-v.

#### Scenario: Bandit theory without external dependency

- GIVEN no wargame infrastructure exists in the repo (research confirmed)
- WHEN Module 6 covers Bandit
- THEN it MUST frame Bandit as external reference (OverTheWire) OR describe how to recreate levels 0-3 locally using ssh/password patterns
- AND MUST NOT claim Bandit levels are implemented in the lab

#### Scenario: Log analysis with tcpdump

- GIVEN tcpdump is installed (Dockerfile line 52) and unit-v covers logging/SIEM
- WHEN Module 6 covers log analysis
- THEN it MUST include a tcpdump capture and analysis exercise (e.g., `tcpdump -i eth0 -w capture.pcap`)
- AND MUST reference logrotate configuration (installed, Dockerfile line 55)

#### Scenario: Report writing structure

- GIVEN plantilla.md exists (249 lines) as student answer template
- WHEN Module 6 covers security reporting
- THEN it MUST reference plantilla.md sections (objective, commands used, output, answer)
- AND exercises MUST produce output matching the plantilla format

**Tools covered:** tcpdump, logrotate, openssl, john, bash, grep, awk, sed, pandoc (for report generation)
**Lab units:** v-logging-siem-bcp (10 retos), v (10 retos), checkpoint-v (5 retos)
**Exercises:** (1) Capture and analyze network traffic with tcpdump, (2) Configure logrotate for a custom application log, (3) Write a security incident report using plantilla.md, (4) Recreate Bandit level 0-2 challenge locally with ssh
**Estimated lines:** 400-500

---

## Cross-Reference Matrix

| Module | Lab Units | Tools (Dockerfile-validated) | Est. Lines |
|--------|-----------|------------------------------|------------|
| M1 (existing) | i, ii, vi | bash, coreutils, nano, vim | 585 |
| M2 (rewrite) | ii-firewalls-redes, ii, iii-iam-mfa | nmap, tcpdump, ufw, iptables | 350-450 |
| M3 (update) | iii | git | 455 |
| M4 (new) | iv-criptografia-cvss, iv, vii, ix, x | openssl, nginx, ufw, iptables | 400-500 |
| M5 (new) | viii, xi | docker, rsync, tar | 350-450 |
| M6 (new) | v-logging-siem-bcp, v, checkpoint-v | tcpdump, logrotate, john, pandoc | 400-500 |

## Self-Assessment Checklist (per module)

Each module SHALL end with a checklist of 8-12 verifiable items. Students MUST be able to demonstrate each item via terminal command or written explanation.

## Index Update Requirement

The `index.qmd` TOC SHALL list exactly 6 content modules (plus intro). The "5 módulos temáticos" reference on line 63 SHALL be updated to "6 módulos temáticos". Module titles in the TOC MUST match actual module filenames.