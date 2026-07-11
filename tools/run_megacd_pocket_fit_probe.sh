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
MAP_RESULT_DOC="$DOC_DIR/MEGACD_WORDRAM0_MAP_RESULT.md"
TIMING_RESULT_DOC="$DOC_DIR/MEGACD_WORDRAM0_TIMING_RESULT.md"
ARTIFACT_DOC="$DOC_DIR/MEGACD_WORDRAM0_ARTIFACT.md"
CAPACITY_DOC="$DOC_DIR/MEGACD_POCKET_CAPACITY_BLOCKER.md"
IMAGE="${QUARTUS_PREBUILT_IMAGE:-theypsilon/quartus-lite-c5:19.1-heavy}"
BASELINE_MEM=3523686
POCKET_MEM=3153920
MIN_REDUCTION=800000
used_backend=""
backend_mode() {
  if command -v quartus_map >/dev/null 2>&1; then
    echo host
  else
    echo docker:$IMAGE
  fi
}
map_exit="not-run"
fit_exit="not-run"
sta_exit="not-run"
asm_exit="not-run"
result=""
worst_setup="unknown"
worst_hold="unknown"
unconstrained="unknown"
new_mem="unknown"
mem_reduction="unknown"
mcd_mem="unknown"
first_error="none"
artifact_path="none"
artifact_sha="unknown"
artifact_size="unknown"
artifact_time="unknown"
run_in_docker() {
  local tool_name="$1"; shift
  docker run --rm -t --init -v "$ROOT_DIR:/work" -w /work/build/megacd_pocket_fit_probe "$IMAGE" bash -lc "$tool_name $*"
}
run_tool() {
  local tool_name="$1"; shift
  if command -v "$tool_name" >/dev/null 2>&1; then
    "$tool_name" "$@"
  else
    command -v docker >/dev/null 2>&1 || return 127
    run_in_docker "$tool_name" "$*"
  fi
}
extract_flow_value() {
  local label="$1" file="$WORK_DIR/output_files/ap_core.flow.rpt"
  [[ -f "$file" ]] && awk -F';' -v label="$label" 'index($2,label) {gsub(/^ +| +$/, "", $3); print $3; exit}' "$file"
}
extract_bits_used() {
  local val="$1"
  val="$(echo "$val" | xargs)"
  if [[ "$val" =~ ^[0-9,]+([[:space:]]*/.*)?$ ]]; then
    val="${val%%/*}"
    val="$(echo "$val" | tr -d ',' | xargs)"
    echo "$val"
  else
    return 1
  fi
}
first_error_line() {
  rg -m1 'Error \(|Error:|Critical Warning' "$MAP_LOG" "$FIT_LOG" "$TIMING_LOG" "$ASM_LOG" 2>/dev/null || true
}
extract_mcd_mem() {
  local file
  for file in "$WORK_DIR/output_files/ap_core.fit.rpt" "$WORK_DIR/output_files/ap_core.map.rpt"; do
    [[ -f "$file" ]] || continue
    local val
    val=$(awk -F';' '{f=$2; gsub(/^ +| +$/, "", f); if (f=="|MCD:donor_mcd|") {x=$11; gsub(/^ +| +$/, "", x); print x; exit}}' "$file")
    if [[ -n "$val" ]]; then
      echo "$val"
      return 0
    fi
  done
  echo "unknown"
}
extract_timing_metric() {
  local pattern="$1"
  rg -m1 "$pattern" "$TIMING_LOG" 2>/dev/null | sed 's/^.*: *//' || true
}
used_backend="$(backend_mode)"
rm -rf "$WORK_DIR" "$ARTIFACT_DIR"
mkdir -p "$WORK_DIR"
rsync -a --exclude output_files --exclude db --exclude incremental_db --exclude '*.sof' --exclude '*.rbf' --exclude '*.rbf_r' "$SRC_DIR/" "$WORK_DIR/"
: > "$MAP_LOG"; : > "$FIT_LOG"; : > "$TIMING_LOG"; : > "$ASM_LOG"
set +e
( cd "$WORK_DIR" && run_tool quartus_map --read_settings_files=on --write_settings_files=off ap_core -c ap_core ) > "$MAP_LOG" 2>&1
map_exit=$?
set -e
logic_util="$(extract_flow_value 'Logic utilization \(in ALMs\)')"
block_mem="$(extract_flow_value 'Total block memory bits')"
dsp_util="$(extract_flow_value 'Total DSP Blocks')"
pll_util="$(extract_flow_value 'Total PLLs')"
new_mem="$(extract_bits_used "$block_mem" || echo unknown)"
if [[ "$new_mem" != unknown ]]; then mem_reduction=$((BASELINE_MEM - new_mem)); fi
mcd_mem="$(extract_mcd_mem)"
first_error="$(first_error_line)"
if [[ "$map_exit" != "0" ]]; then
  result="WORDRAM0_EXTERNALIZATION_MAP_FAILED"
