# lab-manuals Specification

## Purpose

Define requirements for structured lab manuals in checkpoint units. Ensures each checkpoint provides clear learning objectives, progressive challenges with increasing difficulty, and verifiable deliverables that students can self-check before submission.

## Requirements

### Requirement: Clear learning objectives

Every checkpoint manual MUST open with a numbered list of specific, measurable learning objectives. Objectives MUST use action verbs (identify, configure, analyze, implement) and describe what the student will be able to do after completing the checkpoint.

#### Scenario: Student reads manual opening

- GIVEN a student opens a checkpoint manual.sh
- WHEN the manual displays its introduction
- THEN it MUST present 3-5 numbered learning objectives
- AND each objective MUST start with an action verb
- AND objectives MUST be specific enough to verify completion

#### Scenario: Manual without objectives

- GIVEN a checkpoint manual.sh has no objectives section
- WHEN remediation is applied
- THEN a objectives section MUST be added before the challenges
- AND objectives MUST align with the retos that follow

### Requirement: Progressive challenge structure

Each checkpoint manual MUST present retos in progressive difficulty order: foundational concepts first, applied skills in the middle, synthesis/analysis last. The manual MUST include a brief description for each reto explaining what to do and why it matters.

#### Scenario: Student follows challenge sequence

- GIVEN a checkpoint has 5 retos
- WHEN the student completes reto 1 through reto 5 in order
- THEN each reto MUST build on skills from previous retos
- AND the difficulty MUST increase from reto 1 (easiest) to reto 5 (hardest)

#### Scenario: Challenge description present

- GIVEN the manual lists reto 3
- WHEN the student reads the reto section
- THEN it MUST include a description of the task
- AND it MUST explain the learning purpose of the challenge

### Requirement: Verifiable deliverables

Every reto MUST specify concrete deliverables — files, scripts, configurations, or outputs — that the student must produce. Deliverables MUST be verifiable by the test.sh validators. The manual MUST state where each deliverable should be saved.

#### Scenario: Student completes a reto

- GIVEN reto 2 requires creating a file `analysis.md`
- WHEN the student finishes the challenge
- THEN the manual MUST specify the expected file path
- AND the file MUST be verifiable by a corresponding `assert_*` call in test.sh

#### Scenario: Deliverable path specified

- GIVEN a reto requires a script output
- WHEN the manual describes the deliverable
- THEN it MUST state the exact path (e.g., `~/laboratorio/checkpoints/checkpoint-ii/analysis.md`)
- AND the path MUST match what test.sh validates

### Requirement: Manual-test alignment

Every deliverable mentioned in the manual MUST have a corresponding validator in test.sh. Every validator in test.sh MUST have a corresponding deliverable documented in the manual.

#### Scenario: Manual mentions deliverable not tested

- GIVEN the manual describes reto 3 producing `report.txt`
- WHEN test.sh validates reto 3
- THEN test.sh MUST check for `report.txt` existence or content

#### Scenario: Test validates undocumented deliverable

- GIVEN test.sh reto 4 checks for `config.yaml`
- WHEN the manual describes reto 4
- THEN the manual MUST mention `config.yaml` as an expected deliverable
