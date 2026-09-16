# Progress Persistence Specification

## Purpose
This specification defines the progress-persistence mechanism that tracks per-unit and per-reto completion status in a root-owned, tamper-proof state directory at `/var/lab-state`.

## Requirements

### Requirement: Root-Owned State Directory
The `/var/lab-state` directory MUST be owned by `root:root` with permissions `0755` (read and execute for all, writable only by root).

#### Scenario: Directory exists with correct ownership
- GIVEN the Docker image is built
- WHEN `/var/lab-state` is inspected
- THEN its owner is `root` and its group is `root`

#### Scenario: Non-root user cannot create files
- GIVEN a non-root user (`estudiante`)
- WHEN they attempt to create a file in `/var/lab-state`
- THEN the write is denied with a permission error

### Requirement: Tamper-Proof Progress File
The progress file `/var/lab-state/progress` MUST be owned by `root:sudo` with permissions `0640` (readable by the `sudo` group, writable only by root).

#### Scenario: Progress file resists tampering
- GIVEN the progress file exists at `/var/lab-state/progress`
- WHEN the `estudiante` user attempts to modify it directly
- THEN the write is denied

#### Scenario: Root can append progress entries
- GIVEN a validator returns success
- WHEN `marcar_completado` appends to the progress file
- THEN a new line in the format `unit-ID:reto:N` is added

### Requirement: Per-Reto Completion Tracking
The progress file MUST store one line per completed reto in the format `unit-ID:reto:N`, supporting `esta_completado` (check) and `contar_completados` (count) queries.

#### Scenario: Completing a reto marks it
- GIVEN a reto validator returns success
- WHEN `marcar_completado "unit-ID" "N"` is called
- THEN the line `unit-ID:reto:N` exists in the progress file

#### Scenario: Checking an unmarked reto fails
- GIVEN a reto has not been completed
- WHEN `esta_completado "unit-ID" "N"` is called
- THEN it returns a non-zero exit code

### Requirement: Per-Unit Progress Summary
The system MUST compute the completion count and total retos per unit, enabling a global progress summary across all 26 units and 243 retos (85 CORE).

#### Scenario: Unit completion count computed
- GIVEN a unit has 10 total retos and 7 are marked
- WHEN `contar_completados "unit-ID" 10` is called
- THEN it returns 7

#### Scenario: Global progress reflects all units
- GIVEN progress is tracked across multiple units
- WHEN a global summary is generated
- THEN the total of 243 retos and 85 CORE retos is computed

### Requirement: Non-Root Read Access
Non-root users MUST be able to read the progress file for reporting purposes, without being able to modify it.

#### Scenario: estudiante reads progress via sudo group
- GIVEN `estudiante` belongs to the `sudo` group
- WHEN they read `/var/lab-state/progress`
- THEN the file contents are displayed

#### Scenario: Idempotent completion marking
- GIVEN a reto is already marked complete
- WHEN `marcar_completado` is called again with the same unit and reto
- THEN no duplicate line is appended to the progress file
