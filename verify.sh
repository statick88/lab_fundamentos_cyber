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

    if [ $overall_fail -eq 0 ]; then
        log_pass "All verification checks PASSED"
        return 0
    else
        log_fail "One or more verification checks FAILED"
        return 1
    fi
}

main "$@"