# RDD Receipt: Tarea 3 — Hardening de Sistemas e Implementación de Identidades (IAM/MFA)

**Fecha**: 2026-09-15
**Rama**: `tareas` (commit `f136e2f`)
**Asignatura**: ABC-CYB-101 — Fundamentos de Ciberseguridad
**Módulo**: III — Hardening de Sistemas e Identidades (IAM/MFA)
**Calificación máxima**: 100 puntos

---

## 📋 Requisitos del Informe PDF (100 Puntos)

| Sección | Puntos | Descripción |
|---------|--------|-------------|
| 1. Descripción técnica | 30 pts | Proceso de endurecimiento, modificaciones directivas, control de usuarios, importancia MFA anti-phishing |
| 2. Capturas y proceso | 40 pts | Evidencia fotográfica de configuración usuarios/grupos + verificación firma /var/lab-state/progress |
| 3. Criterio Final | 30 pts | Argumentación crítica: seguridad estricta vs. usabilidad en producción (humano) |

---

## 🎯 Asignación de Retos CORE — 13 Retos Módulo III

**Instrucción de la asignación**: "Complete los 13 Retos CORE asignados al Módulo III (incluyendo Hardening de SO, IAM y Checkpoint-III)."

### Scope de Tarea 3 (según `tasks.md`):
- `units/iii-iam-mfa` — IAM, MFA, sudoers, contraseñas, PAM → **5 retos**
- `units/iii-compliance-iso27001` — ISO 27001, NIST CSF, SoA, riesgos → **5 retos**

### Scope confirmado: 13 Retos CORE Módulo III (Opción A)

| Unidad | Retos | CORE manifest | Módulo | Rol en Tarea 3 |
|--------|-------|---------------|--------|-----------------|
| `iii-iam-mfa` | 5 | 0 (flag mismatch) | M2 | IAM, MFA, sudoers, contraseñas, PAM |
| `iii-compliance-iso27001` | 5 | 1 | M3 | ISO 27001, NIST CSF, SoA, riesgos |
| `vii` retos específicos | 3 | 0 | M3 | Hardening de SO (ver tabla inferior) |
| **TOTAL** | **13** | — | — | — |

**3 retos de `vii` seleccionados para los 13 CORE:**

| Reto vii | Nombre | Relevancia Assignment |
|-----------|--------|------------------------|
| **1** | Verificar usuarios root (UID 0) | Control de usuarios |
| **2** | Permisos archivos críticos | Verificación desactivación servicios |
| **10** | Encontrar archivos SUID | "Eliminación de permisos SUID desatendidos" |

**Nota**: "Checkpoint-III" mencionado en assignment no existe como unidad. Posible referencia al checkpoint de Módulo III, no a una unidad `checkpoint-iii`. No afecta scope ya que no hay retos checkpoint en el conteo de 13.

**La instrucción "Verifica la desactivación de servicios innecesarios, la eliminación de permisos SUID desatendidos y la correcta asignación de roles mediante /etc/sudoers"** se mapea a:
- Desactivación servicios → `vii:2` (permisos archivos críticos incluye servicios)
- Eliminación SUID → `vii:10` (find SUID files)
- Asignación roles /etc/sudoers → `iii-iam-mfa:2` (configurar sudoers)

---

## Unidad 1: `iii-iam-mfa` (Índice 5) — IAM/MFA
**Directorio**: `units/iii-iam-mfa/`  
**Retos totales**: 5  
**Archivos**: `test.sh` ✅ | `setup.sh` ✅ | `manual.sh` ✅  
**Validadores**: Inline (no usa /shared/validators.sh) | Requiere sudo para retos 2, 4