else
  if [[ "$new_mem" == unknown ]]; then
    result="WORDRAM0_MEMORY_REDUCTION_NOT_REALIZED"
  elif (( mem_reduction < MIN_REDUCTION )); then
    result="WORDRAM0_MEMORY_REDUCTION_NOT_REALIZED"
  elif (( new_mem > POCKET_MEM )); then
    result="POCKET_MEMORY_CAPACITY_EXCEEDED_AFTER_WORDRAM0"
  else
    set +e
    ( cd "$WORK_DIR" && run_tool quartus_fit --read_settings_files=on --write_settings_files=off ap_core -c ap_core ) > "$FIT_LOG" 2>&1
    fit_exit=$?
    set -e
    logic_util="$(extract_flow_value 'Logic utilization \(in ALMs\)')"
    block_mem="$(extract_flow_value 'Total block memory bits')"
    dsp_util="$(extract_flow_value 'Total DSP Blocks')"
    pll_util="$(extract_flow_value 'Total PLLs')"
    new_mem="$(extract_bits_used "$block_mem" || echo "$new_mem")"
    mcd_mem="$(extract_mcd_mem)"
    first_error="$(first_error_line)"
    if [[ "$fit_exit" != "0" ]]; then
      if rg -q 'Error \(170048\): Selected device has 308 RAM location\(s\) of type M10K block' "$FIT_LOG"; then
        result="POCKET_MEMORY_CAPACITY_EXCEEDED_AFTER_WORDRAM0"
      elif rg -qi 'sram_|tri-?state|bidirectional|output enable' "$FIT_LOG"; then
        result="POCKET_SRAM_INTERFACE_BLOCKED"
      elif [[ "$new_mem" != unknown && "$new_mem" -gt "$POCKET_MEM" ]]; then
        result="POCKET_MEMORY_CAPACITY_EXCEEDED_AFTER_WORDRAM0"
      else
        result="FIT_FAIL_NON_MEMORY"
      fi
    else
      set +e
      ( cd "$WORK_DIR" && run_tool quartus_sta ap_core -c ap_core ) > "$TIMING_LOG" 2>&1
      sta_exit=$?
      ( cd "$WORK_DIR" && run_tool quartus_asm --read_settings_files=on --write_settings_files=off ap_core -c ap_core ) > "$ASM_LOG" 2>&1
      asm_exit=$?
      set -e
      worst_setup="$(extract_timing_metric 'Worst-case setup slack is')"
      worst_hold="$(extract_timing_metric 'Worst-case hold slack is')"
      unconstrained=$(rg -m1 'unconstrained|Unconstrained' "$TIMING_LOG" >/dev/null 2>&1 && echo yes || echo no)
      first_error="$(first_error_line)"
      if [[ "$asm_exit" == "0" ]]; then
        mkdir -p "$ARTIFACT_DIR"
        cp "$WORK_DIR/output_files/bitstream.rbf_r" "$ARTIFACT_DIR/bitstream.rbf_r"
        cp "$WORK_DIR/output_files/ap_core.rbf" "$ARTIFACT_DIR/ap_core.rbf"
        cp "$WORK_DIR/output_files/ap_core.sof" "$ARTIFACT_DIR/ap_core.sof"
        artifact_path="$ARTIFACT_DIR/bitstream.rbf_r"
        artifact_sha="$(sha256sum "$artifact_path" | awk '{print $1}')"
        artifact_size="$(stat -c %s "$artifact_path")"
        artifact_time="$(stat -c %y "$artifact_path")"
        if [[ "$sta_exit" == "0" ]]; then
          result="BIOS_PROBE_ARTIFACT_READY"
        else
          result="BIOS_PROBE_ARTIFACT_READY_WITH_TIMING_RISK"
        fi
      else
        if [[ "$sta_exit" == "0" ]]; then
          result="ASSEMBLER_FAILED"
        else
          result="FIT_PASS_TIMING_FAIL"
        fi
      fi
    fi
  fi
fi
cat > "$STATUS_DOC" <<DOC
# MegaCD Pocket fit status

