# Apply Progress — pdf-verify-fix

## Status: completed

## Summary
Made `verify.sh` container-aware so it correctly detects when it runs inside a Docker
container and conditionally executes `/var/lab-state` tamper-protection checks only in
that environment. On the host, those checks are skipped with an informative warning.
Added an E2E test (`tests/test_pdf_certificates.sh`) that validates student info loading,
PDF certificate generation via `generar_pdf_reto`, and `verify.sh` execution inside the
container.

## Changes Made

### 1. `verify.sh` — Container detection + conditional state checks

**Added `detect_container()` function** (lines 20–26):
- Checks `/.dockerenv` file existence
- Checks `$container` environment variable
- Checks `/proc/1/cgroup` for docker/kubepods

**Modified `check_progress_tampering()`** (line 107):
- Calls `detect_container()` at entry
- If NOT running inside a container (host): emits `log_warn` skipping message and returns 0
- If running inside a container: proceeds with full tamper-protection checks
  (state directory ownership, permissions, read-only enforcement)

This ensures `verify.sh` passes on the host (where `/var/lab-state` doesn't exist)
while still validating container security when run inside the Docker environment.

### 2. `tests/test_pdf_certificates.sh` — E2E test suite (new file)

Four test groups, 13 assertions total:
- **Test 1**: Student info defaults (no `.student_info` file) — `STUDENT_NAME=Estudiante`, `COURSE=ABC-CYB-101`
- **Test 2**: Student info loaded from `.student_info` file with custom name
- **Test 3**: PDF certificate generation via `generar_pdf_reto` for `unit-I-asset` reto 1
  - Validates `PDF_GENERATION=SUCCESS`, file existence, valid `%PDF-` header, non-empty size (>1KB)
- **Test 4**: `verify.sh` execution inside the container — validates exit 0 and "All verification checks PASSED"

Key implementation notes:
- Uses `--entrypoint bash` to bypass the interactive `entrypoint.sh`
- Writes student info inside the container (macOS bind mount issues with temp dirs)
- Sources `shared/common.sh` and `shared/eval.sh` for unit manifest functions
- Volume mounts repo at `/mnt/lab` for `verify.sh` to read Dockerfile, docker-compose.yml, shared/

## Constraints Honored
- No changes to `shared/eval.sh` (unchanged — `generar_pdf_reto` signature used as-is)
- No changes to `docker-compose.yml`
- No changes to `Dockerfile`
- No changes to unit content/test files

## Test Results
All 13 assertions pass:
```
  Total:  13
  Passed: 13
  Failed: 0
  ✓ All tests passed
```
