# SDD Spec: pdf-verify-fix — Container-Aware verify.sh + PDF Certificate E2E Test

## Context

`verify.sh` unconditionally checks `/var/lab-state`, a directory created only inside the Docker container (Dockerfile lines 82-87). Running `bash verify.sh` on the host fails. This change makes `verify.sh` container-aware and adds an end-to-end test for the PDF certificate generation pipeline inside the built container.

---

## Requirements (R1-R11)

### R1 — Container detection in verify.sh

**verify.sh** MUST detect when it is running inside a Docker container and gate `/var/lab-state` checks behind that detection. Detection MUST check at least one of: `/.dockerenv` file existence, `/proc/1/cgroup` containing `docker` or `kubepods`, or the `container` environment variable being set.

### R2 — Host fallback in verify.sh

When **verify.sh** runs on the host (not inside a container), it MUST skip the `check_progress_tampering()` check for `/var/lab-state`, log a warning to stderr, and continue evaluating all other checks, exiting 0 if those checks pass.

### R3 — Student info loading from file

**`cargar_datos_estudiante()`** (in `shared/eval.sh`) MUST read `STUDENT_NAME` and `COURSE` from a valid `.student_info` file at `$HOME/laboratorio/.student_info` when the file exists, using `=`-delimited key-value parsing.

### R4 — Student info fallback to defaults

**`cargar_datos_estudiante()`** MUST set `STUDENT_NAME="Estudiante"` and `COURSE="ABC-CYB-101"` when `$HOME/laboratorio/.student_info` does not exist.

### R5 — PDF certificate output path

**`generar_pdf_reto()`** MUST produce a valid PDF file at `$HOME/laboratorio/units/<unit_dir>/certs/reto_<N>.pdf` where `<unit_dir>` is the directory name for the unit and `<N>` is the reto number.

### R6 — PDF certificate content

The PDF produced by **`generar_pdf_reto()`** MUST contain, in its rendered text, the student name (`STUDENT_NAME`), the unit title (`get_unit_title()`), the reto name, and the completion date (ISO 8601 datetime).

### R7 — E2E test builds container image

**`tests/test_pdf_certificates.sh`** MUST build the Docker image from the project `Dockerfile` before running the test pipeline.

### R8 — E2E test runs entrypoint for student info

**`tests/test_pdf_certificates.sh`** MUST run the container entrypoint (`/entrypoint.sh`) so that student information is collected (either via `$HOME/laboratorio/.student_info` or the interactive prompts piped with defaults).

### R9 — E2E test simulates reto completion

**`tests/test_pdf_certificates.sh`** MUST trigger reto completion by invoking `marcar_completado()` followed by `generar_pdf_reto()` for a valid CORE unit reto inside the running container.

### R10 — E2E test asserts PDF existence and content

**`tests/test_pdf_certificates.sh`** MUST assert that the PDF file exists at the expected path AND contains the student name and unit title as verified text.

### R11 — E2E test cleans up resources

**`tests/test_pdf_certificates.sh`** MUST remove the test container (`docker rm -f`) and all temporary directories created during the test, using a `trap` on `EXIT` to guarantee cleanup regardless of test outcome.

---

## Scenarios (Given/When/Then)

### Scenario: verify.sh exits 0 inside Docker container

- **GIVEN** the test environment is a Docker container (detected via `/.dockerenv`, `/proc/1/cgroup`, or `container` env var)
- **AND** `/var/lab-state` exists with correct ownership (root) and permissions (0750)
- **AND** `/var/lab-state/progress` exists with correct ownership (root:sudo) and permissions (0640)
- **WHEN** `bash verify.sh` is executed inside the container
- **THEN** `check_progress_tampering()` MUST validate the state directory and progress file
- **AND** `verify.sh` MUST exit with code 0 (if all checks pass)

### Scenario: verify.sh skips container checks on host

- **GIVEN** the test environment is a host system (not inside Docker)
- **AND** `/var/lab-state` does not exist
- **WHEN** `bash verify.sh` is executed on the host
- **THEN** `check_progress_tampering()` MUST log a warning about skipping container-only state checks
- **AND** `check_progress_tampering()` MUST return 0 (no failure)
- **AND** `verify.sh` MUST continue evaluating all other checks (container escape, sudo escalation, image poisoning, Dockerfile references, manifest totals)
- **AND** `verify.sh` MUST exit with code 0 (if all non-container checks pass)

### Scenario: cargar_datos_estudiante reads from .student_info file

- **GIVEN** a file `$HOME/laboratorio/.student_info` exists containing `STUDENT_NAME=Maria Garcia` and `COURSE=ABC-CYB-101`
- **WHEN** `cargar_datos_estudiante()` is called
- **THEN** `STUDENT_NAME` MUST be set to `Maria Garcia`
- **AND** `COURSE` MUST be set to `ABC-CYB-101`

### Scenario: cargar_datos_estudiante falls back to defaults

