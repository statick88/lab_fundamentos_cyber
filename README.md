# Laboratorio Interactivo: Fundamentos de Ciberseguridad (ABC-CYB-101)

14 unidades progresivas · 60 retos CORE + 80 optativos · evaluación automática · frase secreta oculta. Todo corre en Docker.

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
|--------|------|--------|:-----:|
| I | Principios y Gestión de Riesgo | 1 | 10 |
| II | Redes y Controles Perimetrales | 2 | 10 |
| II | Checkpoint Módulo II | 12 | 5 |
| III | Hardening e Identidades | 3 | 15 |
| III | Hardening y CIS Benchmarks | 7 | 15 |
| IV | Amenazas, Criptografía y Vulnerabilidades | 4 | 10 |
| IV | Checkpoint Módulo IV | 13 | 5 |
| IV | Scripting Criptografía (ampliación III) | 3 | 15 |
| V | Logging, SIEM, IR y Continuidad | 5 | 10 |
| V | Checkpoint Módulo V | 14 | 5 |
| - | Almacenamiento y LVM | 6 | 10 |
| - | Docker | 8 | 10 |
| - | Nginx | 9 | 10 |
| - | SSL/TLS y Criptografía Aplicada | 10 | 15 |
| - | Docker Compose + DB | 11 | 10 |

**Total: 14 unidades · 140 retos (60 CORE + 80 optativos).**

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

Cada unidad completada revela una palabra. Completa las 14 para descubrir la frase:

```
_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
```

## Instrucciones para el docente

1. Usar `reset.sh --progreso` entre clases para limpiar el estado
2. Los checkpoints (12, 13, 14) son evaluaciones formativas automáticas
3. Cada reto tiene pistas integradas activadas con `pista` durante el juego
4. El sistema no modifica archivos del sistema permanentemente
5. Usar `docker compose logs lab-linux` para depurar problemas

## Medidas de seguridad del laboratorio

- Contenedor aislado en red bridge 172.20.0.0/24
- Capabilities limitadas: NET_ADMIN, NET_RAW (sin SYS_ADMIN, sin privileged)
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
| Docker-in-Docker falla | Verificar `privileged: true` y `/var/run/docker.sock` montado |
| Reglas UFW persisten | Ejecuta `bash reset.sh` para limpiar |

## Arquitectura

```
lab-linux/
├── Dockerfile              # Ubuntu 24.04 + herramientas ciberseguridad
├── docker-compose.yml      # Red aislada 172.20.0.0/24
├── entrypoint.sh           # Sourcing, aliases y banner ABC-CYB-101
├── reset.sh                # Limpia configuraciones y archivos de prueba
├── shared/                 # Librería compartida
│   ├── common.sh           # Funciones base, 14 unidades
│   ├── menu.sh             # Menú principal 14 unidades
│   ├── interactive.sh      # Funciones interactivas (jugar, evaluar, retos)
│   ├── eval.sh             # Sistema de evaluación + funciones ciberseguridad
│   ├── colors.sh           # Colores de terminal
│   ├── banner.sh           # Banners visuales
│   └── unidad.sh           # Cambiar unidad (1-14)
├── units/                  # 14 unidades (I-XIV + checkpoints)
│   ├── i/                  # Principios y Gestión de Riesgo
│   ├── ii-firewalls-redes/ # Filtrado de Red y Firewalls
│   ├── iii-iam-mfa/        # IAM, MFA y Control de Acceso
│   ├── iii/                # Scripting Bash (ampliado criptografía)
│   ├── iv-criptografia-cvss/ # Criptografía y CVSS
│   ├── v-logging-siem-bcp/ # Logging, SIEM y BCP
│   ├── vi/                 # Almacenamiento y LVM
│   ├── vii/                # Hardening y CIS Benchmarks
│   ├── viii/               # Docker
│   ├── ix/                 # Nginx
│   ├── x/                  # SSL/TLS ampliado
│   ├── xi/                 # Docker Compose + DB
│   ├── checkpoint-ii/      # Checkpoint Módulo II
│   ├── checkpoint-iv/      # Checkpoint Módulo IV
│   └── checkpoint-v/       # Checkpoint Módulo V
├── GUIA_DOCENTE_LAB.md     # Guía para el docente
├── ESPECIFICACION_CIBERSEGURIDAD.md # Especificación detallada
└── README.md               # Este archivo
```

## Novedades v2.0

- **Alineación curricular ABC-CYB-101**: 14 unidades organizadas en 5 módulos
- **Nuevas unidades**: Firewalls, IAM/MFA, Criptografía/CVSS, Logging/SIEM/BCP
- **Checkpoints**: Evaluaciones formativas automáticas por módulo
- **Hardening CIS**: Referencias a CIS Benchmarks en unidad VII
- **Scripting criptográfico**: Hashes SHA-256, SHA-3, firmas digitales
- **SSL/TLS ampliado**: RSA 4096, ECC secp384r1, verificación de cadena
- **Reset script**: Limpia configuraciones entre clases
- **140 retos prácticos** con evaluación automática

## Autor

**Lic. Diego Medardo Saavedra García, Mg. Sc.**
🌐 https://statick88.github.io
✉️ dsaavedra88@gmail.com

---

*Curso "Fundamentos de Ciberseguridad" - Abacom ABC-CYB-101*
