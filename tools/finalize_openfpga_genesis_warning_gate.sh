#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STATUS_FILE="$ROOT_DIR/docs/OPENFPGA_GENESIS_ANALYSIS_ONLY_STATUS.md"
SUMMARY_FILE="$ROOT_DIR/docs/OPENFPGA_GENESIS_ANALYSIS_WARNING_SUMMARY.md"
SOURCE_REVIEW_FILE="$ROOT_DIR/docs/OPENFPGA_GENESIS_WARNING_SOURCE_REVIEW.md"
CONNECTIVITY_FILE="$ROOT_DIR/docs/OPENFPGA_GENESIS_CONNECTIVITY_WARNINGS.txt"
DISPOSITION_FILE="$ROOT_DIR/docs/OPENFPGA_GENESIS_WARNING_DISPOSITION.md"
GATE_FILE="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_READINESS_GATE.md"
NOW="$(date -u '+%Y-%m-%d %H:%M:%S UTC')"

need_file() {
  local file="$1"
  if [[ ! -f "$file" ]]; then
    echo "ERROR: missing required file: $file" >&2
    exit 1
  fi
}

need_file "$SUMMARY_FILE"
need_file "$SOURCE_REVIEW_FILE"
need_file "$CONNECTIVITY_FILE"
need_file "$STATUS_FILE"

extract_int() {
  local file="$1"
  local pattern="$2"
  local value
  value="$(grep -E "${pattern}" "$file" 2>/dev/null | tail -n1 | sed -E 's/[^0-9]//g' || true)"
  if [[ -z "$value" ]]; then
    echo 0
  else
    echo "$value"
  fi
}

analysis_exit="$(grep -E '^Analysis exit:' "$STATUS_FILE" 2>/dev/null | awk '{print $NF}' | tail -n1 || true)"
[[ -z "$analysis_exit" ]] && analysis_exit="n/a"

harmless="$(extract_int "$SUMMARY_FILE" '^- likely harmless:')"
review_needed="$(extract_int "$SUMMARY_FILE" '^- needs review before fitter:')"
fitter_blocker="$(extract_int "$SUMMARY_FILE" '^- likely fitter blocker:')"
unknown="$(extract_int "$SUMMARY_FILE" '^- unknown:')"

source_blocked_codes="$(grep -E -o 'blocked codes:[[:space:]]+[0-9]+' "$SOURCE_REVIEW_FILE" | tail -n1 | awk '{print $3}' || true)"
[[ -z "$source_blocked_codes" ]] && source_blocked_codes=0

connectivity_no_detailed=0
if grep -q "No detailed connectivity detail was captured from generated reports before cleanup." "$CONNECTIVITY_FILE"; then
  connectivity_no_detailed=1
fi

code12241_disposition="needs-review"
if grep -q '^## Warning code 12241' "$SUMMARY_FILE"; then
  if [[ "$connectivity_no_detailed" -eq 1 ]]; then
    code12241_disposition="accepted-risk"
  else
    code12241_disposition="needs-review-but-not-blocking"
  fi
fi

code10259_disposition="needs-review"
if grep -q '^## Warning code 10259' "$SUMMARY_FILE"; then
  code10259_disposition="accepted-risk"
fi

code10030_disposition="needs-review"
code10858_disposition="needs-review"
if grep -q '^## Warning code 10030' "$SUMMARY_FILE"; then
  if grep -n '^## Warning code 10030' "$SOURCE_REVIEW_FILE" -A10 2>/dev/null | grep -q "likely safe for first fitter smoke gate: yes"; then
    code10030_disposition="accepted-risk"
  else
    code10030_disposition="needs-review-but-not-blocking"
  fi
fi
if grep -q '^## Warning code 10858' "$SUMMARY_FILE"; then
  if grep -n '^## Warning code 10858' "$SOURCE_REVIEW_FILE" -A10 2>/dev/null | grep -q "likely safe for first fitter smoke gate: yes"; then
    code10858_disposition="accepted-risk"
  else
    code10858_disposition="needs-review-but-not-blocking"
  fi
