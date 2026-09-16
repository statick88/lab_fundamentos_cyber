# Documentation Suite Specification

## Purpose
This specification defines the documentation suite covering all 26 laboratory units, the shared validator API reference, a troubleshooting guide, and a contributor guide.

## Requirements

### Requirement: Per-Unit Documentation
The `docs/` directory MUST contain a markdown guide for each of the 26 unit directories, covering setup instructions, testing procedure, and manual reference.

#### Scenario: Documentation exists for every unit
- GIVEN the units manifest lists 26 units
- WHEN `docs/` is scanned for unit guides
- THEN a markdown file exists for each of the 26 units

#### Scenario: Unit guide covers setup and testing
- GIVEN a unit documentation file
- WHEN it is read by a student
- THEN it contains a "Setup" section and a "Testing" section with the `bash test.sh` command

### Requirement: Shared Validator API Documentation
The `docs/validators-standard.md` document MUST document every public function in `/shared/validators.sh` and `/shared/sudo-wrappers.sh`, including its signature, return contract (0 = PASS, 1 = FAIL), and a usage example.

#### Scenario: Validator reference lists all helpers
- GIVEN the validators-standard document
- WHEN it is parsed for function signatures
- THEN it lists `assert_file_exists`, `assert_file_contains`, `assert_command_ok`, `assert_openssl_chain`, `assert_openssl_subject_matches`, `assert_file_not_exists`, `assert_sudo_ok`, `assert_file_owner`, `assert_mount_active`, `assert_ufw_active`, `assert_user_exists`, `assert_group_exists`, `assert_user_in_group`

#### Scenario: Each helper has a usage example
- GIVEN the validator reference
- WHEN a reader looks up `assert_command_ok`
- THEN an example call with arguments and expected return behavior is provided

### Requirement: Troubleshooting Guide
The `docs/` directory MUST contain a troubleshooting guide covering CI failures, validator failures, container permission issues, and progress-state corruption.

#### Scenario: CI failure diagnosis
- GIVEN a CI run fails on a CORE unit
- WHEN a student reads the troubleshooting guide
- THEN they find steps to reproduce locally via `docker run` with the `lab-ciberseguridad` image

#### Scenario: Validator false failure
- GIVEN a reto validator reports FAIL unexpectedly
- WHEN the student consults the guide
- THEN they find common causes: wrong file path, missing `sudo` wrapper, or stale progress state

### Requirement: Contributor Guide
The repository MUST contain a `CONTRIBUTING.md` that documents the `test.sh` structure (`retoN`, `retoN_info`, `validators` and `challenge_names` arrays), the validator contract (0 = PASS, 1 = FAIL; no sudo; paths under `$HOME/laboratorio`, `/tmp`, `/shared`), and the shared-module sourcing pattern.

#### Scenario: Contributor can add a unit
- GIVEN a new contributor reads `CONTRIBUTING.md`
- WHEN they want to add a new unit
- THEN the guide explains the required `test.sh` function and array conventions

### Requirement: Top-Level README Integration
The `README.md` MUST document the CI pipeline status, the Docker quickstart (`docker compose up -d`), the `bash verify.sh` command, and links to the documentation suite and validator guide.

#### Scenario: README has CI status reference
- GIVEN the README is read at the top
- WHEN it is scanned for CI references
- THEN it references the GitHub Actions workflow and the `bash verify.sh` verification command

#### Scenario: README quickstart section
- GIVEN the README
- WHEN a first-time user reads it
- THEN they find a quickstart section with `docker compose up -d` and the command to enter the container
