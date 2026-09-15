# OpenSpec SDD Configuration for tarea-5
# 5 Tasks SDD Workflow - Cybersecurity Laboratory

schema: spec-driven

context: |
  Tech stack: Bash, Markdown, Docker, OpenCode
  Architecture: Cybersecurity laboratory with 5 operational security tasks
  Testing: Docker-based validator execution; Strict TDD mode applies where test commands cover all in-scope project objectives
  Style: Professional technical documentation

rules:
  proposal:
    - Include rollback plan for risky changes
  specs:
    - Use Given/When/Then for scenarios
    - Use RFC 2119 keywords (MUST, SHALL, SHOULD, MAY)
  design:
    - Document architecture decisions with rationale
  tasks:
    - Group by phase, use hierarchical numbering
    - Keep tasks completable in one session
  apply:
    guidelines:
      - Follow existing code patterns
      - Validate every tool ref against Dockerfile lines 21-57
    tdd: true
    test_command: "bash test.sh"
  verify:
    test_command: "bash test.sh"
    build_command: "bash verify.sh"
    coverage_threshold: 0
  archive:
    - Warn before merging destructive deltas