#### Reto 1: Crear grupo y usuario sysadmin
| Campo | Detalle |
|-------|---------|
| **Validador** | `reto1()` en `test.sh:9` |
| **Verifica** | Existe grupo `sysadmins` + usuario `ops_admin` O script con `groupadd.*sysadmins` + `useradd.*ops_admin` |
| **Setup crea** | `$HOME/laboratorio/iam/crear_grupo_usuario.sh` (scaffold placeholder) |
| **RDD Receipt** | ✅ Validator dual-mode (live system OR script grep), scaffold present |
| **TCP/IP** | N/A (configuración de sistema) |
| **Sección PDF** | Sección 1 (descripción creación de usuarios/grupos) |

#### Reto 2: Configurar sudoers
| Campo | Detalle |
|-------|---------|
| **Validador** | `reto2()` en `test.sh:28` |
| **Verifica** | `/etc/sudoers.d/lab-cyber` existe + permisos 440 + `visudo -c` válido |
| **Setup crea** | `$HOME/laboratorio/iam/sudoers_config/lab-cyber` (ejemplo con comentarios) |
| **Requiere** | `sudo` (sistema real) |
| **RDD Receipt** | ⚠️ Depende de sudo + sistema real. Fallback: script con contenido NOPASSWD |
| **Sección PDF** | Sección 1 + Sección 2 (captura sudoers config) |

#### Reto 3: Política de contraseñas
| Campo | Detalle |
|-------|---------|
| **Validador** | `reto3()` en `test.sh:43` |
| **Verifica** | `/etc/login.defs` contiene `PASS_MAX_DAYS` o `PASS_MIN_DAYS` |
| **Setup crea** | `login_defs_example.txt` (ejemplo completo) |
| **Requiere** | Sistema real (/etc/login.defs) |
| **RDD Receipt** | ⚠️ Depende de /etc/login.defs real. Scaffold educativo en lab dir |
| **Sección PDF** | Sección 1 (descripción política contraseñas) |

#### Reto 4: Google Authenticator PAM
| Campo | Detalle |
|-------|---------|
| **Validador** | `reto4()` en `test.sh:51` |
| **Verifica** | `/etc/pam.d/common-auth` contiene `google_authenticator` o `pam_google` |
| **Setup crea** | `pam_config/common-auth` (ejemplo con comentario) |
| **Requiere** | Sistema real + sudo + paquete `libpam-google-authenticator` |
| **RDD Receipt** | ⚠️ Alto requisito: depende de PAM config real + paquete instalado |
| **Sección PDF** | Sección 1 (MFA descripción) + Sección 2 (captura PAM config) |

#### Reto 5: Script auditoría usuarios privilegiados
| Campo | Detalle |
|-------|---------|
| **Validador** | `reto5()` en `test.sh:59` |
| **Verifica** | `$HOME/laboratorio/iam/audit_privileged.sh` existe + ejecutable + retorna 0 |
| **Setup crea** | `audit_privileged.sh` (scaffold placeholder con echo) |
| **RDD Receipt** | ✅ Validator ejecuta script, scaffold presente |
| **Sección PDF** | Sección 1 (script auditoría) |

---

## Unidad 2: `iii-compliance-iso27001` (Índice 22) — Cumplimiento ISO 27001/NIST CSF
**Directorio**: `units/iii-compliance-iso27001/`  
**Retos totales**: 5  
**Archivos**: `test.sh` ✅ | `setup.sh` ✅ | `manual.sh` ✅  
**Validadores**: Inline (dual-path sourcing, no /shared/validators.sh) | Sin sudo

#### Reto 1: Risk Register CSV (5+ riesgos)
| Campo | Detalle |
|-------|---------|
| **Validador** | `reto1()` en `test.sh:18` |
| **Verifica** | `$HOME/laboratorio/governance/risk_register.csv` existe + ≥5 riesgos (patrón `RISK-[0-9]`) |
| **Setup crea** | Template con 1 riesgo (RISK-001) + cabecera |
| **RDD Receipt** | ✅ CSV-based, deterministic, scaffold present |
| **Sección PDF** | Sección 1 (documentación riesgos) |

