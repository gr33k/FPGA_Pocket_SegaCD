#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPORT_PATH="$ROOT_DIR/docs/DOCKER_QUARTUS_INSTALL_FLOW_CHECK.md"
INSTALL_SCRIPT="$ROOT_DIR/tools/docker_install_quartus_lite.sh"
ANALYSIS_SCRIPT="$ROOT_DIR/tools/docker_run_openfpga_genesis_analysis_only.sh"

rel_path() {
  local path="$1"
  if [[ -z "$path" ]]; then
    printf ''
  elif [[ "$path" == "$ROOT_DIR"* ]]; then
    printf '%s' "${path#$ROOT_DIR/}"
  else
    printf '%s' "$path"
  fi
}

PASS_COUNT=0
WARN_COUNT=0

log() {
  echo "$1"
}

log_pass() {
  echo "PASS: $(rel_path "$1")"
  PASS_COUNT=$((PASS_COUNT + 1))
}

log_warn() {
  echo "WARN: $(rel_path "$1")"
  WARN_COUNT=$((WARN_COUNT + 1))
}

: > "$REPORT_PATH"
{
  echo "# Docker Quartus install flow check"
  echo "Generated: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  echo "Advisory check; exits 0"
  echo
} > "$REPORT_PATH"

{
  if [[ -x "$INSTALL_SCRIPT" ]]; then
    log_pass "tools/docker_install_quartus_lite.sh exists and executable"
  else
    log_warn "tools/docker_install_quartus_lite.sh missing or not executable"
  fi

  if [[ -x "$ANALYSIS_SCRIPT" ]]; then
    log_pass "tools/docker_run_openfpga_genesis_analysis_only.sh exists and executable"
  else
    log_warn "tools/docker_run_openfpga_genesis_analysis_only.sh missing or not executable"
  fi

  if grep -Fq "/root/fpga/installers" "$INSTALL_SCRIPT"; then
    log_pass "install script references /root/fpga/installers as install input"
  else
    log_warn "install script does not reference /root/fpga/installers"
  fi

  if grep -Fq "/root/fpga/intelFPGA_lite" "$INSTALL_SCRIPT"; then
    log_pass "install script references /root/fpga/intelFPGA_lite as install output"
  else
    log_warn "install script does not reference /root/fpga/intelFPGA_lite"
  fi

  if grep -Eq "quartus_fit|quartus_asm|quartus_sta|quartus_cpf" "$INSTALL_SCRIPT"; then
    log_warn "install script references forbidden Quartus commands"
  else
    log_pass "install script does not call quartus_fit/asm/sta/cpf"
  fi

  if grep -Fq "tools/run_openfpga_genesis_analysis_only.sh" "$ANALYSIS_SCRIPT"; then
    log_pass "analysis script invokes tools/run_openfpga_genesis_analysis_only.sh"
  else
    log_warn "analysis script does not invoke analysis wrapper"
  fi

  if grep -Eq "quartus_fit|quartus_asm|quartus_sta|quartus_cpf" "$ANALYSIS_SCRIPT"; then
    log_warn "analysis script references forbidden Quartus commands"
  else
    log_pass "analysis script does not call quartus_fit/asm/sta/cpf"
  fi

  if grep -Fq "/root/fpga/intelFPGA_lite" "$ANALYSIS_SCRIPT"; then
    log_pass "analysis script references /root/fpga/intelFPGA_lite mount"
  else
    log_warn "analysis script does not reference /root/fpga/intelFPGA_lite"
  fi

  echo
  echo "Summary: PASS=$PASS_COUNT WARN=$WARN_COUNT"
  echo "Status file: $(rel_path "$REPORT_PATH")"
  echo
} | tee "$REPORT_PATH"

exit 0
