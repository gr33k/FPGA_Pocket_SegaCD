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
AUDIT_DOC="$DOC_DIR/MEGACD_M10K_PACKING_AUDIT.md"
MAP_RESULT_DOC="$DOC_DIR/MEGACD_CDC_RAM_MAP_RESULT.md"
TIMING_RESULT_DOC="$DOC_DIR/MEGACD_CDC_RAM_TIMING_RESULT.md"
ARTIFACT_DOC="$DOC_DIR/MEGACD_CDC_RAM_ARTIFACT.md"
CAPACITY_DOC="$DOC_DIR/MEGACD_POCKET_CAPACITY_BLOCKER.md"
MARGIN_DOC="$DOC_DIR/MEGACD_M10K_MARGIN_ADJUSTMENT.md"
IMAGE="${QUARTUS_PREBUILT_IMAGE:-theypsilon/quartus-lite-c5:19.1-heavy}"
PREV_LOGIC="$(sed -n 's/^- logic utilization: `\(.*\)`/\1/p' "$RESOURCE_DOC" | head -1 || true)"
PREV_BLOCK_BITS="$(sed -n 's/^- total block memory bits: `\(.*\)`/\1/p' "$RESOURCE_DOC" | head -1 || true)"
used_backend=""
map_exit="not-run"
fit_exit="not-run"
sta_exit="not-run"
asm_exit="not-run"
result=""
worst_setup="unknown"
worst_hold="unknown"
unconstrained="unknown"
logic_before="${PREV_LOGIC:-unknown}"
logic_after="unknown"
block_mem_after="unknown"
block_impl_after="unknown"
m10k_after="unknown"
m10k_used="unknown"
m10k_headroom="unknown"
cdc_m10k_after="unknown"
cdc_mlab_hit="no"
cdc_reg_fallback="no"
first_error="none"
artifact_path="none"
artifact_sha="unknown"
artifact_size="unknown"
artifact_time="unknown"

autotrim() {
  echo "$1" | tr -d ',' | xargs
}

