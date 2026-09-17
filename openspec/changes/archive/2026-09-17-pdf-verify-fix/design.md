# Design: pdf-verify-fix

## Overview

Two deliverables for the 15% remaining work on the PDF certificate generation feature:

1. **verify.sh container-awareness** — Make `verify.sh` detect whether it runs inside the Docker container and only execute `/var/lab-state` checks when inside the container. On the host, skip those checks with a warning and return 0.
2. **E2E test for PDF certification flow** — A new test that builds the container, simulates student info + reto completion, and asserts PDF generation.

## Architecture Decisions

### Decision 1: Container detection via multiple signals
**Rationale**: Single-signal detection is unreliable. `/.dockerenv` is the most reliable for Docker, but CI environments may use containerd or other runtimes. Checking `/proc/1/cgroup` for `docker` or `kubepods` covers Kubernetes. The `$container` env var is used by some distros (e.g., Debian's `/etc/environment`). Using all three in an OR provides maximum coverage.

### Decision 2: Host runs check as PASS (skip with warning)
**Rationale**: On the host, `/var/lab-state` does not exist — it is created by the Dockerfile at image build time (lines 82-87). The verify.sh check is fundamentally a runtime container-hardening assertion. On the host it CANNOT pass because the path doesn't exist. Treating this as a hard FAIL on the host makes verify.sh unusable for local pre-commit checks. Skipping with a warning preserves the check's value inside the container while making the script usable on the host.

### Decision 3: E2E test uses CI profile
**Rationale**: The production profile has `read_only: true` with `/var/lab-state` on tmpfs (ephemeral per container run). The CI profile (`--profile ci`) has `read_only: false` which is simpler for testing. The E2E test uses the CI profile via `docker compose --profile ci up --no-start` then `docker compose --profile ci run`.

### Decision 4: E2E test calls scripts directly (not interactive menu)
**Rationale**: The menu (`jugar_reto`) requires interactive input via `read`. For an automated test, we source `shared/eval.sh` and `shared/units_manifest.sh` directly inside the container, call `cargar_datos_estudiante()` to verify student info, then call `marcar_completado()` + `generar_pdf_reto()` for "unit-I-asset" reto 1. This tests the same code path the menu would invoke.

### Decision 5: No changes to shared/eval.sh or Dockerfile
**Rationale**: The PDF generation logic is already implemented and tested. The E2E test exercises it as-is, validating the existing contract.

## verify.sh Changes

### New helper: `detect_container()`
```bash
detect_container() {
    # Returns 0 if running inside a Docker/containerd/k8s container
    [ -f /.dockerenv ] && return 0
    [ -n "${container:-}" ] && return 0
    grep -qaE 'docker|kubepods|containerd' /proc/1/cgroup 2>/dev/null && return 0
    return 1
}
```

### Modified: `check_progress_tampering()`
Add a guard at the top:
```bash
check_progress_tampering() {
    log_info "Checking progress state tamper protection..."

    if ! detect_container; then
        log_warn "Not running inside a container; skipping /var/lab-state checks (host-only)"
        log_warn "Run 'docker run --rm <image> bash verify.sh' to validate container runtime state"
        return 0
    fi

    # ... existing /var/lab-state checks unchanged ...
}
```

## test_pdf_certificates.sh Design

**Location**: `tests/test_pdf_certificates.sh`

**Structure** (following `tests/metrics_e2e_test.sh` patterns):

1. **Setup**
   - Set `SCRIPT_DIR`, `LAB_DIR`
   - Build image: `docker build -t lab-ciberseguridad:test .`
   - Create temp dir for volume mount
   - `trap cleanup EXIT` — remove container, temp dir

2. **Test 1: Student info defaults (no .student_info)**
   - Run container with CI profile, source shared scripts, call `cargar_datos_estudiante`
   - Assert `STUDENT_NAME=Estudiante`, `COURSE=ABC-CYB-101`

3. **Test 2: Student info with provided file**
   - Create `.student_info` in mounted volume
   - Run same flow, assert values match

4. **Test 3: PDF generation for unit-I-asset reto 1**
   - Run container with mounted volume
   - Source shared/eval.sh + shared/units_manifest.sh
   - Call `cargar_datos_estudiante` then `generar_pdf_reto "unit-I-asset" 1 "📋"`
   - Assert: file exists at `~/laboratorio/units/i-asset-classification/certs/reto_1.pdf`
   - Assert: file is non-empty and starts with `%PDF-`
   - Assert: PDF text (via `pdftotext` if available, or `strings`) contains student name and unit title "Clasificación de Activos / CSF 2.0"

5. **Test 4: verify.sh inside container**
   - Copy verify.sh into container, run it
   - Assert exit code 0
   - Assert "All verification checks PASSED"

6. **Cleanup**: `trap` on EXIT — `docker rm -f`, remove temp volume

## Risks and Mitigations

| Risk | Likelihood | Mitigation |
|---|---|---|
| Container detection false-negative | Low | 3 signals; default to running checks if uncertain |
| pdftotext not in image | Medium | Use `strings` or `grep` fallback; assert via file header |
| Docker build flakiness | Low | Pin base image digest (already done in Dockerfile) |
| Test container leaks | Medium | trap cleanup on EXIT; --rm on docker run |
| Units not copied (entrypoint needed) | Medium | Source scripts directly; don't depend on entrypoint for test |

## Testability Notes

- verify.sh changes are pure shell logic — testable by sourcing and calling `detect_container` with mocked environment
- E2E test requires Docker — can be skipped in environments without Docker (use `skip-if-no-docker` guard pattern from metrics_e2e_test.sh)
- The PDF content assertion depends on `strings` or `pdftotext` — `strings` is available via `binutils` (may need install); `pdftotext` via `poppler-utils` (not in Dockerfile). Use `strings | grep` as portable fallback.
- Unit index for "unit-I-asset" = 21, dir = "i-asset-classification", title = "Clasificación de Activos / CSF 2.0", icon = "🏷️"
