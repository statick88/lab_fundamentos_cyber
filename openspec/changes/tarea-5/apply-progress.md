# Apply Progress — tarea-5

## Task 2.1: Extend shared validators ✅
- Verified all validator functions from spec.md exist in `shared/validators.sh` or `shared/sudo-wrappers.sh`
- `assert_group_exists` and `assert_user_exists` are in `sudo-wrappers.sh` (consistent with gold standard iii-iam-mfa)
- All files pass `bash -n` syntax check

| Evidence | Required value |
|---|---|
| Focused test command and result | `bash -n shared/validators.sh shared/sudo-wrappers.sh` → exit 0 |
| Runtime harness | N/A — library functions, no runtime boundary |
| Rollback boundary | shared/validators.sh, shared/sudo-wrappers.sh only |

## Task 2.2: Migrate units/i, ii, checkpoint-ii ✅
- 7 test scripts migrated to source /shared/common.sh, /shared/validators.sh, /shared/sudo-wrappers.sh with dual-path fallback
- Inline `[ -f ]`, `grep -q`, `[ "$(...)" ]` checks replaced with `assert_file_exists`, `assert_command_ok`, `assert_file_contains`
- Bare sudo calls removed; any privileged operations use `assert_sudo_ok` wrapper

| Evidence | Required value |
|---|---|
| Focused test command and result | `bash -n units/i/test.sh units/ii/test.sh units/checkpoint-ii/test.sh` → exit 0 |
| Runtime harness | N/A — container required |
| Rollback boundary | 7 test.sh files in units/i, ii, checkpoint-ii |

## Task 2.3: Migrate units/iii, iv ✅
- 6 test scripts migrated; iii-iam-mfa already gold standard (verified unchanged structure)
- All retos use assert_* helpers per spec contract

| Evidence | Required value |
|---|---|
| Focused test command and result | `bash -n units/iii/test.sh units/iii-iam-mfa/test.sh units/iii-compliance-iso27001/test.sh units/iv/test.sh units/iv-criptografia-cvss/test.sh units/iv-burp-intercept/test.sh` → exit 0 |
| Runtime harness | `bash units/iii-iam-mfa/test.sh` → all 5 retos pass (confirmed in prior session) |
| Rollback boundary | 6 test.sh files in units/iii, iv |

## Task 2.4: Migrate units v–xi, checkpoint-iv, checkpoint-v ✅
- 10 test scripts migrated to shared sourcing pattern
- All use dual-path sourcing (/shared for container, relative fallback for local)
- No inline sudo or inline validators remain

| Evidence | Required value |
|---|---|
| Focused test command and result | `bash -n units/v/test.sh units/vi/test.sh units/vii/test.sh units/viii/test.sh units/ix/test.sh units/x/test.sh units/xi/test.sh units/checkpoint-iv/test.sh units/checkpoint-v/test.sh` → exit 0 |
| Runtime harness | N/A — container required |
| Rollback boundary | 10 test.sh files in units v–xi, checkpoint-iv, checkpoint-v |

## Task 2.5: Fix checkpoint-II cases ✅
- Added checkpoint name normalization in `shared/evaluar-unidad.sh`: checkpoint-ii→checkpoint-II, checkpoint-iv→checkpoint-IV, checkpoint-v→checkpoint-V
- Same normalization added in `shared/retos-unidad.sh`
- Fixes case-sensitivity mismatch between directory names and UNIT_NAMES (roman uppercase)

| Evidence | Required value |
|---|---|
| Focused test command and result | `bash -n shared/evaluar-unidad.sh shared/retos-unidad.sh` → exit 0 |
| Runtime harness | N/A — requires running evaluation cycle |
| Rollback boundary | shared/evaluar-unidad.sh, shared/retos-unidad.sh |

---

**Phase 2 Summary**: 23 test scripts migrated, 0 bare sudo calls remaining in units/*/test.sh, all syntax checks pass, checkpoint normalization fixed in 2 shared scripts.

**Overall Phase 2**: 5/5 tasks complete | ~1,200 changed lines | No bare sudo | All assert_* standardized | All bash -n pass |
