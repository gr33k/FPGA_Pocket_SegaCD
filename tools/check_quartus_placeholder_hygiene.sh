#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
REPORT_PATH="$ROOT_DIR/docs/QUARTUS_PLACEHOLDER_HYGIENE_REPORT.md"
TEMP_REPORT="${REPORT_PATH}.tmp"
RUN_TIMESTAMP="$(date -u '+%Y-%m-%d %H:%M:%S UTC')"

PLACEHOLDER_FILES=(
  "quartus/FPGA_Pocket_SegaCD.qpf"
  "quartus/FPGA_Pocket_SegaCD.qsf"
  "quartus/FPGA_Pocket_SegaCD.sdc"
  "quartus/files_apf_scaffold.qsf"
  "quartus/files_genesis_runtime.qsf"
  "quartus/files_constraints.qsf"
)

REQUIRED_MARKERS=(
  "NON-BUILDABLE PLACEHOLDER"
  "DO NOT RUN SYNTHESIS FROM THIS FILE YET"
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
    printf "%s\n" "- [PASS] $message" >> "$TEMP_REPORT"
    PASS_COUNT=$((PASS_COUNT + 1))
  else
    printf "%s\n" "- [FAIL] $message" >> "$TEMP_REPORT"
    FAIL_COUNT=$((FAIL_COUNT + 1))
  fi
}

section() {
  echo
  printf "== %s ==\n" "$1"
  echo
  printf "## %s\n" "$1" >> "$TEMP_REPORT"
}

{
  cat <<REPORT
# Quartus Placeholder Hygiene Report

Validation date/time: $RUN_TIMESTAMP

This report is advisory and does not claim synthesis success.

## Files checked
REPORT
for file in "${PLACEHOLDER_FILES[@]}"; do
    printf "%s\n" "- $file" >> "$TEMP_REPORT"
done
printf "\n" >> "$TEMP_REPORT"
} > "$TEMP_REPORT"

section "1) Placeholder file existence"
for file in "${PLACEHOLDER_FILES[@]}"; do
  if [[ -f "$ROOT_DIR/$file" ]]; then
    log PASS "Exists: $file"
  else
    log FAIL "Missing: $file"
  fi
done

section "2) Required marker presence"
for file in "${PLACEHOLDER_FILES[@]}"; do
  for marker in "${REQUIRED_MARKERS[@]}"; do
    if grep -Fq "$marker" "$ROOT_DIR/$file"; then
      log PASS "Marker '$marker' in $file"
    else
      log FAIL "Marker '$marker' in $file"
    fi
  done
done

section "3) Forbidden source reference check"
for file in "${PLACEHOLDER_FILES[@]}"; do
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

section "4) Generated output files"
BAD_EXT_FOUND=0
BAD_EXTENSIONS=("*.sof" "*.pof" "*.jic" "*.rpd" "*.rbf" "*.rbf_r")
for ext in "${BAD_EXTENSIONS[@]}"; do
  if find "$ROOT_DIR" \
    \( -path "$ROOT_DIR/third_party/Genesis_MiSTer" -o -path "$ROOT_DIR/third_party/Genesis_MiSTer/releases" \) -prune \
    -o -type f -name "$ext" -print -quit \
    | grep -q .; then
    log FAIL "Found generated-like file matching $ext"
    BAD_EXT_FOUND=1
  fi
done
if [[ "$BAD_EXT_FOUND" -eq 0 ]]; then
  log PASS "No generated output files matched known binary markers"
fi

section "5) Generated output directories"
OUTPUT_DIRS=("build" "output_files" "db" "incremental_db" "simulation" "greybox_tmp")
for dir in "${OUTPUT_DIRS[@]}"; do
  if [[ -d "$ROOT_DIR/$dir" ]]; then
    log FAIL "Directory exists: $dir"
  else
    log PASS "Directory absent: $dir"
  fi
done

section "6) Imported runtime cleanliness"
if [[ -d "$ROOT_DIR/third_party/Genesis_MiSTer" ]]; then
  if submodule_status="$(git -C "$ROOT_DIR" submodule status third_party/Genesis_MiSTer 2>/dev/null || true)"; then
    if [[ -n "$submodule_status" ]]; then
      log PASS "Submodule status command returned output"
      printf "%s\n" "- submodule status: $submodule_status" >> "$TEMP_REPORT"
    else
      log FAIL "Submodule status returned empty output"
    fi
  else
    log FAIL "Submodule status command failed"
  fi

  if submodule_tree_status="$(git -C "$ROOT_DIR/third_party/Genesis_MiSTer" status --short 2>/dev/null || true)"; then
    if [[ -z "$submodule_tree_status" ]]; then
      log PASS "third_party/Genesis_MiSTer status is clean"
    else
      log FAIL "third_party/Genesis_MiSTer has local edits"
      printf "%s\n" "- submodule local status: $submodule_tree_status" >> "$TEMP_REPORT"
    fi
  else
    log FAIL "Failed to read third_party/Genesis_MiSTer git status"
  fi
else
  log FAIL "third_party/Genesis_MiSTer path not found"
fi

section "7) .gitignore generated-output rules"
if [[ -f "$ROOT_DIR/.gitignore" ]]; then
  for token in "build/" "output_files/" "db/" "incremental_db/" "*.sof" "*.rbf" "*.rbf_r"; do
    if grep -Fq -- "$token" "$ROOT_DIR/.gitignore"; then
      log PASS ".gitignore contains: $token"
    else
      log FAIL ".gitignore missing: $token"
    fi
  done
else
  log FAIL ".gitignore file is missing"
fi

{
  echo
  echo "## Summary"
  echo "- PASS count: $PASS_COUNT"
  echo "- FAIL count: $FAIL_COUNT"
  if [[ "$FAIL_COUNT" -eq 0 ]]; then
    echo "- Overall status: PASS (advisory only)"
  else
    echo "- Overall status: FAIL (advisory only - must be reviewed manually)"
  fi
  echo
  echo "## Notes"
  echo "- No synthesis was run."
  echo "- No runtime compile success is claimed."
  echo "- No games were booted by this task."
} >> "$TEMP_REPORT"

mv "$TEMP_REPORT" "$REPORT_PATH"

echo "Report written to: $REPORT_PATH"
echo "Advisory validation complete."
exit 0
