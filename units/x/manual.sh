#!/bin/bash
# Unit X: SSL/TLS Certificates — manual.sh
# Interactive guide for learning SSL

# Support both container (/shared) and local (relative) paths
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
fi

UNIT_NAME="unit-X"
banner_unidad 10 "Certificados SSL/TLS"

cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║  Guia de Certificados SSL/TLS                              ║
║  Aprende a proteger la comunicacion web con cifrado        ║
╚══════════════════════════════════════════════════════════════╝

📚 CONCEPTOS CLAVE
═══════════════════

  SSL/TLS cifra la comunicacion entre navegador y servidor:
  • Confidencialidad — datos cifrados en transito
  • Integridad — datos no alterados
  • Autenticidad — servidor verificado

  Tipos de certificados:
  • Auto-firmado — para desarrollo/pruebas
  • Let's Encrypt — gratuito, para produccion
  • Comercial — pagado, con garantia

🔧 COMANDOS ESENCIALES
══════════════════════════

  Claves y certificados
  ───────────────────────
  openssl genrsa -out clave.pem 2048      # Generar clave privada
  openssl req -x509 ... -out cert.pem     # Crear certificado autofirmado
  openssl req -new ... -out request.csr   # Crear solicitud de certificado
  openssl x509 -in cert.pem -text -noout  # Ver detalles del certificado

  Verificar certificados
  ────────────────────────
  openssl x509 -in cert.pem -checkend 0   # Verificar si expiro
  openssl verify -CAfile ca.crt cert.pem  # Verificar contra CA
  openssl s_client -connect host:443      # Verificar certificado remoto

  Let's Encrypt (produccion)
  ───────────────────────────
  sudo certbot --nginx -d midominio.com   # Obtener certificado
  sudo certbot renew                       # Renovar certificados
  sudo certbot certificates                # Ver certificados activos

🎯 RETOS
══════════

  Los retos estan en ~/laboratorio/ssl/reto[1-15].sh
  Ejecuta cada reto con: bash reto1.sh
  Usa 'evaluar' para verificar tu progreso.

💡 EJEMPLOS UTILES
════════════════════

  # Crear certificado autofirmado rapido
  openssl req -x509 -newkey rsa:2048 -keyout key.pem \
    -out cert.pem -days 365 -nodes -subj "/CN=localhost"

  # Verificar certificado de un sitio web
  openssl s_client -connect google.com:443 < /dev/null 2>/dev/null | openssl x509 -text -noout

  # Crear CA local para tu organizacion
  openssl genrsa -out ca.key 4096
  openssl req -x509 -new -key ca.key -sha256 -days 3650 -out ca.crt -subj "/CN=Mi CA"

  # Firmar un certificado con tu CA
  openssl x509 -req -in servidor.csr -CA ca.crt -CAkey ca.key \
    -CAcreateserial -out servidor.crt -days 365 -sha256

  RSA Y ECC AVANZADO
  ───────────────────
  RSA 4096 bits: mayor seguridad que 2048, recomendado para CA
  ECC secp384r1: curva elíptica, claves más cortas, misma seguridad
  CSR: Certificate Signing Request, solicitud de firma a CA
  Cadena de certificados: verificar servidor.crt → CA intermedia → CA raíz

  Comandos RSA/ECC:
  openssl genrsa -out rsa4096.pem 4096
  openssl ecparam -genkey -name secp384r1 -out ecc.key
  openssl req -new -key key.pem -out request.csr
  openssl verify -CAfile ca.crt cert.pem

EOF

echo -e "\n${AMARILLO}Escribe ${CYAN}'evaluar'${AMARILLO} para verificar tu progreso o ${CYAN}'retos'${AMARILLO} para ver los retos.${RESET}"
