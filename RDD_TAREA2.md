# RDD Receipt: Tarea 2 — Configuración de Firewalls Perimetrales y Filtrado de Tráfico

**Fecha**: 2026-09-15
**Rama**: `tareas` (commit `f136e2f`)
**Asignatura**: ABC-CYB-101 — Fundamentos de Ciberseguridad
**Módulo**: II — Seguridad en Redes y Controles Perimetrales
**Calificación máxima**: 100 puntos

---

## 📋 Requisitos del Informe PDF

| Sección | Puntos | Descripción |
|---------|--------|-------------|
| 1. Descripción técnica | 30 pts | Paso a paso con justificación TCP/IP |
| 2. Capturas y proceso | 40 pts | `ufw status`, `iptables -L`, `/var/lab-state/progress` |
| 3. Diagnóstico final | 30 pts | Impacto defensivo vs. escaneo perimetral (humano) |

---

## Unidades y Retos Módulo II

### Unidad 1: `ii-firewalls-redes` (Índice 2) — CORE ✅
**Directorio**: `units/ii-firewalls-redes/`  
**Retos totales**: 10 (todos CORE)  
**Archivos**: `test.sh` ✅ | `setup.sh` ✅ | `manual.sh` ✅  
**Validadores**: Usan `/shared/common.sh`, modo dual (sudo live | file fallback)

#### Reto 1: Identificar HTTP en captura
| Campo | Detalle |
|-------|---------|
| **Validador** | `reto1()` en `test.sh:9` |
| **Verifica** | `captura_http.pcapng` existe + contiene "GET / HTTP" |
| **Setup crea** | `$HOME/laboratorio/redes/captura_http.pcapng` (hex/ASCII pcap con payload HTTP) |
| **Protocolo** | HTTP puerto 80/tcp, método GET |
| **TCP/IP** | Capa 4 (Transporte): TCP handshake 3-way, puerto destino 80. Capa 7 (Aplicación): método GET, host header |
| **RDD Receipt** | ✅ Validator exists, setup scaffold present, no sudo dependency |

#### Reto 2: Identificar HTTPS
| Campo | Detalle |
|-------|---------|
| **Validador** | `reto2()` en `test.sh:14` |
| **Verifica** | `/etc/services` contiene línea `^https` |
| **Setup crea** | Ninguno (valida sistema) |
| **Protocolo** | HTTPS puerto 443/tcp |
| **TCP/IP** | Igual que HTTP + TLS capa presentación (capa 6) cifrado |
| **RDD Receipt** | ✅ Validator exists, depends on /etc/services (always present) |

#### Reto 3: Identificar SSH en captura
| Campo | Detalle |
|-------|---------|
| **Validador** | `reto3()` en `test.sh:17` |
| **Verifica** | `captura_ssh.pcapng` existe + contiene "SSH" |
| **Setup crea** | `$HOME/laboratorio/redes/captura_ssh.pcapng` (hex/ASCII con banner SSH-2.0-OpenSSH_8.9p1) |
| **Protocolo** | SSH puerto 22/tcp |
| **TCP/IP** | TCP puerto 22; banner negotiation en capa aplicación |
| **RDD Receipt** | ✅ Validator exists, setup scaffold present |

#### Reto 4: Identificar DNS en captura
| Campo | Detalle |
|-------|---------|
| **Validador** | `reto4()` en `test.sh:22` |
| **Verifica** | `/etc/services` contiene `^domain` |
| **Setup crea** | Ninguno (valida sistema). Nota: `captura_dns.pcapng` creada por setup.sh |
| **Protocolo** | DNS puerto 53 udp/tcp |
| **TCP/IP** | Capa aplicación (7): query/respuesta; Capa transporte: UDP sin conexión (típicamente) |
| **RDD Receipt** | ✅ Validator exists, setup creates pcap (unused by validator but educational) |

#### Reto 5: UFW — Permitir SSH
| Campo | Detalle |
|-------|---------|
| **Validador** | `reto5()` en `test.sh:27` |
| **Verifica** | `sudo ufw status` muestra 22/tcp OBO `$HOME/laboratorio/redes/ufw_ssh.sh` ejecutable con contenido |
| **Setup crea** | `$HOME/laboratorio/redes/ufw_ssh.sh` (placeholder ejecutable) |
| **RDD Receipt** | ✅ Validator dual-mode, scaffold present, requiere ejecución del estudiante para completar |

#### Reto 6: UFW — Denegar Telnet
| Campo | Detalle |
|-------|---------|
| **Validador** | `reto6()` en `test.sh:35` |
| **Verifica** | `sudo ufw status` muestra 23/tcp como DENEGADO OBO `ufw_telnet.sh` ejecutable |
| **Setup crea** | `$HOME/laboratorio/redes/ufw_telnet.sh` (placeholder) |
| **RDD Receipt** | ✅ Validator dual-mode, scaffold present |

