# Laboratorio Interactivo: Fundamentos de Ciberseguridad (ABC-CYB-101)

18 unidades progresivas · 175 retos (60 CORE + 115 OPT) · evaluación automática · frase secreta oculta. Todo corre en Docker.

## Quick path

```bash
git clone https://github.com/statick88/lab-linux.git
cd lab-linux
docker compose build
docker compose up -d
docker compose exec lab-linux bash
```

Dentro del contenedor: `menu` · `jugar` · `retos` · `evaluar` · `progreso`

## Alineación Curricular ABC-CYB-101

| Módulo | Tema | Unidad | Retos |
|--------|------|:------:|:-----:|
| I | Principios y Gestión de Riesgo | 1 (unit-I) | 10 |
| I | Redes y Protocolos | 3 (unit-ii) | 10 |
| I | Almacenamiento y LVM (ampliación) | 9 (unit-VI) | 10 |
| II | Filtrado de Red y Firewalls | 2 (unit-II) | 10 |
| II | IAM, MFA y Control de Acceso | 4 (unit-III / iii-iam-mfa) | 5 |
| II | Scripting Bash | 5 (unit-iii) | 15 |
| II | Checkpoint Módulo II | 16 (checkpoint-ii) | 5 |
| III | Criptografía y CVSS | 6 (unit-IV) | 10 |
| III | Criptografía Aplicada | 7 (unit-iv) | 10 |
| III | Logging, SIEM y BCP | 8 (unit-V) | 10 |
| III | Procesos y Servicios | 9 (unit-V-processes) | 10 |
| III | Hardening y CIS Benchmarks | 10 (unit-VII) | 15 |
| III | Docker (contenedores) | 11 (unit-VIII) | 10 |
| IV | Nginx | 12 (unit-IX) | 10 |
| IV | SSL/TLS y Criptografía Aplicada | 13 (unit-X) | 15 |
| IV | Docker Compose + DB | 14 (unit-XI) | 10 |
| IV | Checkpoint Módulo IV | 17 (checkpoint-iv) | 5 |
| V | Checkpoint Módulo V | 18 (checkpoint-v) | 5 |

**Total: 18 unidades · 175 retos (60 CORE + 115 OPT).**

## Comandos del contenedor

| Comando | Acción | Alcance |
|---------|--------|---------|
| `menu` | Menú principal con progreso global | Alias |
| `jugar` | Modo interactivo: instrucción → comando → verificar | Alias |
| `unidad <n>` | Seleccionar unidad (ej: `unidad 3`) | Alias |
| `retos` | Ver retos de la unidad actual | Alias |
| `evaluar` | Ejecutar validación y mostrar puntaje | Alias |
| `revelar-frase` | Revelar palabra al completar una unidad | Alias |
| `progreso` | Ver barra de progreso global | Alias |
| `ayuda` | Lista de comandos disponibles | Función |
| `~/bin/lab` | Lanza el menú interactivo desde cualquier ruta | Script |

## Flujo por unidad

```
Seleccionar → Instrucciones → Resolver → Validar → Revelar palabra
    │              │              │           │            │
    ▼              ▼              ▼           ▼            ▼
unidad 2       retos        (terminal)    evaluar    revelar-frase
```

1. **Seleccionar** → `unidad 2` cambia la unidad activa
2. **Instrucciones** → `retos` muestra pistas progresivas
3. **Resolver** → ejecuta comandos en la terminal
4. **Validar** → `evaluar` muestra ✓ PASS / ✗ FAIL por reto
5. **Frase** → `revelar-frase` revela la palabra oculta

## Frase secreta

Cada unidad completada revela una palabra. Completa las 18 para descubrir la frase:

```
_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
```

## Instrucciones para el docente

1. Usar `reset.sh --progreso` entre clases para limpiar el estado
2. Los checkpoints (16, 17, 18) son evaluaciones formativas automáticas
3. Cada reto tiene pistas integradas activadas con `pista` durante el juego
4. El sistema no modifica archivos del sistema permanentemente
5. Usar `docker compose logs lab-linux` para depurar problemas

## Medidas de seguridad del laboratorio

