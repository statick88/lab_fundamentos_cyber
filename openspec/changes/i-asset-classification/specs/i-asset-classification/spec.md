# i-asset-classification Specification

## Purpose

Define the Asset Classification Unit (i-asset-classification) for Lab 3, covering NIST CSF 2.0 asset inventory, classification by confidentiality/integrity/availability (CIA), and mapping to ID.AM-01, ID.AM-05, and ID.AM-07.

## Requirements

### Requirement: Scenario Generation

The unit setup MUST generate `escenario.json` containing exactly 5 assets distributed across hardware, software, data, and supplier-service types. Each asset MUST have a unique identifier (A1–A5), name, type, classification level, and CIA ratings (confidencialidad, integridad, disponibilidad) on a scale of 1–5.

#### Scenario: Valid scenario generation

- GIVEN `setup.sh` executes successfully
- WHEN `escenario.json` is created
- THEN it MUST contain exactly 5 assets
- AND each asset MUST have a unique id from A1 to A5
- AND asset types MUST cover hardware, software, data, and supplier-service

#### Scenario: Invalid scenario rejection

- GIVEN `setup.sh` is interrupted mid-execution
- WHEN `test.sh` validates the unit
- THEN `reto1` MUST fail because `escenario.json` is missing or incomplete

### Requirement: Asset Registry CSV

The unit setup MUST generate `data/asset_registry.csv` with columns: `name`, `type`, `classification`, `confidencialidad`, `integridad`, `disponibilidad`.

#### Scenario: CSV structure validation

- GIVEN `setup.sh` completes
- WHEN `asset_registry.csv` is inspected
- THEN it MUST contain a header row with exactly the required columns
- AND each of the 5 assets MUST have a corresponding data row

#### Scenario: Classification values

- GIVEN `asset_registry.csv` exists
- WHEN classification values are evaluated
- THEN each classification MUST be one of: `público`, `interno`, `confidencial`, `restringido`
- AND each CIA rating MUST be on a scale of 1–5

### Requirement: Classification Template

The unit setup MUST generate `plantilla-clasificacion.md` as a Markdown worksheet template for student asset classification.

#### Scenario: Template existence

- GIVEN `setup.sh` completes
- WHEN `plantilla-clasificacion.md` is checked
- THEN the file MUST exist
- AND it MUST contain a table structure for 5 assets with CIA columns

### Requirement: CSF Mapping Reference

The unit setup MUST generate `data/csf_mapping.md` referencing ID.AM-01, ID.AM-05, and ID.AM-07 from NIST CSF 2.0.

#### Scenario: CSF reference validation

- GIVEN `setup.sh` completes
- WHEN `csf_mapping.md` is inspected
- THEN it MUST contain the string `ID.AM-01`
- AND it MUST contain the string `ID.AM-05`
- AND it MUST contain the string `ID.AM-07`

### Requirement: Test Validators

The unit `test.sh` MUST implement 10 validators (`reto1`–`reto10`) using existing shared validator helpers, covering scenario validity, asset count, CSV structure, classification values, CSF references, and template completeness.

#### Scenario: All 10 retos pass

- GIVEN `setup.sh` has been executed
- WHEN `test.sh` runs all validators
- THEN exactly 10 retos MUST be defined
- AND each reto function MUST return 0 on a valid setup

#### Scenario: Validator helper usage

- GIVEN `test.sh` is reviewed
- WHEN reto functions are inspected
- THEN they MUST source `/shared/validators.sh`
- AND they MUST use `assert_file_exists`, `assert_file_contains`, or equivalent helpers

### Requirement: Integration Wiring

Shared scripts MUST be updated to register unit #21 (XXI) with directory `i-asset-classification`, title "Clasificación de Activos / CSF 2.0", 10 retos, and module M1.

#### Scenario: units_manifest.sh entry

- GIVEN `units_manifest.sh` is sourced
- WHEN `get_unit_index "unit-I-asset"` is called
- THEN it MUST return 21
- AND `get_unit_dir 21` MUST return `i-asset-classification`

#### Scenario: evaluar-unidad.sh mapping

- GIVEN `CURRENT_UNIT` is `unit-I-asset`
- WHEN `evaluar-unidad.sh` resolves the directory
- THEN `UNIT_DIR` MUST be `i-asset-classification`

#### Scenario: retos-unidad.sh mapping

- GIVEN `CURRENT_UNIT` is `unit-I-asset`
- WHEN `retos-unidad.sh` resolves the directory
- THEN `UNIT_DIR` MUST be `i-asset-classification`

#### Scenario: interactive.sh roman numeral

- GIVEN input `21` to `get_unit_num_romano`
- WHEN the function returns
- THEN it MUST output `XXI`

#### Scenario: common.sh phrase

- GIVEN unit index 21
- WHEN `get_frase_for_unit 21` is called
- THEN it MUST return a non-empty phrase from `FRASES_OCULTAS`
