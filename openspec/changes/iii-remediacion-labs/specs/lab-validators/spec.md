# lab-validators Specification

## Purpose

Define requirements for deterministic test validators in unit test.sh files. Ensures every reto (challenge) has at least one `assert_*` call that checks concrete artifacts — files, content, commands — rather than superficial shell conditionals. Aligns all units with the gold standard pattern established by `iii-compliance-iso27001/test.sh`.

## Requirements

### Requirement: Assert-based validation per reto

Each reto function in a unit's test.sh MUST contain at least one `assert_*` call from `shared/validators.sh`. Validators MUST check concrete artifacts (files exist, files contain patterns, commands succeed) rather than raw shell conditionals like `[ -f ... ]` or `[ -d ... ]`.

#### Scenario: Reto with file existence check

- GIVEN a unit's test.sh defines a reto that validates a student-created file
- WHEN the reto function executes
- THEN it MUST call `assert_file_exists` with the expected file path
- AND it MUST NOT use bare `[ -f "$file" ]` as the sole check

#### Scenario: Reto with file content check

- GIVEN a unit's test.sh defines a reto that validates file content
- WHEN the reto function executes
- THEN it MUST call `assert_file_contains` with the file path and expected pattern
- AND it MUST NOT use bare `grep -q` as the sole check

#### Scenario: Reto with command success check

- GIVEN a unit's test.sh defines a reto that validates a command runs successfully
- WHEN the reto function executes
- THEN it MUST call `assert_command_ok` with the command and arguments
- AND it MUST NOT use bare `command -v` or `"$@" >/dev/null 2>&1` as the sole check

#### Scenario: Reto with no matching artifact type

- GIVEN a reto validates a concept or system state not representable as a file or command
- WHEN the reto function executes
- THEN it MAY use a direct shell check with an inline comment explaining why `assert_*` is not applicable
- AND it MUST still return 0 on success and 1 on failure

### Requirement: Validators library sourcing

Every test.sh that uses `assert_*` calls MUST source `shared/validators.sh` via the dual-path pattern (container `/shared` or relative `../../shared`). The sourcing block MUST appear before any reto function definition.

#### Scenario: Container environment sourcing

- GIVEN the test.sh runs in a container where `/shared/validators.sh` exists
- WHEN the script sources the library
- THEN it MUST resolve to `/shared/validators.sh`

#### Scenario: Local environment sourcing

- GIVEN the test.sh runs locally where `../../shared/validators.sh` exists relative to the unit directory
- WHEN the script sources the library
- THEN it MUST resolve to the relative path from the script's directory

#### Scenario: Missing validators library

- GIVEN `shared/validators.sh` does not exist at either path
- WHEN the script sources the library
- THEN the script MUST fail with a clear error message before any reto executes

### Requirement: Gold standard structural parity

All units MUST follow the structural pattern of `iii-compliance-iso27001/test.sh`: sourced libraries, `UNIT_NAME`, `TOTAL_RETOS`, reto functions with `assert_*` calls, `validators=()` array, `challenge_names=()` array, `ICONOS=()` array, `retoN_info()` functions, and standalone execution block.

#### Scenario: New unit added to course

- GIVEN a new unit is created for ABC-CYB-101
- WHEN its test.sh is authored
- THEN it MUST include all structural elements from the gold standard
- AND every reto MUST have at least one `assert_*` call

#### Scenario: Existing unit remediated

- GIVEN an existing unit has retos with zero `assert_*` calls
- WHEN remediation is applied
- THEN each reto MUST gain at least one `assert_*` call
- AND existing passing behavior MUST NOT be broken (additive only)
