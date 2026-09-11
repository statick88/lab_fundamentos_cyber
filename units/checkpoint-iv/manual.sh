#!/bin/bash
# Checkpoint IV: Evaluación Módulo IV — manual.sh

# Dual-path sourcing
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
fi

banner_unidad 13 "Checkpoint Módulo IV"

cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║  Checkpoint Módulo IV: Amenazas y Criptografía              ║
╚══════════════════════════════════════════════════════════════╝

📚 CONCEPTOS CLAVE
══════════════════

  CVSS (Common Vulnerability Scoring System)
  ───────────────────────────────────────────
  Framework para puntuar la severidad de vulnerabilidades.
  CVSS 3.1: Score base de 0.0 a 10.0.
  Métricas base: AV, AC, PR, UI, S, C, I, A.
  Rangos: Crítico (9.0-10.0), Alto (7.0-8.9), Medio (4.0-6.9), Bajo (0.1-3.9).

  Hashing Criptográfico
  ─────────────────────
  Función unidireccional que genera un "fingerprint" de datos.
  SHA-256: produce un hash de 256 bits (64 hex chars).
  Propiedades: resistencia a colisión, preimage, segunda preimage.
  Usos: integridad de archivos, verificación de descargas.

  Certificados X.509
  ──────────────────
  Estándar para certificados digitalesPKI.
  Contienen: subject, issuer, válido desde/hasta, clave pública, firma.
  Cadena de confianza: Root CA → Intermediate CA → End-entity cert.
  Verificación: openssl verify -CAfile ca.crt servidor.crt

  Infraestructura de Clave Pública (PKI)
  ───────────────────────────────────────
  Sistema para gestionar claves y certificados.
  Componentes: CA, RA, repositorio, CRL, OCSP.
  Flujo: generar CSR → CA firma → certificado emitido → uso.

  Firmas Digitales
  ────────────────
  Prueba de autoría e integridad de un documento.
  Proceso: hash del documento + cifrar hash con clave privada.
  Verificación: descifrar firma con clave pública + comparar hashes.

🎯 RETOS DE ESTA UNIDAD
═══════════════════════

  Reto 1: CVSS Base Score
  ────────────────────────
  Objetivo: Calcular el score CVSS 3.1 base de una vulnerabilidad.
  Criterio: Usar calculadora o script que retorne score correcto.
  Métricas: AV:N/AC:H/PR:L/UI:N/S:U/C:H/I:H/A:H → ~7.5

  Reto 2: Hash SHA-256
  ─────────────────────
  Objetivo: Generar el hash SHA-256 de un archivo de clave privada.
  Criterio: sha256sum deve retornar hash de 64 caracteres hex.

  Reto 3: Verificar Cadena de Certificados
  ─────────────────────────────────────────
  Objetivo: Verificar que servidor.crt es válido contra ca.crt.
  Criterio: openssl verify debe retornar "OK".

  Reto 4: Inspeccionar Detalles X.509
  ────────────────────────────────────
  Objetivo: Extraer subject e issuer de un certificado.
  Criterio: openssl x509 -text debe mostrar subject/issuer.

  Reto 5: Firma Digital
  ──────────────────────
  Objetivo: Firmar un archivo con la clave privada de la CA.
  Criterio: Generar archivo de firma válido con openssl dgst.

💡 COMANDOS PARA EL LAB
═══════════════════════

  # CVSS — calculadora python
  python3 cvss_calculator.py

  # Hash SHA-256
  sha256sum servidor.key
  sha256sum servidor.crt

  # Verificar cadena
  openssl verify -CAfile ca/ca.crt servidor.crt

  # Detalles certificado
  openssl x509 -in servidor.crt -text -noout
  openssl x509 -in servidor.crt -subject -issuer -dates

  # Firma digital
  openssl dgst -sha256 -sign ca/ca.key -out firma.sig archivo.txt
  openssl dgst -sha256 -verify ca/ca.crt -signature firma.sig archivo.txt

  # Generar clave y cert
  openssl genrsa -out clave.pem 2048
  openssl req -new -key clave.pem -out solicitud.csr

📝 EJEMPLOS ÚTILES
══════════════════

  # Script de verificación completa:
  #!/bin/bash
  echo "=== Verificación de Cadena ==="
  openssl verify -CAfile ca/ca.crt servidor.crt
  echo ""
  echo "=== Detalles del Certificado ==="
  openssl x509 -in servidor.crt -subject -issuer -dates -noout
  echo ""
  echo "=== Hash SHA-256 ==="
  sha256sum servidor.crt

EOF

echo -e "${AMARILLO}Escribe ${CYAN}'retos-unidad'${AMARILLO} para ver los retos o ${CYAN}'evaluar'${AMARILLO} para evaluar.${RESET}"
