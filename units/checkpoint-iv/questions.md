# Preguntas de Evaluación - Checkpoint IV: Amenazas y Criptografía

## Pregunta 1: Evaluación de severidad con CVSS 3.1

**Escenario**:
El equipo de respuesta a incidentes de TechCorp descubrió una vulnerabilidad en el servidor de correo electrónico. El vector de ataque es de red (AV:N), la complejidad es baja (AC:L), no se requiere autenticación (PR:N), no hay interacción del usuario (UI:N), el impacto es alto en confidencialidad (C:H) e integridad (I:H), y no hay impacto en disponibilidad (A:N). Debes calcular el score CVSS 3.1 y clasificar la severidad según el rango CVSS.

**Requisitos**:
- Calcular el score CVSS 3.1 a partir de los vectores dados
- Clasificar la severidad: crítico (9.0-10.0), alto (7.0-8.9), medio (4.0-6.9), bajo (0.1-3.9)
- Registrar el vector de ataque completo en formato CVSS 3.1
- Reportar la severidad encontrada

**Restricciones**:
- Usar la fórmula oficial de CVSS 3.1
- No asumir valores de métricas no especificadas
- El cálculo debe ser verificable con una calculadora CVSS oficial
- Reportar el score con un decimal de precisión

**Criterios de Validación**:
- El score CVSS 3.1 es correcto según la fórmula oficial
- La clasificación de severidad es consistente con el score
- El vector de ataque está en formato correcto: `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:N`
- Se verificó con `eval_cvss` o cálculo manual

**Pregunta de Selección Múltiple**:

¿Cuál es la fórmula para calcular el Score Base de CVSS 3.1?

A) `Exploitability × Impact`
B) `(Exploitability + Impact) / 2`
C) `Exploitability × Impact` (con redondeo según especificación)
D) `Impact - Exploitability`

**Explicación**:
- Respuesta correcta: C) El Score Base de CVSS 3.1 se calcula multiplicando el subscore de Explotabilidad por el subscore de Impacto, con un redondeo al decimal más cercano según la especificación oficial FIRST.org.
- Distractor A: Formalmente correcto en multiplicación, pero falta la especificación de redondeo y el manejo del rango (0-10).
- Distractor B: Promediar no es la fórmula de CVSS; el score se basa en multiplicación.
- Distractor D: Restar no corresponde a la metodología CVSS.

---

## Pregunta 2: Generación y verificación de hash SHA-256

**Escenario**:
El equipo de integridad de datos necesita verificar que un archivo de configuración crítico no ha sido modificado. Debes generar el hash SHA-256 del archivo `/etc/ssh/sshd_config` y guardarlo en un archivo de verificación. El hash debe ser verificable para confirmar que el archivo no ha sido alterado desde la captura inicial.

**Requisitos**:
- Generar el hash SHA-256 del archivo objetivo
- Guardar el hash en un archivo de verificación con el formato estándar
- Verificar que el hash generado coincide con el archivo
- Documentar el proceso de verificación

**Restricciones**:
- No modificar el archivo original
- Usar solo herramientas estándar del sistema (`sha256sum`)
- El archivo de verificación debe incluir el nombre del archivo y el hash
- No usar herramientas de terceros no verificadas

**Criterios de Validación**:
- El hash SHA-256 generado es de 64 caracteres hexadecimales
- La verificación con `sha256sum -c` reporta "OK" para el archivo
- El archivo de verificación tiene el formato correcto
- El proceso es reproducible y genera el mismo hash

**Pregunta de Selección Múltiple**:

¿Qué comando genera el hash SHA-256 de un archivo y lo muestra en pantalla?

A) `md5sum archivo`
B) `sha256sum archivo`
C) `sha1sum archivo`
D) `hashsum archivo`

**Explicación**:
- Respuesta correcta: B) `sha256sum archivo` — Genera el hash SHA-256 del archivo especificado y lo imprime en formato hexadecimal de 64 caracteres. Es el estándar para verificación de integridad en Linux.
- Distractor A: `md5sum` usa MD5 que es criptográficamente débil y deprecated para verificación de integridad.
- Distractor C: `sha1sum` usa SHA-1 que también tiene colisiones conocidas y no se recomienda para uso de seguridad.
- Distractor D: `hashsum` no es un comando estándar de Linux.
