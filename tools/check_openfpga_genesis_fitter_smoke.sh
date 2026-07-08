#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CHECK_FILE="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_SMOKE_CHECK.md"
RUNNER="$ROOT_DIR/tools/run_openfpga_genesis_fitter_smoke.sh"
GATE_CHECK="$ROOT_DIR/tools/check_openfpga_genesis_fitter_gate_ready.sh"
GATE_DOC="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_READINESS_GATE.md"
GATE_STATUS="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_GATE_READY_CHECK.md"
STATUS="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_SMOKE_STATUS.md"
REPORT="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_SMOKE_REPORTS.md"
CLEAN="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_SMOKE_CLEANUP.md"
MAP_LOG="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt"
FIT_LOG="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt"
WORK_ROOT="$ROOT_DIR/build/openfpga_genesis_fitter_smoke_work"
NOW="$(date -u "+%Y-%m-%d %H:%M:%S UTC")"
RUNNER_REL="tools/run_openfpga_genesis_fitter_smoke.sh"
GATE_CHECK_REL="tools/check_openfpga_genesis_fitter_gate_ready.sh"
GATE_DOC_REL="docs/OPENFPGA_GENESIS_FITTER_READINESS_GATE.md"
GATE_STATUS_REL="docs/OPENFPGA_GENESIS_FITTER_GATE_READY_CHECK.md"
STATUS_REL="docs/OPENFPGA_GENESIS_FITTER_SMOKE_STATUS.md"
REPORT_REL="docs/OPENFPGA_GENESIS_FITTER_SMOKE_REPORTS.md"
CLEAN_REL="docs/OPENFPGA_GENESIS_FITTER_SMOKE_CLEANUP.md"

status="pass"
reasons=()
notes=()
TMP_GATE_LOG="/tmp/openfpga_fitter_gate_ready.log"

require_file() {
  local file="$1"
  local label="$2"
  if [[ ! -f "$file" ]]; then
    status="fail"
    reasons+=("missing:$label")
  fi
}

require_dir() {
  local dir="$1"
  local label="$2"
  if [[ ! -d "$dir" ]]; then
    status="fail"
    reasons+=("missing:$label")
  fi
}

lower() {
  printf "%s" "$1" | tr "[:upper:]" "[:lower:]"
}

has_clear_gate_failure() {
  local text="$1"
  local lower_text=""
  lower_text="$(lower "$text")"

  if [[ "$lower_text" == *"blocked"* ]]; then
    return 0
  fi
  if [[ "$lower_text" == *"not ready"* ]]; then
    return 0
  fi
  if [[ "$lower_text" == *"fail"* ]]; then
    return 0
  fi
  return 1
}

extract_dir_state() {
  local file="$1"
  local tag="$2"
  rg -q "Removed dir: .*${tag}" "$file" 2>/dev/null
}

smoke_status_ok() {
  if [[ "${map_exit:-}" == "0" && "${fit_exit:-}" == "0" && "${fit_attempted:-}" == "yes" ]]; then
    if rg -q "Result: fitter-smoke-pass" "$STATUS" 2>/dev/null; then
      return 0
    fi
  fi
  return 1
}

work_root_cleanup_expected() {
  local file="$1"
  if extract_dir_state "$file" "output_files" && extract_dir_state "$file" "db" && extract_dir_state "$file" "incremental_db"; then
    return 0
  fi
  return 1
}

has_gate_ready_output() {
  local text="$1"
  # Accept either explicit structured pass text or plain PASS line from checker output.
  if printf "%s" "$text" | rg -q "(^|[[:space:]])PASS([[:space:]]|$)|Result: PASS"; then
    return 0
  fi
  return 1
}

# Gate check must run and report ready
if bash "$GATE_CHECK" >"$TMP_GATE_LOG" 2>&1; then
  :
else
  status="fail"
  reasons+=("gate-ready-check-failed")
fi

gate_log="$(cat "$TMP_GATE_LOG" 2>/dev/null || true)"
if [[ -z "$gate_log" ]]; then
  status="fail"
  reasons+=("gate-not-ready")
elif ! has_gate_ready_output "$gate_log"; then
  status="fail"
  reasons+=("gate-ready-output-missing")
elif has_clear_gate_failure "$gate_log"; then
  status="fail"
  reasons+=("gate-blocked")
fi

if ! rg -q "READY_FOR_FITTER_GATE" "$GATE_DOC" 2>/dev/null; then
  status="fail"
  reasons+=("gate-decision-check-failed")
fi

require_file "$RUNNER" "runner"
require_file "$GATE_CHECK" "gate-check script"
require_file "$STATUS" "smoke status"
require_file "$REPORT" "smoke report"
require_file "$CLEAN" "smoke cleanup"
require_file "$MAP_LOG" "smoke map log"
require_file "$FIT_LOG" "smoke fit log"
require_file "$GATE_DOC" "gate readiness doc"
require_file "$GATE_STATUS" "gate-ready status"
map_exit="$(rg -m1 "^Map exit code:" "$STATUS" | sed "s/.*: //")"
fit_exit="$(rg -m1 "^Fitter exit code:" "$STATUS" | sed "s/.*: //")"
fit_attempted="$(rg -m1 "^Fitter attempted:" "$STATUS" | sed "s/.*: //")"

