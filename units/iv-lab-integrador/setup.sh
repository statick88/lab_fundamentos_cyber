#!/bin/bash
# Unit IV Lab Integrador — Capstone Integrador del Curso
# Combina: Risk Assessment, Asset Classification, Perimeter Security,
#           Cryptography, Incident Response, Malware Analysis

set -e

if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
fi

UNIT_NAME="unit-IV-lab-integrador"
UNIT_NUM=4
export TOTAL_RETOS=10

banner_unidad "$UNIT_NUM" "Lab Integrador — Capstone del Curso"

echo -e "${CYAN}Este laboratorio integra TODOS los módulos del curso:${RESET}"
echo -e "${AMARILLO}Evaluación de Riesgos → Clasificación de Activos → Seguridad Perimetral → Criptografía → IR → Malware.${RESET}"
echo -e "${AMARILLO}Completarás 10 retos que cruzan fronteras entre unidades.${RESET}\n"

mkdir -p "$HOME/laboratorio/integrador"
cd "$HOME/laboratorio/integrador"

# ============================================================
# Reto 1: Risk-Incident Correlation Analysis
# ============================================================
cat > risk-incident.md << 'EOF'
# Risk-Incident Correlation Analysis

## Escenario
Una organización ha sufrido múltiples incidentes de seguridad. Correlaciona los
incidentes con el register de riesgos para determinar qué controles fallaron.

## Plantilla

### Incidentes Reportados
| # | Fecha | Tipo | Severidad | Activo Afectado | Control Esperado |
|---|-------|------|-----------|-----------------|------------------|
| 1 |       |      |           |                 |                  |
| 2 |       |      |           |                 |                  |
| 3 |       |      |           |                 |                  |

### Correlación con Risk Register
| Incidente | Riesgo Asociado | Probabilidad Original | Impacto Real | Control que Falló | Lección Aprendida |
|-----------|-----------------|:---------------------:|:------------:|-------------------|-------------------|
|           |                 |                       |              |                   |                   |

### Análisis
- [ ] ¿Algún riesgo materializado no estaba en el register?
- [ ] ¿Los controles existentes fueron efectivos?
- [ ] ¿Qué tratamientos propuestos habrían mitigado el impacto?

### Conclusiones
📝 Completar con hallazgos y recomendaciones.

---
Completado cuando contiene análisis de correlación Risk ↔ Incident.
EOF

# ============================================================
# Reto 2: Network Forensics Script
# ============================================================
cat > network-forensics.sh << 'EOF'
#!/bin/bash
# Network Forensics — Análisis de tráfico de red para detectar indicadores de compromiso
# Retroalimenta a Module II (Perimeter/IDS) y Module III (IR)

echo "=== Network Forensics Script ==="

# Capturar y analizar tráfico
# 1. Identificar conexiones sospechosas (puertos inusuales)
# 2. Analizar patrones de beaconing
# 3. Correlacionar con IOCs conocidos

# PLACEHOLDER: Agregar comandos de análisis forense de red
# Ejemplos:
#   tshark -r capture.pcap -Y "tcp.port == 4444"
#   tcpdump -r capture.pcap 'tcp[tcpflags] & tcp-syn != 0'

echo "Forensics de red completado"
EOF
chmod +x network-forensics.sh

# ============================================================
# Reto 3: Cryptographic Analysis Template
# ============================================================
cat > crypto-analysis.md << 'EOF'
# Cryptographic Analysis — Análisis Criptográfico Cross-Module

## Escenario
Evaluar la postura criptográfica de una organización integrando hallazgos de
criptografía (Module III), malware (Module IV) y riesgos (Module I).

## Análisis

### 1. Identificación de Algoritmos en Uso
| Sistema | Algoritmo | Uso | Estado | Riesgo |
|---------|-----------|-----|--------|--------|
|         |           |     |        |        |

### 2. Evaluación de Fortaleza
| Criterio | Valor | Estándar | Cumple |
|----------|-------|----------|--------|
| Longitud de clave |       | ≥256 bits (simétrico) / ≥2048 bits (asimétrico) | |
| Modo de operación |     | GCM/CTR (no ECB) | |
| Rotación de claves |   | Período definido | |

### 3. Hallazgos de Criptografía en Malware
| Muestra | Cifrado Detectado | Algoritmo | ¿Reverseable? | Impacto IR |
|---------|-------------------|-----------|----------------|------------|
|         |                   |           |                |            |

