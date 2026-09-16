# Tasks: tarea-5 (5 Tasks SDD Workflow)

## Review Workload Forecast

| Field | Value |
|---|---|
| Estimated changed lines | ~2,000 |
| 400-line budget risk | High |
| Chained PRs recommended | Yes |
| Delivery strategy | auto-chain |
| Chain strategy | feature-branch-chain |

Decision needed before apply: Yes
Chained PRs recommended: Yes
Chain strategy: feature-branch-chain
400-line budget risk: High

### Existing Task List

| Task | Scope | PR | Focused test command | Runtime harness | Rollback boundary |
|---|---|---|---|---|---|
| Task 1 | Tarea 1 - Riesgos y Clasificación | PR 1 (tracker) | `bash verify.sh` | `docker run --rm lab-ciberseguridad` | Remove task directories |
| Task 2 | Tarea 2 - Firewalls perimetrales | PR 2 | `bash verify.sh` | `docker compose config` | Revert firewall configs |
| Task 3 | Tarea 3 - Hardening e IAM/MFA | PR 3 | `bash units/iii-iam-mfa/test.sh` | `bash units/iii-iam-mfa/test.sh` | Revert system changes |
| Task 4 | Tarea 4 - Vulnerabilidades y Cripto | PR 4 | `bash verify.sh` | `bash -n shared/*.sh` | Revert crypto/YARA changes |
| Task 5 | Tarea 5 - Logging, SIEM, BCP | PR 5 (merges to main) | `bash verify.sh` | `docker build -t lab-ciberseguridad .` | Remove logging artifacts |

## Phase 1: Foundation/Infrastructure

- [x] 1.1 RED: Create `verify.sh` with a failing container-escape assertion. Given hardened image, when capabilities/security options are inspected, then only allowed caps remain; SYS_ADMIN and Docker socket are absent.
- [x] 1.2 RED: Add failing sudo-escalation assertion to `verify.sh`. Given non-CI profile, when `estudiante` elevates, then no new privileges are acquired.
- [x] 1.3 RED: Add failing progress-tampering assertion to `verify.sh`. Given `estudiante`, when writing `/var/lab-state/progress`, then denied; root append succeeds.
- [x] 1.4 RED: Add failing image-poisoning assertion to `verify.sh`. Given Dockerfile, when base image is inspected, then digest is pinned.
- [x] 1.5 Harden `Dockerfile` and `docker-compose.yml`: `USER estudiante`, cap drop/add, `no-new-privileges:true`, read-only rootfs, writable `/tmp` (read-only), `/var/log/nginx` (read-only), `/var/lab-state` (read-only), no privileged/socket.
- [x] 1.6 Move state to root-owned `/var/lab-state` (read-only) in `Dockerfile` and `shared/eval.sh`; set directory `0755`, progress `root:sudo`/`0640`, student read-only, root append explicit.

## Phase 2: Core Implementation

- [ ] 2.1 Extend `shared/validators.sh` and `shared/sudo-wrappers.sh` with missing helpers and contracts.
- [ ] 2.2 Migrate `units/i/test.sh`, `units/i-risk-assessment/test.sh`, `units/i-asset-classification/test.sh`, `units/ii/test.sh`, `units/ii-firewalls-redes/test.sh`, `units/ii-ids-intrusion-detection/test.sh`, and `units/checkpoint-ii/test.sh` to shared sourcing/assertions; remove bare `sudo`/inline checks.
- [ ] 2.3 Migrate `units/iii/test.sh`, `units/iii-iam-mfa/test.sh`, `units/iii-compliance-iso27001/test.sh`, `units/iv/test.sh`, `units/iv-criptografia-cvss/test.sh`, and `units/iv-burp-intercept/test.sh` similarly.
- [ ] 2.4 Migrate `units/v/test.sh`, `units/v-logging-siem-bcp/test.sh`, `units/vi/test.sh`, `units/vii/test.sh`, `units/viii/test.sh`, `units/ix/test.sh`, `units/x/test.sh`, `units/xi/test.sh`, `units/checkpoint-iv/test.sh`, and `units/checkpoint-v/test.sh` similarly.
- [ ] 2.5 Fix checkpoint-II cases in `shared/evaluar-unidad.sh` and `shared/retos-unidad.sh`.

## Phase 3: Integration/Wiring

- [ ] 3.1 Create `.github/workflows/ci.yml` with push/PR triggers for `feature/cyb-101-labs` and `main`, 26-unit matrix, missing-test skip, CORE fail-fast, and PASS/FAIL report.
- [ ] 3.2 Add CI Compose profile (`no-new-privileges:false`, whitelisted sudo) while keeping production hardened.
- [ ] 3.3 Extend `verify.sh` cross-checks for Dockerfile, manifest totals (26/243/85), shared modules, and docs links.

## Phase 4: Testing/Verification

- [ ] 4.1 Run `bash -n shared/*.sh units/*/test.sh` and `bash units/iii-iam-mfa/test.sh`; Given valid image, when validators load, then all five retos pass.
- [ ] 4.2 Run `bash verify.sh`; Given built image, when verification executes, then shared modules/manifest load and all checks pass.
- [ ] 4.3 Run `docker compose config` and container checks; Given hardened service, when inspected, then non-root, allowed caps, read-only rootfs, writable paths, and state modes match.
- [ ] 4.4 Run `bash verify.sh`; Given 26 manifest units, when docs are scanned, then 26 guides and validator signatures/examples exist.

## Phase 5: Cleanup/Documentation

- [ ] 5.1 Update `docs/validators-standard.md`, 26 unit guides, `docs/troubleshooting.md`, `CONTRIBUTING.md`, and `README.md` with CI, quickstart, API, and troubleshooting links.
- [ ] 5.2 Remove temporary fallback code; verify no direct `sudo` or inline validators remain with `bash verify.sh`.
