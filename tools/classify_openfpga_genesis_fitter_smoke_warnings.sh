#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STATUS_FILE="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_SMOKE_STATUS.md"
MAP_LOG="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt"
FIT_LOG="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt"
REPORT_FILE="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_SMOKE_REPORTS.md"
SUMMARY_FILE="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_WARNING_SUMMARY.md"
REVIEW_FILE="$ROOT_DIR/docs/OPENFPGA_GENESIS_POST_FITTER_REVIEW_STATUS.md"
NOW="$(date -u '+%Y-%m-%d %H:%M:%S UTC')"
TMP_CLASS="$(mktemp)"
trap 'rm -f "$TMP_CLASS"' EXIT

for file in "$STATUS_FILE" "$MAP_LOG" "$FIT_LOG" "$REPORT_FILE"; do
  if [[ ! -f "$file" ]]; then
    echo "Missing required file: $file"
    exit 1
  fi
done

extract_error_count() {
  local count
  count="$(rg -c '^[[:space:]]*Error[[:space:]]|^[[:space:]]*Error\\b' "$1" 2>/dev/null || true)"
  printf '%s\n' "${count:-0}"
}

extract_warning_count() {
  local count
  count="$(rg -c '^[[:space:]]*Warning|^[[:space:]]*[Ww]arning' "$1" 2>/dev/null || true)"
  printf '%s\n' "${count:-0}"
}

warn_key() {
  local line="$1"
  local key=""

  case "$line" in
    *"RST port on the PLL is not properly connected"*)
      key="PLL_RESET_NOT_CONNECTED" ;;
    *"incomplete I/O assignments"*|*"(15714)")
      key="INCOMPLETE_IO_ASSIGNMENTS" ;;
    *"non-dedicated clock"*|*"(16406)"*|*"(16407)")
      key="NON_DEDICATED_CLOCK_ROUTING" ;;
    *"wildcard destinations"*|*"(176251)")
      key="IGNORED_FAST_IO_WILDCARD" ;;
    *"no output enable"*|*"permanently disabled output enable"*|*"(169064)"*|*"(169065)")
      key="NO_OUTPUT_ENABLE" ;;
    *"LogicLock"*|*"(292013)")
      key="LOGICLOCK_LICENSE" ;;
    *"memory block"*|*"Memory block"*|*"RAM"*"timing"*)
      key="MEMORY_SETUP_HOLD" ;;
    *"unsupported"*"device"*|*"Device family"*)
      key="DEVICE_FAMILY_WARNING" ;;
    *"pin"*"assignment"*|*"I/O"*"pin"*|*"No output dependent"*)
      key="PIN_ASSIGNMENT_WARNING" ;;
    *"Placement"*"Effort"*)
      key="PLACEMENT_ROUTING_WARNING" ;;
    *"PLL"*|*"altsyncram"*|*"IP"*)
      key="IP_PLL_MEMORY_WARNING" ;;
    *"timing"*"warning"*|*"timing-driven"*)
      key="TIMING_RELEVANT_WARNING" ;;
    *"Warning ("*)
      code="${line#*Warning (}"; code="${code%%)*}"
      key="CODE_${code}" ;;
    *)
      key="NO_CODE_WARNING" ;;
  esac

  printf '%s\n' "$key"
}

risk_of() {
  case "$1" in
    PLL_RESET_NOT_CONNECTED|INCOMPLETE_IO_ASSIGNMENTS|NON_DEDICATED_CLOCK_ROUTING|IGNORED_FAST_IO_WILDCARD|NO_OUTPUT_ENABLE|MEMORY_SETUP_HOLD|PIN_ASSIGNMENT_WARNING|PLACEMENT_ROUTING_WARNING|TIMING_RELEVANT_WARNING)
      echo "needs review before timing gate" ;;
    CODE_292013|LOGICLOCK_LICENSE|DEVICE_FAMILY_WARNING)
      echo "accepted smoke-only risk" ;;
    CODE_10036|CODE_10030|CODE_10762|CODE_10230|CODE_10858|CODE_10259|CODE_113028|CODE_113027|CODE_12241|IP_PLL_MEMORY_WARNING)
      echo "safe / known inherited" ;;
    *)
      echo "unknown" ;;
  esac
}

