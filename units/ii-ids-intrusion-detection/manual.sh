#!/bin/bash
# Unit II-ids: Detección de Intrusos con Suricata — manual.sh

# Support both container (/shared) and local (relative) paths
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
fi

banner_unidad 6 "Detección de Intrusos con Suricata"

cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║  Módulo II: Redes y Controles Perimetrales                 ║
║  Unidad II-ids: Detección de Intrusos con Suricata          ║
╚══════════════════════════════════════════════════════════════╝

📚 CONCEPTOS CLAVE
══════════════════

  SISTEMAS DE DETECCIÓN DE INTRUSIONES (IDS)
  ─────────────────────────────────────────────
  Un IDS monitorea tráfico de red o actividad de sistema
  para detectar comportamientos maliciosos o violaciones
  de políticas de seguridad.

  Suricata: motor IDS/IPS de código abierto que:
  • Analiza tráfico en tiempo real
  • Aplica reglas de detección (snort-compatible)
  • Genera alertas en formato JSON (eve.json) y fast.log
  • Soporta reglas personalizadas en local.rules

  TIPOS DE DETECCIÓN
  ──────────────────
  • Signature-based: coincide con patrones conocidos (firmas)
  • Anomaly-based: detecta desviaciones del baseline
  • Protocol analysis: verifica cumplimiento de protocolos

  FORMATO DE REGLAS SURICATA
  ───────────────────────────
  action protocol source_ip source_port -> dest_ip dest_port (opciones)
  
  Ejemplo:
  alert tcp 192.168.1.0/24 any -> 10.0.0.10 22 (msg:"SSH scan"; sid:1000001;)

  ARCHIVOS DE ALERTAS
  ───────────────────
  • /var/log/suricata/fast.log — alertas en formato legacy "fast"
  • /var/log/suricata/eve.json — alertas en JSON estructurado

🎯 RETOS DE ESTA UNIDAD
═══════════════════════

   3 retos CORE de detección de intrusiones:

   1. Verificar instalación y estado de Suricata
      Comprobar que Suricata está instalado, el binario existe,
      y la configuración es válida.

   2. Validar reglas personalizadas (local.rules)
      Crear y validar sintaxis de reglas Suricata para detectar:
      - Escaneos SSH
      - Intentos de SQL injection
      - Escaneos de puertos

   3. Generar y verificar alertas
      Simular tráfico de red que active las reglas y verificar
      que se generan alertas en /var/log/suricata/fast.log

💡 CONSEJOS
═══════════
  - Usa 'suricata -T -c /etc/suricata/suricata.yaml' para validar config
  - Usa 'suricata -S local.rules' para cargar solo tus reglas
  - Los logs de alertas son en texto plano, usa grep para filtrar
EOF
