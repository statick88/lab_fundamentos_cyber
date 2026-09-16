# Validator Standardization Specification

## Purpose
This specification standardizes all unit `test.sh` validators on the shared `/shared/validators.sh` and `/shared/sudo-wrappers.sh` function libraries, with `units/iii-iam-mfa/test.sh` as the reference (gold-standard) implementation.

## Requirements

### Requirement: Source Shared Validator Libraries
Every `test.sh` file MUST source `/shared/common.sh`, `/shared/validators.sh`, and `/shared/sudo-wrappers.sh` at the top.

#### Scenario: Validators sourced on module load
- GIVEN any unit's `test.sh` is loaded
- WHEN the source directives execute
- THEN `assert_file_exists`, `assert_group_exists`, and `assert_user_exists` are available as callable functions

#### Scenario: Fallback path resolution
- GIVEN the container mounts shared modules at `/shared`
- WHEN `test.sh` is executed inside or outside the container
- THEN shared paths resolve to `/shared/*.sh` or the relative fallback without error

### Requirement: Use Standard Assertion Functions
All `retoN()` validator functions MUST use `assert_file_exists`, `assert_file_contains`, `assert_command_ok`, `assert_file_not_exists`, and `assert_openssl_*` helpers instead of inline `[ -f ]`, `grep -q`, or `[ "$(...)" ]` comparisons.

#### Scenario: File existence check uses standard helper
- GIVEN a reto validates a student-created file exists
- WHEN the validator runs
- THEN it calls `assert_file_exists "$filepath"` returning 0 on success

#### Scenario: Content check uses standard helper
- GIVEN a reto validates a config file contains a directive
- WHEN the validator runs
- THEN it calls `assert_file_contains "$file" "$pattern"` returning 0 on match

### Requirement: Use Sudo Wrappers for Privileged Operations
Validators that require elevated privileges MUST use `/shared/sudo-wrappers.sh` helpers (`assert_sudo_ok`, `assert_file_owner`, `assert_mount_active`, `assert_ufw_active`, `assert_user_in_group`) instead of direct `sudo` or `su` calls inside the validator body.

#### Scenario: User existence check via wrapper
- GIVEN a reto validates a system user was created
- WHEN the validator runs
- THEN it calls `assert_user_exists "username"` returning 0

#### Scenario: Sudo command wrapped
- GIVEN a reto executes a privileged command
- WHEN the validator runs
- THEN it calls `assert_sudo_ok <command>` rather than a bare `sudo <command>`

### Requirement: Reference Implementation Compliance
The `iii-iam-mfa/test.sh` MUST serve as the canonical pattern: it sources both shared libraries, uses `assert_file_exists`/`assert_file_contains`/`assert_command_ok` in `retoN()` validators, and defines `validators` and `challenge_names` arrays.

#### Scenario: New unit matches reference structure
- GIVEN a unit's `test.sh` is migrated to shared validators
- WHEN it is loaded
- THEN it defines `UNIT_NAME`, `TOTAL_RETOS`, `validators`, `challenge_names`, and `ICONOS` arrays

#### Scenario: iii-iam-mfa passes standalone
- GIVEN the container is running as `estudiante`
- WHEN `bash units/iii-iam-mfa/test.sh` executes
- THEN all 5 retos evaluate with exit code 0 and no sourcing errors

### Requirement: No Direct Privilege Escalation in Validators
No `test.sh` validator MUST contain inline `sudo`, `su`, `chmod +s`, or `chown root` calls outside of the sudo-wrappers library function bodies.

#### Scenario: Static scan finds no bare sudo
- GIVEN all `test.sh` files in the repository
- WHEN each is scanned for bare `sudo` calls in `retoN()` bodies
- THEN no direct `sudo` invocation is found outside wrapper functions
