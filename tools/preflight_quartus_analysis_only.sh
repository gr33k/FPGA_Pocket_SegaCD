#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
REPORT_PATH="$ROOT_DIR/docs/QUARTUS_PREFLIGHT_CHECK_REPORT.md"
TEMP_REPORT="${REPORT_PATH}.tmp"
RUN_TIMESTAMP="$(date -u '+%Y-%m-%d %H:%M:%S UTC')"

REQUIRED_FILES=(
  "quartus/FPGA_Pocket_SegaCD.qpf"
  "quartus/FPGA_Pocket_SegaCD.qsf"
  "quartus/files_apf_scaffold.qsf"
  "quartus/files_genesis_runtime.qsf"
  "quartus/files_constraints.qsf"
  "quartus/FPGA_Pocket_SegaCD.sdc"
)

ACTIVE_FILES=(
  "quartus/FPGA_Pocket_SegaCD.qpf"
  "quartus/FPGA_Pocket_SegaCD.qsf"
)

APF_FILES=(
  "quartus/files_apf_scaffold.qsf"
)

RUNTIME_FILES=(
  "quartus/files_genesis_runtime.qsf"
)

CONSTRAINT_FILES=(
  "quartus/files_constraints.qsf"
  "quartus/FPGA_Pocket_SegaCD.sdc"
)

FORBIDDEN_PATTERNS=(
  "third_party/Genesis_MiSTer/Genesis.sv"
  "third_party/Genesis_MiSTer/sys/sys_top.v"
  "hps_io"
  "IOCTL"
  "SegaCD"
  "MegaCD"
  "megacd"
  "32X"
  "32x"
  "apf/src/fpga/sim/apf_genesis_base_stub.sv"
)

PASS_COUNT=0
FAIL_COUNT=0

log() {
  local status="$1"
  local message="$2"
  printf "[%s] %s\n" "$status" "$message"
  if [ "$status" = "PASS" ]; then
    printf '%s\n' "- [PASS] $message" >> "$TEMP_REPORT"
    PASS_COUNT=$((PASS_COUNT + 1))
  else
    printf '%s\n' "- [FAIL] $message" >> "$TEMP_REPORT"
    FAIL_COUNT=$((FAIL_COUNT + 1))
  fi
}

section() {
  local title="$1"
  printf "\n== %s ==\n\n" "$title"
  printf '## %s\n' "$title" >> "$TEMP_REPORT"
}

{
  cat <<REPORT
# Quartus Preflight Check Report

Validation date/time: $RUN_TIMESTAMP

This is an advisory preflight only. It does not run Quartus, does not run synthesis, and does not perform any build.

## Files checked
REPORT
  for file in "${REQUIRED_FILES[@]}"; do
    printf '%s\n' "- $file" >> "$TEMP_REPORT"
  done
  printf '\n' >> "$TEMP_REPORT"
} > "$TEMP_REPORT"

section "1) Required Quartus files existence"
for file in "${REQUIRED_FILES[@]}"; do
  if [[ -f "$ROOT_DIR/$file" ]]; then
    log PASS "Exists: $file"
  else
    log FAIL "Missing: $file"
  fi
done

section "2) Active skeleton marker check"
for file in "${ACTIVE_FILES[@]}"; do
  if grep -Fq "ACTIVE SKELETON" "$ROOT_DIR/$file"; then
    log PASS "ACTIVE SKELETON in $file"
  else
    log FAIL "ACTIVE SKELETON in $file"
  fi

done

section "3) APF scaffold source list check"
for file in "${APF_FILES[@]}"; do
  if grep -Fq "ACTIVE SCAFFOLD SOURCE LIST" "$ROOT_DIR/$file"; then
    log PASS "ACTIVE SCAFFOLD SOURCE LIST in $file"
  else
    log FAIL "ACTIVE SCAFFOLD SOURCE LIST in $file"
  fi

done

section "4) Runtime inactive check (Genesis runtime file)"
for file in "${RUNTIME_FILES[@]}"; do
  if awk 'BEGIN {found=0} {
    s=$0
    sub(/^[[:space:]]*#.*$/, "", s)
    if (s ~ /^\//) {
      sub(/\/\/.*/, "", s)
    }
    if (s ~ /^[[:space:]]*set_global_assignment.*third_party\/Genesis_MiSTer/) {
      found=1
    }
  } END { exit(found ? 0 : 1) }' "$ROOT_DIR/$file"; then
    log FAIL "Active third_party/Genesis_MiSTer assignment found in $file"
  else
    log PASS "No active third_party/Genesis_MiSTer runtime activation in $file"
  fi

