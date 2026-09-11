#!/bin/bash
# Unit ii-arquitectura-perimetral: Arquitectura Perimetral, Segmentación y DMZ — manual.sh

# Support both container (/shared) and local (relative) paths
if [ -f "/shared/common.sh" ]; then
    source /shared/common.sh
else
    source "$(dirname "$0")/../../shared/common.sh"
fi

banner_unidad 7 "Arquitectura Perimetral, Segmentación y DMZ"

cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║  Módulo II: Redes y Seguridad                               ║
║  Unidad: Arquitectura Perimetral, Segmentación y DMZ        ║
╚══════════════════════════════════════════════════════════════╝

📚 CONCEPTOS CLAVE
══════════════════

  WAN / DMZ / LAN / Mgmt
  ───────────────────────
  Zonas de red que definen niveles de confianza:
  • WAN (Wide Area Network) — Zona de menor confianza, conectada a Internet.
    Todo el tráfico entrante se considera hostil hasta que se demuestre lo contrario.
  • DMZ (Demilitarized Zone) — Zona intermedia para servicios expuestos al exterior
    (web, DNS público, correo). Aislada de la LAN; si es comprometida, no afecta
    la red interna directamente.
  • LAN (Local Area Network) — Zona interna de mayor confianza. Alberga servidores
    de base de datos, aplicaciones internas y estaciones de trabajo.
  • Mgmt (Management) — Zona de gestión aislada. Solo accesible desde bastion/jump
    hosts autorizados. Usada para administrar firewalls, switches y servidores.

  Default-Deny
  ────────────
  Política de firewall que bloquea todo el tráfico por defecto y solo permite
  lo explícitamente autorizado. Es el PRIMER paso en cualquier configuración:
    iptables -P FORWARD DROP
    iptables -P INPUT DROP
    iptables -P OUTPUT DROP

  Allowlisting
  ────────────
  Lista explícita de tráfico permitido. Complementa el default-deny: solo se
  abren puertos y flujos específicos con justificación documentada.
  Ejemplo: permitir TCP 80/443 desde WAN hacia DMZ para servicios web públicos.

  Defense-in-Depth (Defensa en Profundidad)
  ──────────────────────────────────────────
  Estrategia de seguridad con múltiples capas independientes. Si una capa falla,
  las demás siguen protegiendo. En arquitectura perimetral:
  1. Firewall perimetral (WAN→DMZ)
  2. Segmentación interna (DMZ→LAN)
  3. Aislamiento de gestión (Mgmt)
  4. Control de egress (LAN→WAN via proxy)
  5. Hardening de endpoints
  6. Cifrado de datos

  Egress Filtering
  ────────────────
  Control del tráfico saliente de la red interna. Previene:
  • Exfiltración de datos hacia servidores C2
  • Comunicación no autorizada con Internet
  • Callbacks de malware
  Implementación típica: proxy forward obligatorio desde LAN.

  Firewall Rule Evaluation Order
  ──────────────────────────────
  iptables evalúa reglas de ARIBA hacia ABAJO en cada cadena. La primera regla
  que coincide determina la acción (ACCEPT/DROP). Por eso:
  • Las reglas más específicas van PRIMERO
  • Las reglas más generales van DESPUÉS
  • La política por defecto (policy) se aplica si NINGUNA regla coincide
  Ejemplo: primero permitir TCP 80, después DROP todo lo demás.

🎯 RETOS DE ESTA UNIDAD
══════════════════════

  10 retos prácticos:
  1.  Diagrama de Zonas de Red — Documentar zonas WAN/DMZ/LAN/Mgmt con CIDR y servicios
  2.  Configuración de Interfaces — Definir interfaces de red por zona
  3.  Reglas Firewall WAN→DMZ — Implementar default-deny + allows para servicios públicos
  4.  Reglas Firewall DMZ→LAN — Restringir tráfico a puertos app-to-DB específicos
  5.  Reglas Firewall LAN→WAN — Configurar egress filtering via proxy
  6.  Reglas Firewall Mgmt — Aislar gestión con acceso solo desde bastion
  7.  Validación de Segmentación — Verificar que las reglas de firewall sean correctas
  8.  Documentación de Arquitectura — Documentar zonas, políticas y flujos de confianza
  9.  Auditoría de Firewall — Auditar configuración contra best practices
  10. Resumen de Arquitectura — Consolidar defensa en profundidad documentada

💡 COMANDOS PARA EL LAB
══════════════════════

EOF

echo -e "\n${AMARILLO}Escribe ${CYAN}'retos-unidad'${AMARILLO} para ver los retos o ${CYAN}'evaluar'${AMARILLO} para evaluar.${RESET}"