#### Reto 7: UFW — Permitir HTTP/HTTPS
| Campo | Detalle |
|-------|---------|
| **Validador** | `reto7()` en `test.sh:42` |
| **Verifica** | `sudo ufw status` muestra 80/tcp y/o 443/tcp OBO `ufw_web.sh` ejecutable |
| **Setup crea** | `$HOME/laboratorio/redes/ufw_web.sh` (placeholder) |
| **RDD Receipt** | ✅ Validator dual-mode, scaffold present |

#### Reto 8: iptables — Bloquear IP sospechosa
| Campo | Detalle |
|-------|---------|
| **Validador** | `reto8()` en `test.sh:50` |
| **Verifica** | `sudo iptables -L INPUT -n -v` muestra DROP OBO `iptables_block.sh` ejecutable con "DROP" |
| **Setup crea** | `$HOME/laboratorio/redes/iptables_block.sh` (placeholder: `iptables -A INPUT -s 10.0.0.99 -j DROP`) |
| **RDD Receipt** | ✅ Validator dual-mode, scaffold present |

#### Reto 9: Listar reglas iptables
| Campo | Detalle |
|-------|---------|
| **Validador** | `reto9()` en `test.sh:58` |
| **Verifica** | `sudo iptables -L` ejecuta OK OBO `iptables_list.sh` ejecutable con "iptables" |
| **Setup crea** | `$HOME/laboratorio/redes/iptables_list.sh` (placeholder) |
| **RDD Receipt** | ✅ Validator dual-mode, scaffold present |

#### Reto 10: Identificar escaneo de puertos
| Campo | Detalle |
|-------|---------|
| **Validador** | `reto10()` en `test.sh:67` |
| **Verifica** | `captura_scan.pcapng` existe + (tcpdump disponible con SYN flags O tamaño > 1024 bytes) |
| **Setup crea** | `$HOME/laboratorio/redes/captura_scan.pcapng` (hex/ASCII — captura vacía para análisis) |
| **RDD Receipt** | ✅ Validator exists, setup creates pcap, logic OK (tcpdump OR size check) |

---

### Unidad 2: `checkpoint-ii` (Índice 17) — Módulo II ✅
**Directorio**: `units/checkpoint-ii/`  
**Retos totales**: 5  
**Archivos**: `test.sh` ✅ | `setup.sh` ✅ | `manual.sh` ✅ | `questions.md` ✅  
**Validadores**: Usan `/shared/validators.sh` (assert_file_exists, assert_file_contains, assert_command_ok)  
**⚠️ CORE flag**: 0 en `units_manifest.sh` (alineado con GUIA que lista solo 60 CORE units; este checkpoint es evaluativo)

#### Reto 1 (Checkpoint): Identificar HTTP en Captura
| Campo | Detalle |
|-------|---------|
| **Validador** | `reto1()` en `test.sh:22` |
| **Verifica** | `captura_checkpoint.pcapng` existe + contiene "GET" + "HTTP" |
| **Setup crea** | `$HOME/laboratorio/checkpoints/checkpoint-ii/captura_checkpoint.pcapng` |
| **RDD Receipt** | ✅ Uses assert_file_exists + assert_file_contains, deterministic |

#### Reto 2 (Checkpoint): Identificar DNS en /etc/services
| Campo | Detalle |
|-------|---------|
| **Validador** | `reto2()` en `test.sh:42` |
| **Verifica** | `/etc/services` contiene `^domain` o `^dns` o `53.*domain` |
| **Setup crea** | Ninguno |
| **RDD Receipt** | ✅ Uses assert_file_exists, grep with fallback patterns |

#### Reto 3 (Checkpoint): Identificar SSH
| Campo | Detalle |
|-------|---------|
| **Validador** | `reto3()` en `test.sh:55` |
| **Verifica** | Evidencia SSH en: archivos lab, pcap con SSH, o `^ssh` en /etc/services (or-logic) |
| **Setup crea** | Ninguno |
| **RDD Receipt** | ✅ Multi-source evidence; flexible validation |

