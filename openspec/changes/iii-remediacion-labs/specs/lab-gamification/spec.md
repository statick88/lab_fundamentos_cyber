# lab-gamification Specification

## Purpose

Define requirements for gamification elements in unit test.sh files. Ensures every unit provides a consistent, engaging student experience through challenge information functions, visual icons, and named challenges. Aligns all 25 units with the gamification pattern proven in 14 existing units.

## Requirements

### Requirement: Challenge info functions

Every reto MUST have a corresponding `retoN_info()` function (e.g., `reto1_info`, `reto2_info`) that displays the challenge name, description, and useful commands to the student. Each info function MUST call `separador` at start and end, and use `${CYAN}` for the title.

#### Scenario: Student invokes reto info

- GIVEN a unit has N retos defined
- WHEN the student selects reto K (1 ≤ K ≤ N)
- THEN `retoK_info()` MUST exist and display the challenge title, description, and hints
- AND the output MUST be wrapped with `separador` calls

#### Scenario: Missing info function for a reto

- GIVEN a unit defines `reto5()` but not `reto5_info()`
- WHEN the gamification menu attempts to display reto 5 info
- THEN the function MUST be present — a missing function is a spec violation

### Requirement: Icons array

Every unit MUST define an `ICONOS=()` bash array with one emoji per reto, in reto order. The array length MUST equal `TOTAL_RETOS`.

#### Scenario: Menu displays icons

- GIVEN a unit has 5 retos and `ICONOS=("📋" "📑" "📜" "⚠️" "✅")`
- WHEN the evaluation loop runs
- THEN each `[PASS]` or `[FAIL]` line MUST include the corresponding icon from the array

#### Scenario: Icon count mismatch

- GIVEN a unit defines 10 retos but `ICONOS` has only 8 entries
- WHEN the evaluation loop accesses `ICONOS[8]` or `ICONOS[9]`
- THEN the access MUST return empty string (bash default) — but this is a spec violation and MUST be remediated

### Requirement: Challenge names array

Every unit MUST define a `challenge_names=()` bash array with human-readable names per reto, in reto order. The array length MUST equal `TOTAL_RETOS`.

#### Scenario: Menu displays challenge names

- GIVEN a unit has 5 retos and `challenge_names=("Risk Register CSV" "SoA JSON" ...)`
- WHEN the evaluation loop runs
- THEN each `[PASS]` or `[FAIL]` line MUST display the name from `challenge_names[i]`

#### Scenario: Name used in standalone output

- GIVEN a unit runs in standalone mode (`BASH_SOURCE[0] == "$0"`)
- WHEN the evaluation loop reports results
- THEN the challenge name MUST appear in the output line

### Requirement: Consistent gamification structure

The three gamification arrays (`validators`, `challenge_names`, `ICONOS`) and info functions MUST be defined in the same relative order and count. The standalone execution block MUST iterate using these arrays.

#### Scenario: All arrays present and aligned

- GIVEN a unit defines `TOTAL_RETOS=5`
- WHEN the test.sh is parsed
- THEN `validators`, `challenge_names`, and `ICONOS` MUST each have exactly 5 entries
- AND `reto1_info` through `reto5_info` MUST all be defined

#### Scenario: Unit with zero gamification elements

- GIVEN a unit's test.sh has no `ICONOS`, `challenge_names`, or `retoN_info()` functions
- WHEN remediation is applied
- THEN all three elements MUST be added for every reto
- AND the pattern MUST match existing gamified units (e.g., `iii-compliance-iso27001`)
