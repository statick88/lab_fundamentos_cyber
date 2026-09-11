# SPEC: Audit Fixes — fix-critical-audit-findings

## Phase 1 — Test Integrity (H1: Self-Creating Tests)

**Problem:** `iii-compliance-iso27001/test.sh` and `iii-iam-mfa/test.sh` create the artifacts they then validate, passing even when student did nothing.

**Files:** `units/iii-compliance-iso27001/test.sh`, `units/iii-iam-mfa/test.sh`

**Current behavior:** test.sh runs `setup.sh` (or inline `mkdir`/`cat >`) to create student artifacts, then asserts they exist.

**Required behavior:** Remove all artifact-creation from `test.sh`. Tests MUST only assert — never create. If setup is needed, call `setup.sh` separately before test, but never inline in test functions.

**Acceptance criteria:**
- `grep -c 'mkdir\|cat >\|echo.*>\|touch' units/iii-compliance-iso27001/test.sh` returns 0
- `grep -c 'mkdir\|cat >\|echo.*>\|touch' units/iii-iam-mfa/test.sh` returns 0
- `units/iii-compliance-iso27001/test.sh` still passes when artifacts exist from `setup.sh`
- `units/iii-iam-mfa/test.sh` still passes when artifacts exist from `setup.sh`

---

## Phase 2 — Portability (H2: Hardcoded `/shared/`)

**Problem:** 20 test.sh files source `/shared/common.sh` without fallback. Fails outside container.

**Files:** All `units/*/test.sh` (except `iii-compliance-iso27001` and `iii-iam-mfa` which already have dual-path).

**Current behavior:** `source /shared/common.sh` (no fallback).

**Required behavior:** Dual-path pattern in every test.sh:
```bash
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
fi
```
Same for `validators.sh` and `eval.sh` if sourced.

**Acceptance criteria:**
- `grep -rl 'source /shared/common.sh' units/*/test.sh | wc -l` returns 0 (no bare `/shared/` sources)
- Every `units/*/test.sh` has the dual-path `if [ -f "/shared/common.sh" ]` block
- `units/v-logging-siem-bcp/test.sh` also sources `eval.sh` with dual-path (H10 fix)

---

## Phase 3 — Content & Config

### H4: Broken Heredoc in `units/x/manual.sh`

**File:** `units/x/manual.sh` (line 81–85)

**Current behavior:** Heredoc `EOF` on line 81 closes prematurely, leaving bare text on lines 85–96 outside any quoting.

**Required behavior:** Move `EOF` to end of file (after line 96), or restructure so the RSA/ECC reference text is inside the heredoc.

**Acceptance criteria:**
- `bash -n units/x/manual.sh` exits 0
- The RSA/ECC reference text is still present and readable

### H5: Wrong `TOTAL_RETOS` in `units/x/test.sh`

**File:** `units/x/test.sh` (line 15)

**Current behavior:** `TOTAL_RETOS=15` but `setup.sh` creates only 10 retos, and `test.sh` defines `reto1`–`reto15` but only 10 have validators registered.

**Required behavior:** Either:
- (a) Change `TOTAL_RETOS=10` and remove `reto11`–`reto15` from test.sh, OR
- (b) Add `reto11`–`reto15` to `setup.sh` and register them in validators array

Recommended: option (a) — match test.sh to setup.sh (10 retos).

**Acceptance criteria:**
- `TOTAL_RETOS` in `units/x/test.sh` matches the number of `reto*()` functions defined
- `units/x/evaluar.sh` displays same count as `TOTAL_RETOS`

### H6: Wrong Unit Content in `units/xi/evaluacion.md`

**File:** `units/xi/evaluacion.md`

**Current behavior:** Header says "Unit X — SSL/TLS Certificates" and questions are about PKI/openssl — this is Unit X content duplicated into Unit XI.

**Required behavior:** Replace with "Unit XI — Backup & Recovery" evaluation questions covering tar, gzip, rsync, cron-based backup, restore verification.

**Acceptance criteria:**
- `units/xi/evaluacion.md` header says "Unit XI" and topic matches backup/recovery
- No references to SSL/TLS/openssl in `units/xi/evaluacion.md`

### H7: Log-Before-Delete Ordering in `units/viii/test.sh`

**File:** `units/viii/test.sh` (reto9, ~line 65+)

**Current behavior:** `reto9()` deletes log entries before checking if they were logged (reversed order).

**Required behavior:** Verify log entries exist FIRST, then assert cleanup/deletion.

**Acceptance criteria:**
- In `reto9()`, log-check assertions appear BEFORE deletion assertions
- Test still passes when student has logged and then deleted

### H8: GNU-only `stat` in `units/iv/test.sh`

**File:** `units/iv/test.sh` (line 57)

**Current behavior:** `stat -c "%a"` (GNU stat only, fails on macOS).

**Required behavior:** Cross-platform stat pattern:
```bash
permisos=$(stat -c "%a" "$path" 2>/dev/null || stat -f "%Lp" "$path" 2>/dev/null)
```

**Acceptance criteria:**
- `units/iv/test.sh` passes on both Linux and macOS (GNU + BSD stat)

### H10: Undefined `eval_log_analysis` in `units/v-logging-siem-bcp/test.sh`

**File:** `units/v-logging-siem-bcp/test.sh` (lines 67, 73, 79)

**Current behavior:** `eval_log_analysis` is called but `shared/eval.sh` is never sourced. Function is undefined — tests silently fail or error.

**Required behavior:** Source `shared/eval.sh` with dual-path at top of test.sh:
```bash
if [ -f "/shared/eval.sh" ]; then
    source /shared/eval.sh
else
    source "$(dirname "$0")/../../shared/eval.sh"
fi
```

**Acceptance criteria:**
- `units/v-logging-siem-bcp/test.sh` sources `eval.sh`
- `type eval_log_analysis` resolves without error when test.sh is loaded

---

## Phase 4 — Validator Infrastructure (H6 partial + completeness)

### Missing `questions.md` (14 units)

**Files:** `units/{checkpoint-ii,checkpoint-iv,checkpoint-v,i-asset-classification,i-risk-assessment,ii-arquitectura-perimetral,ii-firewalls-redes,ii-ids-intrusion-detection,iii-compliance-iso27001,iii-iam-mfa,iv-criptografia-cvss,iv-lab-integrador,iv-malware-sandbox,v-logging-siem-bcp}/questions.md`

**Current behavior:** 14 of 25 units have no `questions.md`.

**Required behavior:** Create `questions.md` for each missing unit with at least 5 multiple-choice questions covering the unit's learning objectives.

**Acceptance criteria:**
- Every `units/*/questions.md` exists
- Each has at least 5 questions with correct answer marked

---

## Coverage Summary

| Phase | Finding | Units Affected | Status |
|-------|---------|---------------|--------|
| 1 | H1: Self-creating tests | iii-compliance-iso27001, iii-iam-mfa | 2 |
| 2 | H2: Hardcoded /shared/ | 20 test.sh files | 20 |
| 3 | H4: Broken heredoc | x | 1 |
| 3 | H5: Wrong TOTAL_RETOS | x | 1 |
| 3 | H6: Wrong eval content | xi | 1 |
| 3 | H7: Log-before-delete | viii | 1 |
| 3 | H8: GNU-only stat | iv | 1 |
| 3 | H10: Missing eval.sh source | v-logging-siem-bcp | 1 |
| 4 | Missing questions.md | 14 units | 14 |
