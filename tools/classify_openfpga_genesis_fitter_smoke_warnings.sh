#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STATUS_FILE="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_SMOKE_STATUS.md"
MAP_LOG="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt"
FIT_LOG="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt"
SUMMARY_FILE="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_WARNING_SUMMARY.md"
REVIEW_FILE="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_UNKNOWN_WARNING_REVIEW.md"
NOW="$(date -u '+%Y-%m-%d %H:%M:%S UTC')"
TMP_CLASS="$(mktemp)"
trap 'rm -f "$TMP_CLASS"' EXIT

for file in "$STATUS_FILE" "$MAP_LOG" "$FIT_LOG" "$REVIEW_FILE"; do
  if [[ ! -f "$file" ]]; then
    echo "Missing required file: $file"
    exit 1
  fi
  
done

extract_error_count() {
  local file="$1"
  rg -c '^[[:space:]]*[Ee]rror\b|[[:space:]]*Error[[:space:]]' "$file" 2>/dev/null | awk '{s+=$1} END {print s+0}'
}

extract_warning_count() {
  local file="$1"
  rg -c '^[[:space:]]*[Ww]arning\s*\([0-9]+' "$file" 2>/dev/null | awk '{s+=$1} END {print s+0}'
}

as_int() {
  local raw="$1"
  local value
  value="$(printf '%s\n' "$raw" | tr -dc '0-9')"
  if [[ -z "$value" ]]; then
    value=0
  fi
  printf '%s' "$value"
}

warn_key() {
  local line="$1"
  local lower
  local code
  lower="$(printf '%s' "$line" | tr 'A-Z' 'a-z')"

  if [[ "$lower" =~ warning[[:space:]]*\([[:space:]]*([0-9]+)[[:space:]]*\) ]]; then
    code="${BASH_REMATCH[1]}"
    if [[ -z "$code" ]]; then
      echo "NO_CODE_WARNING"
      return
    fi
    echo "CODE_${code}"
    return
  fi

  if [[ "$line" == *"RST port on the PLL is not properly connected"* ]]; then
    echo "PLL_RESET_NOT_CONNECTED"; return
  fi
  if [[ "$line" == *"incomplete I/O assignments"* ]]; then
    echo "INCOMPLETE_IO_ASSIGNMENTS"; return
  fi
  if [[ "$line" == *"non-dedicated"* ]]; then
    echo "NON_DEDICATED_CLOCK_ROUTING"; return
  fi
  if [[ "$line" == *"Ignoring some wildcard destinations"* ]]; then
    echo "IGNORED_FAST_IO_WILDCARD"; return
  fi
  if [[ "$line" == *"no output enable"* ]]; then
    echo "NO_OUTPUT_ENABLE"; return
  fi
  if [[ "$line" == *"No output dependent on input pin"* ]]; then
    echo "PIN_ASSIGNMENT_WARNING"; return
  fi
  if [[ "$line" == *"Placement Effort Multiplier"* ]]; then
    echo "PLACEMENT_ROUTING_WARNING"; return
  fi

  echo "NO_CODE_WARNING"
}

base_risk() {
  case "$1" in
    CODE_10030|CODE_10036|CODE_10230|CODE_12241)
      echo "safe / known inherited" ;;
    CODE_10259|CODE_113027|CODE_113028|CODE_10762|CODE_10858|CODE_292013)
      echo "accepted smoke-only risk" ;;
    CODE_13009|CODE_13010|CODE_13024|CODE_13032|CODE_13033|CODE_13039|CODE_13040|CODE_13410|CODE_15610|CODE_15714|CODE_16406|CODE_16407|CODE_169064|CODE_170136|CODE_176251|CODE_19016|CODE_19017|CODE_21074|CODE_287013|NO_CODE_WARNING|IGNORED_FAST_IO_WILDCARD|INCOMPLETE_IO_ASSIGNMENTS|NON_DEDICATED_CLOCK_ROUTING|NO_OUTPUT_ENABLE|PIN_ASSIGNMENT_WARNING|PLACEMENT_ROUTING_WARNING|PLL_RESET_NOT_CONNECTED)
      echo "needs review before timing gate" ;;
    CODE_14284|CODE_14285|CODE_14320)
      echo "safe / known inherited" ;;
    *)
      echo "unknown" ;;
  esac
}

reviewed_disposition() {
  local target="$1"
  local token
  local line
  local class=""
  local reviewed="false"
  local disposition=""

  while IFS= read -r line; do
    [[ "$line" == REVIEW_ENTRY* ]] || continue
    class=""
    reviewed="false"
    disposition=""
    for token in $line; do
      case "$token" in
        class=*) class="${token#class=}" ;;
        reviewed=*) reviewed="${token#reviewed=}" ;;
        disposition=*) disposition="${token#disposition=}" ;;
      esac
    done
    if [[ "$class" == "$target" && "$reviewed" == "true" ]]; then
      echo "$disposition"
      return 0
    fi
  done < "$REVIEW_FILE"

  return 1
}

