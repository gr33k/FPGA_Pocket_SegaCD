#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPORT_FILE="$ROOT_DIR/docs/OPENFPGA_PACKAGE_SKELETON_STATUS.md"

PASS_COUNT=0
WARN_COUNT=0
FAIL_COUNT=0

log_ok() {
  echo "PASS: $1" | tee -a "$REPORT_FILE"
  PASS_COUNT=$((PASS_COUNT + 1))
}

log_warn() {
  echo "WARN: $1" | tee -a "$REPORT_FILE"
  WARN_COUNT=$((WARN_COUNT + 1))
}

log_fail() {
  echo "FAIL: $1" | tee -a "$REPORT_FILE"
  FAIL_COUNT=$((FAIL_COUNT + 1))
}

check_dir() {
  local path="$1"
  if [ -d "$path" ]; then
    log_ok "directory exists: $path"
  else
    log_fail "missing directory: $path"
  fi
}

check_file() {
  local path="$1"
  if [ -f "$path" ]; then
    log_ok "file exists: $path"
  else
    log_fail "missing file: $path"
  fi
}

check_no_files() {
  local pattern="$1"
  local count
  count="$(find "$ROOT_DIR/openfpga/FPGA_Pocket_SegaCD" -type f \( -name "$pattern" \) 2>/dev/null | wc -l | tr -d ' ')"
  if [ "$count" -eq 0 ]; then
    log_ok "no prohibited file pattern in package skeleton: $pattern"
  else
    log_fail "found $count prohibited files matching: $pattern"
  fi
}

: > "$REPORT_FILE"
{
  echo "# openFPGA package skeleton check (non-blocking)"
  echo
  echo "Generated: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  echo
  echo "Rule: advisory check only; does not mutate files."
  echo
} >> "$REPORT_FILE"

check_dir "$ROOT_DIR/openfpga"
check_dir "$ROOT_DIR/openfpga/FPGA_Pocket_SegaCD"
check_dir "$ROOT_DIR/openfpga/FPGA_Pocket_SegaCD/apf"
check_dir "$ROOT_DIR/openfpga/FPGA_Pocket_SegaCD/quartus"
check_dir "$ROOT_DIR/openfpga/FPGA_Pocket_SegaCD/build"
check_dir "$ROOT_DIR/openfpga/FPGA_Pocket_SegaCD/docs"

check_file "$ROOT_DIR/openfpga/README.md"
check_file "$ROOT_DIR/openfpga/FPGA_Pocket_SegaCD/README.md"
check_file "$ROOT_DIR/openfpga/FPGA_Pocket_SegaCD/apf/README.md"
check_file "$ROOT_DIR/openfpga/FPGA_Pocket_SegaCD/quartus/README.md"
check_file "$ROOT_DIR/openfpga/FPGA_Pocket_SegaCD/build/README.md"
check_file "$ROOT_DIR/openfpga/FPGA_Pocket_SegaCD/docs/README.md"

check_no_files "*.sof"
check_no_files "*.pof"
check_no_files "*.jic"
check_no_files "*.rbf"
check_no_files "*.rbf_r"
check_no_files "*.wlf"

if [ ! -f "$ROOT_DIR/third_party/Genesis_MiSTer/.git" ] && [ ! -d "$ROOT_DIR/third_party/Genesis_MiSTer" ]; then
  log_warn "Genesis_MiSTer submodule/runtime not yet present in third_party."
fi

cat >> "$REPORT_FILE" <<EOF
## Summary

PASS: $PASS_COUNT
WARN: $WARN_COUNT
FAIL: $FAIL_COUNT

EOF

if [ "$FAIL_COUNT" -eq 0 ]; then
  log_ok "CHECK RESULT: PASS"
else
  log_fail "CHECK RESULT: FAIL"
fi

echo "Done. Report: $REPORT_FILE"
exit 0