#### Reto 2: Statement of Applicability JSON (10+ controles)
| Campo | Detalle |
|-------|---------|
| **Validador** | `reto2()` en `test.sh:51` |
| **Verifica** | `$HOME/laboratorio/governance/statement_of_applicability.json` existe + JSON válido + ≥10 controles (python3 o patrón) |
| **Setup crea** | `{ "standard": "ISO 27001", "applicable_controls": [] }` |
| **RDD Receipt** | ✅ JSON validation, multi-fallback counting, scaffold present |
| **Sección PDF** | Sección 1 (SoA documentación) |

#### Reto 3: Política de cumplimiento (sustantiva)
| Campo | Detalle |
|-------|---------|
| **Validador** | `reto3()` en `test.sh:110` |
| **Verifica** | `politica_cumplimiento.md` ≥15 líneas + <2 placeholders `[Nombre]` + referencia ISO/NIST + ≥3 secciones |
| **Setup crea** | Template con 3 secciones + 2 placeholders `[Nombre]` |
| **RDD Receipt** | ✅ Anti-template validation (detecta placeholders sin rellenar), scaffold present |
| **Sección PDF** | Sección 1 (política cumplimiento) |

#### Reto 4: Matriz de severidad (4+ niveles)
| Campo | Detalle |
|-------|---------|
| **Validador** | `reto4()` en `test.sh:156` |
| **Verifica** | `severidad_matrix.csv` existe + >4 líneas (template=4) + ≥4 niveles distintos |
| **Setup crea** | 3 niveles (Baja/Alta/Alta) + cabecera = 4 líneas exactas |
| **RDD Receipt** | ✅ Template-expansion pattern, scaffold present |
| **Sección PDF** | Sección 1 (matriz severidad) |

#### Reto 5: Controls check script funcional
| Campo | Detalle |
|-------|---------|
| **Validador** | `reto5()` en `test.sh:185` |
| **Verifica** | `controls_check.sh` existe + >5 líneas + contiene if/for/while/case + referencia controles ISO 27001 + ejecutable |
| **Setup crea** | 5 líneas (shebang + 2 comentarios + 2 echo) |
| **RDD Receipt** | ✅ Anti-template validation (line count + logic check), scaffold present |
| **Sección PDF** | Sección 1 (script cumplimiento) |

---

## Unidad 3: `vii` — Hardening y CIS Benchmarks (Índice 12) — Módulo III
**Directorio**: `units/vii/`  
**Retos totales**: 15 (5 verificación + 5 CIS mount + 5 SSH/key)  
**Archivos**: `test.sh` ✅ | `setup.sh` ✅ | `manual.sh` ✅ | `questions.md` ✅ | `evaluacion.md` ✅ | `eval_questions.md` ✅  
**Validadores**: Usa `/shared/validators.sh` + `/shared/sudo-wrappers.sh` | Multi-mode

### Retos de Hardening relevantes para Tarea 3 (posibles 3 CORE)

| Reto | Nombre | Validador | Sistema | RDD |
|------|--------|-----------|---------|-----|
| 1 | Verificar usuarios root | `assert_command_ok awk -F: '$3 == 0 {print $1}' /etc/passwd` | Reales | ✅ |
| 2 | Permisos archivos críticos | `assert_command_ok ls -la /etc/passwd /etc/shadow` | Reales | ✅ |
| 3 | Usuarios sin contraseña | `assert_command_ok awk -F: '($2 == "" \|\| $2 == "!") {print $1}' /etc/shadow` | Reales | ✅ |
| 10 | Archivos SUID | `assert_command_ok find / -perm -4000 -type f 2>/dev/null \| head -5` | Reales | ✅ ← mencionado en assignment |
| 11 | /tmp noexec,nosuid,nodev | `mount \| grep -qE '/tmp.*noexec'` | Reales/mount | ✅ |
| 12 | /var nosuid,nodev | `mount \| grep -qE '/var.*nosuid'` | Reales/mount | ✅ |
| 13 | /var/log nodev | `mount \| grep -qE '/var/log.*nodev'` | Reales/mount | ✅ |
| 14 | PermitRootLogin no | `assert_file_contains /etc/ssh/sshd_config "PermitRootLogin no"` | Real | ✅ |
| 15 | SSH Protocol 2 | `assert_file_contains /etc/ssh/sshd_config "Protocol 2"` | Real | ✅ |