done

section "5) Constraint inactive check"
for file in "${CONSTRAINT_FILES[@]}"; do
  if grep -Fq "NON-BUILDABLE PLACEHOLDER" "$ROOT_DIR/$file" && \
     grep -Fq "DO NOT RUN SYNTHESIS FROM THIS FILE YET" "$ROOT_DIR/$file"; then
    log PASS "Constraint placeholder markers present in $file"
  else
    log FAIL "Constraint placeholder markers present in $file"
  fi

done

section "6) Forbidden reference check"
ALL_ACTIVE_FILES=("${ACTIVE_FILES[@]}" "${APF_FILES[@]}" "${RUNTIME_FILES[@]}" "${CONSTRAINT_FILES[@]}")
for file in "${ALL_ACTIVE_FILES[@]}"; do
  local_failed=0
  for pattern in "${FORBIDDEN_PATTERNS[@]}"; do
    if grep -Fq "$pattern" "$ROOT_DIR/$file"; then
      log FAIL "Forbidden pattern '$pattern' found in $file"
      local_failed=1
    fi
  done
  if [[ "$local_failed" -eq 0 ]]; then
    log PASS "No forbidden pattern found in $file"
  fi
done

section "7) Generated output directory check"
OUTPUT_DIRS=("build" "output_files" "db" "incremental_db" "simulation" "greybox_tmp")
for dir in "${OUTPUT_DIRS[@]}"; do
  if [[ -d "$ROOT_DIR/$dir" ]]; then
    log FAIL "Directory exists: $dir"
  else
    log PASS "Directory absent: $dir"
  fi
done

section "8) Generated output file check"
BAD_EXTENSIONS=("*.sof" "*.pof" "*.jic" "*.rpd" "*.rbf" "*.rbf_r")
bad_found=0
for ext in "${BAD_EXTENSIONS[@]}"; do
  if find "$ROOT_DIR" -path "$ROOT_DIR/third_party/Genesis_MiSTer" -prune -o -type f -name "$ext" -print -quit | grep -q .; then
    log FAIL "Found generated-like file matching $ext"
    bad_found=1
  fi
done
if [[ "$bad_found" -eq 0 ]]; then
  log PASS "No generated-like binary files detected"
fi

section "9) Submodule cleanliness"
if [[ -d "$ROOT_DIR/third_party/Genesis_MiSTer" ]]; then
  submodule_status="$(git -C "$ROOT_DIR" submodule status third_party/Genesis_MiSTer 2>/dev/null || true)"
  if [[ -n "$submodule_status" ]]; then
    log PASS "Submodule status command returned output"
    printf '%s\n' "- submodule status: $submodule_status" >> "$TEMP_REPORT"
  else
    log FAIL "Submodule status command returned empty output"
  fi

  submodule_tree_status="$(git -C "$ROOT_DIR/third_party/Genesis_MiSTer" status --short 2>/dev/null || true)"
  if [[ -z "$submodule_tree_status" ]]; then
    log PASS "third_party/Genesis_MiSTer is clean"
  else
    log FAIL "third_party/Genesis_MiSTer has local edits"
    printf '%s\n' "- submodule local status: $submodule_tree_status" >> "$TEMP_REPORT"
  fi
else
  log FAIL "third_party/Genesis_MiSTer path not found"
fi

{
  echo
  echo "## Summary"
  echo "- PASS count: $PASS_COUNT"
  echo "- FAIL count: $FAIL_COUNT"
  if [[ "$FAIL_COUNT" -eq 0 ]]; then
    echo "- Overall status: PASS (advisory only)"
  else
    echo "- Overall status: FAIL (advisory only)"
  fi
  echo
  echo "## Notes"
  echo "- No Quartus command was run."
  echo "- No synthesis was run."
  echo "- No runtime compile success is claimed."
  echo "- No games were booted by this task."
} >> "$TEMP_REPORT"

mv "$TEMP_REPORT" "$REPORT_PATH"

echo "Report written to: $REPORT_PATH"
echo "Advisory preflight complete."
exit 0
