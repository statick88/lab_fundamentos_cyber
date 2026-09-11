# Cross-Unit Reference — Referencia Cross-Module

## Cómo se conectan los módulos

```
┌─────────────────────────────────────────────────────────────────┐
│                    MODULE I: Riesgos y Activos                  │
│  ISO 31000 · Matriz P×I · Clasificación · Risk Register        │
└───────────────┬─────────────────────────────┬───────────────────┘
                │                             │
    ┌───────────▼───────────┐     ┌───────────▼───────────┐
    │   MODULE II: Perímetro│     │  MODULE III: Cripto +  │
    │   Firewall · IDS ·    │     │  IR · Forensics        │
    │   DMZ · VPN           │     │  CIF/CAV · PICERL      │
    └───────────┬───────────┘     └───────────┬───────────┘
                │                             │
                └──────────────┬──────────────┘
                               │
                ┌──────────────▼──────────────┐
                │   MODULE IV: Malware         │
                │   Static · Dynamic · YARA    │
                │   MITRE ATT&CK · Sandboxing  │
                └──────────────┬──────────────┘
                               │
                ┌──────────────▼──────────────┐
                │   LAB INTEGRADOR             │
                │   Todos + Defense-in-Depth   │
                └─────────────────────────────┘
```

## Flujo de datos cross-module

### 1. Risk → Assets (Module I)
- El risk register define QUÉ proteger
- La clasificación de activos define EL OBJETIVO de la protección
- Sin activos identificados, no hay riesgos que gestionar

### 2. Assets → Perimeter (Module I → II)
- Los activos críticos definen la ARQUITECTURA perimetral
- Activos de mayor criticidad requieren más capas de defensa
- La segmentación de red se deriva de la clasificación

### 3. Perimeter → Crypto (Module II → III)
- El perímetro define DÓNDE se aplica cifrado
- TLS en la frontera, cifrado en reposo en activos internos
- Los controles perimetrales alimentan la política criptográfica

### 4. Crypto → IR (Module III)
- La criptografía PROTEGE la evidencia forense
- Los hashes verifican integridad de evidencia
- El cifrado preserva confidencialidad en tránsito de evidencia

### 5. IR → Malware (Module III → IV)
- El IR define EL PROCESO para manejar malware
- Los playbooks incluyen análisis de malware como paso
- La preservación de evidencia permite análisis estático/dinámico

### 6. Malware → Risk (Module IV → I)
- Los hallazgos de malware ACTUALIZAN el risk register
- Nuevas amenazas identificadas generan nuevos controles
- El ciclo cierra: Risk → Control → Detection → Response → Risk

## Patrones de integración

### Pattern 1: Incident-Driven Risk Update
```
Incidente detectado → Análisis de malware → IOC extraído
  → Controles actuales evaluados → Risk register actualizado
  → Nuevos controles propuestos → Implementación → Monitoreo
```

### Pattern 2: Risk-Informed Defense Architecture
```
Risk register → Activos críticos identificados
  → Arquitectura perimetral diseñada → Controles seleccionados
  → Validación con threat landscape → Ajustes
```

### Pattern 3: Evidence Chain
```
Detección IR → Preservación de evidencia
  → Chain of custody → Análisis forense
  → Hallazgos criptográficos → Reporte
```

## Defense-in-Depth Validation Methodology

### Capas de defensa y su validación
| Capa | Módulo | Qué valida | Cómo valida |
|------|--------|------------|-------------|
| Políticas | I | Gobernanza de riesgos | Revisión de documentación |
| Activos | I | Inventario completo | Conteo vs realidad |
| Perímetro | II | Barreras de entrada | Pentest / auditoría |
| Red | II | Segmentación | Traceroute / análisis de flujo |
| Criptografía | III | Protección de datos | Auditoría de algoritmos |
| Detección | IV | Visibilidad de amenazas | Simulación de ataque |
| Respuesta | III | Capacidad de reacción | Tabletop exercise |
| Recuperación | I/III | Continuidad del negocio | Test de backup/restore |

### Checklist de validación cross-module
- [ ] Cada activo crítico tiene al menos 3 capas de control
- [ ] Cada control está mapeado a un riesgo en el register
- [ ] Cada tipo de incidente tiene un playbook asociado
- [ ] La criptografía cubre transmisión Y almacenamiento
- [ ] Los IOCs de malware se correlacionan con alertas de red
- [ ] El risk register se actualiza post-incidente
- [ ] Los controles perimetrales cubren las TOP 10 amenazas
- [ ] El IR plan tiene tiempos definidos (MTTD/MTTR targets)

## Cross-domain analysis techniques

### Technique 1: Blast Radius Analysis
Preguntar: "Si este activo se compromete, qué otros se afectan?"
- Mapear dependencias entre activos
- Identificar activos single-point-of-failure
- Evaluar propagación de impacto

### Technique 2: Kill Chain Mapping
Mapear cada fase de la kill chain a controles:
| Fase | Controles | Estado |
|------|-----------|--------|
| Recon | IDS, honeypots | |
| Weaponization | AppLocker, SRP | |
| Delivery | Email gateway, WAF | |
| Exploitation | Patches, ASLR/DEP | |
| Installation | AV/EDR, FIM | |
| C2 | Firewall, DNS filtering | |
| Actions | DLP, SIEM | |

### Technique 3: MITRE ATT&CK Coverage Matrix
Mapear técnicas observadas a controles existentes:
- Identificar gaps en cobertura
- Priorizar desarrollo de detecciones
- Validar con Atomic Red Team tests

## Holistic reporting

### Structure for executive reporting
1. **Resumen Ejecutivo**: Estado actual en 1 página
2. **Risk Posture**: Top 5 riesgos y su tendencia
3. **Control Effectiveness**: Matriz de controles vs cobertura
4. **Incident Metrics**: MTTD, MTTR, volumen de alertas
5. **Threat Landscape**: Amenazas relevantes para la organización
6. **Recommendations**: Top 10 acciones priorizadas
7. **Roadmap**: Plan de mejora a 6/12/18 meses

### Reporting alignment
| Audience | Frequency | Content | Module Focus |
|----------|-----------|---------|--------------|
| Board | Quarterly | Risk posture, $ impact | I |
| CISO | Monthly | Control metrics, incidents | I, II, III |
| SOC | Daily | Alerts, IOCs, triage | II, IV |
| IT Ops | Weekly | Patches, configs, vulns | II, III |
| IR Team | Per incident | Timeline, evidence, actions | III, IV |