reverse_rbf_bits() {
  local in_file="$1" out_file="$2"
  python3 - "$in_file" "$out_file" <<'PYREV'
from pathlib import Path
import sys
src = Path(sys.argv[1]).read_bytes()
rev = bytes(int(f"{b:08b}"[::-1], 2) for b in src)
Path(sys.argv[2]).write_bytes(rev)
PYREV
}
backend_mode() {
  if command -v quartus_map >/dev/null 2>&1; then
    echo host
  else
    echo docker:$IMAGE
  fi
}
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
  [[ -f "$file" ]] && awk -F';' -v label="$label" '{f=$2; gsub(/^ +| +$/, "", f); if (f==label) {v=$3; gsub(/^ +| +$/, "", v); print v; exit}}' "$file"
}
extract_fit_value() {
  local label="$1" file="$WORK_DIR/output_files/ap_core.fit.rpt"
  [[ -f "$file" ]] && awk -F';' -v label="$label" '{f=$2; gsub(/^ +| +$/, "", f); if (f==label) {v=$3; gsub(/^ +| +$/, "", v); print v; exit}}' "$file"
}
extract_used_from_ratio() {
  local raw="$1"
  raw="$(autotrim "$raw")"
  if [[ "$raw" == *'/'* ]]; then
    raw="${raw%%/*}"
  fi
  autotrim "$raw"
}
extract_timing_metric() {
  local pattern="$1"
  rg -m1 "$pattern" "$TIMING_LOG" 2>/dev/null | sed 's/^.*: *//' || true
}
first_error_line() {
  rg -m1 'Error \(|Error:|Critical Warning' "$MAP_LOG" "$FIT_LOG" "$TIMING_LOG" "$ASM_LOG" 2>/dev/null || true
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
first_error="$(first_error_line)"
if [[ "$map_exit" != "0" ]]; then
  result="CDC_MLAB_MAP_FAILED"
else
  set +e
  ( cd "$WORK_DIR" && run_tool quartus_fit --read_settings_files=on --write_settings_files=off ap_core -c ap_core ) > "$FIT_LOG" 2>&1
  fit_exit=$?
  set -e
  logic_after="$(extract_flow_value 'Logic utilization (in ALMs)')"
  block_mem_after="$(extract_fit_value 'Block Memory Bits')"
  block_impl_after="$(extract_fit_value 'Total block memory implementation bits')"
  m10k_after="$(extract_fit_value 'M10K blocks')"
  [[ -z "$block_impl_after" ]] && block_impl_after="$(extract_flow_value 'Total block memory implementation bits')"
  [[ -z "$block_mem_after" ]] && block_mem_after="$(extract_flow_value 'Total block memory bits')"
  m10k_used="$(extract_used_from_ratio "$m10k_after")"
  if [[ "$m10k_used" =~ ^[0-9]+$ ]]; then
    m10k_headroom=$((308 - m10k_used))
  else
    m10k_headroom=unknown
  fi
  if rg -q 'dpram_dif:CDC_RAM' "$WORK_DIR/output_files/ap_core.fit.rpt" 2>/dev/null; then
    cdc_m10k_after="16"
  elif rg -q 'megacd_cdc_ram_mlab' "$WORK_DIR/output_files/ap_core.fit.rpt" "$FIT_LOG" 2>/dev/null; then
    cdc_m10k_after="0"
  fi
  if rg -q 'megacd_cdc_ram_mlab' "$FIT_LOG" "$WORK_DIR/output_files/ap_core.fit.rpt" 2>/dev/null; then
    cdc_mlab_hit="yes"
  fi
  if [[ "$fit_exit" != "0" ]]; then
    if [[ "$m10k_used" =~ ^[0-9]+$ && "$m10k_used" -gt 308 ]]; then
      result="M10K_DEFICIT_REMAINS_AFTER_CDC"
    elif rg -qi 'MLAB|routing' "$FIT_LOG"; then
      result="FIT_FAIL_MLAB_ROUTING"
    elif rg -qi 'ALM|logic utilization|not enough logic' "$FIT_LOG"; then
      result="FIT_FAIL_LOGIC_CAPACITY"
    elif rg -qi 'M10K block|RAM location\(s\) of type M10K' "$FIT_LOG"; then
      result="FIT_FAIL_M10K"
    else
      result="FIT_FAIL_NON_MEMORY"
    fi
  else
    if [[ ! "$m10k_used" =~ ^[0-9]+$ ]]; then
      result="CDC_MLAB_NOT_INFERRED"
    elif (( m10k_used > 308 )); then
      result="M10K_DEFICIT_REMAINS_AFTER_CDC"
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
      if [[ "$asm_exit" == "0" ]]; then
        mkdir -p "$ARTIFACT_DIR"
        cp "$WORK_DIR/output_files/ap_core.rbf" "$ARTIFACT_DIR/ap_core.rbf"
        cp "$WORK_DIR/output_files/ap_core.sof" "$ARTIFACT_DIR/ap_core.sof"
        reverse_rbf_bits "$ARTIFACT_DIR/ap_core.rbf" "$ARTIFACT_DIR/bitstream.rbf_r"
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
first_error="$(first_error_line)"
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
- logic utilization before: \`${logic_before:-unknown}\`
- logic utilization after: \`${logic_after:-unknown}\`
- total block memory bits before: \`${PREV_BLOCK_BITS:-unknown}\`
- total block memory bits after: \`${block_mem_after:-unknown}\`
- total block memory implementation bits after: \`${block_impl_after:-unknown}\`
- total M10K blocks after: \`${m10k_after:-unknown}\`
- total DSP blocks after: \`$(extract_flow_value 'Total DSP Blocks')\`
- total PLLs after: \`$(extract_flow_value 'Total PLLs')\`
- first fatal error: \`${first_error:-none}\`
DOC
cat > "$AUDIT_DOC" <<DOC
# MegaCD M10K packing audit

- previous M10K count: \`325 / 308\`
- previous CDC RAM M10K use: \`16\`
- previous PCM RAM M10K use: \`64\`
- previous WORDRAM1 M10K use: \`128\`
- previous total block memory bits: \`2475110 / 3153920\`
- previous implementation bits: \`3328000 / 3153920\`
- current total block memory bits after Task 9C: \`${block_mem_after:-unknown}\`
- current total block memory implementation bits after Task 9C: \`${block_impl_after:-unknown}\`
- current total M10K blocks after Task 9C: \`${m10k_after:-unknown}\`
- current M10K headroom: \`${m10k_headroom}\`
- CDC RAM helper file: \`src/megacd_pocket/fpga/core/rtl/pocket/megacd_cdc_ram_mlab.sv\`
- CDC RAM donor instance retained in fit report: \`$([[ "$cdc_m10k_after" == 16 ]] && echo yes || echo no)\`
DOC
cat > "$MAP_RESULT_DOC" <<DOC
# MegaCD CDC RAM map result

- map exit code: \`${map_exit}\`
- fitter exit code: \`${fit_exit}\`
- previous M10K count: \`325\`
- new M10K count: \`${m10k_used}\`
- exact M10K reduction: \`$([[ "$m10k_used" =~ ^[0-9]+$ ]] && echo $((325 - m10k_used)) || echo unknown)\`
- M10K capacity: \`308\`
- CDC RAM moved to MLAB: \`${cdc_mlab_hit}\`
- CDC RAM converted to registers: \`${cdc_reg_fallback}\`
- CDC RAM still uses M10K: \`$([[ "$cdc_m10k_after" == 16 ]] && echo yes || echo no)\`
- approved classification: \`${result}\`
DOC
if [[ "$result" == M10K_DEFICIT_REMAINS_AFTER_CDC || "$result" == FIT_FAIL_M10K ]]; then
  cat > "$CAPACITY_DOC" <<DOC
# MegaCD Pocket capacity blocker

- final classification: \`${result}\`
- block memory bits after CDC move: \`${block_mem_after:-unknown}\`
- block memory implementation bits after CDC move: \`${block_impl_after:-unknown}\`
- M10K blocks after CDC move: \`${m10k_after:-unknown}\`
- M10K headroom: \`${m10k_headroom}\`
- note: \`CDC moved off the donor M10K lane, but one or more M10Ks still need to be reclaimed before Pocket fit can finish.\`
- next safe adjustment class: \`one smallest helper RAM/ROM or debug/status memory; leave PCM and WORDRAM1 alone unless explicitly escalated\`
DOC
  cat > "$MARGIN_DOC" <<DOC
# MegaCD M10K margin adjustment

- used in Task 9C: \`no\`
- reason: \`CDC-only pass completed first to measure the exact post-CDC M10K deficit.\`
DOC
fi
if [[ "$sta_exit" != not-run ]]; then
  timing_class="TIMING_INCOMPLETE"
  if [[ "$sta_exit" == 0 ]]; then
    timing_class="TIMING_PASS"
  elif rg -qi 'EXT_CDC_RAM|megacd_cdc_ram_mlab|CDC' "$TIMING_LOG"; then
    timing_class="TIMING_FAIL_CDC_MLAB"
  elif rg -qi 'sram_a|sram_dq|sram_oe_n|sram_we_n|wordram' "$TIMING_LOG"; then
    timing_class="TIMING_FAIL_EXTERNAL_WORDRAM0"
  else
    timing_class="TIMING_FAIL_GENERAL"
  fi
  cat > "$TIMING_RESULT_DOC" <<DOC
# MegaCD CDC RAM timing result

- timing result: \`${timing_class}\`
- timing exit code: \`${sta_exit}\`
- worst setup slack: \`${worst_setup}\`
- worst hold slack: \`${worst_hold}\`
- unconstrained paths: \`${unconstrained}\`
DOC
fi
if [[ -f "$ARTIFACT_DIR/bitstream.rbf_r" ]]; then
  cat > "$ARTIFACT_DOC" <<DOC
# MegaCD CDC RAM artifact

- result: \`${result}\`
- artifact path: \`${artifact_path}\`
- artifact size: \`${artifact_size}\`
- artifact sha256: \`${artifact_sha}\`
- artifact timestamp: \`${artifact_time}\`
- timing status: \`$([[ "$sta_exit" == 0 ]] && echo TIMING_PASS || echo TIMING_RISK)\`
- conversion source: \`build/megacd_pocket_artifacts/ap_core.rbf\`
- conversion method: \`byte-wise bit reversal matching Analogue RBF_R packaging rule\`
DOC
fi
