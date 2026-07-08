#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REVIEW_DOC="$ROOT_DIR/docs/OPENFPGA_GENESIS_PRIORITY1_CLOCKING_REVIEW.md"
WARNING_SUMMARY="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_WARNING_SUMMARY.md"
TIMING_DOC="$ROOT_DIR/docs/OPENFPGA_GENESIS_TIMING_REVIEW_BLOCKER_ORDER.md"
OUT="$ROOT_DIR/docs/OPENFPGA_GENESIS_PRIORITY1_CLOCKING_ACTIONS.md"
NOW="$(date -u '+%Y-%m-%d %H:%M:%S UTC')"

required=("$REVIEW_DOC" "$WARNING_SUMMARY" "$TIMING_DOC")
for file in "${required[@]}"; do
  if [[ ! -f "$file" ]]; then
    echo "Missing required file: $file" >&2
    exit 1
  fi
done

count_code() {
  local code="$1"
  local pattern
  if [[ "$code" == "PLL_RESET_NOT_CONNECTED" ]]; then
    pattern="- ${code} | count="
  else
    pattern="- CODE_${code} | count="
  fi
  rg -m 1 -F -- "$pattern" "$WARNING_SUMMARY" 2>/dev/null | sed -E 's/.*count=([0-9]+).*/\1/' || true
}

get_field() {
  local cls="$1"
  local field="$2"
  awk -v cls="$cls" -v field="$field" '
    $0=="### " cls { in_section=1; next }
    in_section && $0 ~ /^### / { in_section=0 }
    in_section && $0 ~ ("^- " field ":") {
      sub(/^[[:space:]]*- [^:]+: /, "", $0)
      print $0
      exit
    }
  ' "$REVIEW_DOC" || true
}

has_qsf() {
  local cls="$1"
  local text
  text="$(get_field "$cls" "qsf evidence")"
  if [[ -n "$text" && "$text" != "source evidence not found in reviewed qsf" ]]; then
    echo 1
  else
    echo 0
  fi
}

has_source_context() {
  local cls="$1"
  local section
  section="$(awk -v cls="$cls" '
    $0=="### " cls { in_section=1; next }
    in_section && /^### / { exit }
    in_section { print }
  ' "$REVIEW_DOC" || true)"
  if echo "$section" | rg -q "source context not found in reviewed files"; then
    echo 0
  elif echo "$section" | rg -q "^-[[:space:]]third_party/"; then
    echo 1
  else
    echo 0
  fi
}

has_pix_mux() {
  local cls="$1"
  local text
  text="$(get_field "$cls" "likely behavior")"
  if echo "$text" | rg -q "mux"; then
    echo 1
  else
    echo 0
  fi
}

has_pll_reset_connection() {
  local text
  text="$(get_field "PLL_RESET_NOT_CONNECTED" "source reset connection status")"
  if echo "$text" | rg -q "not found"; then
    echo 0
  elif echo "$text" | rg -q "present"; then
    echo 1
  else
    echo 0
  fi
}

evidence_quality() {
  local value="$1"
  if [[ "$value" == "strong" || "$value" == "partial" || "$value" == "missing" ]]; then
    echo "$value"
  else
    echo "missing"
  fi
}

action_for_clock_pin() {
  local count="$1"
  local qsf_present="$2"
  local src_present="$3"

  if (( count == 0 )); then
    echo "docs_only_followup"
    return
  fi
  if (( qsf_present == 1 || src_present == 1 )); then
    echo "source_or_qsf_change_required"
  else
    echo "blocked_until_source_evidence"
  fi
}

action_for_1901x() {
  local count="$1"
  local src_present="$2"
  local is_mux="$3"

  if (( count == 0 )); then
    echo "docs_only_followup"
    return
  fi
  if (( src_present == 1 && is_mux == 1 )); then
    echo "accept_with_timing_caveat"
  else
    echo "source_or_qsf_change_required"
  fi
}

count_16406="$(count_code 16406)"; count_16406="${count_16406:-0}"
count_16407="$(count_code 16407)"; count_16407="${count_16407:-0}"
count_19016="$(count_code 19016)"; count_19016="${count_19016:-0}"
count_19017="$(count_code 19017)"; count_19017="${count_19017:-0}"
count_pll="$(count_code PLL_RESET_NOT_CONNECTED)"; count_pll="${count_pll:-0}"

qsf_16406="$(has_qsf "CODE_16406")"
src_16406="$(has_source_context "CODE_16406")"
qsf_16407="$(has_qsf "CODE_16407")"
src_16407="$(has_source_context "CODE_16407")"
src_19016="$(has_source_context "CODE_19016")"
src_19017="$(has_source_context "CODE_19017")"

