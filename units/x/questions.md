# Preguntas de Evaluación - Unidad X: SSL/TLS

## Pregunta 1: Generación de CSR para certificado wildcard

**Escenario**:
El equipo de DevOps necesita obtener un certificado SSL/TLS para el dominio `*.empresa.com` y sus subdominios. Como parte del proceso, debes generar una Solicitud de Firma de Certificado (CSR) con los datos de la organización y una clave privada RSA de 2048 bits. Una vez generada, debes extraer y reportar el valor exacto del campo `CN` (Common Name) contenido en la CSR para que el equipo de seguridad lo valide antes de enviarlo a la Autoridad Certificadora.

**Requisitos**:
- Generar una clave privada RSA de 2048 bits llamada `key_csr.pem`
- Generar una CSR llamada `request.csr` con el Subject `/C=EC/ST=Quito/L=Quito/O=MiOrg/CN=*.empresa.com`
- Extraer el campo `CN` del Subject de la CSR
- Mostrar el contenido del Subject en formato texto

**Restricciones**:
- Usar `openssl req` con los flags `-new`, `-newkey rsa:2048`, `-nodes`
- El archivo de la clave privada debe ser `key_csr.pem`
- El archivo de la CSR debe ser `request.csr`
- No modificar el archivo una vez generado

**Criterios de Validación**:
- El comando `openssl req -in request.csr -text -noout | grep -A1 "Subject"` muestra el Subject completo
- El campo `CN` en el Subject es exactamente `*.empresa.com`
- El archivo `request.csr` existe y es legible
- El archivo `key_csr.pem` existe y es legible

**Pregunta de Selección Múltiple**:

¿Cuál es el valor exacto del campo `CN` (Common Name) en el Subject de la CSR generada?

A) `empresa.com`
B) `*.empresa.com`
C) `midominio.com`
D) `servidor.local`

**Explicación**:
- Respuesta correcta: B) `*.empresa.com` - Este es el valor del parámetro `CN` en el Subject de la CSR, especificado con `-subj "/C=EC/ST=Quito/L=Quito/O=MiOrg/CN=*.empresa.com"`. Se obtiene ejecutando: `openssl req -in request.csr -text -noout | grep "Common Name"` o `openssl req -in request.csr -text -noout | grep -A1 "Subject"`
- Distractor A: `empresa.com` - Es el dominio base sin el prefijo wildcard `*.`. Un estudiante podría olvidar incluir el asterisco en el CN.
- Distractor C: `midominio.com` - Es el CN utilizado en el reto 7 (`-subj "/C=EC/ST=Quito/O=Test/CN=test.com"`). Corresponde a un reto diferente de generación de CSR.
- Distractor D: `servidor.local` - Es el CN utilizado en el reto 10 para firmar el certificado con la CA local (`-subj "/C=EC/O=Test/CN=servidor.local"`). Corresponde a otro reto de la unidad.

---

## Pregunta 2: Verificación de validez de certificado autofirmado

**Escenario**:
Un servicio web interno dejó de responder porque su certificado SSL/TLS expiró. El equipo de operaciones necesita verificar urgentemente la validez del certificado autofirmado `cert.pem` que se encuentra en el laboratorio, y reportar la cantidad exacta de días restantes antes de su vencimiento para justificar la creación de uno nuevo. Debes ejecutar el comando de verificación de OpenSSL, capturar la salida exacta y determinar el número de días restantes.

**Requisitos**:
- Ejecutar el comando de verificación de validez del certificado `cert.pem`
- Capturar la salida exacta del comando
- Extraer el número de días restantes antes del vencimiento
- Reportar la fecha de vencimiento exacta del certificado

**Restricciones**:
- No modificar el archivo `cert.pem`
- No generar un nuevo certificado
- No usar herramientas externas, solo `openssl`
- El certificado fue generado con `-days 365`

**Criterios de Validación**:
- El comando `openssl x509 -in cert.pem -checkend 0 -noout 2>&1` contiene la palabra `will not expire` o `ok`
- El comando `openssl x509 -in cert.pem -enddate -noout` devuelve una fecha en formato `notAfter=MMM DD HH:MM:SS YYYY GMT`
- El certificado `cert.pem` existe en `/root/laboratorio/ssl/`
- El archivo `cert.pem` fue generado con el Subject `/C=EC/ST=Quito/O=Test/CN=localhost`

**Pregunta de Selección Múltiple**:

¿Cuál es la salida exacta de `openssl x509 -in cert.pem -checkend 0 -noout 2>&1` cuando el certificado es válido?

A) `Certificate will expire`
B) `Certificate will not expire`
C) `cert.pem: OK`
D) `Certificate is valid`

**Explicación**:
- Respuesta correcta: B) `Certificate will not expire` - Cuando el certificado `cert.pem` (generado con `-days 365`) aún está dentro de su período de validez, el comando `openssl x509 -checkend 0 -noout` devuelve exactamente esta cadena. El parámetro `-checkend 0` verifica si el certificado expira en los próximos 0 segundos (es decir, si ya expiró). Si no expira, OpenSSL imprime `Certificate will not expire`.
- Distractor A: `Certificate will expire` - Es la salida cuando el certificado ya expiró o está a punto de expirar. No coincide con un certificado recién generado con 365 días de validez.
- Distractor C: `cert.pem: OK` - No es un formato de salida de OpenSSL. Podría confundirse con la salida de `openssl verify` o de otros comandos de verificación.
- Distractor D: `Certificate is valid` - No es la salida exacta de `openssl x509 -checkend`. Es una frase genérica que podría usarse en documentación, pero no es el formato de OpenSSL.
