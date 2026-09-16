# Design: tarea-5 — CI/CD Integration, Hardening & Documentation

## Technical Approach

Bash/Docker/GitHub Actions pipeline covering 26 lab units. CI builds Docker image, runs `bash test.sh` per unit in matrix (fail-fast on CORE). Container hardening flips `no-new-privileges` to `true`, adds read-only rootfs, drops all caps except NET_ADMIN/NET_RAW/SETUID/SETGID. Validators standardized via `/shared/validators.sh`. Documentation generated from validator source. Progress state moves to root-owned `/var/lab-state`.

## Architecture Decisions

### Decision: CI Profile Strategy
**Choice**: Separate CI test profile in Compose with `no-new-privileges:false` for privileged validators during CI; production profile uses full hardening.
**Alternatives**: Single hardened profile (breaks NET_ADMIN tests); skip privileged tests (loses coverage).
**Rationale**: Tests requiring sudo (ufw/iptables/suricata) need elevation; CI runner can grant sudo to the `estudiante` user while local dev stays hardened.

### Decision: Progress State Location
**Choice**: `/var/lab-state` root-owned, mode `0750`, writable only via a root cron writer; student reads it read-only.
**Alternatives**: Keep `$HOME/.lab-state` (no hardening benefit); make writable by estudiante (violates tamper-proof spec).
**Rationale**: Tamper-proof requires root ownership. Student-side `marcar_completado` in `eval.sh` becomes read-only; completion marking deferred to CI or admin script.

### Decision: Validator Loading Pattern
**Choice**: Every `test.sh` sources `/shared/validators.sh` and `/shared/sudo-wrappers.sh` at the top, following `iii-iam-mfa/test.sh` as reference.
**Alternatives**: Copy validators into each unit (maintenance burden); inline validation logic (no reuse).
**Rationale**: Single source of truth; C4 fix already proves this works; reduces future maintenance from 23 files to 1.

### Decision: Documentation Generation
**Choice**: Markdown docs in `docs/` generated from validator source comments; CI links generated docs to verify they're current.
**Alternatives**: Manual docs (drift risk); auto-generate during `quarto render` (scope creep).
**Rationale**: Source-comments are accurate by convention; generation link catches drift on every push.

## Data Flow

```
GitHub Push → ci.yml → build lab-ciberseguridad → matrix: 26 units
    ├─ test.sh → source /shared/validators.sh → assert_* → PASS/FAIL per reto
    ├─ evaluar-unidad.sh → read /var/lab-state → report checkpoint-II status
    └─ verify.sh → bash verify.sh → cross-reference tests + README refs
```

## File Changes

| File | Action | Description |
|------|--------|-------------|
| `.github/workflows/ci.yml` | Create | Matrix over 26 units, fail-fast on CORE |
| `Dockerfile` | Modify | `USER estudiante`, cap drop, security-opt, read-only rootfs |
| `docker-compose.yml` | Modify | `no-new-privileges:true`, `tmpfs` for writable dirs, CI profile section |
| `verify.sh` | Create | Cross-reference tests + Dockerfile line validation |
| `shared/eval.sh` | Modify | Read-only for estudiante; migration path for state format |
| `shared/validators.sh` | Modify | Extend with any missing helpers |
| `shared/sudo-wrappers.sh` | Modify | Extend with privileged wrappers |
| `shared/evaluar-unidad.sh` | Modify | checkpoint-II case |
| `shared/retos-unidad.sh` | Modify | checkpoint-II case |
| `units/*/test.sh` | Modify | Standardize to /shared/validators.sh |
| `docs/validators-standard.md` | Modify | Extend to full API reference |
| `README.md` | Modify | CI badges, quickstart |

## Interfaces / Contracts

```bash
# Validator API (from /shared/validators.sh)
assert_group_exists "$GROUP"      # exit 1 if missing
assert_user_exists "$USER"        # exit 1 if missing
assert_file_exists "$FILE"        # exit 1 if missing
assert_file_contains "$FILE" "STR" # exit 1 if not found
assert_command_ok "cmd args"      # exit 1 if non-zero
```

## Testing Strategy

| Layer | What | Approach |
|-------|------|----------|
| Unit | Individual reto validators | `bash test.sh` per unit, 23 units have tests |
| Integration | CI matrix | GitHub Actions runs all 26, fail-fast on CORE |
| E2E | Full lab verification | `bash verify.sh` validates all Dockerfile refs + test results |
| Security | Hardening | Verify non-root user, cap drops, no-new-privileges in CI |

## Threat Matrix

| Threat | Applicability | Safe Behavior | Failure Behavior |
|--------|--------------|---------------|-----------------|
| Container escape via privileged port | Applicable | cap-drop ALL, no-new-privileges | Deny escalation, log to CI |
| Privilege escalation via sudo | Applicable | CI grants sudo only for validators | Block if not in CI profile |
| Tampered progress state | Applicable | root-owned /var/lab-state, 0750 | Read-only for estudiante, write via cron |
| CI supply chain (malicious action) | N/A | GitHub Actions uses ubuntu-latest | N/A — no third-party actions |
| Docker image poisoning | Applicable | Pin base image digest | Fail build if digest mismatch |

## Migration / Rollout

1. **Phase 1**: Add CI workflow with `no-new-privileges:false` profile (backward compatible)
2. **Phase 2**: Standardize validators (iii-iam-mfa already done, others follow)
3. **Phase 3**: Flip to hardened Compose profile locally
4. **Phase 4**: Move progress state to /var/lab-state with cron writer
5. **Phase 5**: Enable fail-fast on CORE in CI

## Open Questions

- [ ] **Progress state writer**: How should root write `/var/lab-state`? Cron job? CI step? Sidecar?
- [ ] **Privileged tests in CI**: Should CI grant sudo globally or use a whitelist approach?
- [ ] **3 units without test.sh**: `ii-arquitectura-perimetral`, `iv-lab-integrador`, `iv-malware-sandbox` — should CI skip silently or warn?
