#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UPSTREAM_FPGA_DIR="$ROOT_DIR/third_party/openFPGA-Genesis/src/fpga"
WORK_ROOT="$ROOT_DIR/build/genesis_first_boot_work"
WORK_FPGA_DIR="$WORK_ROOT/src/fpga"
ARTIFACT_DIR="$ROOT_DIR/build/genesis_first_boot_artifacts"
STATUS_DOC="$ROOT_DIR/docs/FIRST_GENESIS_BOOT_CANDIDATE_STATUS.md"
MAP_LOG="$ROOT_DIR/docs/FIRST_GENESIS_MAP_LOG.txt"
FIT_LOG="$ROOT_DIR/docs/FIRST_GENESIS_FIT_LOG.txt"
TIMING_LOG="$ROOT_DIR/docs/FIRST_GENESIS_TIMING_SMOKE_LOG.txt"
ASM_LOG="$ROOT_DIR/docs/FIRST_GENESIS_ASSEMBLER_LOG.txt"
ARTIFACT_DOC="$ROOT_DIR/docs/FIRST_GENESIS_BUILD_ARTIFACTS.md"
CLEANUP_DOC="$ROOT_DIR/docs/FIRST_GENESIS_BUILD_CLEANUP.md"
TIMESTAMP="$(date -u '+%Y-%m-%d %H:%M:%S UTC')"
IMAGE="${QUARTUS_PREBUILT_IMAGE:-theypsilon/quartus-lite-c5:19.1-heavy}"
map_exit="not-run"
fit_exit="not-run"
sta_exit="not-run"
asm_exit="not-run"
result=""
timing_result="not-run"
worst_setup="unknown"
worst_hold="unknown"
unconstrained="unknown"
artifact_count=0
artifact_list=()
used_backend=""

write_status() { printf '%s\n' "$1" >> "$STATUS_DOC"; }
write_artifacts() { printf '%s\n' "$1" >> "$ARTIFACT_DOC"; }
write_cleanup() { printf '%s\n' "$1" >> "$CLEANUP_DOC"; }