cleanup_ok="false"
if smoke_status_ok && work_root_cleanup_expected "$CLEAN"; then
  cleanup_ok="true"
fi

if [[ -d "$WORK_ROOT" ]]; then
  if [[ -d "$WORK_ROOT/src/fpga" ]]; then
    if [[ -d "$WORK_ROOT/src/fpga/output_files" || -d "$WORK_ROOT/src/fpga/db" || -d "$WORK_ROOT/src/fpga/incremental_db" || -d "$WORK_ROOT/src/fpga/greybox_tmp" || -d "$WORK_ROOT/src/fpga/simulation" ]]; then
      status="fail"
      reasons+=("cleanup-incomplete")
    elif [[ "$cleanup_ok" == "true" ]]; then
      notes+=("smoke-work-dir-cleaned")
    fi
  else
    if [[ "$cleanup_ok" == "true" ]]; then
      notes+=("smoke-work-dir-cleaned")
    else
      status="fail"
      reasons+=("missing:smoke work dir")
    fi
  fi
else
  if [[ "$cleanup_ok" == "true" ]]; then
    notes+=("smoke-work-root-cleaned")
  else
    status="fail"
    reasons+=("missing:smoke work root")
  fi
fi

# Validate smoke status output as source of truth
if ! rg -q "Result: fitter-smoke-pass" "$STATUS" 2>/dev/null; then
  status="fail"
  reasons+=("smoke-status-not-pass")
fi

if [[ -z "$map_exit" ]]; then
  status="fail"
  reasons+=("status-missing-map-exit")
elif [[ "$map_exit" != "0" ]]; then
  status="fail"
  reasons+=("map-exit:$map_exit")
fi

if [[ -z "$fit_attempted" ]]; then
  status="fail"
  reasons+=("status-missing-fitter-flag")
elif [[ "$fit_attempted" != "yes" ]]; then
  status="fail"
  reasons+=("fitter-not-attempted")
elif [[ -z "$fit_exit" || "$fit_exit" != "0" ]]; then
  status="fail"
  reasons+=("fit-exit:${fit_exit:-missing}")
fi

for token in "quartus_map" "quartus_fit" "--read_settings_files=on" "--write_settings_files=off"; do
  if ! rg -q --fixed-strings -- "$token" "$RUNNER"; then
    status="fail"
    reasons+=("runner-missing-token:$token")
  fi
  if ! rg -q --fixed-strings -- "$token" "$STATUS"; then
    status="fail"
    reasons+=("status-missing-token:$token")
  fi

done

for token in "quartus_asm" "quartus_sta" "quartus_cpf" "quartus_sh --flow compile"; do
  if rg -q --fixed-strings -- "$token" "$RUNNER"; then
    status="fail"
    reasons+=("forbidden-token:$token")
  fi
  if rg -q --fixed-strings -- "$token" "$STATUS"; then
    status="fail"
    reasons+=("status-forbidden-token:$token")
  fi

done

if ! rg -q "Map command:" "$STATUS"; then
  status="fail"
  reasons+=("runner-no-map-command")
fi
if ! rg -q "Fit command:" "$STATUS"; then
  status="fail"
  reasons+=("runner-no-fit-command")
fi

if [[ -d "$WORK_ROOT/src/fpga/output_files" || -d "$WORK_ROOT/src/fpga/db" || -d "$WORK_ROOT/src/fpga/incremental_db" || -d "$WORK_ROOT/src/fpga/greybox_tmp" || -d "$WORK_ROOT/src/fpga/simulation" ]]; then
  status="fail"
  reasons+=("cleanup-incomplete")
fi

{
  echo "# openFPGA Genesis fitter smoke check"
  echo "Generated: $NOW"
  echo "Status: $status"
  echo "Runner: $RUNNER_REL"
  echo "Gate check: $GATE_CHECK_REL"
  echo "Gate status: $GATE_STATUS_REL"
  echo "Gate readiness decision: $GATE_DOC_REL"
  echo "Status doc: $STATUS_REL"
  echo "Report doc: $REPORT_REL"
  echo "Cleanup doc: $CLEAN_REL"
  echo
  if [[ "$status" == pass ]]; then
    echo "Result: PASS"
    echo "Fitter smoke result: FITTER_SMOKE_PASS"
    echo "Map exit code: ${map_exit:-missing}"
    echo "Fitter exit code: ${fit_exit:-missing}"
    echo "Assembler ran: no"
    echo "Timing ran: no"
    echo "Bitstream generated intentionally: no"
    echo "APF packaging ran: no"
    echo "Pocket boot claimed: no"
    echo "Runtime correctness claimed: no"
  else
    echo "Result: checks failed"
  fi
  if [[ ${#notes[@]} -gt 0 ]]; then
    echo
    echo "Notes:"
    printf " - %s\n" "${notes[@]}"
  fi
  echo
  if [[ ${#reasons[@]} -gt 0 ]]; then
    printf "%s\n" "${reasons[@]}"
  fi
} > "$CHECK_FILE"

if [[ "$status" == "pass" ]]; then
  echo "PASS"
else
  echo "WARN"
  printf "%s\n" "${reasons[@]}"
fi