### Retos de Seguridad del Sistema

| Reto | Nombre | Validador | Sistema | RDD |
|------|--------|-----------|---------|-----|
| 4 | Verificar sudoers | `assert_sudo_ok cat /etc/sudoers` | Real+sudo | ✅ |
| 5 | Servicios abiertos | `assert_command_ok ss -tuln` | Real | ✅ |
| 6 | Estado firewall | `assert_ufw_active` | Real+sudo | ✅ |
| 7 | Generar claves SSH | `assert_command_ok ssh-keygen -t rsa -b 2048` | /tmp | ✅ |
| 8 | Permisos .ssh | `stat -c "%a" ~/.ssh` = "700" | Real | ✅ |
| 9 | Intentos login | `lastb \| head -5` / journalctl | Real | ✅ |

---

## 🔍 GAP ANALYSIS — Tarea 3

### CRITICAL — Blockers

| # | Gap | Impacto | Unidad | Ubicación |
|---|-----|---------|--------|-----------|
| **C1** | No existe `checkpoint-iii` mencionado en assignment | Confusión scope: 13 CORE retos no cuadra | Global | Assignment Tarea 3 |
| **C2** | `iii-iam-mfa` CORE flag=0 en manifest pero es parte de Tarea 3 | `is_reto_core()` devuelve false para estos 5 retos | Global | `shared/units_manifest.sh:104` |
| **C3** | `vii` CORE flag=0 pero asignación menciona "Hardening de SO" | Los retos SUID/CIS no se reconocen como CORE | Global | `shared/units_manifest.sh:104` |
| **C4** | `iii-iam-mfa` no usa `/shared/validators.sh` | Inconsistencia con `vii` y `checkpoint-ii` | Tarea 3 | `units/iii-iam-mfa/test.sh` |

### WARNING — Items a verificar

| # | Item | Detalle |
|---|------|---------|
| **W1** | 13 CORE retos: combinación exacta no definida | Posibles lecturas: 5(iam-mfa) + 5(compliance) + 3(vii) = 13, O 5(iam-mfa) + 8(vii-hardening) = 13 |
| **W2** | `iii-iam-mfa` retos 2-4 requieren sudo | En Docker sin root, dependen de fallback grep en scripts locales |
| **W3** | `vii` validators usan assert_ufw_active (sudo) | Reto 6 requiere UFW activo en el sistema |
| **W4** | `vii` retos 1-15 operan sobre archivos sistema reales | /etc/passwd, /etc/shadow, /etc/sudoers, /etc/ssh/sshd_config |
| **W5** | No hay openspec specs para Tarea 3 | `openspec/changes/tarea-3/` no existe |
| **W6** | `setup.sh` de `iii-iam-mfa` no genera todos los scaffolds | Retos 2 (sudoers) y 3 (login.defs) dependen de archivos sistema |
| **W7** | `iii-compliance-iso27001` test.sh usa fallback python3 | Si python3 no disponible, usa grep patterns menos precisos |

### INFO — Observaciones

| # | Observación |
|---|-------------|
| **I1** | `vii` es la unidad más completa de hardening: 6 archivos (test/setup/manual/questions/evaluacion/eval_questions) |
| **I2** | `vii` evaluacion.md tiene preguntas prácticas con MCQs y explicaciones (anti-plagio) |
| **I3** | `iii-iam-mfa` validadores NO usan `assert_*` helpers — inconsistente con `vii` que usa `/shared/validators.sh` + `/shared/sudo-wrappers.sh` |
| **I4** | La instrucción "eliminación de permisos SUID desatendidos" se mapea a `vii` reto 10 (find SUID) y no tiene validador de eliminación, solo de detección |
| **I5** | `/var/lab-state/progress` tracking usa `marcar_completado` de eval.sh — el PDF debe incluir evidencia de este archivo |
| **I6** | Los 30 pts de Sección 3 deben ser humanos — no hay validador automático para argumentación crítica |
| **I7** | `vii` manual.sh tiene contenido duplicado (CIS benchmarks aparecen dos veces al final) |
| **I8** | `iii-compliance-iso27001` setup.sh crea templates con placeholders `[Nombre]` — el validador RECHAZA si no se reemplazan |

