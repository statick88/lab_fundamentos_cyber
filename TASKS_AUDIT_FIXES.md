# Tasks: Audit Fixes — fix-critical-audit-findings

## Review Workload Forecast

| Field | Value |
|-------|-------|
| Estimated changed lines | 300-450 |
| 400-line budget risk | Medium |
| Chained PRs recommended | Yes |
| Suggested split | PR 1 (Batches 1+3: H1, H4, H5, H6, H7, H8, H10) → PR 2 (Batch 2: H2 portability) → PR 3 (Batch 4: H10 missing questions) |
| Delivery strategy | auto-chain |
| Chain strategy | stacked-to-main |

Decision needed before apply: No
Chained PRs recommended: Yes
Chain strategy: stacked-to-main
400-line budget risk: Medium

---

## Batch 1: Test Integrity + Critical Content Fixes

**Goal:** Fix all correctness bugs that break tests or produce wrong behavior
**Likely PR:** PR 1
**Focused test command:** `bash -n units/*/test.sh && bash units/iii-compliance-iso27001/test.sh && bash units/iii-iam-mfa/test.sh`
**Runtime harness:** N/A — tests run locally
**Rollback boundary:** Revert PR 1 reverts Batches 1+3

### T1: Remove self-creating artifact code from iii-compliance-iso27001/test.sh
- [ ] T1.1 Remove `mkdir -p`, `cat >`, `echo >` from `reto1()` and `reto2()` in `units/iii-compliance-iso27001/test.sh`
- [ ] T1.2 Verify: `grep -c 'mkdir\|cat >\|echo.*>\|touch' units/iii-compliance-iso27001/test.sh` returns 0
- [ ] T1.3 Verify: `bash -n units/iii-compliance-iso27001/test.sh` exits 0

### T2: Remove self-creating artifact code from iii-iam-mfa/test.sh
- [ ] T2.1 Remove `mkdir -p`, `cat >`, `echo >` from `reto2()` in `units/iii-iam-mfa/test.sh`
- [ ] T2.2 Verify: `grep -c 'mkdir\|cat >\|echo.*>\|touch' units/iii-iam-mfa/test.sh` returns 0
- [ ] T2.3 Verify: `bash -n units/iii-iam-mfa/test.sh` exits 0

### T3: Fix log-before-delete ordering in viii/test.sh
- [ ] T3.1 In `reto9()`, move log-check assertions BEFORE deletion assertions in `units/viii/test.sh`
- [ ] T3.2 Verify: `bash -n units/viii/test.sh` exits 0

### T4: Fix GNU-only stat in iv/test.sh
- [ ] T4.1 Replace `stat -c "%a"` with cross-platform pattern in `units/iv/test.sh` line 57
- [ ] T4.2 Verify: `bash -n units/iv/test.sh` exits 0

### T5: Fix undefined eval_log_analysis in v-logging-siem-bcp/test.sh
- [ ] T5.1 Add dual-path sourcing of `shared/eval.sh` to `units/v-logging-siem-bcp/test.sh`
- [ ] T5.2 Verify: `type eval_log_analysis` resolves without error

---

## Batch 2: Portability Fixes

**Goal:** Make all test.sh files portable (work outside container)
**Likely PR:** PR 2
**Focused test command:** `grep -rl 'source /shared/common.sh' units/*/test.sh | wc -l` returns 0
**Runtime harness:** N/A
**Rollback boundary:** Revert PR 2 only

### T6: Add dual-path common.sh to files missing it
- [ ] T6.1 Add `if [ -f "/shared/common.sh" ]; then ... else ... fi` pattern to:
  - `units/iii/test.sh`
  - `units/ii/test.sh`
  - `units/v/test.sh`
  - `units/ix/test.sh`
  - `units/xi/test.sh`
  - `units/x/test.sh`
  - `units/vi/test.sh`
- [ ] T6.2 Verify: `grep -rl 'source /shared/common.sh' units/*/test.sh | wc -l` returns 0