#### Reto 4 (Checkpoint): Configurar UFW para SSH
| Campo | Detalle |
|-------|---------|
| **Validador** | `reto4()` en `test.sh:89 |
| **Verifica** | Script ejecutable en lab dir con "ufw" + "22" OBO archivo .rules con "22" |
| **Setup crea** | `captura_checkpoint.pcapng` only |
| **RDD Receipt** | ✅ Uses assert_command_ok for executable check; multi-location search |

#### Reto 5 (Checkpoint): Listar Reglas iptables
| Campo | Detalle |
|-------|---------|
| **Validador** | `reto5()` en `test.sh:118 |
| **Verifica** | Script ejecutable con "iptables" en contenido |
| **Setup crea** | Ninguno adicional |
| **RDD Receipt** | ✅ Uses assert_file_exists + assert_command_ok + assert_file_contains |

---

### Unidad 3: `ii-arquitectura-perimetral` (Índice 23) — ⚠️ SIN TEST.SH
**Directorio**: `units/ii-arquitectura-perimetral/`  
**Retos totales**: 10 (según setup.sh)  
**Archivos**: `setup.sh` ✅ | `manual.sh` ✅ | `data/` (3 referencias) | ❌ **NO `test.sh`**  
**CORE flag**: 0 en manifest  
**Nota**: Aunque no es parte directa de Tarea 2, su `setup.sh` genera 10 retos de arquitectura perimetral/DMZ que son valor complementario para el módulo II.

---

## 🔍 GAP ANALYSIS

### CRITICAL — Blockers

| # | Gap | Impacto | Unidad | Ubicación |
|---|-----|---------|--------|-----------|
| **C1** | `ii-arquitectura-perimetral` no tiene `test.sh` | No se pueden validar 10 retos | Módulo II | `units/ii-arquitectura-perimetral/` |
| **C2** | `evaluar-unidad.sh` no tiene case para `checkpoint-ii` | `evaluar-unidad checkpoint-II` falla con "No se pudo determinar el directorio" | Global | `shared/evaluar-unidad.sh:22-41` |
| **C3** | `retos-unidad.sh` no tiene case para `checkpoint-ii` | `retos-unidad checkpoint-II` falla con error | Global | `shared/retos-unidad.sh:21-36` |

### WARNING — Items a verificar

| # | Item | Detalle |
|---|------|---------|
| **W1** | Discrepancia "12 Retos CORE" | Asignación dice 12 CORE retos Módulo II; manifest indica 10 CORE en ii-firewalls-redes + checkpoint-ii flag=0. Posible interpretación: completar 12 de los 15 retos disponibles combinando ambas unidades. |
| **W2** | `common.sh` tiene 17 frases ocultas, `units_manifest.sh` tiene 26 unidades | `interactive.sh:ver_frase()` itera 1..26 pero `common.sh` `FRASES_OCULTAS` solo tiene 17 entradas. Las unidades 18-26 devolverán empty string. |
| **W3** | `interactive.sh` no soporta `checkpoint-II` como unidad navegable | El menú `jugar_unidad` usa `resolve_unit_path` (de manifest) → funciona, pero `menu_interactivo` itera 1..UNIT_COUNT(26) y la navegación por número 17 mapea a `checkpoint-II` en menu.sh ✅. |
| **W4** | Reto 10 (ii-firewalls) depende de `tcpdump` o tamaño de archivo | Si tcpdump no está instalado, fallback es stat > 1024 bytes. En Docker podría no estar disponible. |
| **W5** | Retos 5-9 (ii-firewalls) requieren `sudo` | En contenedor Docker sin privilegios de root, dependen del fallback file-based. El estudiante debe completar el archivo script y ejecutarlo. |

### INFO — Observaciones

| # | Observación |
|---|-------------|
| **I1** | `ii-firewalls-redes/test.sh` no hace `source /shared/validators.sh` — usa validaciones inline (grep, test, stat) en lugar de assert_* helpers. Inconsistente con checkpoint-ii. |
| **I2** | `setup.sh` de `ii-arquitectura-perimetral` es completo y pedagógico (plantillas con comentarios) pero sin test.sh correspondiente. Posible trabajo pendiente. |
| **I3** | `checkpoint-ii/setup.sh` crea UNICAMENTE el pcap; no genera scripts scaffold para retos 4-5. El estudiante debe crearlos. |
| **I4** | El PDF report requiere `sudo ufw status verbose` y `sudo iptables -L -n -v` — estos comandos solo funcionan dentro del contenedor Docker con privilegios adecuados. |
| **I5** | `/var/lab-state/progress` se usa para tracking de retos (eval.sh). El PDF debe incluir el progreso asociado al usuario. |

---

## 📊 RDD Status por Reto

### ii-firewalls-redes (10 retos)