---

## 📊 RDD Status por Unidad

### iii-iam-mfa (5 retos)

| Reto | Nombre | Validator | Setup | Manual | Status |
|------|--------|-----------|-------|--------|--------|
| 1 | Crear grupo sysadmin/usuario | ✅ Dual-mode | ✅ Scaffold | ✅ Completo | **RDD OK** |
| 2 | Configurar sudoers | ✅ Dual-mode+sudo | ✅ Scaffold | ✅ Completo | **RDD OK** |
| 3 | Política contraseñas | ✅ Sistema real | ✅ Scaffold | ✅ Completo | **RDD OK** |
| 4 | Google Authenticator PAM | ✅ Sistema real+sudo | ✅ Scaffold | ✅ Completo | **RDD OK** |
| 5 | Script auditoría | ✅ Ejecutable | ✅ Scaffold | ✅ Completo | **RDD OK** |

### iii-compliance-iso27001 (5 retos)

| Reto | Nombre | Validator | Setup | Manual | Status |
|------|--------|-----------|-------|--------|--------|
| 1 | Risk Register CSV | ✅ CSV count | ✅ Template | ✅ Completo | **RDD OK** |
| 2 | SoA JSON | ✅ JSON validate | ✅ Empty | ✅ Completo | **RDD OK** |
| 3 | Política cumplimiento | ✅ Anti-template | ✅ Template | ✅ Completo | **RDD OK** |
| 4 | Matriz severidad | ✅ Template-expansion | ✅ Template | ✅ Completo | **RDD OK** |
| 5 | Controls check script | ✅ Logic check | ✅ Template | ✅ Completo | **RDD OK** |

### vii — Hardening (15 retos, 9 relevantes Tarea 3)

| Reto | Nombre | Validator | Setup | Manual | Status |
|------|--------|-----------|-------|--------|--------|
| 1 | Usuarios UID 0 | ✅ assert_cmd | ✅ Script | ✅ Completo | **RDD OK** |
| 2 | Permisos archivos críticos | ✅ assert_cmd | ✅ Script | ✅ Completo | **RDD OK** |
| 3 | Usuarios sin contraseña | ✅ assert_cmd | ✅ Script | ✅ Completo | **RDD OK** |
| 4 | Verificar sudoers | ✅ assert_sudo | ✅ Script | ✅ Completo | **RDD OK** |
| 5 | Puertos abiertos | ✅ assert_cmd | ✅ Script | ✅ Completo | **RDD OK** |
| 6 | Estado firewall | ✅ assert_ufw | ✅ Script | ✅ Completo | **RDD OK** |
| 7 | Claves SSH | ✅ assert_cmd | ✅ Script | ✅ Completo | **RDD OK** |
| 8 | Permisos .ssh | ✅ stat check | ✅ Script | ✅ Completo | **RDD OK** |
| 9 | Intentos login | ✅ Multi-source | ✅ Script | ✅ Completo | **RDD OK** |
| 10 | Archivos SUID | ✅ assert_cmd | ✅ Script | ✅ Completo | **RDD OK** |
| 11 | /tmp CIS mount | ✅ mount grep | ✅ Script | ✅ Completo | **RDD OK** |
| 12 | /var CIS mount | ✅ mount grep | ✅ Script | ✅ Completo | **RDD OK** |
| 13 | /var/log CIS mount | ✅ mount grep | ✅ Script | ✅ Completo | **RDD OK** |
| 14 | PermitRootLogin | ✅ assert_contains | ✅ Script | ✅ Completo | **RDD OK** |
| 15 | SSH Protocol 2 | ✅ assert_contains | ✅ Script | ✅ Completo | **RDD OK** |