### T7: Add dual-path validators.sh to files missing it
- [ ] T7.1 Add `if [ -f "/shared/validators.sh" ]; then ... else ... fi` pattern to:
  - `units/iii/test.sh`
  - `units/x/test.sh`
  - `units/v/test.sh`
  - `units/ix/test.sh`
  - `units/xi/test.sh`
  - `units/ii/test.sh`
  - `units/vi/test.sh`
- [ ] T7.2 Verify: `grep -rl 'source /shared/validators.sh' units/*/test.sh | wc -l` returns 0

### T8: Add dual-path sudo-wrappers.sh to iv and vi
- [ ] T8.1 Add dual-path sourcing of `shared/sudo-wrappers.sh` to `units/iv/test.sh` and `units/vi/test.sh`
- [ ] T8.2 Verify: `grep -rl 'source /shared/sudo-wrappers.sh' units/*/test.sh | wc -l` returns 0

---

## Batch 3: Content & Config Fixes

**Goal:** Fix all content and configuration bugs
**Likely PR:** PR 1 (same as Batch 1)
**Runtime harness:** N/A
**Rollback boundary:** Revert PR 1

### T9: Fix broken heredoc in x/manual.sh
- [ ] T9.1 Move `EOF` from line 81 to end of file in `units/x/manual.sh`
- [ ] T9.2 Verify: `bash -n units/x/manual.sh` exits 0
- [ ] T9.3 Verify: RSA/ECC reference text is still present

### T10: Fix TOTAL_RETOS mismatch in x/test.sh
- [ ] T10.1 Change `TOTAL_RETOS=15` to `TOTAL_RETOS=10` and remove `reto11`–`reto15` definitions from `units/x/test.sh`
- [ ] T10.2 Update validators array to only include reto1–reto10
- [ ] T10.3 Verify: `TOTAL_RETOS` matches `reto*()` function count

### T11: Replace wrong content in xi/evaluacion.md
- [ ] T11.1 Replace SSL/TLS content in `units/xi/evaluacion.md` with backup/recovery topic (tar, gzip, rsync, cron-based backup, restore verification)
- [ ] T11.2 Verify: No references to SSL/TLS/openssl remain

---

## Batch 4: Missing questions.md

**Goal:** Create questions.md for 14 missing units
**Likely PR:** PR 3
**Runtime harness:** `bash units/*/test.sh` (after test integrity fixes)
**Rollback boundary:** Revert PR 3 only

### T12: Create questions.md for batch-a units
- [ ] T12.1 Create `units/checkpoint-ii/questions.md` (5+ MC questions)
- [ ] T12.2 Create `units/checkpoint-iv/questions.md`
- [ ] T12.3 Create `units/checkpoint-v/questions.md`
- [ ] T12.4 Create `units/i-asset-classification/questions.md`
- [ ] T12.5 Create `units/i-risk-assessment/questions.md`
- [ ] T12.6 Create `units/ii-arquitectura-perimetral/questions.md`
- [ ] T12.7 Verify: Each file has at least 5 questions with correct answer marked

### T13: Create questions.md for batch-b units
- [ ] T13.1 Create `units/ii-firewalls-redes/questions.md` (5+ MC questions)
- [ ] T13.2 Create `units/ii-ids-intrusion-detection/questions.md`
- [ ] T13.3 Create `units/iii-compliance-iso27001/questions.md`
- [ ] T13.4 Create `units/iii-iam-mfa/questions.md`
- [ ] T13.5 Create `units/iv-criptografia-cvss/questions.md`
- [ ] T13.6 Create `units/iv-lab-integrador/questions.md`
- [ ] T13.7 Create `units/iv-malware-sandbox/questions.md`
- [ ] T13.8 Create `units/v-logging-siem-bcp/questions.md`
- [ ] T13.9 Verify: Each file has at least 5 questions with correct answer marked
