#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPORT_PATH="$ROOT_DIR/docs/DOCKER_QUARTUS_VALIDATION_STATUS.md"
DOCKER_DOCKERFILE="$ROOT_DIR/docker/quartus/Dockerfile.ubuntu-quartus-base"
DOCKER_README="$ROOT_DIR/docker/quartus/README.md"
DOCKER_IGNORE="$ROOT_DIR/docker/quartus/.gitignore"
WORKFLOW_DOC="$ROOT_DIR/docs/FEDORA_NAS_DOCKER_QUARTUS_WORKFLOW.md"
POLICY_DOC="$ROOT_DIR/docs/QUARTUS_DOCKER_INSTALLER_POLICY.md"

PASS_COUNT=0
WARN_COUNT=0

log_pass() {
  echo "PASS: $1" | tee -a "$REPORT_PATH"
  PASS_COUNT=$((PASS_COUNT + 1))
}

log_warn() {
  echo "WARN: $1" | tee -a "$REPORT_PATH"
  WARN_COUNT=$((WARN_COUNT + 1))
}

check_file() {
  local path="$1"
  local label="$2"
  if [ -f "$path" ]; then
    log_pass "file exists: $label"
  else
    log_warn "missing file: $label"
  fi
}

check_file_optional() {
  local path="$1"
  local label="$2"
  if [ -f "$path" ]; then
    log_pass "optional file exists: $label"
  else
    log_warn "optional file missing: $label"
  fi
}

check_grep() {
  local path="$1"
  local pattern="$2"
  local label="$3"
  if [ -f "$path" ] && grep -Fq "$pattern" "$path"; then
    log_pass "pattern present: $label"
  else
    log_warn "pattern missing: $label"
  fi
}

check_root_gitignore_pattern() {
  local pattern="$1"
  local label="$2"
  if grep -Fq "$pattern" "$ROOT_DIR/.gitignore"; then
    log_pass "root .gitignore includes $label"
  else
    log_warn "root .gitignore missing $label ($pattern)"
  fi
}

: > "$REPORT_PATH"
{
  echo "# Quartus Docker workflow validation status"
  echo
  echo "Generated: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  echo "Advisory check; exits 0 by design."
  echo
} >> "$REPORT_PATH"

log_pass "Docker command check started"
if command -v docker >/dev/null 2>&1; then
  log_pass "docker command present"
else
  log_warn "docker command not found in PATH (expected on build host)"
fi

check_file "$DOCKER_DOCKERFILE" "docker/quartus/Dockerfile.ubuntu-quartus-base"
check_file "$DOCKER_README" "docker/quartus/README.md"
check_file "$DOCKER_IGNORE" "docker/quartus/.gitignore"
check_file "$WORKFLOW_DOC" "docs/FEDORA_NAS_DOCKER_QUARTUS_WORKFLOW.md"
check_file "$POLICY_DOC" "docs/QUARTUS_DOCKER_INSTALLER_POLICY.md"

check_file_optional "$ROOT_DIR/docs/TASK6S_DOCKER_QUARTUS_BUILD_HOST_PREP.md" "Task 6S scaffold summary doc"

if [ -f "$DOCKER_IGNORE" ]; then
  for pattern in \
    "installers/" \
    "intelFPGA*/" \
    "intelFPGA_lite*/" \
    "*.run" \
    "*.tar" \
    "*.tar.gz" \
    "*.zip" \
    "*.deb" \
    "*.rpm" \
    "license*" \
    "*.dat" \
    "*.sof" \
    "*.pof" \
    "*.jic" \
    "*.rpd" \
    "*.rbf" \
    "*.rbf_r" \
    "output_files/" \
    "db/" \
    "incremental_db/" \
    "simulation/" \
    "greybox_tmp/"
  do
    check_grep "$DOCKER_IGNORE" "$pattern" "$pattern in docker/quartus/.gitignore"
  done
fi

for pattern in \
  "installers/" \
  "intelFPGA*/" \
  "intelFPGA_lite*/" \
  "*.run" \
  "*.tar" \
  "*.tar.gz" \
  "*.zip" \
  "*.deb" \
  "*.rpm" \
  "license*" \
  "*.dat" \
  "*.sof" \
  "*.pof" \
  "*.jic" \
  "*.rpd" \
  "*.rbf" \
  "*.rbf_r" \
  "output_files/" \
  "db/" \
  "incremental_db/" \
  "simulation/" \
  "greybox_tmp/" \
  "*.fit.*" \
  "*.sta.*"
do
  check_root_gitignore_pattern "$pattern" "$pattern"
done

{
  echo
  echo "## Summary"
  echo "- PASS-like checks: $PASS_COUNT"
  echo "- WARN-like checks: $WARN_COUNT"
  echo "- Status: CHECKED"
  echo
} >> "$REPORT_PATH"

exit 0
