#!/bin/bash
# verify.sh — Build verification for lab-ciberseguridad
# Validates container hardening, image integrity, and runtime security posture.
# Exits 0 on PASS, 1 on FAIL.

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${RESET} $*"; }
log_pass() { echo -e "${GREEN}[PASS]${RESET} $*"; }
log_fail() { echo -e "${RED}[FAIL]${RESET} $*"; }
log_warn() { echo -e "${YELLOW}[WARN]${RESET} $*"; }

detect_container() {
    # Returns 0 if running inside a Docker/containerd/k8s container
    [ -f /.dockerenv ] && return 0
    [ -n "${container:-}" ] && return 0
    grep -qaE 'docker|kubepods|containerd' /proc/1/cgroup 2>/dev/null && return 0
    return 1
}

# =============================================================================
# Task 1.1: Container Escape Assertion
# =============================================================================
check_container_escape() {
    log_info "Checking container escape vectors..."
    local fail=0

    # Check Dockerfile for SYS_ADMIN capability
    if grep -q "SYS_ADMIN" Dockerfile 2>/dev/null; then
        log_fail "Dockerfile contains SYS_ADMIN capability (container escape risk)"
        fail=1
    else
        log_pass "SYS_ADMIN capability not found in Dockerfile"
    fi

    # Check docker-compose.yml for seccomp=unconfined
    if grep -q "seccomp=unconfined" docker-compose.yml 2>/dev/null; then
        log_fail "docker-compose.yml contains seccomp=unconfined (container escape risk)"
        fail=1
    else
        log_pass "seccomp=unconfined not found in docker-compose.yml"
    fi

    # Check for Docker socket mount
    if grep -q "/var/run/docker.sock" docker-compose.yml 2>/dev/null; then
        log_fail "docker-compose.yml mounts Docker socket (container escape risk)"
        fail=1
    else
        log_pass "Docker socket not mounted in docker-compose.yml"
    fi

    # Check for privileged: true
    if grep -q "privileged:\s*true" docker-compose.yml 2>/dev/null; then
        log_fail "docker-compose.yml has privileged: true (container escape risk)"
        fail=1
    else
        log_pass "privileged mode not enabled in docker-compose.yml"
    fi

    return $fail
}

# =============================================================================
# Task 1.2: Sudo Escalation Assertion
# =============================================================================
check_sudo_escalation() {
    log_info "Checking sudo/no-new-privileges configuration..."
    local fail=0

    # Check docker-compose.yml for no-new-privileges:true
    if grep -q "no-new-privileges:\s*true" docker-compose.yml 2>/dev/null; then
        log_pass "no-new-privileges: true found in docker-compose.yml"
    else
        # Check if it's explicitly false (non-CI profile should not allow this)
        if grep -q "no-new-privileges:\s*false" docker-compose.yml 2>/dev/null; then
            log_fail "no-new-privileges: false found in docker-compose.yml (production profile must be true)"
            fail=1
        else
            log_fail "no-new-privileges not set in docker-compose.yml (must be true for production)"
            fail=1
        fi
    fi

    # Check Dockerfile for security-opt no-new-privileges (build-time hint)
    if grep -q "security-opt.*no-new-privileges" Dockerfile 2>/dev/null; then
        log_pass "security-opt no-new-privileges found in Dockerfile"
    else
        log_warn "security-opt no-new-privileges not in Dockerfile (runtime enforced via compose)"
    fi

    return $fail
}

# =============================================================================
# Task 1.3: Progress Tampering Assertion
# =============================================================================
check_progress_tampering() {
    log_info "Checking progress state tamper protection..."

    if ! detect_container; then
        log_warn "Not running inside a container; skipping /var/lab-state checks (host-only)"
        log_warn "Run 'docker run --rm <image> bash verify.sh' to validate container runtime state"
        return 0
    fi

    local fail=0

    local state_dir="/var/lab-state"
    local progress_file="${state_dir}/progress"

    # Check directory exists and is root-owned
    if [ -d "$state_dir" ]; then
        local owner
        owner=$(stat -c "%U" "$state_dir" 2>/dev/null || echo "unknown")
        local group
        group=$(stat -c "%G" "$state_dir" 2>/dev/null || echo "unknown")
        local perms
        perms=$(stat -c "%a" "$state_dir" 2>/dev/null || echo "000")

        if [ "$owner" = "root" ]; then
            log_pass "State directory owned by root"
        else
            log_fail "State directory not owned by root (owner: $owner)"
            fail=1
        fi

        if [ "$perms" = "750" ] || [ "$perms" = "0750" ]; then
            log_pass "State directory permissions are 0750"
        else
            log_fail "State directory permissions are $perms (expected 0750)"
            fail=1
        fi
    else
        log_fail "State directory $state_dir does not exist"
        fail=1
    fi

    # Check progress file exists and is root-owned with 0640
    if [ -f "$progress_file" ]; then
        local p_owner
        p_owner=$(stat -c "%U" "$progress_file" 2>/dev/null || echo "unknown")
        local p_group
        p_group=$(stat -c "%G" "$progress_file" 2>/dev/null || echo "unknown")
        local p_perms
        p_perms=$(stat -c "%a" "$progress_file" 2>/dev/null || echo "000")

        if [ "$p_owner" = "root" ]; then
            log_pass "Progress file owned by root"
        else
            log_fail "Progress file not owned by root (owner: $p_owner)"
            fail=1
        fi

        if [ "$p_perms" = "640" ] || [ "$p_perms" = "0640" ]; then
            log_pass "Progress file permissions are 0640"
        else
            log_fail "Progress file permissions are $p_perms (expected 0640)"
            fail=1
        fi

        # Verify non-root cannot write (student should be read-only)
        if [ "$(id -u)" -ne 0 ]; then
            # Test if current non-root user can write
            if [ -w "$progress_file" ]; then
                log_fail "Non-root user can write to progress file (should be read-only for estudiante)"
                fail=1
            else
                log_pass "Non-root user cannot write to progress file (read-only enforced)"
            fi
        fi
    else
        log_fail "Progress file $progress_file does not exist"
        fail=1
    fi

    return $fail
}