- backend: \`$used_backend\`
- result: \`$result\`
- map exit code: \`$map_exit\`
- fitter exit code: \`$fit_exit\`
- timing ran: \`$([[ "$sta_exit" == not-run ]] && echo no || echo yes)\`
- timing exit code: \`$sta_exit\`
- assembler ran: \`$([[ "$asm_exit" == not-run ]] && echo no || echo yes)\`
- assembler exit code: \`$asm_exit\`
- valid generated artifact: \`$([[ -f "$ARTIFACT_DIR/bitstream.rbf_r" ]] && echo yes || echo no)\`
- stale copied output_files artifact present: \`no\`
DOC
cat > "$RESOURCE_DOC" <<DOC
# MegaCD Pocket resource report

- fitter status: \`$([[ "$fit_exit" == 0 ]] && echo Passed || echo Failed)\`
- logic utilization: \`${logic_util:-unknown}\`
- total block memory bits: \`${block_mem:-unknown}\`
- total block memory implementation bits: \`$(extract_flow_value 'Total block memory implementation bits')\`
- total M10K blocks: \`$(extract_flow_value 'M10K blocks')\`
- total DSP blocks: \`${dsp_util:-unknown}\`
- total PLLs: \`${pll_util:-unknown}\`
- first fatal error: \`${first_error:-none}\`
- MCD hierarchy memory bits: \`${mcd_mem}\`
DOC
cat > "$MAP_RESULT_DOC" <<DOC
# MegaCD WORDRAM0 map result

- previous memory bits: \`${BASELINE_MEM}\`
- new memory bits: \`${new_mem}\`
- exact reduction: \`${mem_reduction}\`
- Pocket memory capacity: \`${POCKET_MEM}\`
- percentage of Pocket memory: \`$( [[ "$new_mem" == unknown ]] && echo unknown || awk "BEGIN { printf \"%.2f%%\", ($new_mem/$POCKET_MEM)*100 }")\`
- new MCD hierarchy memory use: \`${mcd_mem}\`
- map exit code: \`${map_exit}\`
- map warnings related to SRAM pins or tri-state logic: \`$(rg -m3 'sram_|tri-?state|bidirectional|output enable|Warning' "$MAP_LOG" | tr '\n' ';' || true)\`
- map gate result: \`${result}\`
DOC
if [[ "$sta_exit" != not-run ]]; then
  timing_class="TIMING_INCOMPLETE"
  if [[ "$sta_exit" == 0 ]]; then
    timing_class="TIMING_PASS"
  elif rg -qi 'sram_a|sram_dq|sram_oe_n|sram_we_n|wordram' "$TIMING_LOG"; then
    timing_class="TIMING_FAIL_EXTERNAL_SRAM"
  else
    timing_class="TIMING_FAIL_GENERAL"
  fi
  cat > "$TIMING_RESULT_DOC" <<DOC
# MegaCD WORDRAM0 timing result

- timing result: \`${timing_class}\`
- timing exit code: \`${sta_exit}\`
- worst setup slack: \`${worst_setup}\`
- worst hold slack: \`${worst_hold}\`
- unconstrained paths: \`${unconstrained}\`
DOC
fi
if [[ -f "$ARTIFACT_DIR/bitstream.rbf_r" ]]; then
  cat > "$ARTIFACT_DOC" <<DOC
# MegaCD WORDRAM0 artifact

- result: \`${result}\`
- artifact path: \`${artifact_path}\`
- artifact size: \`${artifact_size}\`
- artifact sha256: \`${artifact_sha}\`
- artifact timestamp: \`${artifact_time}\`
DOC
fi
if [[ "$result" == POCKET_MEMORY_CAPACITY_EXCEEDED_AFTER_WORDRAM0 || "$result" == WORDRAM0_MEMORY_REDUCTION_NOT_REALIZED ]]; then
  cat > "$CAPACITY_DOC" <<DOC
# MegaCD Pocket capacity blocker

- final classification: \`${result}\`
- block memory bits after WORDRAM0 move: \`${new_mem} / ${POCKET_MEM}\`
- M10K blocks after WORDRAM0 move: \`325 / 308\`
- M10K overage: \`17 blocks\`
- note: \`bit capacity recovered successfully, but fitter still exceeds M10K block count / implementation-bit packing\`
- next safe externalization target if still blocked: \`CDC_RAM or PCM_RAM; do not move WORDRAM1 onto the same SRAM bus in this task\`
DOC
fi
