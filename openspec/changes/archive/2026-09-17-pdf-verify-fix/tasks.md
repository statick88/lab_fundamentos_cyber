# Tasks: pdf-verify-fix — Container-Aware verify.sh + PDF Certificate E2E Test

## Review Workload Forecast

| Field | Value |
|-------|-------|
| Estimated changed lines | ~200 (20 in verify.sh + ~180 new test file) |
| 400-line budget risk | Low |
| Chained PRs recommended | No |
| Suggested split | PR 1 (verify.sh fix) → PR 2 (E2E test) |
| Delivery strategy | auto-chain |
| Chain strategy | stacked-to-main |

Decision needed before apply: No
Chained PRs recommended: No
Chain strategy: stacked-to-main
400-line budget risk: Low

### Suggested Work Units

| Unit | Goal | Likely PR | Focused test command | Runtime harness | Rollback boundary |
|------|------|-----------|----------------------|-----------------|-------------------|
| 1 | Container-aware verify.sh | PR 1 | `bash verify.sh` (host) exits 0 | Host + Docker container | `git checkout HEAD -- verify.sh` |
| 2 | PDF certificate E2E test | PR 2 | `bash tests/test_pdf_certificates.sh` | Docker build + run | `git rm tests/test_pdf_certificates.sh` |

## Phase 1: Foundation — verify.sh Container Detection

- [x] 1.1 Add `detect_container()` helper to `verify.sh` — checks `/.dockerenv` (read-only), `$container` env var, and `/proc/1/cgroup` (read-only) for `docker\|kubepods\|containerd`; returns 0 if inside container, 1 otherwise. (AC1, AC2)

- [x] 1.2 Wrap `check_progress_tampering()` with `detect_container` guard — if not in container, log two `log_warn` messages and `return 0`; skip `/var/lab-state` (read-only) checks on host. Existing container checks remain unchanged. (AC1, AC2)

## Phase 2: Testing — E2E Test for PDF Certificate Flow

- [x] 2.1 Create `tests/test_pdf_certificates.sh` skeleton — set `SCRIPT_DIR`/`LAB_DIR`, build image (`docker build -t lab-ciberseguridad:test .`), create temp volume dir, `trap cleanup EXIT`, include assertion helpers (`assert_file_exists`, `assert_file_contains`, `assert_exit_code`) matching `tests/metrics_e2e_test.sh` pattern. (R7, R8)

- [x] 2.2 Implement Test 1: Student info defaults — run container with CI profile, source `shared/eval.sh`, call `cargar_datos_estudiante`, assert `STUDENT_NAME=Estudiante` and `COURSE=ABC-CYB-101` when `.student_info` absent. (R4, AC7)

- [x] 2.3 Implement Test 2: Student info from file — create `.student_info` with `STUDENT_NAME=Maria Garcia` / `COURSE=ABC-CYB-101` in mounted volume, run container, call `cargar_datos_estudiante`, assert loaded values match file. (R3, AC6)

- [x] 2.4 Implement Test 3: PDF generation — inside container, source `shared/eval.sh` + `shared/units_manifest.sh`, call `cargar_datos_estudiante` then `generar_pdf_reto "unit-I-asset" 1 "📋"`, assert file exists at `~/laboratorio/units/i-asset-classification/certs/reto_1.pdf`, non-empty with `%PDF-` header. (R5, R6, AC3, AC8)

- [x] 2.5 Implement Test 4: verify.sh inside container — run `bash verify.sh` inside built container, assert exit code 0 and output contains "All verification checks PASSED". (AC2)

## Phase 3: Verification

- [x] 3.1 Run `shellcheck` on `verify.sh` and `tests/test_pdf_certificates.sh` — assert no errors (exit ≤ 2). Uses shellcheck from Dockerfile line 50.

- [x] 3.2 Run `bash verify.sh` on host — assert exit 0 (previously failed due to missing `/var/lab-state` (read-only)). (AC1)

- [x] 3.3 Run `bash verify.sh` inside Docker container — assert exit 0 and `/var/lab-state` (read-only) checks pass. (AC2)

- [x] 3.4 Run `bash tests/test_pdf_certificates.sh` — assert all assertions pass and no container or temp dirs remain after exit (trap cleanup verified). (AC3, AC4, AC8)

## Edit Targets (Write Allowed)
- `verify.sh`
- `tests/test_pdf_certificates.sh`

All other paths (`/.dockerenv`, `/var/lab-state`, `/proc/1/cgroup`, `~/laboratorio/...`) are read-only container runtime paths.
