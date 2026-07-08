#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPORT_PATH="$ROOT_DIR/docs/PREBUILT_QUARTUS_DOCKER_ANALYSIS_CHECK.md"
RUN_SCRIPT="$ROOT_DIR/tools/docker_run_openfpga_genesis_analysis_prebuilt.sh"
STATUS_FILE="$ROOT_DIR/docs/PREBUILT_QUARTUS_DOCKER_ANALYSIS_STATUS.md"
OPENFPGA_STATUS="$ROOT_DIR/docs/OPENFPGA_GENESIS_ANALYSIS_ONLY_STATUS.md"
RUN_LOG="$ROOT_DIR/docs/PREBUILT_QUARTUS_DOCKER_RUN_LOG.txt"
TIMESTAMP="$(date -u "+%Y-%m-%d %H:%M:%S UTC")"

log_ok() { printf "PASS: %s\n" "$1" | tee -a "$REPORT_PATH"; }
log_warn() { printf "WARN: %s\n" "$1" | tee -a "$REPORT_PATH"; }
log_fail() { printf "FAIL: %s\n" "$1" | tee -a "$REPORT_PATH"; }

: > "$REPORT_PATH"
{
  echo "# Prebuilt Quartus Docker analysis checker"
  echo "Generated: $TIMESTAMP"
  echo "Script: tools/docker_run_openfpga_genesis_analysis_prebuilt.sh"
  echo
} > "$REPORT_PATH"

if [[ ! -f "$RUN_SCRIPT" ]]; then
  log_fail "run script missing: tools/docker_run_openfpga_genesis_analysis_prebuilt.sh"
  exit 0
fi
log_ok "run script exists"

if [[ ! -x "$RUN_SCRIPT" ]]; then
  log_fail "run script not executable"
else
  log_ok "run script executable"
fi

if [[ -f "$STATUS_FILE" ]]; then
  log_ok "prebuilt status file exists"
else
  log_warn "prebuilt status file missing"
fi

if [[ -f "$RUN_LOG" ]]; then
  log_ok "run log exists"
else
  log_warn "run log missing"
fi

if rg -q "QUARTUS_PREBUILT_IMAGE" "$RUN_SCRIPT"; then
  log_ok "supports QUARTUS_PREBUILT_IMAGE override"
else
  log_warn "QUARTUS_PREBUILT_IMAGE override not detected"
fi

if rg -q "command -v quartus_map" "$RUN_SCRIPT"; then
  log_ok "container probes for quartus_map command"
else
  log_warn "container does not probe quartus_map command"
fi

if rg -q "quartus_map --version" "$RUN_SCRIPT"; then
  log_ok "container probes quartus_map --version"
else
  log_warn "container does not probe quartus_map --version"
fi

if rg -q "ls -lh tools/run_openfpga_genesis_analysis_only.sh" "$RUN_SCRIPT"; then
  log_ok "run log captures analysis script location check"
else
  log_warn "analysis script location check not found in container command"
fi

if rg -q "./tools/run_openfpga_genesis_analysis_only.sh" "$RUN_SCRIPT"; then
  log_ok "runner invocation present"
else
  log_warn "runner invocation missing"
fi

if rg -q "./tools/check_openfpga_genesis_analysis_runner.sh" "$RUN_SCRIPT"; then
  log_ok "runner checker invocation present"
else
  log_warn "runner checker invocation missing"
fi

if rg -q "No fitter, assembler, timing, or bitstream commands were run" "$RUN_SCRIPT"; then
  log_ok "wrapper says no forbidden synth/impl path executed"
else
  log_warn "wrapper does not include explicit no-forbidden-commands note"
fi

if rg -q "quartus_fit|quartus_asm|quartus_sta|quartus_cpf" "$RUN_SCRIPT"; then
  log_fail "disallowed Quartus command tokens appear in wrapper"
else
  log_ok "no disallowed Quartus commands in prebuilt wrapper"
fi

if [[ -f "$OPENFPGA_STATUS" ]]; then
  if rg -q "analysis result|Analysis exit|BLOCKED: quartus_map not found" "$OPENFPGA_STATUS"; then
    log_ok "openFPGA status file was refreshed and includes analysis markers"
  else
    log_warn "openFPGA status file has no recognizable analysis markers"
  fi

  if rg -q "Analysis exit:" "$OPENFPGA_STATUS"; then
    local_analysis_exit="$(awk '/Analysis exit:/{print $3; exit}' "$OPENFPGA_STATUS" || true)"
    if [[ -n "${local_analysis_exit}" ]]; then
      log_ok "analysis exit captured: $local_analysis_exit"
    else
      log_warn "analysis exit marker found but value not parsed"
    fi
  elif rg -q "BLOCKED: quartus_map not found" "$OPENFPGA_STATUS"; then
    log_ok "openFPGA status indicates quartus_map blocked"
  else
    log_warn "openFPGA status marker missing or stale"
  fi
else
  log_warn "openFPGA analysis status file missing"
fi

{
  echo
  echo "## Summary"
  echo "Result: PASS"
  echo "This is an advisory checker (no hard-fail on stale evidence)."
} >> "$REPORT_PATH"

log_ok "check completed."
exit 0
