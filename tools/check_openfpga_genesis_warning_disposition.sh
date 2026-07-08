#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DISPOSITION_FILE="$ROOT_DIR/docs/OPENFPGA_GENESIS_WARNING_DISPOSITION.md"
GATE_FILE="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_READINESS_GATE.md"
CHECK_FILE="$ROOT_DIR/docs/OPENFPGA_GENESIS_WARNING_DISPOSITION_CHECK.md"
NOW="$(date -u '+%Y-%m-%d %H:%M:%S UTC')"

status="pass"
reasons=()

require_file() {
  local file="$1"
  if [[ ! -f "$file" ]]; then
    status="fail"
    reasons+=("missing:$file")
    return 1
  fi
}

require_file "$DISPOSITION_FILE"
require_file "$GATE_FILE"

if [[ -f "$DISPOSITION_FILE" ]]; then
  if ! grep -qF "This does not prove Pocket boot or runtime correctness." "$DISPOSITION_FILE"; then
    status="fail"
    reasons+=("disposition-missing:boot-correctness-safety-statement")
  fi
  if ! grep -qF "controlled fitter-only smoke gate" "$DISPOSITION_FILE"; then
    status="fail"
    reasons+=("disposition-missing:smoke-gate-scope")
  fi
fi

if [[ -f "$GATE_FILE" ]]; then
  if ! grep -qF "Current gate decision" "$GATE_FILE"; then
    status="fail"
    reasons+=("gate-missing:decision")
  else
    decision="$(grep -m1 -Eo 'Current gate decision: \*\*[^*]+\*\*' "$GATE_FILE" | sed -E 's/Current gate decision: \*\*([^*]+)\*\*/\1/' || true)"
    case "$decision" in
      READY_FOR_FITTER_GATE|REVIEW_WARNINGS_FIRST|BLOCKED_BEFORE_FITTER)
        ;;
      *)
        status="fail"
        reasons+=("gate-invalid-decision:$decision")
        ;;
    esac
  fi

  for token in "fitter: not run in this task" "assembler: not run in this task" "timing: not run in this task" "bitstream: not generated in this task"; do
    if ! grep -qF "$token" "$GATE_FILE"; then
      status="fail"
      reasons+=("gate-missing-constraint:$token")
    fi
  done

  if ! grep -qF "This does not prove Pocket boot or runtime correctness." "$GATE_FILE"; then
    status="fail"
    reasons+=("gate-missing-boot-correctness-statement")
  fi
  if ! grep -qF "This only allows the next task to run a controlled fitter-only smoke gate." "$GATE_FILE"; then
    status="fail"
    reasons+=("gate-missing-controlled-smoke-statement")
  fi
fi

{
  echo "# openFPGA Genesis warning disposition check"
  echo "Generated: $NOW"
  echo "Status: $status"
  echo
  if [[ -f "$DISPOSITION_FILE" ]]; then
    echo "- Disposition file exists: yes"
  else
    echo "- Disposition file exists: no"
  fi
  if [[ -f "$GATE_FILE" ]]; then
    echo "- Gate file exists: yes"
  else
    echo "- Gate file exists: no"
  fi

  if [[ ${#reasons[@]} -eq 0 ]]; then
    echo "- Result: all checks passed"
  else
    echo "- Result: checks failed"
    echo "- Failing checks:"
    printf '%s
' "${reasons[@]}"
  fi
} > "$CHECK_FILE"

if [[ "$status" == "pass" ]]; then
  echo "PASS"
else
  echo "FAIL"
  echo "Reasons:"
  printf '%s
' "${reasons[@]}"
fi
