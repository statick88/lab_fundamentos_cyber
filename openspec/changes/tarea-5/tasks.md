# Tasks: tarea-5 (5 Tasks SDD Workflow)

## Review Workload Forecast

| Field | Value |
|-------|-------|
| Estimated changed lines | ~2000 (across 5 tasks) |
| 400-line budget risk | High |
| Chained PRs recommended | Yes |
| Delivery strategy | auto-chain |
| Decision needed before apply | Yes |

Decision needed before apply: Yes (split vs. exception)
Chained PRs recommended: Yes
Chain strategy: feature-branch-chain
400-line budget risk: High

### Suggested Work Units (feature-branch-chain topology)

| Unit | Goal | Target PR | Focus | Rollback boundary |
|------|------|-----------|-------|-------------------|
| Task 1 | Tarea 1 - Riesgos y Clasificación | PR 1 (tracker) | units/i-risk-assessment, units/i-asset-classification | Remove task directories |
| Task 2 | Tarea 2 - Firewalls perimetrales | PR 2 | units/ii-firewalls-redes, units/ii-arquitectura-perimetral | Revert firewall configs |
| Task 3 | Tarea 3 - Hardening e IAM/MFA | PR 3 | units/iii-iam-mfa, units/iii-compliance-iso27001 | Revert system changes |
| Task 4 | Tarea 4 - Vulnerabilidades y Cripto | PR 4 | units/iv-criptografia-cvss, units/iv-malware-sandbox | Revert crypto/YARA changes |
| Task 5 | Tarea 5 - Logging, SIEM, BCP | PR 5 (merges to main) | units/v-logging-siem-bcp | Remove logging artifacts |

### Phase Progression

| Phase | Status | Next |
|-------|--------|------|
| proposal | completed | (already exist: task-1-proposal.md through task-5-proposal.md) |
| specs | completed | (already exist: task-1-spec.md through task-5-spec.md) |
| tasks | completed | (already exist: task-1-tasks.md through task-5-tasks.md) |
| apply | pending | Implement 5 tasks via feature-branch-chain |
| verify | pending | Validate implementation against specs |
| archive | pending | Close change and persist final state |

### Task Interfaces

**Task 1 Input**: sdd-tasks/task-1-tasks.md, sdd-specs/task-1-spec.md  
**Task 1 Output**: Completed risk analysis and asset classification in lab environment

**Task 2 Input**: sdd-tasks/task-2-tasks.md, sdd-specs/task-2-spec.md  
**Task 2 Output**: Configured firewall rules, network zone documentation in lab environment

**Task 3 Input**: sdd-tasks/task-3-tasks.md, sdd-specs/task-3-spec.md  
**Task 3 Output**: Hardened system config, IAM/MFA setup, compliance mapping in lab environment

**Task 4 Input**: sdd-tasks/task-4-tasks.md, sdd-specs/task-4-spec.md  
**Task 4 Output**: Cryptography results, malware analysis, vulnerability detection in lab environment

**Task 5 Input**: sdd-tasks/task-5-tasks.md, sdd-specs/task-5-spec.md  
**Task 5 Output**: Logging/SIEM/incident response/BCP documentation in lab environment

### Delivery Strategy "ask-on-risk" Consideration

After sdd-tasks completes, gatekeeper checks delivery strategy:
- Forecast indicates high risk or >400 changed lines equivalent
- STOP and ask whether to split into chained PRs or proceed with size:exception
- For this task: user selected auto-chain with feature-branch-chain, so no ask needed
- If user had selected ask-on-risk: ask whether to split into chained PRs or proceed with size:exception

### Chain Strategy "feature-branch-chain" Detail

When delivery_strategy results in chained PRs:
- PR #1 targets the tracker branch (main)
- PR #2 targets the immediate previous PR branch (PR #1's branch)
- PR #3 targets PR #2's branch
- PR #4 targets PR #3's branch
- PR #5 (tracker) merges to main

This keeps review diffs focused and enables rollback control and coordinated releases.

**Cache**: Cache the chain strategy for the session. Pass it as `chain_strategy` to sdd-tasks and sdd-apply prompts alongside delivery_strategy. Do not ask again unless the user changes scope.