collect_artifacts() {
  rm -rf "$ARTIFACT_DIR"
  mkdir -p "$ARTIFACT_DIR"
  shopt -s nullglob
  local files=("$WORK_FPGA_DIR"/output_files/*.{sof,pof,jic,rpd,rbf,rbf_r} "$WORK_FPGA_DIR"/*.{sof,pof,jic,rpd,rbf,rbf_r})
  shopt -u nullglob
  for f in "${files[@]}"; do
    [[ -f "$f" ]] || continue
    cp -f "$f" "$ARTIFACT_DIR/"
    artifact_list+=("$ARTIFACT_DIR/$(basename "$f")")
  done
  artifact_count="${#artifact_list[@]}"
}

run_in_docker() {
  local tool_name="$1"; shift
  docker run --rm -t --init \
    -v "$ROOT_DIR:/work" \
    -w /work/build/genesis_first_boot_work/src/fpga \
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

: > "$STATUS_DOC"
: > "$ARTIFACT_DOC"
: > "$CLEANUP_DOC"
: > "$MAP_LOG"
: > "$FIT_LOG"
: > "$TIMING_LOG"
: > "$ASM_LOG"

{
  echo "# First Genesis boot candidate status"
  echo "Generated: $TIMESTAMP"
  echo
} > "$STATUS_DOC"

if [[ ! -d "$UPSTREAM_FPGA_DIR" ]]; then
  write_status "Result: MAP_FAILED"
  write_status "BLOCKER: missing upstream FPGA dir: $UPSTREAM_FPGA_DIR"
  exit 0
fi

rm -rf "$WORK_ROOT"
mkdir -p "$WORK_FPGA_DIR"
cp -R "$UPSTREAM_FPGA_DIR"/. "$WORK_FPGA_DIR"/
write_status "Source copied from: third_party/openFPGA-Genesis/src/fpga"
write_status "Work dir: build/genesis_first_boot_work/src/fpga"
write_status "Quartus backend: auto-detect"

{
  echo "# First Genesis boot build cleanup"
  echo "Generated: $TIMESTAMP"
  echo
  echo "Work root reset before run: build/genesis_first_boot_work"
} > "$CLEANUP_DOC"

set +e
( cd "$WORK_FPGA_DIR" && run_tool quartus_map --read_settings_files=on --write_settings_files=off ap_core -c ap_core ) > "$MAP_LOG" 2>&1
map_exit=$?
set -e
write_status "Map exit code: $map_exit"
write_status "Map log: docs/FIRST_GENESIS_MAP_LOG.txt"
write_status "Backend used: ${used_backend:-unresolved}"
if [[ "$map_exit" != "0" ]]; then
  result="MAP_FAILED"
  write_status "Result: $result"
  write_status "First map error: $(grep -n '^Error' "$MAP_LOG" | head -n 1 || echo 'none found')"
  exit 0
fi

set +e
( cd "$WORK_FPGA_DIR" && run_tool quartus_fit --read_settings_files=on --write_settings_files=off ap_core -c ap_core ) > "$FIT_LOG" 2>&1
fit_exit=$?
set -e
write_status "Fitter exit code: $fit_exit"
write_status "Fitter log: docs/FIRST_GENESIS_FIT_LOG.txt"
if [[ "$fit_exit" != "0" ]]; then
  result="FITTER_FAILED"
  write_status "Result: $result"
  write_status "First fitter error: $(grep -n '^Error' "$FIT_LOG" | head -n 1 || echo 'none found')"
  exit 0
fi

set +e
( cd "$WORK_FPGA_DIR" && run_tool quartus_sta ap_core -c ap_core ) > "$TIMING_LOG" 2>&1
sta_exit=$?
set -e
write_status "Timing ran: yes"
write_status "Timing exit code: $sta_exit"
write_status "Timing log: docs/FIRST_GENESIS_TIMING_SMOKE_LOG.txt"
worst_setup="$(grep -E 'Worst-case setup slack|Setup slack is' "$TIMING_LOG" | head -n 1 | sed 's/^ *//' || true)"
worst_hold="$(grep -E 'Worst-case hold slack|Hold slack is' "$TIMING_LOG" | head -n 1 | sed 's/^ *//' || true)"
if grep -qi 'unconstrained' "$TIMING_LOG"; then unconstrained="yes"; else unconstrained="no-or-not-reported"; fi
[[ -n "$worst_setup" ]] || worst_setup="unknown"
[[ -n "$worst_hold" ]] || worst_hold="unknown"
if [[ "$sta_exit" == "0" ]]; then
  timing_result="timing-report-complete"
else
  if grep -qiE 'Error|Critical Warning|failed' "$TIMING_LOG"; then
    timing_result="timing-report-risk-or-failure"
  else
    timing_result="timing-report-incomplete"
  fi
fi
write_status "Timing result: $timing_result"
write_status "Worst setup slack: $worst_setup"
write_status "Worst hold slack: $worst_hold"
write_status "Unconstrained paths: $unconstrained"

set +e
( cd "$WORK_FPGA_DIR" && run_tool quartus_asm --read_settings_files=on --write_settings_files=off ap_core -c ap_core ) > "$ASM_LOG" 2>&1
asm_exit=$?
set -e
write_status "Assembler ran: yes"
write_status "Assembler exit code: $asm_exit"
write_status "Assembler log: docs/FIRST_GENESIS_ASSEMBLER_LOG.txt"
if [[ "$asm_exit" != "0" ]]; then
  result="ASSEMBLER_FAILED"
  write_status "Result: $result"
  write_status "First assembler error: $(grep -n '^Error' "$ASM_LOG" | head -n 1 || echo 'none found')"
  exit 0
fi

collect_artifacts
{
  echo "# First Genesis build artifacts"
  echo "Generated: $TIMESTAMP"
  echo
  echo "Artifact count: $artifact_count"
  echo
} > "$ARTIFACT_DOC"
if (( artifact_count > 0 )); then
  for f in "${artifact_list[@]}"; do
    write_artifacts "- ${f#$ROOT_DIR/}"
  done
else
  write_artifacts "No bitstream-like artifacts found after assembler."
fi

if (( artifact_count == 0 )); then
  result="TIMING_FAILED_NO_ARTIFACT"
else
  if [[ "$sta_exit" == "0" ]]; then
    result="FIRST_BITSTREAM_READY_FOR_PACKAGING"
  else
    result="ARTIFACT_GENERATED_WITH_TIMING_RISK"
  fi
fi
write_status "Bitstream generated: $([[ $artifact_count -gt 0 ]] && echo yes || echo no)"
write_status "Result: $result"

for d in output_files db incremental_db greybox_tmp simulation; do
  if [[ -e "$WORK_FPGA_DIR/$d" ]]; then
    write_cleanup "Preserved for Task 8A evidence: build/genesis_first_boot_work/src/fpga/$d"
  fi
done
