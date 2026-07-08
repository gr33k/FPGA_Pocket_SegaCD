#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPORT_PATH="$ROOT_DIR/docs/PREBUILT_QUARTUS_DOCKER_ANALYSIS_CHECK.md"
SCRIPT_PATH="$ROOT_DIR/tools/docker_run_openfpga_genesis_analysis_prebuilt.sh"
TIMESTAMP="$(date -u "+%Y-%m-%d %H:%M:%S UTC")"

: > "$REPORT_PATH"
{
  echo "# Prebuilt Quartus Docker analysis checker"
  echo "Generated: $TIMESTAMP"
  echo "Script: tools/docker_run_openfpga_genesis_analysis_prebuilt.sh"
  echo
} > "$REPORT_PATH"

ok() {
  printf "OK: %s\n" "$1" | tee -a "$REPORT_PATH"
}

warn() {
  printf "WARN: %s\n" "$1" | tee -a "$REPORT_PATH"
}

if [[ ! -f "$SCRIPT_PATH" ]]; then
  warn "Script missing: tools/docker_run_openfpga_genesis_analysis_prebuilt.sh"
  exit 0
fi

if [[ ! -x "$SCRIPT_PATH" ]]; then
  warn "Script is not executable: tools/docker_run_openfpga_genesis_analysis_prebuilt.sh"
  exit 0
fi

ok "script exists and is executable"

if ! rg -q "QUARTUS_PREBUILT_IMAGE" "$SCRIPT_PATH"; then
  warn "Default image override variable QUARTUS_PREBUILT_IMAGE not found."
else
  ok "script accepts QUARTUS_PREBUILT_IMAGE override."
fi

if ! rg -q "theypsilon/quartus-lite-c5:19.1-heavy" "$SCRIPT_PATH"; then
  warn "default image string not found."
else
  ok "default image string found."
fi

if ! rg -q "no2chem/quartuslite:latest" "$SCRIPT_PATH"; then
  warn "fallback image mention not found."
else
  ok "fallback image mention present."
fi

if ! rg -q "run_openfpga_genesis_analysis_only.sh" "$SCRIPT_PATH"; then
  warn "runner script call missing."
else
  ok "runner call present."
fi

if rg -q "quartus_(fit|asm|sta|cpf)" "$SCRIPT_PATH"; then
  warn "disallowed Quartus commands found (fit/asm/sta/cpf)."
else
  ok "no disallowed Quartus commands in wrapper."
fi

ok "check completed."
exit 0