- **GIVEN** `$HOME/laboratorio/.student_info` does not exist
- **WHEN** `cargar_datos_estudiante()` is called
- **THEN** `STUDENT_NAME` MUST be set to `Estudiante`
- **AND** `COURSE` MUST be set to `ABC-CYB-101`

### Scenario: generar_pdf_reto produces PDF at expected path

- **GIVEN** the container is running with `$HOME/laboratorio` mounted
- **AND** `cargar_datos_estudiante()` has been called (student info loaded)
- **AND** a valid unit name and reto number are provided to `generar_pdf_reto()`
- **WHEN** `generar_pdf_reto()` is called
- **THEN** a file MUST exist at `$HOME/laboratorio/units/<unit_dir>/certs/reto_<N>.pdf`
- **AND** the file MUST be a non-empty PDF (valid PDF header or non-zero size)

### Scenario: PDF contains expected content

- **GIVEN** `generar_pdf_reto()` has successfully generated a PDF
- **WHEN** the PDF content is extracted (e.g., via `pdftotext` or `strings`)
- **THEN** the extracted text MUST contain the student name (`STUDENT_NAME`)
- **AND** the extracted text MUST contain the unit title
- **AND** the extracted text MUST contain the reto name
- **AND** the extracted text MUST contain the completion date

### Scenario: E2E test builds container image

- **GIVEN** the test script `tests/test_pdf_certificates.sh` starts execution
- **WHEN** the test initiates the container build phase
- **THEN** `docker build` MUST be invoked using the project `Dockerfile`
- **AND** the build MUST complete successfully before proceeding to the test pipeline

### Scenario: E2E test collects student info via entrypoint

- **GIVEN** the container image has been built
- **WHEN** the test runs the container with the entrypoint (`/entrypoint.sh`)
- **THEN** the entrypoint MUST execute and create `$HOME/laboratorio/.student_info` if it does not exist (with default or piped values)
- **AND** `STUDENT_NAME` and `COURSE` environment variables MUST be set after entrypoint execution

### Scenario: E2E test simulates reto completion

- **GIVEN** the container is running with student info loaded
- **AND** a CORE unit reto is selected (e.g., Unit 1 Reto 1)
- **WHEN** the test invokes `marcar_completado()` followed by `generar_pdf_reto()` for that reto
- **THEN** the progress file is updated to mark the reto as completed
- **AND** the PDF certificate generation function is called and returns success

### Scenario: E2E test asserts PDF exists with expected content

- **GIVEN** reto completion has been triggered via `marcar_completado()` + `generar_pdf_reto()`
- **WHEN** the test checks for the PDF artifact
- **THEN** the test MUST assert the PDF file exists at the expected path using `assert_file_exists`
- **AND** the test MUST assert the PDF contains the student name using `assert_file_contains`
- **AND** the test MUST assert the PDF contains the unit title using `assert_file_contains`

### Scenario: E2E test cleans up container and temp resources

- **GIVEN** the E2E test has completed (pass or fail)
- **WHEN** the test script receives `EXIT` signal (via `trap`)
- **THEN** the test MUST execute `docker rm -f` on the test container
- **AND** the test MUST remove all temporary directories created during the test (e.g., `$HOME/laboratorio` temp copy, temp state files)
- **AND** no container or temp directory MUST remain after the test exits

---

## Acceptance Criteria

| ID | Criterion | Maps To |
|----|-----------|---------|
| AC1 | `bash verify.sh` exits 0 on the host (previously failed) | R2 |
| AC2 | `bash verify.sh` exits 0 inside the container (existing behavior preserved) | R1 |
| AC3 | `bash tests/test_pdf_certificates.sh` passes: PDF generated with student name and unit name present | R5, R6, R10 |
| AC4 | Test cleans up all containers and temp dirs (no leaks after run) | R11 |
| AC5 | No changes to `shared/eval.sh`, `docker-compose.yml`, `Dockerfile`, or unit content | Scope |
| AC6 | `cargar_datos_estudiante()` reads valid `.student_info` file correctly | R3 |
| AC7 | `cargar_datos_estudiante()` falls back to defaults when file missing | R4 |
| AC8 | E2E test uses existing assertion helpers (`assert_file_exists`, `assert_file_contains`, `assert_exit_code`) | R10 |

---

## Scope Constraints

**In Scope:**
- `verify.sh` container detection and gated `/var/lab-state` checks
- `tests/test_pdf_certificates.sh` new E2E test
- Reuse of existing assertion helpers from `tests/metrics_e2e_test.sh` and `shared/validators.sh`

**Out of Scope:**
- `shared/eval.sh` PDF generation logic (pandoc, pdflatex, emoji sanitization)
- `docker-compose.yml` profiles, capabilities, volume definitions
- New unit development or reto content
- Quarto/ebook content (separate `ebook` spec)

---

## Rollback Plan

1. `git rm tests/test_pdf_certificates.sh` → removes E2E test
2. `git checkout HEAD -- verify.sh` → restores unconditional `/var/lab-state` checks
3. No data migration needed — no production behavior or config changed
