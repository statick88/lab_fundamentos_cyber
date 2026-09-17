# Proposal: pdf-verify-fix — Container-Aware verify.sh + PDF Certificate E2E Test

## Intent

`verify.sh` fails on the host because it unconditionally checks `/var/lab-state`, a directory that only exists inside the Docker container. This change makes `verify.sh` container-aware and adds an end-to-end test for the PDF certificate generation flow inside the built container.

## Scope

### In Scope
- Modify `verify.sh` to detect container runtime (`/.dockerenv`, `/proc/1/cgroup`, or `container` env var) and gate `/var/lab-state` checks behind that detection.
- Add `tests/test_pdf_certificates.sh` — container-based E2E test reusing existing assertion helpers (`assert_file_exists`, `assert_file_contains`, `assert_exit_code`).

### Out of Scope
- `shared/eval.sh` PDF generation logic (pandoc, pdflatex, emoji sanitization).
- `docker-compose.yml` profiles, capabilities, volume definitions.
- New unit development or reto content.
- Quarto/ebook content (separate `ebook` spec).

## Capabilities

### New Capabilities
- `container-aware-verification`: `verify.sh` distinguishes host vs container execution; container-only state checks run only inside a container.
- `pdf-certificate-e2e`: Automated test validating the student-info → reto completion → PDF certificate pipeline inside the built container.

### Modified Capabilities
- None at the spec level. Test/verify infrastructure only; no production behavior changes.

## Approach

**verify.sh fix**: Add a `detect_container()` helper returning 0 inside Docker (checks `/.dockerenv`, `/proc/1/cgroup` for `docker`/`kubepods`, or `container` env var). Wrap `check_progress_tampering()` so on the host it logs a warning and returns 0. Other checks already operate on host-side files and stay unchanged.

**E2E test**: `tests/test_pdf_certificates.sh` follows `tests/metrics_e2e_test.sh` patterns: build image, run container with CI profile mounting a temp `$HOME/laboratorio`, pipe student name/course into the entrypoint, trigger `jugar_reto()` on a small CORE unit (calls `marcar_completado()` then `generar_pdf_reto()`), assert the PDF exists at `$HOME/laboratorio/units/<unit>/certs/<name>.pdf` and contains student name, unit name, and date, then clean up via `trap` on EXIT.

## Affected Areas

| Area | Impact | Description |
|------|--------|-------------|
| `verify.sh` | Modified | Add container detection; gate `/var/lab-state` checks |
| `tests/test_pdf_certificates.sh` | New | Container-based E2E test for PDF certificate flow |
| `tests/metrics_e2e_test.sh` | Unchanged | Assertion helper pattern reused |

## Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| Container detection false-negative on LXC/podman | Low | Multiple signals; default to running checks if uncertain |
| E2E flakiness from Docker build/pull timing | Medium | Build retry; pin base image digest |
| Test container leaks | Medium | `trap` cleanup on EXIT; `docker rm -f` in teardown |
| pandoc/pdflatex missing in image | Low | Dockerfile installs both (lines 45-49); assert presence first |

## Rollback Plan

1. `git rm tests/test_pdf_certificates.sh` → removes E2E test.
2. `git checkout HEAD -- verify.sh` → restores unconditional `/var/lab-state` checks.
3. No data migration needed — no production behavior or config changed.

## Dependencies

- Docker (build + run) in CI and local environment.
- `bash`, `stat`, `grep`, `find` on host (already used by existing tests).
- Container image `ubuntu:24.04` pinned by digest in Dockerfile.

## Success Criteria

- [ ] `bash verify.sh` exits 0 on the host (previously failed).
- [ ] `bash verify.sh` exits 0 inside the container (existing behavior preserved).
- [ ] `bash tests/test_pdf_certificates.sh` passes: PDF generated with student name and unit name present.
- [ ] Test cleans up all containers and temp dirs (no leaks after run).
- [ ] No changes to `shared/eval.sh`, `docker-compose.yml`, `Dockerfile`, or unit content.