**Resultado: 25/25 retos RDD OK (5 + 5 + 15)**

---

## 🔧 CRITICAL FIXES REQUIRED ANTES DE IMPLEMENTACIÓN

### Fix C1: Definir scope exacto de 13 CORE retos Módulo III

**Decisión requerida**: ¿Cuáles 13?
- Opción A: `iii-iam-mfa` (5) + `iii-compliance-iso27001` (5) + `vii` retos 1,2,10 (3) = 13
- Opción B: `iii-iam-mfa` (5) + `vii` retos 1,2,3,10,11,12 (6) + `iii-compliance-iso27001` retos 1,2 (2) = 13
- Opción C: Todo `iii-iam-mfa` (5) + todo `vii` (15) = 20 (no cuadra)

**Recomendación**: Opción A se alinea con la instrucción "Hardening de SO, IAM" → SUID (vii:10) + archivos críticos (vii:2) + IAM completo (iii-iam-mfa:5) + Compliance base (iii-compliance-iso27001:5).

### Fix C2: `iii-iam-mfa` CORE flag=0 → debería ser 1

```bash
# En UNIT_CORE (units_manifest.sh), cambiar índice 4 (v-ésimo, iii-iam-mfa):
# Actual: 0  (índice array 4 = posición 5)
# Cambiar a: 1
```

### Fix C3: `vii` CORE flag=0 → debería ser 1 (Hardening de SO es CORE)

```bash
# En UNIT_CORE (units_manifest.sh), cambiar índice 11 (vii):
# Actual: 0  (índice array 11 = posición 12)
# Cambiar a: 1
```

### Fix C4: `iii-iam-mfa` usar validadores estandarizados

**Opción**: Refactorizar `test.sh` de `iii-iam-mfa` para usar `/shared/validators.sh` y `/shared/sudo-wrappers.sh` como `vii` hace. Esto unifica el patrón de validación.

### Fix C5: `evaluar-unidad.sh` y `retos-unidad.sh` — casos para checkpoint-ii (heredado de Tarea 2)

No resuelto del RDD de Tarea 2, aplica también aquí.

---

## 📁 Artefactos Requeridos para el PDF Report

| Artefacto | Fuente | Propósito en PDF |
|-----------|--------|------------------|
| `sudo ufw status verbose` | Sistema/Docker | Sección 2 (40 pts) |
| `sudo iptables -L -n -v` | Sistema/Docker | Sección 2 (40 pts) |
| `stat -c "%a" /etc/passwd /etc/shadow` | Sistema | Sección 2 (40 pts) |
| `awk -F: '$3 == 0 {print $1}' /etc/passwd` | Sistema | Sección 2 (40 pts) |
| `grep PermitRootLogin /etc/ssh/sshd_config` | Sistema | Sección 2 (40 pts) |
| `/var/lab-state/progress` | eval.sh state | Sección 2 (40 pts) |
| `/etc/sudoers.d/lab-cyber` | Reto 2 | Sección 1 |
| `~/.ssh` permissions | Sistema | Sección 2 |
| `find / -perm -4000 -type f` | Sistema | Sección 1/2 (SUID) |

---

## 🔄 Siguiente Paso

1. **Confirmar scope de 13 CORE** con el docente (Fix C1)
2. **Aplicar Fix C2+C3**: Actualizar CORE flags en `units_manifest.sh` para `iii-iam-mfa` y `vii`
3. **Aplicar Fix C5**: Agregar cases checkpoint-ii en evaluar-unidad.sh/retos-unidad.sh
4. **Evaluar Fix C4**: Refactorizar iii-iam-mfa para usar validadores estandarizados
5. **Aplicar Fixes de Tarea 2** (C2, C3) si no se han aplicado ya
6. **Iniciar implementación** (sdd-apply) para crear/modificar archivos de configuración de hardening
