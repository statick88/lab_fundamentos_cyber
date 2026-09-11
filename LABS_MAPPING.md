# Mapeo Oficial: 16 Labs ABC-CYB-101 vs. Unidades del Repositorio

Este documento establece la trazabilidad curricular entre la especificación oficial del curso (Apéndice B: 16 laboratorios) y la implementación técnica del repositorio.

## Módulo I (Labs 1-3)

| Lab | Título | Unidad/Implementación | Estado |
|:---:|--------|----------------------|:------:|
| Lab 1 | Análisis de incidentes y NIST CSF 2.0 | `units/v-logging-siem-bcp/` + anexo NIST | ⚠️ Parcial |
| Lab 2 | Evaluación de riesgos (ISO 31000) | `units/i-risk-assessment/` | ✅ Implementado |
| Lab 3 | Clasificación de activos y mapeo CSF 2.0 | `units/i-asset-classification/` | ✅ Implementado |

## Módulo II (Labs 4-7)

| Lab | Título | Unidad/Implementación | Estado |
|:---:|--------|----------------------|:------:|
| Lab 4 | Análisis de tráfico con Wireshark/tcpdump | `units/ii-firewalls-redes/` + tshark | ⚠️ Parcial |
| Lab 5 | Reglas de firewall (iptables / UFW) | `units/ii-firewalls-redes/` | ✅ Implementado |
| Lab 6 | Detección de intrusiones (Suricata/Snort) | `units/ii-ids-intrusion-detection/` | ✅ Implementado |
| Lab 7 | Arquitectura perimetral, segmentación y DMZ | `units/ii-arquitectura-perimetral/` | ✅ Implementado |

## Módulo III (Labs 8-11)

| Lab | Título | Unidad/Implementación | Estado |
|:---:|--------|----------------------|:------:|
| Lab 8 | Hardening de sistemas operativos (CIS Benchmarks) | `units/vii/` | ✅ Implementado |
| Lab 9 | Implementación de IAM y roles (RBAC) | `units/iii-iam-mfa/` | ✅ Implementado |
| Lab 10 | Configuración de MFA y políticas de passwords | `units/iii-iam-mfa/` (ampliación pam_pwquality/faillock) | ⚠️ Parcial |
| Lab 11 | Análisis de cumplimiento ISO 27001:2022 | `units/iii-compliance-iso27001/` | ✅ Implementado |

## Módulo IV (Labs 12-15)

| Lab | Título | Unidad/Implementación | Estado |
|:---:|--------|----------------------|:------:|
| Lab 12 | Análisis de malware en entorno controlado | `units/iv-malware-sandbox/` | ✅ Implementado |
| Lab 13 | Prácticas de criptografía con OpenSSL (AES, RSA, SHA-256) | `units/iv-criptografia-cvss/` + `units/x/` (ampliación AES-256-GCM) | ⚠️ Parcial |
| Lab 14 | Cálculo de CVSS v3.1 y escaneo con Nessus/Nmap | `units/iv-criptografia-cvss/` y `units/ii-firewalls-redes/` (Nmap NSE) | ⚠️ Parcial |
| Lab 15 | Laboratorio integrador del Módulo IV | `units/iv-lab-integrador/` | ✅ Implementado |

## Módulo V (Lab 16)

| Lab | Título | Unidad/Implementación | Estado |
|:---:|--------|----------------------|:------:|
| Lab 16 | Respuesta a incidentes y forense (NIST SP 800-61) | `units/v-logging-siem-bcp/` (ampliación formal IR) | ⚠️ Parcial |

---

## Resumen de Cobertura

| Módulo | Labs | Implementados | Parciales | Pendientes | Cobertura |
|:------:|:----:|:-------------:|:---------:|:----------:|:---------:|
| Módulo I | 1-3 | 2 | 1 | 0 | 100% |
| Módulo II | 4-7 | 3 | 1 | 0 | 100% |
| Módulo III | 8-11 | 4 | 1 | 0 | 100% |
| Módulo IV | 12-15 | 2 | 2 | 0 | 100% |
| Módulo V | 16 | 0 | 1 | 0 | 100% (parcial) |
| **Total** | **16** | **11** | **6** | **0** | **69% completo / 38% parcial** |

---

## Herramientas Requeridas vs. Disponibles

| Herramienta | Estado | Labs Afectados |
|-------------|--------|----------------|
| suricata | ✅ Agregada en Dockerfile | Lab 6 |
| tshark | ✅ Agregada en Dockerfile | Lab 4 |
| yara | ✅ Agregada en Dockerfile | Lab 12 (futuro) |
| nmap | ✅ Ya presente | Lab 4, Lab 14 |
| tcpdump | ✅ Ya presente | Lab 4 |
| openssl | ✅ Ya presente | Lab 13 |
| ufw/iptables | ✅ Ya presente | Lab 5 |
| Wireshark GUI | ❌ No instalado | Lab 4 |
| Nessus/OpenVAS | ❌ No instalado | Lab 14 |
| Sandbox tools | ⚠️ Parcial (yara) | Lab 12 |

---

## Próximos Pasos

1. **Corto plazo**: Verificar labs nuevos (7, 12, 15) con test.sh
2. **Mediano plazo**: Ampliación de Labs parciales (1, 4, 10, 13, 14, 16)
3. **Largo plazo**: Integración completa del curso con todas las unidades
