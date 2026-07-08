#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_DIR="$ROOT_DIR/third_party/openFPGA-Genesis/src/fpga"
WORK_ROOT_DIR="$ROOT_DIR/build/openfpga_genesis_fitter_smoke_work"
WORK_FPGA_DIR="$WORK_ROOT_DIR/src/fpga"
STATUS_PATH="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_SMOKE_STATUS.md"
MAP_LOG="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt"
FIT_LOG="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt"
REPORT_PATH="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_SMOKE_REPORTS.md"
CLEANUP_PATH="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_SMOKE_CLEANUP.md"
GATE_FILE="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_READINESS_GATE.md"
RUN_TIMESTAMP="$(date -u '+%Y-%m-%d %H:%M:%S UTC')"
cleaned_items=()
map_exit=99
fit_exit=99
fitter_attempted="no"
fit_first_error=""
fit_first_warning=""
map_first_error=""
map_first_warning=""

append_status() { printf '%s\n' "$1" >> "$STATUS_PATH"; }
append_report() { printf '%s\n' "$1" >> "$REPORT_PATH"; }
append_cleanup() { printf '%s\n' "$1" >> "$CLEANUP_PATH"; }
collect_quartus_exe() {
  local exe_name="$1"
  local path_candidate

  path_candidate="$(command -v "$exe_name" 2>/dev/null || true)"
  if [[ -n "$path_candidate" && -x "$path_candidate" ]]; then
    echo "$path_candidate"
    return 0
  fi

  if [[ "$exe_name" == quartus_map && -n "${QUARTUS_MAP:-}" && -x "${QUARTUS_MAP}" ]]; then
    echo "$QUARTUS_MAP"
    return 0
  fi
  if [[ "$exe_name" == quartus_fit && -n "${QUARTUS_FIT:-}" && -x "${QUARTUS_FIT}" ]]; then
    echo "$QUARTUS_FIT"
    return 0
  fi

  if [[ -n "${QUARTUS_ROOTDIR:-}" ]]; then
    for base in "$QUARTUS_ROOTDIR/bin" "$QUARTUS_ROOTDIR/quartus/bin"; do
      local candidate="$base/$exe_name"
      [[ -x "$candidate" ]] && { echo "$candidate"; return 0; }
    done
  fi

  for base in /opt/intelFPGA_lite /root/fpga/intelFPGA_lite /opt/intelFPGA; do
    for pattern in "$base"/*/quartus/bin/$exe_name "$base"/*/*/quartus/bin/$exe_name "$base"/*/*/*/quartus/bin/$exe_name "$base"/Intel*/*/quartus/bin/$exe_name; do
      if [[ -x "$pattern" ]]; then
        echo "$pattern"
        return 0
      fi
    done
  done

  return 1
}

: > "$STATUS_PATH"
: > "$REPORT_PATH"
: > "$CLEANUP_PATH"
{
  echo "# openFPGA-Genesis fitter smoke status"
  echo "Generated: $RUN_TIMESTAMP"
  echo
} > "$STATUS_PATH"

if ! grep -q "Current gate decision: \*\*READY_FOR_FITTER_GATE\*\*" "$GATE_FILE" 2>/dev/null; then
  append_status "BLOCKED: fitter gate not ready"
  append_status "Gate decision not ready in $GATE_FILE"
  echo "BLOCKED: fitter gate not ready"
  exit 0
fi

append_status "Gate check: READY_FOR_FITTER_GATE"

QUARTUS_MAP_EXE="$(collect_quartus_exe quartus_map || true)"
QUARTUS_FIT_EXE="$(collect_quartus_exe quartus_fit || true)"

if [[ -z "$QUARTUS_MAP_EXE" || -z "$QUARTUS_FIT_EXE" ]]; then
  append_status "BLOCKER: Quartus executables not found"
  append_status "quartus_map: ${QUARTUS_MAP_EXE:-missing}"
  append_status "quartus_fit: ${QUARTUS_FIT_EXE:-missing}"
  echo "BLOCKED: Quartus executables not found"
  exit 0
fi

append_status "Selected quartus_map: $QUARTUS_MAP_EXE"
append_status "Selected quartus_fit: $QUARTUS_FIT_EXE"
append_status "Quartus version (map): $($QUARTUS_MAP_EXE --version 2>/dev/null | awk '/Build/ {print; exit}' || true)"
append_status "Quartus version (fit): $($QUARTUS_FIT_EXE --version 2>/dev/null | awk '/Build/ {print; exit}' || true)"

rm -rf "$WORK_ROOT_DIR"
mkdir -p "$WORK_FPGA_DIR"
cp -R "$SOURCE_DIR"/. "$WORK_FPGA_DIR"/
append_status "Work dir: $WORK_FPGA_DIR"
append_status "Source copied from: $SOURCE_DIR"

map_command=("$QUARTUS_MAP_EXE" --read_settings_files=on --write_settings_files=off ap_core -c ap_core)
fit_command=("$QUARTUS_FIT_EXE" --read_settings_files=on --write_settings_files=off ap_core -c ap_core)
append_status "Map command: ${map_command[*]}"
append_status "Fit command: ${fit_command[*]}"
append_status "Running map prerequisite"

# map prerequisite (never use --analysis_and_elaboration here)
set +e
( cd "$WORK_FPGA_DIR" && "${map_command[@]}" > "$MAP_LOG" 2>&1 )
map_exit=$?
if (( map_exit != 0 )); then
  append_status "Map failed; fitter not run"
  : > "$FIT_LOG"
  fit_exit=0
else
  append_status "Map succeeded; running fitter"
  fitter_attempted="yes"
  ( cd "$WORK_FPGA_DIR" && "${fit_command[@]}" > "$FIT_LOG" 2>&1 )
  fit_exit=$?
  append_status "Fitter attempted: yes"
  append_status "Fitter exit code: $fit_exit"
  map_first_error="$(grep -n '^Error' "$MAP_LOG" | head -n 1 || true)"
fi
set -e

append_status "Map exit code: $map_exit"
append_status "Map log path: $MAP_LOG"
append_status "Fitter log path: $FIT_LOG"
append_status "Fitter attempted: $fitter_attempted"
if (( fit_exit != 0 )) || (( map_exit != 0 )); then
  append_status "Result: blocked-or-failed"
else
  append_status "Result: fitter-smoke-pass"
fi
if [[ -s "$MAP_LOG" ]]; then
  map_first_error="${map_first_error:-$(grep -n '^Error' "$MAP_LOG" | head -n 1 || true)}"
  map_first_warning="$(grep -n '^Warning' "$MAP_LOG" | head -n 1 || true)"
else
  map_first_error='Map log empty or missing'
  map_first_warning='Map log empty or missing'
fi
if [[ -s "$FIT_LOG" ]]; then
  fit_first_error="${fit_first_error:-$(grep -n '^Error' "$FIT_LOG" | head -n 1 || true)}"
  fit_first_warning="${fit_first_warning:-$(grep -n '^Warning' "$FIT_LOG" | head -n 1 || true)}"
else
  fit_first_error='Fitter log empty or missing'
  fit_first_warning='Fitter log empty or missing'
fi

{
  echo "# openFPGA Genesis fitter smoke reports"
  echo "Generated: $RUN_TIMESTAMP"
  echo "Source work dir: $WORK_FPGA_DIR"
  echo
  echo "## Map exit summary"
  echo "Map exit code: $map_exit"
  echo "Map first error: ${map_first_error:-none}"
  echo "Map first warning: ${map_first_warning:-none}"
  echo
  echo "## Fitter exit summary"
  echo "Fitter attempted: $fitter_attempted"
  if [[ "$fitter_attempted" == "yes" ]]; then
    echo "Fitter exit code: $fit_exit"
    echo "Fitter first error: ${fit_first_error:-none}"
    echo "Fitter first warning: ${fit_first_warning:-none}"
  else
    echo "Fitter exit code: not run"
  fi
  echo
  echo "## Fitter smoke resource/warning snippets"
  echo
  echo "### Map first 30 error lines"
  grep -n '^Error' "$MAP_LOG" | head -n 30 || true
  echo
  echo "### Map first 30 warning lines"
  grep -n '^Warning' "$MAP_LOG" | head -n 30 || true
  echo
  echo "### Fitter first 30 error lines"
  grep -n '^Error' "$FIT_LOG" | head -n 30 || true
  echo
  echo "### Fitter first 50 warning lines"
  grep -n '^Warning' "$FIT_LOG" | head -n 50 || true
  echo
  echo "### Map/device/fitter notable lines"
  grep -n "Unsupported\|family\|PLL\|memory\|rom\|SDRAM\|12241\|10259\|10030\|10858\|pins\|IO" "$MAP_LOG" "$FIT_LOG" 2>/dev/null | head -n 80 || true
} > "$REPORT_PATH"

{
  echo "# openFPGA Genesis fitter smoke cleanup"
  echo "Generated: $RUN_TIMESTAMP"
  echo
  echo "Work dir: $WORK_FPGA_DIR"
  echo
} > "$CLEANUP_PATH"

for item in "$WORK_FPGA_DIR/output_files" "$WORK_FPGA_DIR/db" "$WORK_FPGA_DIR/incremental_db" "$WORK_FPGA_DIR/greybox_tmp" "$WORK_FPGA_DIR/simulation"; do
  if [[ -d "$item" ]]; then
    append_cleanup "Removed dir: $item"
    cleaned_items+=("$item")
    rm -rf "$item"
  fi
done

shopt -s nullglob
for f in "$WORK_FPGA_DIR"/*.{sof,pof,jic,rpd,rbf,rbf_r}; do
  if [[ -f "$f" ]]; then
    append_cleanup "Removed bitstream-like file: $f"
    cleaned_items+=("$f")
    rm -f "$f"
  fi
done
shopt -u nullglob

append_status "Cleanup recorded in $CLEANUP_PATH"
if (( ${#cleaned_items[@]} > 0 )); then
  for item in "${cleaned_items[@]}"; do
    append_status "Removed: $item"
  done
else
  append_status "No items matched cleanup patterns."
fi
append_status "Fitter smoke flow complete"

append_report "# Map/fitter first-error summary"
append_report "Map first error class: ${map_first_error:-none}"
append_report "Fitter first error class: ${fit_first_error:-none}"

if (( map_exit != 0 )); then
  echo "Map failed with exit $map_exit"
elif (( fit_exit != 0 )); then
  echo "Fitter failed with exit $fit_exit"
else
  echo "Fitter smoke completed"
fi
