# Preguntas de Evaluación - Clasificación de Activos

## Pregunta 1: Clasificación de activos según el triada CIA

**Escenario**:
La empresa GlobalTech está implementando un programa de gestión de activos bajo el marco NIST CSF 2.0. Debes clasificar los siguientes activos de información según su valor para la confidencialidad, integridad y disponibilidad (CIA): base de datos de clientes, código fuente de la aplicación, logs de auditoría del sistema y contrato con proveedor externo.

**Requisitos**:
- Identificar qué activos requieren protección de confidencialidad
- Identificar qué activos requieren protección de integridad
- Identificar qué activos requieren protección de disponibilidad
- Clasificar cada activo según su nivel de criticidad CIA

**Restricciones**:
- Usar la taxonomía de NIST CSF 2.0 para clasificación
- No asumir requisitos de negocio no especificados
- Cada activo debe ser clasificado según las tres dimensiones CIA
- Los niveles deben ser: alto, medio o bajo

**Criterios de Validación**:
- La clasificación CIA es consistente con el tipo de activo
- Se identificaron correctamente los activos de alta criticidad
- La justificación de clasificación es coherente
- Se aplicaron los criterios de NIST CSF 2.0

**Pregunta de Selección Múltiple**:

¿Cuáles son las tres dimensiones del triada CIA en seguridad de la información?

A) Confidencialidad, Integridad, Autenticidad
B) Confidencialidad, Integridad, Disponibilidad
C) Contención, Identificación, Acceso
D) Control, Integridad, Verificación

**Explicación**:
- Respuesta correcta: B) Confidencialidad, Integridad, Disponibilidad — El triada CIA es el modelo fundamental de seguridad de la información. Confidencialidad protege contra acceso no autorizado, Integridad protege contra modificación no autorizada, y Disponibilidad garantiza acceso cuando se necesita.
- Distractor A: Autenticidad es un concepto de seguridad pero no forma parte del triada CIA clásico.
- Distractor C: Contención, Identificación y Acceso son conceptos de respuesta a incidentes, no del triada CIA.
- Distractor D: Control y Verificación son controles de seguridad, pero no componen el triada CIA.

---

## Pregunta 2: Evaluación de riesgos con matriz de probabilidad-impacto

**Escenario**:
El equipo de seguridad de MegaCorp está realizando una evaluación de riesgos para tres activos: servidor web, estación de trabajo de desarrollo y base de datos de producción. Debes evaluar el riesgo de cada activo usando una matriz de probabilidad-impacto, donde la probabilidad es "alta" para el servidor web (expuesto a internet), "media" para la estación de desarrollo, y "baja" para la base de datos (aislada en red interna), con impacto "alto" para todos.

**Requisitos**:
- Evaluar el riesgo para cada activo usando la matriz probabilidad × impacto
- Clasificar el nivel de riesgo: alto, medio o bajo
- Proponer al menos un tratamiento de riesgo para cada activo
- Documentar la evaluación en formato estándar

**Restricciones**:
- Usar la matriz de riesgos estándar (probabilidad × impacto)
- No omitir ningún activo de la evaluación
- Los tratamientos deben ser viables técnicamente
- La evaluación debe ser consistente con NIST SP 800-30

**Criterios de Validación**:
- La matriz de riesgos está correctamente aplicada
- El servidor web tiene riesgo ALTO (probabilidad alta × impacto alto)
- Cada activo tiene al menos un tratamiento propuesto
- La documentación sigue el formato de NIST

**Pregunta de Selección Múltiple**:

¿Cuáles son los cuatro tipos de tratamiento de riesgo según ISO 27005?

A) Aceptar, Evitar, Transferir, Mitigar
B) Identificar, Evaluar, Controlar, Monitorear
C) Prevenir, Detectar, Responder, Recuperar
D) Analizar, Medir, Gestionar, Reportar

**Explicación**:
- Respuesta correcta: A) Aceptar, Evitar, Transferir, Mitigar — Son los cuatro tratamientos estándar de riesgo. Aceptar implica vivir con el riesgo, Evitar elimina la actividad que genera riesgo, Transferir lo transfiere a terceros (seguros), y Mitigar reduce la probabilidad o impacto.
- Distractor B: Son etapas del ciclo de gestión de riesgos, no tratamientos.
- Distractor C: Son funciones del marco NIST CSF, no tratamientos de riesgo específicos.
- Distractor D: Son actividades de gestión de riesgos, no los cuatro tratamientos definidos.