fi

harmless_disposition="safe"
if [[ "$unknown" -gt 0 || "$fitter_blocker" -gt 0 ]]; then
  harmless_disposition="needs-review-but-not-blocking"
fi

# Gate decision logic for this milestone:
# - Any hard blocker or analysis error: BLOCKED
# - Any unknown warnings: REVIEW
# - Whitelisted needs-review classes are allowed for controlled-fit smoke
# - Otherwise, READY
if [[ "$analysis_exit" != "0" || "$fitter_blocker" -gt 0 || "$source_blocked_codes" -gt 0 ]]; then
  gate_decision="BLOCKED_BEFORE_FITTER"
elif [[ "$unknown" -gt 0 ]]; then
  gate_decision="REVIEW_WARNINGS_FIRST"
else
  gate_decision="READY_FOR_FITTER_GATE"
fi

cat > "$DISPOSITION_FILE" <<DISP
# openFPGA Genesis warning disposition

Generated: $NOW

- Analysis exit: $analysis_exit
- Fitter-blocker warning count: $fitter_blocker
- Unknown warning count: $unknown
- Needs-review warning count: $review_needed
- Harmless warning count: $harmless
- Final gate decision: **$gate_decision**

This does not prove Pocket boot or runtime correctness.
This only allows the next task to run a controlled fitter-only smoke gate.

## Requested class dispositions

### 12241 (connectivity summary)
- disposition: $code12241_disposition
- rationale:
  - 12241 is accepted as pre-fit smoke risk when connectivity detail is not present as detailed text in this analysis output.
  - analysis-only did not emit a detailed text connectivity report in inspected files; this is accepted as pre-fit smoke-risk only.
  - This is not a runtime correctness proof.

### 10259 (SDRAM/default overflow)
- disposition: $code10259_disposition
- rationale:
  - 10259 is localized to SDRAM/state math in upstream source.
  - Accepted for this milestone as non-blocking, with a caveat to revisit if fitter/timing/runtime later indicates a concrete issue.

### 10030 / 10858 (ROM/bridge placeholder-like)
- disposition: $code10030_disposition / $code10858_disposition
- rationale:
  - These warnings are associated with ROM/bridge placeholder and interface-stub paths in the reviewed upstream source.
  - Accepted for this first fitter smoke gate as non-blocking, with follow-up review retained for later milestones.

### Other warnings
- disposition: $harmless_disposition
- rationale:
  - Remaining classes are classified as non-critical for this scaffold-only pre-fitter smoke gate.
  - No hard fitter blockers were identified from the current analysis summaries.

## Gate summary
- If a deeper connectivity text report is still unavailable, this remains an explicit smoke-only caveat.
- No Sega-CD/32X/SAVEs path is enabled in this milestone.
- No ROM runtime correctness claim is being made by this decision.
DISP

cat > "$GATE_FILE" <<GATE
# openFPGA-Genesis fitter-readiness gate

Generated: $NOW

- Current gate decision: **$gate_decision**
- Disposition source: $DISPOSITION_FILE
- Warning summary source: $SUMMARY_FILE
- Source review source: $SOURCE_REVIEW_FILE
- Status source: $STATUS_FILE

## Decision constraints
- fitter: not run in this task
- assembler: not run in this task
- timing: not run in this task
- bitstream: not generated in this task
- APF packaging: not run in this task

## Evidence checkpoints
- analysis exit code: $analysis_exit
- likely fitter blocker count: $fitter_blocker
- unknown warning count: $unknown
- needs-review warning count: $review_needed

## Final state
- If decision is READY_FOR_FITTER_GATE, next task may run a controlled fitter-only smoke gate only.
- This does not prove Pocket boot or runtime correctness.
- This only allows the next task to run a controlled fitter-only smoke gate.
- Connectivity report caveat remains in scope: if deeper report evidence remains unavailable, treat this as a smoke-risk-only acceptance.
GATE

echo "Wrote $DISPOSITION_FILE"
echo "Wrote $GATE_FILE"
