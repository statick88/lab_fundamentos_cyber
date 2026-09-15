#!/bin/bash
# ==============================================================================
# Script Cliente para Pruebas con Burp Suite / Curl — Lab iv-burp-intercept
# ==============================================================================

# Definir la URL objetivo provista por el setup del laboratorio (ej. puerto local del backend)
TARGET_URL="${TARGET_URL:-http://localhost:5000/api/v1/transaction}"

# Definir el proxy de Burp Suite (por defecto 127.0.0.1:8080)
BURP_PROXY="${BURP_PROXY:-http://127.0.0.1:8080}"

echo "================================================================="
echo " [1] Prueba sin Proxy (Conexión Directa al Servidor Objetivo)     "
echo "================================================================="
curl -s -X GET "$TARGET_URL" \
     -H "User-Agent: LabClient-Direct/1.0" \
     -H "Accept: application/json" | json_pp 2>/dev/null || curl -s -X GET "$TARGET_URL"

echo -e "\n\n================================================================="
echo " [2] Prueba con Proxy Intermedio (Burp Suite en $BURP_PROXY)        "
echo "================================================================="
echo "Nota: Asegúrate de tener Burp Suite abierto y el Intercept encendido si deseas modificar la petición en tránsito."

curl -s -x "$BURP_PROXY" -X POST "$TARGET_URL" \
     -H "Content-Type: application/json" \
     -H "X-User-Role: standard" \
     -d '{"item_id": 101, "quantity": 1, "total_price": 50.00}' \
     -iv

echo -e "\n\n================================================================="
echo " [3] Simulación de Bypass / Modificación de Cabeceras o Parámetros "
echo "================================================================="
# Petición diseñada para que el estudiante intercepte y altere 'total_price' o 'X-User-Role'
curl -s -x "$BURP_PROXY" -X PUT "$TARGET_URL/update" \
     -H "Content-Type: application/json" \
     -H "X-User-Role: guest" \
     -d '{"transaction_id": "TX-9988", "discount_applied": false, "amount_due": 500.00}'

echo -e "\n\n[INFO] Ejecución de pruebas con curl finalizada."