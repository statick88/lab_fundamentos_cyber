# CI Pipeline Specification

## Purpose
This specification defines the GitHub Actions continuous integration pipeline that builds the `lab-ciberseguridad` Docker image, verifies the build, and executes the test suites for every unit in the ABC-CYB-101 cybersecurity laboratory course.

## Requirements

### Requirement: Workflow Trigger
The CI workflow MUST trigger on push and pull_request events to the `feature/cyb-101-labs` and `main` branches.

#### Scenario: Push to protected branch
- GIVEN a push event to the `feature/cyb-101-labs` branch
- WHEN the workflow is evaluated
- THEN the CI job starts automatically

#### Scenario: Pull request opened
- GIVEN a pull request targeting `main`
- WHEN the CI workflow is triggered
- THEN all build and test steps execute before merge is allowed

### Requirement: Docker Image Build
The workflow MUST build a Docker image tagged `lab-ciberseguridad` from the repository `Dockerfile` using `docker build`.

#### Scenario: Image builds successfully
- GIVEN the Dockerfile is present and valid
- WHEN `docker build -t lab-ciberseguridad .` executes
- THEN the image build completes with exit code 0

#### Scenario: Shared scripts pass syntax lint
- GIVEN the image is built
- WHEN each file in `shared/*.sh` is checked with `bash -n`
- THEN no syntax errors are found and the step exits 0

### Requirement: Build Verification
The workflow MUST run `bash verify.sh` inside the built container to validate the build integrity before executing unit tests.

#### Scenario: Build verification passes
- GIVEN the `lab-ciberseguridad` image is built
- WHEN `bash verify.sh` executes inside the container
- THEN it exits 0 and confirms shared modules and unit manifest load

#### Scenario: Build verification fails on broken image
- GIVEN the container image is malformed
- WHEN `bash verify.sh` executes
- THEN it exits non-zero and the CI job fails

### Requirement: Unit Test Matrix
The workflow MUST define a matrix strategy over all 26 unit directories listed in `UNIT_DIRS` of `shared/units_manifest.sh`.

#### Scenario: All 26 units in matrix
- GIVEN the units manifest defines 26 unit directories
- WHEN the matrix is constructed
- THEN it contains exactly 26 entries

#### Scenario: Unit without test.sh is skipped
- GIVEN a unit directory has no `test.sh` file
- WHEN the test step runs for that matrix entry
- THEN it skips the unit and does not report a failure

### Requirement: Per-Unit Test Execution
For each unit in the matrix that has a `test.sh`, the workflow MUST run `bash test.sh` and report PASS or FAIL.

#### Scenario: Unit test suite passes
- GIVEN a unit has a valid `test.sh`
- WHEN `bash <unit>/test.sh` executes
- THEN the step exits 0 and is reported as PASS

#### Scenario: Unit test suite fails
- GIVEN a unit's `test.sh` contains failing validators
- WHEN the test executes
- THEN the step exits non-zero and is reported as FAIL

### Requirement: Fail-Fast on CORE Retos
The workflow MUST fail-fast when any CORE unit's test suite fails. CORE units are the 9 units whose retos total 85, as defined by `UNIT_CORE` flags in `units_manifest.sh`.

#### Scenario: CORE unit failure stops CI
- GIVEN a CORE unit (e.g., unit-I) test suite fails
- WHEN the matrix job completes with a failure
- THEN the overall CI run is marked failed

#### Scenario: OPT unit failure does not block
- GIVEN an OPT unit test suite fails
- WHEN all CORE units pass
- THEN the CI run is marked passing with non-blocking warnings

### Requirement: Per-Unit Reporting
The workflow MUST produce a structured report listing each unit's PASS/FAIL status, the total reto count (243), and the CORE reto count (85).

#### Scenario: Report generated after test run
- GIVEN all matrix jobs complete
- WHEN the reporting step executes
- THEN it outputs a summary table with unit name, status, and reto counts
