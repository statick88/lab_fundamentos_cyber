# IV — Lab Integrador (Capstone)

---

## Pregunta 1: Análisis Cross-Module — Correlación Riesgo-Incidente

**Escenario:**

Una empresa fintech ha sufrido un incidente de ransomware que cifró la base de datos de clientes. El atacante ingresó a través de un phishing a un empleado del departamento de recursos humanos. Durante el análisis post-incidente, se descubrió que: (1) no existía segmentación entre la red de RH y la de producción, (2) los backups de la base de datos no se habían verificado en 6 meses, y (3) la clasificación de activos no consideraba la base de datos como "crítica".

**Requisitos:**

1. Correlacionar el incidente con un risk register hipotético, identificando qué controles fallaron en cada capa de defensa (prevención, detección, respuesta).
2. Determinar qué habría pasado si se hubiera aplicado defense-in-depth correctamente en al menos 3 capas.
3. Proponer al menos 5 remediaciones específicas, priorizadas por impacto y esfuerzo.
4. Mapear las técnicas del atacante al framework MITRE ATT&CK (mínimo 4 técnicas).

**Restricciones:**

- Las remediaciones deben ser accionables y específicas (no genéricas como "mejorar la seguridad").
- El análisis debe integrar al menos 3 módulos del curso (Riesgos, Perímetro, IR/Malware).
- Cada remediación debe incluir responsable estimado y timeline.

**Criterios de Validación:**

1. Risk register correlacionado con al menos 3 controles que fallaron.
2. Análisis de defense-in-depth con al menos 3 capas evaluadas.
3. 5 remediaciones priorizadas con responsable y timeline.
4. Mapeo MITRE ATT&CK con al menos 4 técnicas identificadas (ej: T1566 Phishing, T1486 Data Encrypted for Impact, T1078 Valid Accounts, T1021 Remote Services).

**Pregunta de Opción Múltiple:**

En un análisis cross-module de un incidente de ransomware, ¿cuál es la secuencia CORRECTA de correlación entre módulos?

a) Malware → Red → Riesgos → Criptografía
b) Riesgos → Activos → Perímetro → Criptografía → IR → Malware
c) IR → Malware → Red → Riesgos
d) Perímetro → Red → IR → Malware → Activos

**Explicación:**

La respuesta correcta es **b) Riesgos → Activos → Perímetro → Criptografía → IR → Malware**.

La secuencia correcta de análisis cross-module sigue la cadena de valor de seguridad:

1. **Riesgos** (Module I): Se identifican los riesgos que la organización enfrenta — ¿qué puede salir mal?
2. **Activos** (Module I): Se clasifican los activos por criticidad — ¿qué estamos protegiendo?
3. **Perímetro** (Module II): Se evalúan las defensas perimetrales — ¿cómo protegemos los activos?
4. **Criptografía** (Module III): Se evalúa la protección de datos — ¿cómo aseguramos la confidencialidad e integridad?
5. **IR** (Module III): Se analiza la respuesta al incidente — ¿cómo respondimos cuando fallaron los controles?
6. **Malware** (Module IV): Se analiza la amenaza técnica — ¿qué nos atacó y cómo funciona?

Esta secuencia es la que sigue un analista de seguridad en un escenario real: primero entiende el contexto de riesgo, luego los activos, después las defensas, la protección de datos, la respuesta, y finalmente la amenaza técnica. Saltar pasos o ir en desorden produce un análisis incompleto y remediaciones parciales.

---

## Pregunta 2: Diseño de Defensa en Profundidad

**Escenario:**

Una organización con 500 empleados necesita rediseñar su arquitectura de seguridad. Actualmente tiene un firewall perimetral, antivirus en todas las estaciones, y un plan de backup mensual. No tiene segmentación de red, no usa MFA, y no tiene procedimientos de IR documentados.

**Requisitos:**

1. Diseñar una arquitectura defense-in-depth con al menos 5 capas, indicando controles específicos para cada una.
2. Para cada capa, explicar qué amenazas mitiga y qué brechas de la arquitectura actual corrige.
3. Proponer un plan de implementación por fases (inmediato, corto, mediano, largo plazo).
4. Definir métricas de éxito para validar que cada capa está operativa.

**Restricciones:**

- Cada capa debe ser independiente (si una falla, las demás siguen protegiendo).
- El plan debe ser viable para una organización con presupuesto limitado.
- Las métricas deben ser medibles y específicas.

**Criterios de Validación:**

1. Al menos 5 capas de defensa documentadas con controles específicos.
2. Cada capa vinculada a amenazas específicas que mitiga.
3. Plan de implementación en 4 fases con timeline y dependencias.
4. Métricas de éxito medibles para cada capa.

**Pregunta de Opción Múltiple:**

¿Cuál de las siguientes opciones describe MEJOR el principio de defense-in-depth?

a) Implementar el firewall más caro disponible en el perímetro
b) Usar múltiples capas de controles donde cada una mitiga diferentes amenazas
c) Duplicar todos los controles de seguridad para tener redundancia
d) Concentrar todos los recursos en la capa más débil identificada

**Explicación:**

La respuesta correcta es **b) Usar múltiples capas de controles donde cada una mitiga diferentes amenazas**.

Defense-in-depth no es sobre cantidad ni costo, sino sobre **diversidad y complementariedad** de controles. El principio se basa en que:

- **Ningún control es perfecto**: cada capa puede ser evadida o comprometida.
- **Las capas se complementan**: si el firewall falla, el IDS detecta; si el IDS falla, la segmentación limita el movimiento lateral; si el movimiento lateral ocurre, la cifración protege los datos.
- **Diferentes amenazas requieren diferentes controles**: un firewall no detiene el phishing, un antivirus no detecta el movement lateral, MFA no previene el ransomware en backups.

La opción (a) es incorrecta porque un solo control, por costoso que sea, no es defense-in-depth. La opción (c) es incorrecta porque duplicar no agrega diversidad — si el control falla, la copia falla igual. La opción (d) es incorrecta porque ignorar las demás capas crea puntos ciegos.

El verdadero defense-in-depth integra: perímetro → segmentación → endpoint → datos → identidad → monitoreo → respuesta, donde cada capa opera independientemente y se fortalece mutuamente.
