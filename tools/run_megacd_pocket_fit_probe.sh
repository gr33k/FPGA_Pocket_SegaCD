#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="$ROOT_DIR/src/megacd_pocket/fpga"
WORK_DIR="$ROOT_DIR/build/megacd_pocket_fit_probe"
ARTIFACT_DIR="$ROOT_DIR/build/megacd_pocket_artifacts"
DOC_DIR="$ROOT_DIR/docs"
MAP_LOG="$DOC_DIR/MEGACD_POCKET_MAP_LOG.txt"
FIT_LOG="$DOC_DIR/MEGACD_POCKET_FIT_LOG.txt"
TIMING_LOG="$DOC_DIR/MEGACD_POCKET_TIMING_LOG.txt"
ASM_LOG="$DOC_DIR/MEGACD_POCKET_ASSEMBLER_LOG.txt"
STATUS_DOC="$DOC_DIR/MEGACD_POCKET_FIT_STATUS.md"
RESOURCE_DOC="$DOC_DIR/MEGACD_POCKET_RESOURCE_REPORT.md"
IMAGE="${QUARTUS_PREBUILT_IMAGE:-theypsilon/quartus-lite-c5:19.1-heavy}"
used_backend=""
map_exit="not-run"
fit_exit="not-run"
sta_exit="not-run"
asm_exit="not-run"
result=""

run_in_docker() {
  local tool_name="$1"; shift
  docker run --rm -t --init \
    -v "$ROOT_DIR:/work" \
    -w /work/build/megacd_pocket_fit_probe \
    "$IMAGE" \
    bash -lc "$tool_name $*"
}

run_tool() {
  local tool_name="$1"; shift
  if command -v "$tool_name" >/dev/null 2>&1; then
    used_backend="host"
    "$tool_name" "$@"
  else
    if ! command -v docker >/dev/null 2>&1; then
      return 127
    fi
    used_backend="docker:$IMAGE"
    run_in_docker "$tool_name" "$*"
  fi
}

extract_flow_value() {
  local label="$1"
  local file="$WORK_DIR/output_files/ap_core.flow.rpt"
  if [[ -f "$file" ]]; then
    awk -F';' -v label="$label" '$2 ~ label {gsub(/^ +| +$/, "", $3); print $3; exit}' "$file"
  fi
}

first_error_line() {
  rg -m1 'Error \(|Error:|Critical Warning' "$MAP_LOG" "$FIT_LOG" "$TIMING_LOG" "$ASM_LOG" 2>/dev/null || true
}

rm -rf "$WORK_DIR" "$ARTIFACT_DIR"
mkdir -p "$WORK_DIR"
rsync -a \
  --exclude output_files \
  --exclude db \
  --exclude incremental_db \
  --exclude '*.sof' \
  --exclude '*.rbf' \
  --exclude '*.rbf_r' \
  "$SRC_DIR/" "$WORK_DIR/"

: > "$MAP_LOG"
: > "$FIT_LOG"
: > "$TIMING_LOG"
: > "$ASM_LOG"

set +e
( cd "$WORK_DIR" && run_tool quartus_map --read_settings_files=on --write_settings_files=off ap_core -c ap_core ) > "$MAP_LOG" 2>&1
map_exit=$?
set -e

if [[ "$map_exit" == "0" ]]; then
  set +e
  ( cd "$WORK_DIR" && run_tool quartus_fit --read_settings_files=on --write_settings_files=off ap_core -c ap_core ) > "$FIT_LOG" 2>&1
  fit_exit=$?
  set -e
fi

if [[ "$map_exit" == "0" && "$fit_exit" == "0" ]]; then
  set +e
  ( cd "$WORK_DIR" && run_tool quartus_sta ap_core -c ap_core ) > "$TIMING_LOG" 2>&1
  sta_exit=$?
  ( cd "$WORK_DIR" && run_tool quartus_asm --read_settings_files=on --write_settings_files=off ap_core -c ap_core ) > "$ASM_LOG" 2>&1
  asm_exit=$?
  set -e
fi

logic_util="$(extract_flow_value 'Logic utilization \(in ALMs\)')"
block_mem="$(extract_flow_value 'Total block memory bits')"
dsp_util="$(extract_flow_value 'Total DSP Blocks')"
pll_util="$(extract_flow_value 'Total PLLs')"
first_error="$(first_error_line)"

if [[ "$map_exit" != "0" ]]; then
  result="MAP_FAILED_SOURCE_INTEGRATION"
elif [[ "$fit_exit" != "0" ]]; then
  if [[ "$block_mem" =~ \([[:space:]]*1[0-9]{2}[[:space:]]*%[[:space:]]*\) ]]; then
    result="POCKET_MEMORY_CAPACITY_EXCEEDED"
  elif [[ "$logic_util" =~ \([[:space:]]*1[0-9]{2}[[:space:]]*%[[:space:]]*\) ]]; then
    result="POCKET_LOGIC_CAPACITY_EXCEEDED"
  else
    result="MAP_PASS_FIT_FAIL"
  fi
elif [[ "$sta_exit" != "0" && "$asm_exit" == "0" ]]; then
  result="FIT_PASS_TIMING_FAIL"
elif [[ "$asm_exit" == "0" ]]; then
  result="BIOS_PROBE_ARTIFACT_READY"
else
  result="ASSEMBLER_FAILED"
fi

cat > "$STATUS_DOC" <<DOC
# MegaCD Pocket fit status

- backend: \
- result: \`$result\`
- map exit code: \`$map_exit\`
- fitter exit code: \`$fit_exit\`
- timing exit code: \`$sta_exit\`
- assembler exit code: \`$asm_exit\`
DOC
sed -i "s/- backend: \\/- backend: \\`$used_backend\\`/" "$STATUS_DOC"

cat > "$RESOURCE_DOC" <<DOC
# MegaCD Pocket resource report

- logic utilization: \`${logic_util:-unknown}\`
- block memory usage: \`${block_mem:-unknown}\`
- DSP usage: \`${dsp_util:-unknown}\`
- PLL usage: \`${pll_util:-unknown}\`
- first fatal error: \`${first_error:-none}\`
DOC

if [[ "$asm_exit" == "0" ]]; then
  mkdir -p "$ARTIFACT_DIR"
  cp "$WORK_DIR/output_files/bitstream.rbf_r" "$ARTIFACT_DIR/bitstream.rbf_r"
  cp "$WORK_DIR/output_files/ap_core.rbf" "$ARTIFACT_DIR/ap_core.rbf"
  cp "$WORK_DIR/output_files/ap_core.sof" "$ARTIFACT_DIR/ap_core.sof"
fi
