# Verify Report — pdf-verify-fix

## Status: passed

## Verification Results

### CRITICAL
None

### WARNING
None

### SUGGESTION
None

## Verification Evidence

### 3.1 Shellcheck — PASSED
```
$ shellcheck verify.sh
# Only warnings: SC2034 (unused variables: group, p_group) — pre-existing, not introduced by this change

$ shellcheck tests/test_pdf_certificates.sh
# Clean — exit 0
```

### 3.2 verify.sh on host — PASSED
```
$ bash verify.sh
[INFO] === lab-ciberseguridad Build Verification ===
...
[WARN] Not running inside a container; skipping /var/lab-state checks (host-only)
[WARN] Run 'docker run --rm <image> bash verify.sh' to validate container runtime state
...
[PASS] All verification checks PASSED
---exit: 0---
```

**Key behavior verified**: The `detect_container()` guard correctly detects host execution and
skips `/var/lab-state` tamper-protection checks with an informative warning. Previously,
`verify.sh` would fail on the host because `/var/lab-state` doesn't exist.

### 3.3 verify.sh inside Docker container — PASSED
```
$ docker run --rm -v "$LAB_DIR:/mnt/lab:ro" --entrypoint bash lab-ciberseguridad:test -c '
    cd /mnt/lab && bash verify.sh 2>&1; echo "VERIFY_EXIT=$?"
'
...
[PASS] State directory owned by root
[PASS] State directory permissions are 0750
[PASS] Progress file owned by root
[PASS] Progress file permissions are 0640
[PASS] Non-root user cannot write to progress file (read-only enforced)
...
[PASS] All verification checks PASSED
VERIFY_EXIT=0
```

**Key behavior verified**: Inside the container, `detect_container()` returns 0 (true),
and the full tamper-protection checks run against `/var/lab-state`.

### 3.4 E2E test suite — PASSED
```
$ bash tests/test_pdf_certificates.sh
...
  Total:  13
  Passed: 13
  Failed: 0
  ✓ All tests passed
---exit: 0---
```

**Tests verified**:
- Test 1: Student info defaults (`STUDENT_NAME=Estudiante`, `COURSE=ABC-CYB-101`)
- Test 2: Student info from `.student_info` file (`Maria Garcia`)
- Test 3: PDF generation — `generar_pdf_reto "unit-I-asset" 1` produces valid PDF
  - `%PDF-` header valid
  - File size 81,547 bytes (> 1KB threshold)
  - File exists at `~/laboratorio/units/i-asset-classification/certs/reto_1.pdf`
- Test 4: `verify.sh` inside container — exit 0, "All verification checks PASSED"
- Cleanup: No leftover containers after test exit

## Acceptance Criteria Verification

| AC | Description | Status |
|----|-------------|--------|
| AC1 | `verify.sh` exits 0 on host (skips `/var/lab-state` checks) | ✅ PASSED |
| AC2 | `verify.sh` exits 0 inside Docker container (runs `/var/lab-state` checks) | ✅ PASSED |
| AC3 | `generar_pdf_reto` generates PDF with valid `%PDF-` header | ✅ PASSED |
| AC4 | PDF file exists at expected path and is non-empty | ✅ PASSED |
| AC5 | No changes to `shared/eval.sh`, `Dockerfile`, `docker-compose.yml`, or unit content | ✅ VERIFIED |
| AC6 | Student info loaded from `.student_info` file with correct defaults | ✅ PASSED |
| AC7 | Student info defaults used when `.student_info` absent | ✅ PASSED |
| AC8 | E2E test cleans up containers/temp dirs on exit | ✅ PASSED |
