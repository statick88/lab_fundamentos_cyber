# Especificación - Fundamentos de Ciberseguridad ABC-CYB-101

## Mapa de alineación Subtema ABC-CYB-101 ↔ Unidad/Reto

### Módulo I: Principios y Gestión de Riesgo
| Subtema ABC-CYB-101 | Unidad | Reto | Objetivo de aprendizaje |
|---------------------|--------|------|-------------------------|
| Principios éticos y legales | 1 | 1-3 | Identificar estructura FHS y normativa |
| Gestión de riesgos | 1 | 4-6 | Evaluar configuraciones básicas |
| Confidencialidad, integridad, disponibilidad | 1 | 7-10 | Aplicar controles básicos |

### Módulo II: Redes y Controles Perimetrales
| Subtema ABC-CYB-101 | Unidad | Reto | Objetivo de aprendizaje |
|---------------------|--------|------|-------------------------|
| Modelos de red (OSI, TCP/IP) | 2 | 1-4 | Identificar protocolos y puertos |
| Firewalls y filtrado | 2 | 5-7 | Configurar reglas UFW |
| Inspección de paquetes | 2 | 8-9 | Usar iptables y tcpdump |
| Detección de intrusiones básica | 2 | 10 | Identificar escaneos en capturas |
| Evaluación formativa | 12 | 1-5 | Síntesis de módulo II |

### Módulo III: Hardening e Identidades
| Subtema ABC-CYB-101 | Unidad | Reto | Objetivo de aprendizaje |
|---------------------|--------|------|-------------------------|
| Control de acceso | 3 | 11-12 | Configurar grupos, usuarios, sudoers |
| Autenticación multifactor | 3 | 13-14 | Implementar políticas y MFA |
| Auditoría de identidades | 3 | 15 | Crear scripts de auditoría |
| Hardening del sistema | 7 | 1-10 | Aplicar controles de seguridad |
| CIS Benchmarks | 7 | 11-15 | Verificar configuraciones CIS |
| Scripting de seguridad | 3 | 1-10 | Automatizar tareas de ciberseguridad |

### Módulo IV: Amenazas, Criptografía y Vulnerabilidades
| Subtema ABC-CYB-101 | Unidad | Reto | Objetivo de aprendizaje |
|---------------------|--------|------|-------------------------|
| CVSS y clasificación de vulnerabilidades | 4 | 1-4 | Calcular y clasificar scores CVSS |
| Análisis de logs de amenazas | 4 | 5-8 | Identificar SQLi, XSS, path traversal |
| Integridad de archivos | 4 | 9-10 | Generar y comparar hashes criptográficos |
| Certificados digitales | 10 | 11-15 | RSA/ECC, CSR, verificación de cadena |
| Evaluación formativa | 13 | 1-5 | Síntesis de módulo IV |

### Módulo V: Logging, SIEM, IR y Continuidad
| Subtema ABC-CYB-101 | Unidad | Reto | Objetivo de aprendizaje |
|---------------------|--------|------|-------------------------|
| Logging y monitoreo | 5 | 1-4 | Configurar y analizar logs |
| Correlación de eventos | 5 | 5-6 | Correlacionar logs de múltiples fuentes |
| Respuesta a incidentes | 5 | 7-10 | Crear playbooks y scripts IR |
| Continuidad del negocio | 5 | 8-9 | Definir RTO/RPO y backups |
| Evaluación formativa | 14 | 1-5 | Síntesis de módulo V |

## Criterios de evaluación específicos

### Unidad II (10 retos)
- Identificación protocolos: 100% exactitud en puertos
- Configuración UFW: reglas presentes en /etc/ufw/user.rules
- iptables: capacidad de crear reglas DROP

### Unidad III-iam-mfa (15 retos)
- Scripting 1-10: scripts ejecutables y funcionales
- IAM 11-15: configuraciones persistentes verificables

### Unidad IV (10 retos)
- CVSS: cálculo correcto con tolerancia ±0.5
- Análisis de logs: detección de patrones de ataque
- Hashing: comparación correcta de hashes SHA-256

### Unidad V (10 retos)
- Logging: generación y análisis de logs en tiempo real
- SIEM: correlación de eventos entre fuentes
- BCP/IR: documentos completos con fases secuenciales

### Checkpoints (5 retos cada uno)
- Puntaje mínimo: 3/5
- Criterio: síntesis de conocimientos del módulo
- Reintentos ilimitados con fines formativos

## Objetivos de aprendizaje por reto

### Retos de scripting (III, retos 1-10)
1. Crear y ejecutar scripts bash básicos
2. Usar variables y entrada de usuario
3. Implementar condicionales
4. Usar bucles for y while
5. Definir y llamar funciones
6. Trabajar con arrays
7. Procesar argumentos de línea
8. Usar redirección y pipes
9. Manejar errores básicos
10. Generar hashes criptográficos

### Retos de ciberseguridad (III, retos 11-15)
11. Gestionar identidades (grupos, usuarios)
12. Configurar privilegios granulares (sudoers)
13. Establecer políticas de contraseñas
14. Implementar MFA con PAM
15. Auditar accesos privilegiados

### Retos de análisis de amenazas (IV)
1. Calcular severidad CVSS 3.1
2. Clasificar vulnerabilidades
3. Identificar vectores de ataque en logs
4. Detectar inyecciones SQL
5. Detectar path traversal
6. Analizar correos de phishing
7. Verificar integridad con hashes
8. Comparar contra baseline
