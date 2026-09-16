# Container Hardening Specification

## Purpose
This specification defines the security-hardening requirements for the `lab-ciberseguridad` Docker container, including non-root execution, capability dropping, no-new-privileges enforcement, and a read-only root filesystem.

## Requirements

### Requirement: Non-Root User Execution
The Dockerfile MUST switch to the `estudiante` user via `USER estudiante` before defining the working directory and entrypoint.

#### Scenario: Container process runs as estudiante
- GIVEN the Docker image is built
- WHEN a container starts from the image
- THEN the main process runs with the UID of `estudiante`, not root

#### Scenario: estudiante user exists with home directory
- GIVEN the Dockerfile installs the `estudiante` user
- WHEN the image is inspected
- THEN `estudiante` has a home directory at `/home/estudiante` with `/bin/bash` as its shell

### Requirement: Capability Dropping
The `docker-compose.yml` MUST specify `cap_drop: [ALL]` and `cap_add` containing only `NET_ADMIN`, `NET_RAW`, `SETUID`, and `SETGID`.

#### Scenario: No excessive capabilities granted
- GIVEN the docker-compose.yml is loaded
- WHEN a container starts from the service definition
- THEN it has no capabilities beyond NET_ADMIN, NET_RAW, SETUID, SETGID

#### Scenario: SYS_ADMIN must not be present
- GIVEN the container security configuration
- WHEN the granted capability set is enumerated
- THEN `SYS_ADMIN` is not present

### Requirement: No New Privileges
The `docker-compose.yml` MUST set `security_opt` with `no-new-privileges:true`.

#### Scenario: Privilege escalation blocked
- GIVEN a process inside the container attempts to escalate privileges
- WHEN `no-new-privileges` is enforced
- THEN the escalation is denied and the process cannot acquire new privileges

#### Scenario: Security opt explicitly set to true
- GIVEN the docker-compose.yml is parsed
- WHEN the security options are read
- THEN `no-new-privileges` is set to `true`

### Requirement: Read-Only Root Filesystem
The `docker-compose.yml` MUST configure `read_only: true` for the service, with explicit writable mounts for `/tmp`, `/var/log/nginx`, and `/var/lab-state`.

#### Scenario: Root filesystem is read-only
- GIVEN the container is running with `read_only: true`
- WHEN a process attempts to write to a system directory such as `/etc`
- THEN the write is rejected

#### Scenario: Required writable paths are explicitly declared
- GIVEN the read-only root filesystem is enabled
- WHEN the container starts
- THEN `/tmp`, `/var/log/nginx`, and `/var/lab-state` are mounted as writable volumes or tmpfs

### Requirement: No Privileged Mode
The service definition MUST NOT set `privileged: true` and MUST NOT mount the host Docker socket.

#### Scenario: Privileged mode disabled
- GIVEN the docker-compose.yml is loaded
- WHEN the service is inspected
- THEN `privileged` is absent or set to `false`

#### Scenario: Host Docker socket not mounted
- GIVEN the service definition
- WHEN volumes are enumerated
- THEN `/var/run/docker.sock` is not present
