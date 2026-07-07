#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPORT="${ROOT_DIR}/docs/OPENFPGA_GENESIS_SOURCE_PLAN_CHECK.md"
UPSTREAM_ROOT="${ROOT_DIR}/third_party/openFPGA-Genesis"
CANDIDATE="${ROOT_DIR}/quartus/files_openfpga_genesis_runtime.candidate.qsf"
TOP_QSF="${ROOT_DIR}/quartus/FPGA_Pocket_SegaCD.qsf"
REQUIRED_UPSTREAM=(
  "${UPSTREAM_ROOT}/README.md"
  "${UPSTREAM_ROOT}/src/fpga/core/core_top.sv"
  "${UPSTREAM_ROOT}/src/fpga/apf/apf_top.v"
  "${UPSTREAM_ROOT}/src/fpga/core/rtl/system.sv"
)
REQUIRED_DOCS=(
  "${ROOT_DIR}/docs/OPENFPGA_GENESIS_UPSTREAM_FILE_INVENTORY.md"
  "${ROOT_DIR}/docs/OPENFPGA_GENESIS_ACTIVE_SOURCE_PLAN.md"
)

pass_count=0
warn_count=0

log_ok() {
  echo "PASS: $1" | tee -a "$REPORT"
  pass_count=$((pass_count + 1))
}

log_warn() {
  echo "WARN: $1" | tee -a "$REPORT"
  warn_count=$((warn_count + 1))
}

: > "$REPORT"
{
  echo "# Task 6X openFPGA source plan check"
  echo
  echo "Generated: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "Advisory check only; exits 0 even if WARNs exist."
  echo
} >> "$REPORT"

if [ -d "$UPSTREAM_ROOT" ]; then
  log_ok "Upstream path exists: $UPSTREAM_ROOT"
else
  log_warn "Upstream path missing: $UPSTREAM_ROOT"
fi

for file in "${REQUIRED_UPSTREAM[@]}"; do
  if [ -f "$file" ]; then
    log_ok "Required upstream file exists: $file"
  else
    log_warn "Missing required upstream file: $file"
  fi
done

for file in "${REQUIRED_DOCS[@]}"; do
  if [ -f "$file" ]; then
    log_ok "Required planning doc exists: $file"
  else
    log_warn "Missing required planning doc: $file"
  fi
done

if [ -f "$CANDIDATE" ]; then
  log_ok "Candidate QSF exists: $CANDIDATE"

  if grep -q "CANDIDATE ONLY" "$CANDIDATE" && grep -q "OPENFPGA-GENESIS SOURCE LANE" "$CANDIDATE"; then
    log_ok "Candidate QSF has required header markers"
  else
    log_warn "Candidate QSF missing required header markers"
  fi

  if grep -q "SEGA CD EXCLUDED" "$CANDIDATE"; then
    log_ok "Candidate QSF excludes Sega CD"
  else
    log_warn "Candidate QSF does not explicitly exclude Sega CD"
  fi

  if grep -q "32X EXCLUDED" "$CANDIDATE"; then
    log_ok "Candidate QSF excludes 32X"
  else
    log_warn "Candidate QSF does not explicitly exclude 32X"
  fi
else
  log_warn "Candidate QSF missing: $CANDIDATE"
fi

if [ -f "$TOP_QSF" ]; then
  if grep -q "files_openfpga_genesis_runtime.candidate.qsf" "$TOP_QSF"; then
    log_warn "Top QSF currently includes files_openfpga_genesis_runtime.candidate.qsf"
  else
    log_ok "Top QSF does not include files_openfpga_genesis_runtime.candidate.qsf"
  fi
else
  log_warn "Top QSF missing: $TOP_QSF"
fi

if grep -q "third_party/Genesis_MiSTer" "$CANDIDATE" "$TOP_QSF" 2>/dev/null; then
  log_warn "OpenFPGA plan references Genesis_MiSTer"
else
  log_ok "OpenFPGA plan has no Genesis_MiSTer active reference"
fi

{
  echo
  echo "## Summary"
  echo "PASS checks: $pass_count"
  echo "WARN checks: $warn_count"
  echo "Result: advisory"
} >> "$REPORT"

echo "Check complete: $REPORT"
exit 0