- Contenedor aislado en red bridge 172.20.0.0/24 con driver_opts: sin IP masquerade, bind solo a 127.0.0.1
- Capabilities limitadas: NET_ADMIN, NET_RAW, SETUID, SETGID (sin SYS_ADMIN, sin privileged)
- Progreso almacenado en /var/lab-state (root-owned, no escribible por estudiante)
- Validadores estrictos: CVSS requiere script Python con métricas y operaciones matemáticas; logs verifican archivos reales con antigüedad mínima
- No se descargan archivos externos durante los retos
- Todo el malware es simulado (archivos de texto inocuos)
- No se escanean redes externas
- Las reglas iptables se limpian al resetear

## Instalación por sistema operativo

<details>
<summary>macOS</summary>

```bash
brew install --cask docker
git clone https://github.com/statick88/lab-linux.git
cd lab-linux
docker compose build && docker compose up -d
docker compose exec lab-linux bash
```
</details>

<details>
<summary>Ubuntu / Debian</summary>

```bash
sudo apt update && sudo apt install -y docker.io docker-compose-v2
sudo usermod -aG docker $USER
git clone https://github.com/statick88/lab-linux.git
cd lab-linux
docker compose build && docker compose up -d
docker compose exec lab-linux bash
```
</details>

<details>
<summary>Fedora</summary>

```bash
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo systemctl start docker && sudo usermod -aG docker $USER
git clone https://github.com/statick88/lab-linux.git
cd lab-linux
docker compose build && docker compose up -d
docker compose exec lab-linux bash
```
</details>

<details>
<summary>Windows (WSL2)</summary>

```bash
# PowerShell como Administrador:
wsl --install
# Reiniciar el equipo

# Dentro de WSL:
sudo apt update && sudo apt install -y docker.io docker-compose-v2
sudo usermod -aG docker $USER
git clone https://github.com/statick88/lab-linux.git
cd lab-linux
docker compose build && docker compose up -d
docker compose exec lab-linux bash
```
</details>

## Solución de problemas

| Problema | Solución |
|----------|----------|
| Contenedor no inicia | `docker compose logs lab-linux` → `docker compose build --no-cache` |
| Comandos no funcionan | Verificar que estás dentro: `docker compose exec lab-linux bash` |
| Pruebas fallan | directorio debe ser `~/laboratorio`, nombres exactos |
| Reglas UFW persisten | Ejecuta `bash reset.sh` para limpiar |

## Arquitectura

```
lab-linux/
├── Dockerfile              # Ubuntu 24.04 + herramientas ciberseguridad
├── docker-compose.yml      # Red aislada 172.20.0.0/24 + capabilities mínimas
├── entrypoint.sh           # Sourcing, aliases y banner ABC-CYB-101
├── reset.sh                # Limpia configuraciones y archivos de prueba
├── shared/                 # Librería compartida
│   ├── common.sh           # Funciones base, 18 unidades
│   ├── units_manifest.sh   # Manifiesto centralizado CORE/OPT
│   ├── menu.sh             # Menú principal 18 unidades
│   ├── interactive.sh      # Funciones interactivas (jugar, evaluar, retos)
│   ├── eval.sh             # Sistema de evaluación + anti-bypass + eval_cvss
│   ├── cvss_calculator.py  # Calculadora CVSS 3.1 de referencia
│   ├── colors.sh           # Colores de terminal
│   ├── banner.sh           # Banners visuales
│   └── unidad.sh           # Cambiar unidad (1-18)
├── units/                  # 18 directorios (14 nuevas + 4 legacy)
│   ├── i/                  # Principios y Gestión de Riesgo (10 retos, CORE)
│   ├── ii-firewalls-redes/ # Filtrado de Red y Firewalls (10 retos, CORE)
│   ├── iii-iam-mfa/        # IAM, MFA y Control de Acceso (5 retos, CORE)
│   ├── iii/                # Scripting Bash (15 retos, OPT)
│   ├── iv-criptografia-cvss/ # Criptografía y CVSS (10 retos, CORE)
│   ├── v-logging-siem-bcp/ # Logging, SIEM y BCP (10 retos, CORE)
│   ├── vi/                 # Almacenamiento y LVM (10 retos, OPT)
│   ├── vii/                # Hardening y CIS Benchmarks (15 retos, OPT)
│   ├── viii/               # Docker (10 retos, OPT)
│   ├── ix/                 # Nginx (10 retos, OPT)
│   ├── x/                  # SSL/TLS y Criptografía Aplicada (15 retos, OPT)
│   ├── xi/                 # Docker Compose + DB (10 retos, OPT)
│   ├── ii/                 # Redes y Protocolos (legacy, 10 retos, OPT)
│   ├── iv/                 # Criptografía Aplicada (legacy, 10 retos, OPT)
│   ├── v/                  # Procesos y Servicios (legacy, 10 retos, OPT)
│   ├── checkpoint-ii/      # Checkpoint Módulo II (5 retos, CORE)
│   ├── checkpoint-iv/      # Checkpoint Módulo IV (5 retos, CORE)
│   └── checkpoint-v/       # Checkpoint Módulo V (5 retos, CORE)
├── GUIA_DOCENTE_LAB.md     # Guía para el docente
├── ESPECIFICACION_CIBERSEGURIDAD.md # Especificación detallada
├── GUIA_INCIDENCIAS_ESTUDIANTES.md # Guía de gestión de incidencias
├── content/
│   └── ebook-guia/         # Ebook interactivo (Quarto)
│       ├── index.qmd       # Índice principal
│       ├── modulo-01-*.qmd  # Módulos 1-6
│       └── ...
└── README.md               # Este archivo
```

