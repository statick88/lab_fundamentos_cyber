# Referencia: Arquitectura Perimetral, Segmentación y DMZ

## Zonas de Red Fundamentales

### WAN (Wide Area Network) — Zona Externa / Internet
- **Propósito**: Conexión a Internet y redes externas no confiables
- **CIDR típico**: Asignado por ISP (público)
- **Gateway**: Router de borde / ISP gateway
- **Interfaz**: WAN / eth0 (externa)
- **Controles**: Firewall perimetral, IDS/IPS, DDoS mitigation

### DMZ (Demilitarized Zone) — Zona Desmilitarizada
- **Propósito**: Servicios públicos accesibles desde Internet pero aislados de la red interna
- **CIDR típico**: 10.10.10.0/24 o 172.16.10.0/24
- **Gateway**: Firewall DMZ (10.10.10.1)
- **Interfaz**: DMZ / eth1
- **Servicios típicos**: Web servers (A2), DNS público, Mail relay, Proxy forward
- **Política**: Default-deny, solo puertos necesarios (80, 443, 53, 25/587)

### LAN (Local Area Network) — Zona Interna / Red Privada
- **Propósito**: Red corporativa interna, estaciones de trabajo, servidores de aplicaciones, bases de datos
- **CIDR típico**: 10.10.20.0/24 o 192.168.10.0/24
- **Gateway**: Firewall interno / Core switch (10.10.20.1)
- **Interfaz**: LAN / eth2
- **Servicios típicos**: Database (A1), App servers, File servers, AD/DC
- **Política**: Sin acceso directo a Internet, egress controlado via proxy

### Mgmt (Management) — Zona de Administración
- **Propósito**: Administración fuera de banda (OOB), bastion hosts, jump servers, monitoring
- **CIDR típico**: 10.10.30.0/24 o 192.168.100.0/24
- **Gateway**: Firewall Mgmt / Console server (10.10.30.1)
- **Interfaz**: Mgmt / eth3 (o interfaz dedicada OOB)
- **Acceso**: Solo SSH/RDP desde bastion/jump host autorizado
- **Política**: Acceso extremadamente restringido, MFA obligatorio, logging exhaustivo

## Mejores Prácticas DMZ

### Principio de Mínimo Privilegio
1. **Default-deny** en todos los firewalls perimetrales e internos
2. **Allowlisting explícito** — solo puertos/servicios documentados y aprobados
3. **Segmentación por función** — no mezclar web, DNS, mail en mismo host si es evitable

### Colocación de Servicios
| Servicio | Zona Correcta | Justificación |
|----------|---------------|---------------|
| Web Server (A2) | DMZ | Cara pública, recibe tráfico HTTP/HTTPS |
| DNS Público | DMZ | Resolución para dominios públicos |
| Mail Relay | DMZ | Recepción/envío correo externo |
| Database (A1) | **LAN** | Datos sensibles, NUNCA en DMZ |
| App Server | LAN | Lógica de negocio, acceso a BD |
| Proxy Forward | DMZ/LAN border | Chokepoint egress LAN→Internet |
| Bastion/Jump Host | Mgmt | Único punto de admin SSH |

### Defense in Depth — Capas de Protección (Mínimo 3)

1. **Perimeter Layer** — Firewall WAN→DMZ (default-deny + allows explícitos)
2. **Internal Segmentation Layer** — Firewall DMZ→LAN (solo app-to-DB ports)
3. **Management Isolation Layer** — Firewall Mgmt (solo bastion SSH)
4. **Egress Control Layer** — Proxy forward + DNS chokepoint (bloquea LAN→WAN directo)
5. **Host/Endpoint Layer** — Hardening, HIDS, patching, least privilege accounts
6. **Data/Application Layer** — Cifrado en reposo/tránsito, DLP, backup inmutable

## Flujo de Confianza (Trust Boundaries)

```
Internet (Untrusted)
      │
      ▼
┌─────────────┐     WAN→DMZ Firewall      ┌─────────────┐
│   WAN/ISP   │ ─────────────────────────▶ │    DMZ      │
│  (Trust: 0) │  Default-deny + 80/443/53  │ (Trust: 30) │
└─────────────┘                             └──────┬──────┘
                                                   │
                              DMZ→LAN Firewall    │
                              App-to-DB only      ▼
┌─────────────┐                             ┌─────────────┐
│   Mgmt      │ ◀─── Mgmt Firewall (SSH) ── │    LAN      │
│ (Trust: 90) │     Solo Bastion/Jump       │ (Trust: 70) │
└─────────────┘                             └─────────────┘
```

## Referencias Normativas
- **NIST SP 800-41 Rev. 1** — Guidelines on Firewalls and Firewall Policy
- **NIST SP 800-125B** — Secure Virtual Network Configuration
- **CIS Controls v8** — Control 13: Network Monitoring and Defense
- **PCI DSS 4.0** — Requirement 1: Install and maintain network security controls
- **ISO 27001:2022** — A.13.1 Network controls, A.13.2 Information transfer