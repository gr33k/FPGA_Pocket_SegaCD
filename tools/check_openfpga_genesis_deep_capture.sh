#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RUNNER="$ROOT_DIR/tools/run_openfpga_genesis_analysis_only.sh"
REPORT="$ROOT_DIR/docs/OPENFPGA_GENESIS_DEEP_CAPTURE_CHECK.md"

PASS_COUNT=0
WARN_COUNT=0
FAIL_COUNT=0

log() {
  local level="$1"
  local msg="$2"
  printf '%s: %s\n' "$level" "$msg"
  printf '%s: %s\n' "$level" "$msg" >> "$REPORT"
  case "$level" in
    PASS) PASS_COUNT=$((PASS_COUNT + 1)) ;;
    WARN) WARN_COUNT=$((WARN_COUNT + 1)) ;;
    FAIL) FAIL_COUNT=$((FAIL_COUNT + 1)) ;;
  esac
}

: > "$REPORT"
{
  echo "# openFPGA Genesis deep-capture check (advisory)"
  echo
  echo "Generated: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  echo
} >> "$REPORT"

if grep -q "OPENFPGA_GENESIS_QUARTUS_REPORT_INVENTORY.txt" "$RUNNER"; then
  log PASS "Runner references OPENFPGA_GENESIS_QUARTUS_REPORT_INVENTORY.txt"
else
  log WARN "Runner missing OPENFPGA_GENESIS_QUARTUS_REPORT_INVENTORY.txt reference"
fi

if grep -q "OPENFPGA_GENESIS_CONNECTIVITY_WARNINGS.txt" "$RUNNER"; then
  log PASS "Runner references OPENFPGA_GENESIS_CONNECTIVITY_WARNINGS.txt"
else
  log WARN "Runner missing OPENFPGA_GENESIS_CONNECTIVITY_WARNINGS.txt reference"
fi

if grep -q "output_files" "$RUNNER" && grep -q "db" "$RUNNER" && grep -q "incremental_db" "$RUNNER"; then
  log PASS "Runner includes output_files/db/incremental_db references"
else
  log WARN "Runner does not mention output_files/db/incremental_db"
fi

if grep -q "strings" "$RUNNER"; then
  log PASS "Runner references strings for mixed/binary scans"
else
  log WARN "Runner does not reference strings"
fi

if grep -q "\\*\.qmsg" "$RUNNER" && grep -q "\\*\.smsg" "$RUNNER"; then
  log PASS "Runner includes qmsg/smsg evidence patterns"
else
  log WARN "Runner missing qmsg/smsg evidence patterns"
fi

if grep -q -- "--analysis_and_elaboration" "$RUNNER"; then
  log PASS "Runner still uses --analysis_and_elaboration"
else
  log WARN "Runner missing --analysis_and_elaboration"
fi

if rg -n "(^|[[:space:]])quartus_fit([[:space:]]|$)" "$RUNNER" | rg -v "Safety confirmation" >/dev/null 2>&1; then
  log FAIL "Runner references quartus_fit"
else
  log PASS "Runner does not reference quartus_fit"
fi

if rg -n "(^|[[:space:]])quartus_asm([[:space:]]|$)" "$RUNNER" | rg -v "Safety confirmation" >/dev/null 2>&1; then
  log FAIL "Runner references quartus_asm"
else
  log PASS "Runner does not reference quartus_asm"
fi

if rg -n "(^|[[:space:]])quartus_sta([[:space:]]|$)" "$RUNNER" | rg -v "Safety confirmation" >/dev/null 2>&1; then
  log FAIL "Runner references quartus_sta"
else
  log PASS "Runner does not reference quartus_sta"
fi

if rg -n "(^|[[:space:]])quartus_cpf([[:space:]]|$)" "$RUNNER" | rg -v "Safety confirmation" >/dev/null 2>&1; then
  log FAIL "Runner references quartus_cpf"
else
  log PASS "Runner does not reference quartus_cpf"
fi

{
  echo
  echo "Summary"
  echo "PASS: $PASS_COUNT"
  echo "WARN: $WARN_COUNT"
  echo "FAIL: $FAIL_COUNT"
  if [[ "$FAIL_COUNT" -eq 0 ]]; then
    echo "Result: PASS (advisory)"
  else
    echo "Result: WARN/FAIL (advisory)"
  fi
} >> "$REPORT"

echo "PASS=$PASS_COUNT WARN=$WARN_COUNT FAIL=$FAIL_COUNT"
exit 0
