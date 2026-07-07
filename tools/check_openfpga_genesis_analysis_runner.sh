#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RUNNER="$ROOT_DIR/tools/run_openfpga_genesis_analysis_only.sh"
CHECK_REPORT="$ROOT_DIR/docs/OPENFPGA_GENESIS_ANALYSIS_RUNNER_CHECK.md"
STATUS_FILE="$ROOT_DIR/docs/OPENFPGA_GENESIS_ANALYSIS_ONLY_STATUS.md"

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
  log PASS "Runner invokes --analysis_and_elaboration"
else
  log FAIL "Runner does not contain --analysis_and_elaboration"
fi

for forbidden in quartus_fit quartus_asm quartus_sta quartus_cpf; do
  forbidden_hits=""
  while IFS= read -r forbidden_line; do
    [[ -z "$forbidden_line" ]] && continue
    [[ "${forbidden_line}" == \#* ]] && continue
    trimmed="$(printf '%s' "$forbidden_line" | sed 's/^[[:space:]]*//')"
    forbidden_pattern="^${forbidden}([[:space:]]|$)|^&&[[:space:]]+${forbidden}([[:space:]]|$)|^\\|\\|[[:space:]]+${forbidden}([[:space:]]|$)|^;[[:space:]]+${forbidden}([[:space:]]|$)"
    if printf '%s\n' "$trimmed" | grep -Eq "$forbidden_pattern"; then
      forbidden_hits="$trimmed"
      break
    fi
  done < "$RUNNER"
  if [[ -n "$forbidden_hits" ]]; then
    log FAIL "Runner references forbidden tool: $forbidden"
  else
    log PASS "Runner does not reference forbidden tool: $forbidden"
  fi
done

if grep -q "third_party/openFPGA-Genesis/src/fpga" "$RUNNER"; then
  log PASS "Runner references upstream project path third_party/openFPGA-Genesis/src/fpga"
else
  log FAIL "Runner does not reference third_party/openFPGA-Genesis/src/fpga"
fi

if [[ -f "$STATUS_FILE" ]]; then
  log PASS "Status file exists: $STATUS_FILE"
else
  log WARN "Status file missing (expected after running runner): $STATUS_FILE"
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