# =============================================================================
# Task 1.4: Image Poisoning Assertion
# =============================================================================
check_image_poisoning() {
    log_info "Checking base image digest pinning..."
    local fail=0

    # Check Dockerfile FROM line for digest pinning (sha256:...)
    local from_line
    from_line=$(grep -E "^FROM\s+" Dockerfile | head -1 || echo "")

    if [ -z "$from_line" ]; then
        log_fail "No FROM instruction found in Dockerfile"
        return 1
    fi

    if echo "$from_line" | grep -q "@sha256:"; then
        log_pass "Base image pinned by digest: $from_line"
    else
        log_fail "Base image NOT pinned by digest: $from_line"
        log_fail "Expected format: FROM ubuntu:24.04@sha256:<digest>"
        fail=1
    fi

    return $fail
}

# =============================================================================
# Task 3.3: Dockerfile Cross-Checks
# =============================================================================
check_dockerfile_references() {
    log_info "Checking Dockerfile references..."
    local fail=0

    # Dockerfile must exist
    if [ ! -f Dockerfile ]; then
        log_fail "Dockerfile not found"
        return 1
    fi
    log_pass "Dockerfile exists"

    # Dockerfile must contain key paths
    local required_refs=("COPY shared/" "COPY units/" "COPY entrypoint.sh" "WORKDIR" "USER estudiante")
    for ref in "${required_refs[@]}"; do
        if grep -q "$ref" Dockerfile 2>/dev/null; then
            log_pass "Dockerfile contains: $ref"
        else
            log_fail "Dockerfile missing: $ref"
            fail=1
        fi
    done

    # Verify FROM line is present and valid
    local from_line
    from_line=$(grep -E "^FROM\s+" Dockerfile | head -1 || echo "")
    if [ -z "$from_line" ]; then
        log_fail "Dockerfile has no FROM instruction"
        fail=1
    else
        log_pass "Dockerfile FROM instruction present: $from_line"
    fi

    return $fail
}

# =============================================================================
# Task 3.3: Manifest Totals Cross-Check
# =============================================================================
check_manifest_totals() {
    log_info "Checking manifest totals..."
    local fail=0

    # Shared modules must exist
    local required_modules=(
        "shared/common.sh"
        "shared/validators.sh"
        "shared/sudo-wrappers.sh"
        "shared/eval.sh"
        "shared/evaluar-unidad.sh"
        "shared/retos-unidad.sh"
        "shared/units_manifest.sh"
        "shared/menu.sh"
        "shared/unidad.sh"
        "shared/interactive.sh"
    )

    for mod in "${required_modules[@]}"; do
        if [ -f "$mod" ]; then
            log_pass "Shared module exists: $mod"
        else
            log_fail "Shared module missing: $mod"
            fail=1
        fi
    done

    # UNIT_COUNT must be 26
    local unit_count
    unit_count=$(bash -c 'source shared/units_manifest.sh 2>/dev/null; echo "$UNIT_COUNT"' 2>/dev/null || echo "0")
    if [ "$unit_count" = "26" ]; then
        log_pass "UNIT_COUNT = 26 (all units present)"
    else
        log_fail "UNIT_COUNT = $unit_count (expected 26)"
        fail=1
    fi

    # Verify total reto count via calculation
    local total_retos
    total_retos=$(bash -c 'source shared/units_manifest.sh 2>/dev/null; SUM=0; for r in "${UNIT_RETOS[@]}"; do SUM=$((SUM + r)); done; echo "$SUM"' 2>/dev/null || echo "0")
    if [ "$total_retos" = "243" ]; then
        log_pass "Total retos = 243"
    else
        log_fail "Total retos = $total_retos (expected 243)"
        fail=1
    fi

    # Verify CORE reto count via calculation
    local core_retos
    core_retos=$(bash -c 'source shared/units_manifest.sh 2>/dev/null; SUM=0; for i in "${!UNIT_CORE[@]}"; do if [ "${UNIT_CORE[$i]}" = "1" ]; then SUM=$((SUM + UNIT_RETOS[$i])); fi; done; echo "$SUM"' 2>/dev/null || echo "0")
    if [ "$core_retos" = "85" ]; then
        log_pass "CORE retos = 85"
    else
        log_fail "CORE retos = $core_retos (expected 85)"
        fail=1
    fi

    # README.md must exist
    if [ -f README.md ]; then
        log_pass "README.md exists"
    else
        log_fail "README.md not found"
        fail=1
    fi

    return $fail
}

# =============================================================================
# Main
# =============================================================================
main() {
    log_info "=== lab-ciberseguridad Build Verification ==="
    echo

    local overall_fail=0

    check_container_escape || overall_fail=1
    echo

    check_sudo_escalation || overall_fail=1
    echo

    check_progress_tampering || overall_fail=1
    echo

    check_image_poisoning || overall_fail=1
    echo

    check_dockerfile_references || overall_fail=1
    echo

    check_manifest_totals || overall_fail=1
    echo

    if [ $overall_fail -eq 0 ]; then
        log_pass "All verification checks PASSED"
        return 0
    else
        log_fail "One or more verification checks FAILED"
        return 1
    fi
}

main "$@"