# Rúbrica de Evaluación — ABC-CYB-101

**Alineación:** SETEC / ISO/IEC 17024 — Competencias en Ciberseguridad
**Curso:** Fundamentos de Ciberseguridad — Abacom
**Duración de evaluación:** 24 horas continuas (sesión integral)

---

## 1. Competencias por Módulo

| Módulo | Competencia SETEC | Código | Ponderación |
|--------|-------------------|--------|-------------|
| M1 — Terminal y Permisos | Operación segura del sistema Linux | M1-OPS | 15% |
| M2 — Reconocimiento de Red | Análisis de red y perfiles de puertos | M2-ANA | 20% |
| M3 — Git y Control de Versiones | Control de cambios y gestión de riesgos | M3-GIT | 15% |
| M4 — Docker y Aislamiento | Contenedores seguros y hardening | M4-DOC | 20% |
| M5 — Wargames (Bandit) | Análisis de vulnerabilidades éticas | M5-WAR | 15% |
| M6 — Logging, SIEM y BCP | Monitoreo, correlación e incidentes | M6-LOG | 15% |

---

## 2. Criterios de Evaluación por Rubrica

### Escala de puntuación: 1.0 – 5.0

| Puntuación | Descriptor | % de logro |
|-----------|-----------|------------|
| 5.0 | Excelente — Cumple y supera todos los requisitos con profundidad analítica | 90–100% |
| 4.0 | Muy bien — Cumple todos los requisitos con mínimos errores | 75–89% |
| 3.0 | Bien — Cumple la mayoría de los requisitos con algunos errores menores | 60–74% |
| 2.0 | Suficiente — Cumple parcialmente los requisitos, necesita corrección | 40–59% |
| 1.0 | Insuficiente — No cumple los requisitos mínimos | 0–39% |

---

## 3. Matriz de Criterios DETALALADA

### M1 — Terminal, Permisos y Errores (M1-OPS)

| Criterio ID | Descriptor | Puntos | Ponderación |
|-------------|-----------|--------|-------------|
| M1-C1 | Navegación eficiente (pwd, ls -la, find, tree) | 2 | 20% |
| M1-C2 | Gestión de contenido de archivos (cat, head, tail, grep) | 2 | 20% |
| M1-C3 | Permisos Linux (chmod simbólico y octal, ps aux) | 2 | 20% |
| M1-C4 | Tuberías y redirección (\|, >, >>) | 2 | 20% |
| M1-C5 | Comprensión del sistema de archivos FHS | 2 | 20% |

**Puntaje mínimo aprobatorio:** 8/10 (80%)

### M2 — Reconocimiento de Red (M2-ANA)

| Criterio ID | Descriptor | Puntos | Ponderación |
|-------------|-----------|--------|-------------|
| M2-C1 | Identificación de protocolos y puertos (TCP/UDP, /etc/services) | 2 | 20% |
| M2-C2 | Análisis de capturas tcpdump (pcapng) | 2 | 20% |
| M2-C3 | Configuración UFW (reglas ACCEPT/DROP) | 2 | 20% |
| M2-C4 | Configuración iptables (reglas DROP por IP) | 2 | 20% |
| M2-C5 | Uso de nmap para escaneo de puertos | 2 | 20% |

**Puntaje mínimo aprobatorio:** 8/10 (80%)

### M3 — Git y Control de Versiones (M3-GIT)

| Criterio ID | Descriptor | Puntos | Ponderación |
|-------------|-----------|--------|-------------|
| M3-C1 | Configuración y operaciones básicas de Git | 2 | 20% |
| M3-C2 | Gestión de ramas y fusión (checkout -b, merge) | 2 | 20% |
| M3-C3 | Conventional Commits y mensajes claros | 2 | 20% |
| M3-C4 | Resolución de conflictos de merge | 2 | 20% |
| M3-C5 | .gitignore y buenas prácticas de seguridad | 2 | 20% |

**Puntaje mínimo aprobatorio:** 8/10 (80%)

### M4 — Docker y Aislamiento (M4-DOC)

| Criterio ID | Descriptor | Puntos | Ponderación |
|-------------|-----------|--------|-------------|
| M4-C1 | Conceptos de aislamiento (namespaces, cgroups) | 2 | 20% |
| M4-C2 | Inspección de docker-compose (service, network, capabilities) | 2 | 20% |
| M4-C3 | Backup incremental con rsync | 2 | 20% |
| M4-C4 | Hardening Dockerfile (non-root, capability dropping) | 2 | 20% |
| M4-C5 | Análisis de capabilities vs CIS Docker Benchmark | 2 | 20% |

**Puntaje mínimo aprobatorio:** 8/10 (80%)

### M5 — Wargames (Bandit) (M5-WAR)

| Criterio ID | Descriptor | Puntos | Ponderación |
|-------------|-----------|--------|-------------|
| M5-C1 | Recreación local de Bandit nivel 0-1 (ssh) | 2 | 20% |
| M5-C2 | Uso de find/ls para archivos ocultos (niveles 1-2) | 2 | 20% |
| M5-C3 | Análisis de permisos y strings/xxd (niveles 2-3) | 2 | 20% |
| M5-C4 | Búsqueda de passwords con john | 2 | 20% |
| M5-C5 | Enmarque ético y autorización documentada | 2 | 20% |