scan_file() {
  local file="$1"
  while IFS= read -r line; do
    if [[ "$line" != *Warning* && "$line" != *warning* ]]; then
      continue
    fi

    key="$(warn_key "$line")"
    echo "${key}|${line}" >> "$TMP_CLASS"
  done < "$file"
}

scan_file "$MAP_LOG"
scan_file "$FIT_LOG"

map_errors="$(extract_error_count "$MAP_LOG")"
map_warnings="$(extract_warning_count "$MAP_LOG")"
fit_errors="$(extract_error_count "$FIT_LOG")"
fit_warnings="$(extract_warning_count "$FIT_LOG")"

critical=0
review=0
known=0
unknown=0

{
  echo "# openFPGA Genesis post-fitter warning summary"
  echo "Generated: $NOW"
  echo "Source status: $STATUS_FILE"
  echo
  echo "Map errors: $map_errors"
  echo "Map warnings: $map_warnings"
  echo "Fitter errors: $fit_errors"
  echo "Fitter warnings: $fit_warnings"
  echo
  echo "## Warning class summary"

  if [[ -s "$TMP_CLASS" ]]; then
    while IFS='|' read -r key sample; do
      :
    done < /dev/null

    for key in $(cut -d'|' -f1 "$TMP_CLASS" | sort -u); do
      count="$(awk -F'|' -v k="$key" '($1==k){c++} END{print c+0}' "$TMP_CLASS")"
      sample="$(awk -F'|' -v k="$key" '($1==k){print $0; exit}' "$TMP_CLASS")"
      sample="${sample#*|}"
      risk="$(risk_of "$key")"
      echo "- $key | count=$count | risk=$risk"
      echo "  sample: $sample"

      case "$risk" in
        "blocks timing/assembler gate")
          critical=$((critical + count)) ;;
        "needs review before timing gate")
          review=$((review + count)) ;;
        "safe / known inherited"|"accepted smoke-only risk")
          known=$((known + count)) ;;
        *)
          unknown=$((unknown + count)) ;;
      esac
    done
  else
    echo "- (no warning lines captured in current logs)"
  fi

  echo
  echo "## Risk totals"
  echo "- blocks timing/assembler gate: $critical"
  echo "- needs review before timing gate: $review"
  echo "- accepted smoke-only risk / safe inherited: $known"
  echo "- unknown: $unknown"

  decision="REVIEW_FITTER_WARNINGS_FIRST"
  if (( map_errors == 0 && fit_errors == 0 )); then
    if (( critical == 0 && unknown == 0 )); then
      if (( review == 0 )); then
        decision="READY_FOR_TIMING_REVIEW_GATE"
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

  echo
  echo "## Decision"
  echo "decision=$decision"
  echo
  echo "- map errors: $map_errors"
  echo "- fitter errors: $fit_errors"
  echo "- no Quartus run by this script; log-parsing only"
} > "$SUMMARY_FILE"

{
  echo "# openFPGA Genesis post-fitter review status"
  echo "Generated: $NOW"
  echo "Decision candidate: $decision"
  echo
  echo "- map_error_count=$map_errors"
  echo "- map_warning_count=$map_warnings"
  echo "- fitter_error_count=$fit_errors"
  echo "- fitter_warning_count=$fit_warnings"
  echo "- unknown_warning_count=$unknown"
  echo
  echo "- This is a post-fitter document-only review pass."
  echo "- No Quartus tools were run by this script."
} > "$REVIEW_FILE"

echo "Wrote: $SUMMARY_FILE"
echo "Wrote: $REVIEW_FILE"
echo "decision=$decision"