### 4. Recomendaciones
- [ ] Actualizar algoritmos obsoletos
- [ ] Implementar rotación de claves
- [ ] Evaluar migración a post-cuántico

---
Completado cuando contiene análisis criptográfico integrado.
EOF

# ============================================================
# Reto 4: Asset Inventory with Risk Scoring
# ============================================================
cat > asset-inventory.csv << 'EOF'
asset_id,asset_name,asset_type,criticity,owner,location,controls,risk_score,risk_level
A001,Servidor de Base de Datos,hardware,alta,DBA,DC-Principal,"backup,encryption,IDS",, 
A002,Servidor Web,software,media,DevOps,Cloud,"WAF,CDN,patches",,
A003,Firewall Principal,hardware,alta,Red,Perimetro,"reglas,logging",,
A004,Estación de Desarrollo,hardware,baja,Dev,Oficina,"MFA,antivirus",,
A005,Base de Datos de Clientes,datos,critical,DBA,DC-Principal,"encryption,backup,RBAC",,
A006,Servidor de Correo,software,media,IT,Cloud,"spam-filter,DKIM",,
A007,Switch Core,hardware,alta,Red,DC-Principal,"segmentacion,ACL",,
A008,Certificados Digitales,datos,critical,IT,PKI-CA,"HSM,rotation",,
A009,Plan de DRP,datos,alta,BCP,Offsite,"3-2-1,encrypted",,
A010,Equipo Portátil Ejecutivo,hardware,media,Oficina,Variable,"full-disk,MFA,MDM",,
EOF

# ============================================================
# Reto 5: Incident Response Playbook
# ============================================================
cat > incident-playbook.md << 'EOF'
# Incident Response Playbook — Integrador Cross-Module

## Escenario
Playbook que integra detección de malware (Module IV), análisis de red (Module II),
y manejo de incidentes (Module III) en un flujo unificado.

## Fases del Playbook

### Fase 1: Detección y Alarma
| Fuente | Tipo de Detección | Acción Inicial | Responsable |
|--------|-------------------|----------------|-------------|
| IDS/IPS | Anomalía de red | Validar alerta | SOC |
| EDR | Comportamiento sospechoso | Aislar endpoint | SOC |
| Usuario | Reporte manual | Triaje inicial | Helpdesk |

### Fase 2: Contención
- [ ] Contención a corto plazo (aislamiento de red)
- [ ] Contención a largo plazo (cierre de brecha)
- [ ] Preservación de evidencia

### Fase 3: Erradicación
- [ ] Identificar causa raíz
- [ ] Eliminar artefactos de malware
- [ ] Restaurar desde backup verificado

### Fase 4: Recuperación
- [ ] Restaurar sistemas
- [ ] Verificar integridad
- [ ] Monitoreo post-recuperación

### Fase 5: Lecciones Aprendidas
- [ ] Post-mortem documentado
- [ ] Actualizar risk register
- [ ] Mejorar controles

---
Completado cuando contiene playbook completo con las 5 fases.
EOF

# ============================================================
# Reto 6: Perimeter Security Audit
# ============================================================
cat > perimeter-audit.md << 'EOF'
# Perimeter Security Audit — Auditoría Perimetral Integrada

## Escenario
Auditoría completa de la seguridad perimetral que integra hallazgos de:
Module I (Riesgos), Module II (Perímetro), y Module IV (Análisis de Amenazas).

## Metodología

### 1. Inventariado de Superficie de Ataque
| Componente | Función | Expuesto | Controles | Vulnerabilidades |
|------------|---------|:--------:|-----------|------------------|
| Firewall   |         |          |           |                  |
| IDS/IPS    |         |          |           |                  |
| WAF        |         |          |           |                  |
| VPN        |         |          |           |                  |
| DMZ        |         |          |           |                  |

### 2. Evaluación de Controles Perimetrales
| Control | Implementado | Efectivo | Detección | Respuesta |
|---------|:------------:|:--------:|:---------:|:---------:|
| Segregación de redes | | | | |
| Filtrado de tráfico | | | | |
| Monitoreo de intrusos | | | | |
| Gestión de parches | | | | |

### 3. Análisis de Brechas
| Brecha Identificada | Riesgo Asociado | Controles Faltantes | Prioridad |
|---------------------|-----------------|---------------------|-----------|
|                     |                 |                     |           |

### 4. Mapa de Defensa en Profundidad
层次 (Capas) | Estado | Cobertura | Gaps
--- | --- | --- | ---

---
Completado cuando contiene auditoría perimetral completa con análisis de brechas.
EOF