scan_file() {
  local file="$1"
  while IFS= read -r line; do
    # Ignore plain info lines.
    [[ "$line" == *"Info:"* ]] && continue
    [[ "$(printf '%s' "$line" | tr 'A-Z' 'a-z')" =~ warning[[:space:]]*\([[:space:]]*[0-9]+[[:space:]]*\) ]] || continue
    local key
    key="$(warn_key "$line")"
    printf '%s|%s\n' "$key" "$line" >> "$TMP_CLASS"
  done < "$file"
}

scan_file "$MAP_LOG"
scan_file "$FIT_LOG"

map_errors="$(as_int "$(extract_error_count "$MAP_LOG" || true)")"
map_warnings="$(as_int "$(extract_warning_count "$MAP_LOG" || true)")"
fit_errors="$(as_int "$(extract_error_count "$FIT_LOG" || true)")"
fit_warnings="$(as_int "$(extract_warning_count "$FIT_LOG" || true)")"

critical=0
review=0
known=0
accepted=0
unknown=0

{
  echo "# openFPGA Genesis post-fitter warning summary"
  echo "Generated: $NOW"
  echo "Source status: docs/OPENFPGA_GENESIS_FITTER_SMOKE_STATUS.md"
  echo
  echo "Map errors: $map_errors"
  echo "Map warnings: $map_warnings"
  echo "Fitter errors: $fit_errors"
  echo "Fitter warnings: $fit_warnings"

  echo
  echo "## Warning class summary"

  if [[ -s "$TMP_CLASS" ]]; then
    while IFS= read -r key; do
      [[ -n "$key" ]] || continue
      count="$(awk -F'|' -v k="$key" '$1==k {c++} END {print c+0}' "$TMP_CLASS")"
      sample="$(awk -F'|' -v k="$key" '$1==k {print $0; exit}' "$TMP_CLASS")"
      sample="${sample#*|}"

      risk="$(base_risk "$key")"
      review_disp="$(reviewed_disposition "$key" || true)"
      if [[ -n "${review_disp}" ]]; then
        case "${review_disp}" in
          needs_review|needs-review)
            risk="needs review before timing gate" ;;
          safe)
            risk="safe / known inherited" ;;
          accepted_smoke_only|accepted-smoke-only)
            risk="accepted smoke-only risk" ;;
          blocked)
            risk="blocks timing/assembler gate" ;;
          unknown)
            risk="unknown" ;;
          *)
            : ;;
        esac
      fi

      echo "- $key | count=$count | risk=$risk"
      echo "  sample: $sample"

      case "$risk" in
        "blocks timing/assembler gate")
          critical=$((critical + count)) ;;
        "needs review before timing gate")
          review=$((review + count)) ;;
        "safe / known inherited")
          known=$((known + count)) ;;
        "accepted smoke-only risk")
          accepted=$((accepted + count)) ;;
        *)
          unknown=$((unknown + count)) ;;
      esac
    done < <(cut -d'|' -f1 "$TMP_CLASS" | sort -u)
  else
    echo "- (no warning lines captured in current logs)"
  fi

  echo
  echo "## Risk totals"
  echo "- blocks timing/assembler gate: $critical"
  echo "- needs review before timing gate: $review"
  echo "- safe / known inherited: $known"
  echo "- accepted smoke-only risk: $accepted"
  echo "- unknown: $unknown"
  echo

  # Add explicit no-code warning-like entries for review visibility.
  no_code_count="$(awk -F'|' -v k="NO_CODE_WARNING" '$1==k {c++} END {print c+0}' "$TMP_CLASS")"
  if (( no_code_count > 0 )); then
    echo "- NO_CODE_WARNING | count=$no_code_count | risk=$(base_risk NO_CODE_WARNING)"
    sample="$(awk -F'|' -v k="NO_CODE_WARNING" '$1==k {print $0; exit}' "$TMP_CLASS")"
    sample="${sample#*|}"
    echo "  sample: ${sample}"
    unknown=$((unknown + no_code_count))
  fi

  decision="REVIEW_FITTER_WARNINGS_FIRST"
  if (( map_errors == 0 && fit_errors == 0 )); then
    if (( critical == 0 && unknown == 0 )); then
      if (( review == 0 )); then
        decision="READY_FOR_TIMING_REVIEW_GATE"
      else
        decision="REVIEW_FITTER_WARNINGS_FIRST"
      fi
    else
      if (( critical > 0 )); then
        decision="BLOCKED_AFTER_FITTER"
      else
        decision="REVIEW_FITTER_WARNINGS_FIRST"
      fi
    fi
  else
    decision="BLOCKED_AFTER_FITTER"
  fi

  echo "## Decision"
  echo "decision=$decision"
  echo
  echo "- map errors: $map_errors"
  echo "- fitter errors: $fit_errors"
  echo "- review source: docs/OPENFPGA_GENESIS_FITTER_UNKNOWN_WARNING_REVIEW.md"
  echo "- no Quartus run by this script; log-parsing only"
} > "$SUMMARY_FILE"

echo "Wrote: $SUMMARY_FILE"
echo "decision=$decision"