pix16_mux="$(has_pix_mux CODE_19016)"
pix17_mux="$(has_pix_mux CODE_19017)"
pll_reset_connected="$(has_pll_reset_connection)"

act_16406="$(action_for_clock_pin "$count_16406" "$qsf_16406" "$src_16406")"
act_16407="$(action_for_clock_pin "$count_16407" "$qsf_16407" "$src_16407")"
act_19016="$(action_for_1901x "$count_19016" "$src_19016" "$pix16_mux")"
act_19017="$(action_for_1901x "$count_19017" "$src_19017" "$pix17_mux")"
if (( count_pll > 0 )); then
  if (( pll_reset_connected == 1 )); then
    act_pll="source_or_qsf_change_required"
  else
    act_pll="blocked_until_source_evidence"
  fi
else
  act_pll="docs_only_followup"
fi

p1_line="$(rg -m1 'Current priority1 gate decision:' "$TIMING_DOC" | sed -E 's/.*\*\*([^*]+)\*\*.*/\1/' | tr -d '[:space:]' || true)"

: > "$OUT"
{
  echo "# openFPGA Genesis Priority-1 clocking action matrix"
  echo "Generated: $NOW"
  echo
  echo "Inputs:"
  echo "- docs/OPENFPGA_GENESIS_PRIORITY1_CLOCKING_REVIEW.md"
  echo "- docs/OPENFPGA_GENESIS_FITTER_WARNING_SUMMARY.md"
  echo "- docs/OPENFPGA_GENESIS_TIMING_REVIEW_BLOCKER_ORDER.md"
  if [[ -n "${p1_line}" ]]; then
    echo "- timing priority1 gate note: ${p1_line}"
  fi
  echo

  echo "## Action guidance by class"

  echo "### CODE_16406"
  echo "- current disposition: $([[ $count_16406 -gt 0 ]] && echo 'needs review before timing gate' || echo 'no active instances')"
  echo "- evidence quality: $(evidence_quality "$(get_field "CODE_16406" "evidence quality")")"
  echo "- recommended action type: $act_16406"
  echo "- next_action: review inherited clk_74b clock routing intent and update QSF/source only if project plan approves non-dedicated routing."
  echo

  echo "### CODE_16407"
  echo "- current disposition: $([[ $count_16407 -gt 0 ]] && echo 'needs review before timing gate' || echo 'no active instances')"
  echo "- evidence quality: $(evidence_quality "$(get_field "CODE_16407" "evidence quality")")"
  echo "- recommended action type: $act_16407"
  echo "- next_action: keep bridge_spiclk as reviewed timing intent or document the intended limitation before timing-review handoff."
  echo

  echo "### CODE_19016"
  echo "- current disposition: $([[ $count_19016 -gt 0 ]] && echo 'needs review before timing gate' || echo 'no active instances')"
  echo "- evidence quality: $(evidence_quality "$(get_field "CODE_19016" "evidence quality")")"
  echo "- recommended action type: $act_19016"
  echo "- next_action: confirm current_pix_clk is intentional video-mux behavior and capture exact branch conditions in docs."
  echo

  echo "### CODE_19017"
  echo "- current disposition: $([[ $count_19017 -gt 0 ]] && echo 'needs review before timing gate' || echo 'no active instances')"
  echo "- evidence quality: $(evidence_quality "$(get_field "CODE_19017" "evidence quality")")"
  echo "- recommended action type: $act_19017"
  echo "- next_action: verify mux branch mapping from selected clock source and confirm stable fanout."
  echo

  echo "### PLL_RESET_NOT_CONNECTED"
  echo "- current disposition: $([[ $count_pll -gt 0 ]] && echo 'needs review before timing gate' || echo 'no active instances')"
  if (( count_pll > 0 )); then
    echo "- evidence quality: partial"
  else
    echo "- evidence quality: missing"
  fi
  echo "- recommended action type: $act_pll"
  echo "- next_action: document explicit reset source and lock-recovery intent before timing-review handoff."
  echo

  echo "## Disposition synthesis"
  echo "- source_or_qsf_change_required: clocking/pin-reset behavior is present and clear in docs but still requires source or QSF update."
  echo "- blocked_until_source_evidence: no source evidence found to satisfy review requirement."
  echo "- accept_with_timing_caveat: only when current_pix_clk mux behavior is intentional and verified."
  echo "- docs_only_followup: no active instances but item retained for post-hoc documentation."
} > "$OUT"

echo "Wrote docs/OPENFPGA_GENESIS_PRIORITY1_CLOCKING_ACTIONS.md"