# ============================================================
# Reto 7: Cross-Module Malware Analysis
# ============================================================
cat > malware-integration.md << 'EOF'
# Cross-Module Malware Analysis — Análisis Integrado de Malware

## Escenario
Análisis de una muestra de malware que integra técnicas de:
Module I (Impacto en Activos), Module II (Efecto en Red), Module III (IR), Module IV (Análisis).

## Ficha Técnica del Malware
| Campo | Valor |
|-------|-------|
| Nombre/Detección | |
| Tipo | (RAT / Ransomware / Trojan / Rootkit / Worm) |
| Vector de Infección | |
| Objetivos | |
| Técnicas MITRE ATT&CK | |

## Análisis por Módulo

### Module I — Impacto en Activos
| Activo Afectado | Tipo de Dato | Impacto | Riesgo Materializado |
|-----------------|-------------|---------|----------------------|
|                 |             |         |                      |

### Module II — Efecto en Red
| Comportamiento de Red | Protocolo | Destination | IOC |
|-----------------------|-----------|-------------|-----|
|                       |           |             |     |

### Module III — Respuesta a Incidentes
| Fase | Acción Tomada | Efectividad |
|------|---------------|:-----------:|
| Detección | | |
| Contención | | |
| Erradicación | | |
| Recuperación | | |

### Module IV — Análisis Técnico
| Aspecto | Hallazgo |
|---------|----------|
| Packer/Obfuscation | |
| API Calls | |
| Persistence | |
| Evasion | |

---
Completado cuando contiene análisis integrado de los 4 módulos.
EOF

# ============================================================
# Reto 8: Comprehensive Defense Report
# ============================================================
cat > defense-report.md << 'EOF'
# Comprehensive Defense Report — Informe Integral de Defensa

## Resumen Ejecutivo
Combinar hallazgos de todos los módulos para presentar el estado de seguridad
de la organización a la alta dirección.

## 1. Postura de Riesgo (Module I)
| Categoría | N° Riesgos | Alto | Medio | Bajo | Tendencia |
|-----------|:----------:|:----:|:-----:|:----:|:---------:|
| Estratégico | | | | | |
| Operacional | | | | | |
| Financiero | | | | | |
| Cumplimiento | | | | | |

## 2. Estado de Activos (Module I)
| Nivel | Críticos | Altos | Medios | Bajos | Total |
|-------|:--------:|:-----:|:------:|:-----:|:-----:|
| Total | | | | | |

## 3. Seguridad Perimetral (Module II)
| Capa | Estado | Vulnerabilidades | Recomendación |
|------|:------:|:----------------:|---------------|
| Perímetro | | | |
| DMZ | | | |
| Interna | | | |

## 4. Criptografía (Module III)
| Ámbito | Estado | Riesgo | Acción |
|--------|:------:|:------:|--------|
| Transmisión | | | |
| Almacenamiento | | | |
| Gestión de claves | | | |

## 5. Incidentes y IR (Module III)
| Tipo | N° Incidentes | MTTR | MTTD | Tendencia |
|------|:------------:|:----:|:----:|:---------:|
| Malware | | | | |
| Phishing | | | | |
| Acceso no autorizado | | | | |

## 6. Amenazas y Malware (Module IV)
| Categoría | Detecciones | Bloqueos | Fugas | Riesgo |
|-----------|:----------:|:--------:|:-----:|:------:|
| Ransomware | | | | |
| RAT | | | | |
| Banking Trojan | | | | |

## 7. Recomendaciones Priorizadas
| # | Recomendación | Módulo | Impacto | Esfuerzo | Prioridad |
|---|---------------|--------|:-------:|:--------:|:---------:|
| 1 | | | | | |
| 2 | | | | | |
| 3 | | | | | |

---
Completado cuando contiene informe integral con las 7 secciones.
EOF

# ============================================================
# Reto 9: Remediation Plan
# ============================================================
cat > remediation-plan.md << 'EOF'
# Remediation Plan — Plan de Remediación Cross-Module

## Priorización de Remediaciones
Integrando hallazgos de todos los módulos para crear un plan de acción unificado.

## Matriz de Priorización
| # | Hallazgo | Módulo Origen | Riesgo | Impacto | Esfuerzo | Prioridad | Deadline |
|---|----------|---------------|:------:|:-------:|:--------:|:---------:|----------|
| 1 |          |               |        |         |          |           |          |
| 2 |          |               |        |         |          |           |          |
| 3 |          |               |        |         |          |           |          |
| 4 |          |               |        |         |          |           |          |
| 5 |          |               |        |         |          |           |          |

