#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT_PATH="$ROOT_DIR/tools/stage_quartus_installer_from_url.sh"
REPORT="$ROOT_DIR/docs/QUARTUS_INSTALLER_STAGING_HELPER_CHECK.md"
STATUS_DOC="$ROOT_DIR/docs/QUARTUS_INSTALLER_STAGING_STATUS.md"

PASS=0
WARN=0
FAIL=0

log() {
  local level="$1"
  local msg="$2"
  printf '%s: %s\n' "$level" "$msg"
  case "$level" in
    PASS) PASS=$((PASS + 1)) ;;
    WARN) WARN=$((WARN + 1)) ;;
    FAIL) FAIL=$((FAIL + 1)) ;;
  esac
}

: > "$REPORT"
{
  echo "# Quartus installer staging helper check (advisory)"
  echo
  echo "Generated: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  echo
} > "$REPORT"

if [[ -x "$SCRIPT_PATH" ]]; then
  log PASS "tools/stage_quartus_installer_from_url.sh exists and executable"
else
  log FAIL "tools/stage_quartus_installer_from_url.sh missing or not executable"
fi

if grep -q "QUARTUS_INSTALLER_URL" "$SCRIPT_PATH"; then
  log PASS "staging script references QUARTUS_INSTALLER_URL"
else
  log FAIL "staging script does not reference QUARTUS_INSTALLER_URL"
fi

if grep -q "/root/fpga/installers" "$SCRIPT_PATH"; then
  log PASS "staging script targets /root/fpga/installers"
else
  log FAIL "staging script does not target /root/fpga/installers"
fi

if grep -q "QUARTUS_INSTALLER_STAGING_STATUS.md" "$SCRIPT_PATH"; then
  log PASS "staging script writes QUARTUS_INSTALLER_STAGING_STATUS.md"
else
  log FAIL "staging script does not write QUARTUS_INSTALLER_STAGING_STATUS.md"
fi

if grep -qEi "(password|passwd|api[_-]?key|token|cookie|authorization|x-access-token|basic[_-]?auth)" "$SCRIPT_PATH"; then
  log WARN "Potential credential-like token appears in script; verify no hardcoded credentials"
else
  log PASS "No obvious hardcoded credentials found in staging script"
fi

if grep -qE "git\s+add|git\s+commit|git\s+push" "$SCRIPT_PATH"; then
  log WARN "staging script references git write commands"
else
  log PASS "staging script does not attempt git add/commit/push"
fi

if grep -Eq "quartus_fit|quartus_asm|quartus_sta|quartus_cpf" "$SCRIPT_PATH"; then
  log FAIL "staging script references forbidden Quartus runtime commands"
else
  log PASS "staging script does not reference forbidden Quartus runtime commands"
fi

if { [[ -f "$STATUS_DOC" ]] || touch "$STATUS_DOC" >/dev/null 2>&1; }; then
  log PASS "status document path is available"
else
  log WARN "unable to write docs/QUARTUS_INSTALLER_STAGING_STATUS.md"
fi

{
  echo
  echo "Summary"
  echo "PASS=$PASS"
  echo "WARN=$WARN"
  echo "FAIL=$FAIL"
  if [[ "$FAIL" -eq 0 ]]; then
    echo "Result: PASS (advisory)"
  else
    echo "Result: WARN/FAIL (advisory)"
  fi
} >> "$REPORT"

echo "Wrote: $REPORT"

exit 0
