# Unit X — SSL/TLS Certificates
## Evaluación: 2 preguntas prácticas

---

### Pregunta 1 — Certificado autofirmado y Subject DN

**Título:** PKI ticket — self-signed certificate for localhost

**Escenario:**  
El equipo de Seguridad necesita un certificado SSL autofirmado para el dominio `localhost` con validez de 365 días, válido para Ecuador (Quito). Debes generar la clave privada y el certificado, y reportar el Subject DN exacto para incluirlo en el inventario de certificados. Como evidencia, el validador consultará los archivos generados y el Subject del certificado.

**Requisitos:**
- Generar `clave_privada.pem` RSA 2048 bits en `/root/laboratorio/ssl/`.
- Generar `cert.pem` autofirmado con `/C=EC/ST=Quito/L=Quito/O=MiOrg/CN=localhost`.
- Verificar que `cert.pem` y `key.pem` existan.

**Restricciones:**
- Usar `openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem -days 365 -nodes`.
- No usar contraseña para la clave privada (`-nodes`).
- El Subject debe coincidir exactamente con el indicado.

**Criterios de validación:**
- `openssl x509 -in cert.pem -noout -subject` devuelve el Subject esperado.
- El certificado tiene fecha de expiración mayor a 360 días desde su creación.
- La clave privada tiene formato PEM.

**Pregunta de selección múltiple:**

> Después de generar el certificado autofirmado con el Subject indicado, ¿cuál es el valor exacto del campo `CN` (Common Name) en el certificado?

A) `localhost`  
B) `midominio.com`  
C) `MiOrg`  
D) `servidor.local`  

**Explicación de distractores:**
- B) `midominio.com`: coincide con el CN del Reto 7 (CSR), pero no con el certificado autofirmado del Reto 4.
- C) `MiOrg`: coincide con el campo `O` (Organization) del certificado, no con `CN`.
- D) `servidor.local`: coincide con el CN del certificado firmado por CA local (Reto 10), no con el autofirmado del Reto 4.

**Respuesta correcta:** A) `localhost`  
**Evidencia:** El `setup.sh` de Unit X, Reto 4, define `-subj "/C=EC/ST=Quito/L=Quito/O=MiOrg/CN=localhost"`. Se confirma ejecutando: `openssl x509 -in cert.pem -noout -subject | grep -o 'CN=[^/]*'`.

---

### Pregunta 2 — CA local y firma de certificado de servidor

**Título:** PKI ticket — internal CA-signed server certificate

**Escenario:**  
La directiva de seguridad exige que los servidores internos usen certificados firmados por una Autoridad Certificadora (CA) local propia, no autofirmados. Debes crear la CA, generar un CSR para `servidor.local` y firmar el certificado. Como evidencia, el validador consultará la existencia de los archivos de la CA y el certificado firmado.

**Requisitos:**
- Crear el directorio `ca/` en `/root/laboratorio/ssl/`.
- Generar `ca/ca.key` y `ca/ca.crt` con `openssl req -x509`.
- Generar `servidor.csr` y `servidor.key` para `CN=servidor.local`.
- Firmar `servidor.crt` usando `ca/ca.crt` y `ca/ca.key`.

**Restricciones:**
- La CA debe usar SHA-256 (`-sha256`).
- El certificado de servidor debe tener validez de 365 días.
- No reutilizar el CSR del Reto 7; debe ser para `servidor.local`.

**Criterios de validación:**
- `ca/ca.key` y `ca/ca.crt` existen.
- `servidor.crt` y `servidor.key` existen.
- `openssl verify -CAfile ca/ca.crt servidor.crt` devuelve `OK`.

**Pregunta de selección múltiple:**

> Después de firmar el certificado del servidor con la CA local, ¿cuál es el comando exacto que se usa para verificar que la cadena de confianza es válida?

A) `openssl verify -CAfile ca/ca.crt servidor.crt`  
B) `openssl x509 -in servidor.crt -text -noout`  
C) `openssl crl -in ca/ca.crl -verify`  
D) `openssl s_client -connect localhost:443`  

**Explicación de distractores:**
- B) `openssl x509 -in servidor.crt -text -noout`: muestra los detalles del certificado, pero no verifica la cadena de confianza contra la CA.
- C) `openssl crl -in ca/ca.crl -verify`: trabaja con Certificate Revocation Lists, no con la verificación de firma de un certificado.
- D) `openssl s_client -connect localhost:443`: herramienta para probar conexiones TLS, no para verificar cadenas de confianza offline.

**Respuesta correcta:** A) `openssl verify -CAfile ca/ca.crt servidor.crt`  
**Evidencia:** El `setup.sh` de Unit X, Reto 10, genera `servidor.crt` firmado por `ca/ca.crt`. El comando de verificación estándar es `openssl verify -CAfile ca/ca.crt servidor.crt`, que debe imprimir `servidor.crt: OK`.