**Puntaje mínimo aprobatorio:** 8/10 (80%)

### M6 — Logging, SIEM y BCP (M6-LOG)

| Criterio ID | Descriptor | Puntos | Ponderación |
|-------------|-----------|--------|-------------|
| M6-C1 | Captura y análisis con tcpdump (-i, -w, -r, -A) | 2 | 20% |
| M6-C2 | Configuración de logrotate (daily, rotate, compress) | 2 | 20% |
| M6-C3 | Análisis de logs con grep/awk/sed | 2 | 20% |
| M6-C4 | Análisis TLS con openssl s_client | 2 | 20% |
| M6-C5 | Documentación BCP (RTO/RPO, playbook IR) | 2 | 20% |

**Puntaje mínimo aprobatorio:** 8/10 (80%)

---

## 4. Evaluación Formativa (Checkpoints)

| Checkpoint | Módulos evaluados | Retos | Mínimo aprobatorio |
|-----------|-------------------|-------|-------------------|
| Checkpoint II | M1 + M2 | 5 | 3/5 (60%) |
| Checkpoint IV | M3 + M4 | 5 | 3/5 (60%) |
| Checkpoint V | M5 + M6 | 5 | 3/5 (60%) |

**Nota:** Los checkpoints son evaluaciones formativas (no sumativas). Reintentos ilimitados.

---

## 5. Evaluación Sumativa Final

### Cálculo de nota final

```
Nota_final = (M1 × 0.15) + (M2 × 0.20) + (M3 × 0.15) + (M4 × 0.20) + (M5 × 0.15) + (M6 × 0.15)
```

### Tabla de calibración

| Nota_final | Calificación | Soporte SETEC |
|-----------|-------------|---------------|
| 9.0–10.0 | A — Excelente | C1.1, C2.2 |
| 7.0–8.9 | B — Muy bien | C1.1, C2.2 |
| 6.0–6.9 | C — Bien | C1.1 |
| 5.0–5.9 | D — Suficiente | Requiere refuerzo |
| 0–4.9 | F — Insuficiente | Requiere revalidación |

---

## 6. Criterios SETEC / ISO 17024 — Cumplimiento

| Requisito SETEC | Implementación en ABC-CYB-101 |
|-----------------|-------------------------------|
| **C1.1 — Definición de competencias** | Tabla 1: Competencias por módulo (6 criterios) |
| **C1.2 — Objetivos de aprendizaje medibles** | Tabla 3: Matriz de criterios con puntos y ponderación |
| **C2.1 — Proceso de evaluación documentado** | Esta rúbrica + plantilla.md (registro de estudiantes) |
| **C2.2 — Escala de puntuación alineada** | Tabla 2: Escala 1.0–5.0 con descriptores |
| **C2.3 — Mínimos de corte definidos** | Puntaje mínimo 80% por módulo, 60% por checkpoint |
| **C3.1 — Reintentos formativos** | Checkpoints permiten reintentos ilimitados |
| **C4.1 — Evidencia de autenticación** | `revelar-frase` command, archivo de progreso (/var/lab-state/progress) |
| **C4.2 — Cadena de custodia** | Archivos validados con timestamps, SHA-256 verificable |

---

## 7. Procedimiento de Evaluación

### Fase 1: Sesión práctica (24 horas)
1. El estudiante trabaja en el contenedor `lab-ciberseguridad`
2. Completa los retos de cada módulo usando `plantilla.md`
3. El progreso se registra en `/var/lab-state/progress`
4. Los checkpoints (II, IV, V) validan la síntesis

### Fase 2: Revisión de entregables
1. El instructor revisa cada `plantilla.md` completada
2. Verifica comandos, salidas y respuestas con la tabla de solucionarios (SOLUCIONARIOS_MODULOS.md)
3. Asigna puntuación por criterio (Tabla 3)

### Fase 3: Calificación final
1. Calcula nota_final con la fórmula de la sección 4
2. Aplica tabla de calibración (Tabla 5)
3. Registra resultado en formato SETEC

---

## 8. Rúbrica de Corte Rápido (Checklist)

| Ítem | Sí/No | Módulo |
|------|-------|--------|
| ✅ Navegación de archivos FHS | | M1 |
| ✅ Análisis tcpdump captura | | M2 |
| ✅ Conventional Commits aplicados | | M3 |
| ✅ Dockerfile hardeneado | | M4 |
| ✅ Bandit nivel 0-1 resuelto | | M5 |
| ✅ logrotate configurado | | M6 |
| ✅ OpenSSL TLS handshake analizado | | M6 |
| ✅ Reporte IR con plantilla.md | | M6 |
| ✅ Puntaje ≥80% en cada módulo | | Todos |
| ✅ ≥3/5 en cada checkpoint | | II, IV, V |

---

*Documento generado para la acreditación SETEC de competencias en ciberseguridad. Última actualización: 2026-09-01.*