## Remediaciones por Categoría

### Riesgos y Activos (Module I)
| # | Acción | Responsable | Recurso | Duración | Estado |
|---|--------|-------------|---------|----------|--------|
|   |        |             |         |          |        |

### Seguridad Perimetral (Module II)
| # | Acción | Responsable | Recurso | Duración | Estado |
|---|--------|-------------|---------|----------|--------|
|   |        |             |         |          |        |

### Criptografía e IR (Module III)
| # | Acción | Responsable | Recurso | Duración | Estado |
|---|--------|-------------|---------|----------|--------|
|   |        |             |         |          |        |

### Detección de Malware (Module IV)
| # | Acción | Responsable | Recurso | Duración | Estado |
|---|--------|-------------|---------|----------|--------|
|   |        |             |         |          |        |

## Cronograma
| Fase | Período | Entregables | Dependencias |
|------|---------|-------------|--------------|
| Inmediata (0-30 días) | | | |
| Corto plazo (30-90 días) | | | |
| Mediano plazo (90-180 días) | | | |
| Largo plazo (180+ días) | | | |

## Métricas de Éxito
| Métrica | Baseline | Objetivo | Fecha |
|---------|:--------:|:--------:|-------|
|         |          |          |       |

---
Completado cuando contiene plan de remediación priorizado con cronograma.
EOF

# ============================================================
# Reto 10: Final Assessment
# ============================================================
cat > final-assessment.md << 'EOF'
# Final Assessment — Evaluación Final Integradora

## Autoevaluación por Módulo

### Module I: Evaluación de Riesgos y Clasificación de Activos
| Concepto | Dominio (1-5) | Evidencia | Brecha |
|----------|:-------------:|-----------|--------|
| ISO 31000 / Matriz P×I | | | |
| Risk Register | | | |
| Clasificación de activos | | | |
| Controles compensatorios | | | |

### Module II: Seguridad Perimetral y Red
| Concepto | Dominio (1-5) | Evidencia | Brecha |
|----------|:-------------:|-----------|--------|
| Arquitectura de perímetro | | | |
| IDS/IPS | | | |
| Segmentación de red | | | |
| Firewall rules | | | |

### Module III: Criptografía y Respuesta a Incidentes
| Concepto | Dominio (1-5) | Evidencia | Brecha |
|----------|:-------------:|-----------|--------|
| CIF/CAV/ECB/GCM | | | |
| Gestión de claves | | | |
| IR phases (PICERL) | | | |
| Forensics básica | | | |

### Module IV: Análisis de Malware
| Concepto | Dominio (1-5) | Evidencia | Brecha |
|----------|:-------------:|-----------|--------|
| Static analysis | | | |
| Dynamic analysis | | | |
| MITRE ATT&CK | | | |
| YARA rules | | | |

## Integración Cross-Module
| Pregunta | Reflexión |
|----------|-----------|
| ¿Cómo afecta un incidente de malware a tu risk register? | |
| ¿Qué controles perimetrales habrían detectado el ataque? | |
| ¿La criptografía habría protegido los datos comprometidos? | |
| ¿Qué procesos de IR necesitas mejorar? | |

## Plan de Desarrollo Profesional
| Área | Acción | Plazo | Recurso |
|------|--------|-------|---------|
|      |        |       |         |

---
Completado cuando contiene autoevaluación completa de los 4 módulos.
EOF

echo -e "${VERDE}✅ Entorno del Lab Integrador creado en $HOME/laboratorio/integrador/${RESET}"
echo ""
echo -e "${CYAN}Archivos generados:${RESET}"
echo "  risk-incident.md        — Correlación Riesgo-Incidente"
echo "  network-forensics.sh    — Script de forense de red"
echo "  crypto-analysis.md      — Análisis criptográfico"
echo "  asset-inventory.csv     — Inventario de activos con risk scoring"
echo "  incident-playbook.md    — Playbook de respuesta a incidentes"
echo "  perimeter-audit.md      — Auditoría perimetral"
echo "  malware-integration.md  — Análisis integrado de malware"
echo "  defense-report.md       — Informe integral de defensa"
echo "  remediation-plan.md     — Plan de remediación cross-module"
echo "  final-assessment.md     — Evaluación final integradora"
echo ""
echo -e "${AMARILLO}Escribe ${CYAN}'manual'${AMARILLO} para ver las instrucciones o ${CYAN}'evaluar'${AMARILLO} para evaluar.${RESET}"
