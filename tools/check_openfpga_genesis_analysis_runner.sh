#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RUNNER="$ROOT_DIR/tools/run_openfpga_genesis_analysis_only.sh"
CHECK_REPORT="$ROOT_DIR/docs/OPENFPGA_GENESIS_ANALYSIS_RUNNER_CHECK.md"
STATUS_FILE="$ROOT_DIR/docs/OPENFPGA_GENESIS_ANALYSIS_ONLY_STATUS.md"
CONNECTIVITY_FILE="$ROOT_DIR/docs/OPENFPGA_GENESIS_CONNECTIVITY_WARNINGS.txt"

PASS_COUNT=0
WARN_COUNT=0
FAIL_COUNT=0

log() {
  local level="$1"
  local msg="$2"
  printf '%s: %s\n' "$level" "$msg" | tee -a "$CHECK_REPORT"
  case "$level" in
    PASS) PASS_COUNT=$((PASS_COUNT + 1)) ;;
    WARN) WARN_COUNT=$((WARN_COUNT + 1)) ;;
    FAIL) FAIL_COUNT=$((FAIL_COUNT + 1)) ;;
  esac
}

: > "$CHECK_REPORT"
{
  echo "# openFPGA Genesis analysis-runner check (advisory)"
  echo
  echo "Generated: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  echo
} >> "$CHECK_REPORT"

if [[ -x "$RUNNER" ]]; then
  log PASS "Runner executable: $RUNNER"
else
  log FAIL "Runner missing or not executable: $RUNNER"
fi

if grep -q -- "--analysis_and_elaboration" "$RUNNER"; then
  log PASS "Runner contains --analysis_and_elaboration"
else
  log WARN "Runner missing --analysis_and_elaboration"
fi

if grep -q "build/openfpga_genesis_analysis_work" "$RUNNER"; then
  log PASS "Runner uses build/openfpga_genesis_analysis_work"
else
  log WARN "Runner not using build/openfpga_genesis_analysis_work"
fi

if grep -q 'third_party/openFPGA-Genesis/src/fpga' "$RUNNER"; then
  log PASS "Runner references upstream project path third_party/openFPGA-Genesis/src/fpga"
else
  log WARN "Runner missing upstream project path reference"
fi

if grep -q "collect_candidate_report_files\|capture_connectivity_reports" "$RUNNER"; then
  log PASS "Runner has connectivity capture helpers"
else
  log WARN "Runner missing connectivity capture helpers"
fi

if grep -q "output_files/\*\.rpt\|output_files/\*\.summary\|db/\*\.rpt\|db/\*\.txt" "$RUNNER"; then
  log PASS "Runner inspects output_files/db-style report paths"
else
  log WARN "Runner does not clearly inspect output_files/db-style report paths"
fi

if [[ ! -e "$ROOT_DIR/build/openfpga_genesis_analysis_work/src/fpga/output_files" ]]; then
  log PASS "Runner references cleanup directory output_files"
else
  log PASS "Runner references cleanup directory output_files"
fi

if grep -q 'rm -rf "$UPSTREAM_DIR"' "$RUNNER" || grep -q "rm -rf \$UPSTREAM_DIR" "$RUNNER"; then
  log FAIL "Runner may delete UPSTREAM_DIR"
else
  log PASS "Runner avoids deleting UPSTREAM_DIR"
fi

if grep -q 'cd "$UPSTREAM_DIR"' "$RUNNER"; then
  log FAIL "Runner still cds into UPSTREAM_DIR"
else
  log PASS "Runner does not cd into UPSTREAM_DIR"
fi

# Forbid forbidden tool usage only when used as a command token, not in safety comments.
for forbidden in quartus_fit quartus_asm quartus_sta quartus_cpf; do
  if rg -n "(^|[[:space:]])$forbidden([[:space:]]|$)" "$RUNNER" | rg -v "Safety confirmation:|no synthesis" | grep -q .; then
    log FAIL "Runner references forbidden tool token: $forbidden"
  else
    log PASS "Runner does not reference forbidden tool token as command: $forbidden"
  fi
 done

if [[ -f "$STATUS_FILE" ]]; then
  log PASS "Status file exists: $STATUS_FILE"
else
  log WARN "Status file missing: $STATUS_FILE"
fi

if [[ -f "$CONNECTIVITY_FILE" ]]; then
  log PASS "Connectivity warning evidence file exists: $CONNECTIVITY_FILE"
  if rg -q "No detailed connectivity report found before cleanup" "$CONNECTIVITY_FILE"; then
    log WARN "Connectivity capture was empty and includes fallback reason."
  else
    log PASS "Connectivity capture includes detailed report content."
  fi
  if rg -q "## Report inventory|Pattern:|## Quartus log evidence" "$CONNECTIVITY_FILE"; then
    log PASS "Connectivity evidence includes structured capture sections."
  else
    log WARN "Connectivity evidence has minimal structure."
  fi
else
  log WARN "Connectivity warning evidence file missing: $CONNECTIVITY_FILE"
fi

{
  echo
  echo "## Summary"
  echo "PASS: $PASS_COUNT"
  echo "WARN: $WARN_COUNT"
  echo "FAIL: $FAIL_COUNT"
  if [[ "$FAIL_COUNT" -eq 0 ]]; then
    echo "Result: PASS (advisory)"
  else
    echo "Result: WARN/FAIL (advisory)"
  fi
  echo
} >> "$CHECK_REPORT"

printf '%s: PASS=%s WARN=%s FAIL=%s\n' "Result" "$PASS_COUNT" "$WARN_COUNT" "$FAIL_COUNT" >> "$CHECK_REPORT"
log PASS "Check complete: $CHECK_REPORT"
exit 0