| Reto | Nombre | Validator | Setup | Manual | Status |
|------|--------|-----------|-------|--------|--------|
| 1 | Identificar HTTP en captura | ✅ Existe | ✅ Pcap creada | ✅ Completo | **RDD OK** |
| 2 | Identificar HTTPS | ✅ Existe | ✅ N/A (sistema) | ✅ Completo | **RDD OK** |
| 3 | Identificar SSH en captura | ✅ Existe | ✅ Pcap creada | ✅ Completo | **RDD OK** |
| 4 | Identificar DNS | ✅ Existe | ✅ Pcap creada | ✅ Completo | **RDD OK** |
| 5 | UFW Permitir SSH | ✅ Existe | ✅ Script scaffold | ✅ Completo | **RDD OK** |
| 6 | UFW Denegar Telnet | ✅ Existe | ✅ Script scaffold | ✅ Completo | **RDD OK** |
| 7 | UFW Permitir HTTP/HTTPS | ✅ Existe | ✅ Script scaffold | ✅ Completo | **RDD OK** |
| 8 | iptables DROP IP | ✅ Existe | ✅ Script scaffold | ✅ Completo | **RDD OK** |
| 9 | Listar iptables | ✅ Existe | ✅ Script scaffold | ✅ Completo | **RDD OK** |
| 10 | Escaneo de puertos | ✅ Existe | ✅ Pcap creada | ✅ Completo | **RDD OK** |

### checkpoint-ii (5 retos)

| Reto | Nombre | Validator | Setup | Manual | Status |
|------|--------|-----------|-------|--------|--------|
| 1 | HTTP en captura | ✅ assert_file_exists + contains | ✅ Pcap creada | ✅ Completo | **RDD OK** |
| 2 | DNS en /etc/services | ✅ assert_file_exists + grep | ✅ N/A | ✅ Completo | **RDD OK** |
| 3 | SSH | ✅ Multi-source evidence | ✅ Pcap creada | ✅ Completo | **RDD OK** |
| 4 | UFW SSH | ✅ assert_command_ok + contains | ✅ Solo pcap | ✅ Completo | **RDD OK** |
| 5 | Listar iptables | ✅ assert_command_ok + contains | ✅ N/A | ✅ Completo | **RDD OK** |

**Resultado: 15/15 retos con RDD OK (10 firewalls + 5 checkpoint)**

---

## 🔧 CRITICAL FIXES REQUIRED ANTES DE IMPLEMENTACIÓN

### Fix C1: `ii-arquitectura-perimetral/test.sh` — NO EXISTE

**Impacto**: No se puede validar la unidad de arquitectura perimetral. Si esta unidad forma parte de Módulo II para Tarea 2, el estudiante no puede completar esos 10 retos con validación automática.

**Decisión requerida**: ¿Se incluye en Tarea 2 o se excluye? La asignación dice "12 Retos CORE de Módulo II incluyendo Firewalls y Checkpoint-II". 10+5=15 ≠ 12, por lo que es probable que solo sean 12 de esos 15, o que checkpoint-ii cuente parcialmente. Sin test.sh, los 10 retos de arquitectura perimetral son improbable de incluir en los 12.

**Acción sugerida**: Confirmar scope de Tarea 2 = ii-firewalls-redes (10 retos) + selectos de checkpoint-ii (2 retos) = 12, O incluir test.sh para ii-arquitectura-perimetral si se necesitan más retos.

### Fix C2: `evaluar-unidad.sh` — Agregar case checkpoint-II

```bash
# En la sección case "$UNIT_ROMAN_LC", agregar:
checkpoint-ii) UNIT_DIR="checkpoint-ii" ;;
```

### Fix C3: `retos-unidad.sh` — Agregar case checkpoint-II

```bash
# En la sección case "$UNIT_NUM", agregar:
checkpoint-ii) UNIT_DIR="checkpoint-ii" ;;
```

---

## 📁 Artefactos Requeridos para el PDF Report

| Artefacto | Fuente | Propósito en PDF |
|-----------|--------|------------------|
| `sudo ufw status verbose` output | Sistema/Docker | Sección 2 (40 pts) |
| `sudo iptables -L -n -v` output | Sistema/Docker | Sección 2 (40 pts) |
| `/var/lab-state/progress` | eval.sh state file | Sección 2 (40 pts) |
| Capturas .pcapng | setup.sh generadas | Sección 1 (análisis TCP/IP) |
| Scripts UFW/iptables creados | Retos 5-9 | Sección 1 (justificación comandos) |

---

## 🔄 Siguiente Paso

1. Confirmar scope de 12 retos CORE para Tarea 2 con el docente
2. Crear `test.sh` para `ii-arquitectura-perimetral` (si aplica) O confirmar exclusión
3. Aplicar Fixes C2 y C3 en scripts compartidos
4. Crear RDD receipts individuales por reto con: Given/When/Then para cada validador
5. Iniciar fase de implementación (sdd-apply) para crear/modificar archivos necesarios