## Ebook interactivo: Fundamentos de Ciberseguridad

Guía de laboratorio paso a paso en formato Quarto HTML, alineada con las 18 unidades del contenedor.

```bash
# Renderizar el ebook (requiere Quarto)
quarto render content/ebook-guia/

# Abrir en navegador
open content/ebook-guia/index.html
```

El ebook cubre 6 módulos temáticos:

| Módulo | Contenido | Archivo |
|--------|-----------|---------|
| 1 | Principios y Gestión de Riesgo | `modulo-01-principios-riesgo.qmd` |
| 2 | Redes, Firewalls y Servicios | `modulo-02-redes-firewalls.qmd` |
| 3 | Scripting y Control de Acceso | `modulo-03-scripting-acceso.qmd` |
| 4 | Docker y Contenedores | `modulo-04-docker-contenedores.qmd` |
| 5 | Wargames y Ataques Controlados | `modulo-05-wargames.qmd` |
| 6 | Logging, SIEM y BCP | `modulo-06-logging-siem-bcp.qmd` |

Cada módulo incluye ejercicios prácticos con evidencia, advertencias de seguridad, notas del instructor y checklist de autoevaluación.

## Novedades v2.0

- **Alineación curricular ABC-CYB-101**: 18 unidades organizadas en 5 módulos
- **Ebook interactivo**: 6 módulos en Quarto con ejercicios, evidencias y checklist
- **Nuevas unidades**: Firewalls, IAM/MFA, Criptografía/CVSS, Logging/SIEM/BCP
- **Checkpoints**: Evaluaciones formativas automáticas por módulo
- **Hardening CIS**: Referencias a CIS Benchmarks en unidad VII
- **Scripting criptográfico**: Hashes SHA-256, SHA-3, firmas digitales
- **SSL/TLS ampliado**: RSA 4096, ECC secp384r1, verificación de cadena
- **Reset script**: Limpia configuraciones entre clases
- **175 retos prácticos** con evaluación automática
- **Clasificación CORE/OPT**: 60 retos obligatorios + 115 optativos para sesiones de 24h
- **Anti-tampering**: Progreso en /var/lab-state (root-owned, no escribible por estudiante)
- **Validadores estrictos**: CVSS requiere script Python con anti-bypass; logs verifican archivos reales; firewall valida estado ufw/iptables con sudo
- **Red aislada**: driver_opts sin IP masquerade, bind a 127.0.0.1

## Autor

**Lic. Diego Medardo Saavedra García, Mg. Sc.**
🌐 https://statick88.github.io
✉️ dsaavedra88@gmail.com

---

*Curso "Fundamentos de Ciberseguridad" - Abacom ABC-CYB-101*
