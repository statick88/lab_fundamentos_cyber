# IV — Criptografía y CVSS

---

## Pregunta 1: Análisis de Severidad con CVSS 3.1

**Escenario:**

Tu equipo de seguridad ha detectado una vulnerabilidad crítica en el servidor web de la empresa. Un atacante remoto puede explotar una inyección SQL en el parámetro `usuario` del formulario de login sin autenticación. La base de datos contiene registros de clientes incluyendo números de tarjeta de crédito. La producción está 24/7 y no puede ser detenida.

**Requisitos:**

1. Calcular el score CVSS 3.1 de esta vulnerabilidad usando el vector de ataque AV:N/AC:L/PR:N/UI:N/S:C/C:H/I:H/A:H.
2. Determinar la severidad según el rango CVSS (None/Low/Medium/High/Critical).
3. Identificar al menos 3 factores que contribuyen a la alta puntuación.

**Restricciones:**

- NO utilizar herramientas online de calculadoras CVSS; el cálculo debe hacerse manualmente.
- El scoring debe seguir estrictamente la especificación CVSS v3.1.
- El resultado debe documentarse en formato `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:C/C:H/I:H/A:H`.

**Criterios de Validación:**

1. Score numérico correcto: `10.0` (Critical).
2. Vector de ataque documentado completamente con todas las métricas base.
3. Justificación de cada métrica base seleccionada.
4. Identificación de las métricas que contribuyen al score máximo: Attack Vector = Network, Scope = Changed, Confidentiality/Integrity/Availability = High.

**Pregunta de Opción Múltiple:**

Un CVE con CVSS v3.1 `AV:N/AC:L/PR:N/UI:R/S:U/C:H/I:H/A:H` tiene un score de:

a) 8.8 (High)
b) 9.8 (Critical)
c) 7.5 (High)
d) 6.5 (Medium)

**Explicación:**

La respuesta correcta es **b) 9.8 (Critical)**.

- AV:N (Network) = 0.85
- AC:L (Low) = 0.77
- PR:N (None) = 0.85
- UI:R (Required) = 0.62
- Scope:Unchanged = 1.0
- C:H = 0.56, I:H = 0.56, A:H = 0.56

La métrica **UI:R** (User Interaction Required) reduce el score respecto a un escenario sin interacción del usuario (que sería 10.0), porque requiere que la víctima interactúe con el contenido malicioso (por ejemplo, hacer clic en un enlace). Con todas las demás métricas en valores máximos, el score resultante es 9.8, que cae en el rango **Critical** (9.0-10.0).

---

## Pregunta 2: Verificación de Integridad Criptográfica y Análisis de Logs

**Escenario:**

Un sysadmin te entrega un archivo `malware_simulado.bin` y un hash SHA-256 `e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855` que supuestamente corresponde al archivo legítimo. Además, has recibido un archivo `auth.log` con 500 entradas de autenticación y necesitas extraer los intentos fallidos de usuario `root`.

**Requisitos:**

1. Verificar la integridad del archivo usando `sha256sum`.
2. Determinar si el archivo ha sido alterado comparando con el hash proporcionado.
3. Extraer del `auth.log` las entradas de intentos fallidos de root con timestamp, usando herramientas de línea de comandos.
4. Documentar qué significaría una discrepancia en el hash en términos de seguridad.

**Restricciones:**

- El análisis debe hacerse con herramientas CLI estándar (`sha256sum`, `grep`, `awk`).
- NO abrir el archivo binario en un editor de texto.
- Los resultados del análisis de logs deben mostrarse en formato legible.

**Criterios de Validación:**

1. El hash del archivo se calcula correctamente con `sha256sum`.
2. Se determina si el hash coincide o no con el proporcionado.
3. Se extraen exactamente las líneas de `auth.log` que contienen intentos fallidos de root.
4. Se explica que una discrepancia de hash indica manipulación o corrupción del archivo.

**Pregunta de Opción Múltiple:**

¿Cuál es la diferencia fundamental entre SHA-256 y SHA-3?

a) SHA-3 es más rápido que SHA-256 en hardware moderno
b) SHA-3 utiliza la estructura sponge, mientras que SHA-256 usa la estructura Merkle-Damgård
c) SHA-3 proporciona 128 bits de seguridad, igual que SHA-256
d) SHA-3 es compatible con SHA-256 en términos de longitud de hash

**Explicación:**

La respuesta correcta es **b) SHA-3 utiliza la estructura sponge, mientras que SHA-256 usa la estructura Merkle-Damgård**.

- **SHA-256** (familia SHA-2) usa la estructura **Merkle-Damgård**: procesa el mensaje en bloques secuenciales, cada uno alimentando la función de compresión anterior. Esta estructura ha demostrado vulnerabilidades teóricas (como ataques de extensión de longitud).
- **SHA-3** (Keccak) fue diseñado como alternativa con una estructura completamente diferente: el **sponge construction**. Absorbe datos en una fase de "absorción" y produce output en una fase de "extracción", proporcionando resistencia estructural a ataques que afectan a Merkle-Damgård.
- Ambos proporcionan **256 bits de seguridad** contra colisiones (128 bits contra preimage), y ambos producen hashes de **256 bits**.
- SHA-3 no es necesariamente más rápido en software; su fortaleza está en la diversidad algorítmica y la resistencia a ataques de estructura.

La verificación de integridad con SHA-256 es una práctica fundamental en ciberseguridad: si el hash calculado no coincide con el hash esperado, el archivo ha sido modificado, lo que puede indicar inyección de malware, corrupción en transferencia, o manipulación deliberada.
