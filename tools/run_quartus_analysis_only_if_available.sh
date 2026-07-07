#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
REPORT_PATH="$ROOT_DIR/docs/QUARTUS_ANALYSIS_ONLY_RESULT.md"
PRE_FLIGHT="$ROOT_DIR/tools/preflight_quartus_analysis_only.sh"
RUN_TIMESTAMP="$(date -u '+%Y-%m-%d %H:%M:%S UTC')"
analysis_output=""
cleaned_items=()
analysis_ran=0
quartus_map_found=0
preflight_status="not run"
preflight_exit=0
analysis_exit=0

if [[ -x "$PRE_FLIGHT" ]]; then
  preflight_status="ran ($PRE_FLIGHT)"
  if ! "$PRE_FLIGHT"; then
    preflight_exit=$?
  fi
else
  preflight_status="skipped (missing or non-executable: $PRE_FLIGHT)"
  preflight_exit=0
fi

if command -v quartus_map >/dev/null 2>&1; then
  quartus_map_found=1
  analysis_ran=1
  analysis_exit=0
  set +e
  analysis_output="$(cd "$ROOT_DIR/quartus" && quartus_map --analysis_and_elaboration FPGA_Pocket_SegaCD 2>&1)"
  analysis_exit=$?
  set -e
else
  analysis_output="quartus_map unavailable; analysis not run."
fi

# Cleanup generated outputs produced by analysis-only attempt.
for dir in output_files db incremental_db simulation greybox_tmp; do
  if [[ -d "$ROOT_DIR/quartus/$dir" ]]; then
    rm -rf "$ROOT_DIR/quartus/$dir"
    cleaned_items+=("$dir")
  fi
done

for ext in sof pof jic rpd rbf rbf_r; do
  for file in "$ROOT_DIR/quartus"/*."$ext"; do
    if [[ -f "$file" ]]; then
      rm -f "$file"
      cleaned_items+=("$(basename "$file")")
    fi
  done
done

{
  echo "# Quartus Analysis-only Result"
  echo
  echo "## Date/time"
  echo "- $RUN_TIMESTAMP"
  echo
  echo "## Preflight"
  echo "- $preflight_status"
  echo "- preflight_exit_code: $preflight_exit"
  echo
  echo "## Quartus availability"
  echo "- quartus_map found: $([[ $quartus_map_found -eq 1 ]] && echo yes || echo no)"
  echo
  echo "## Command"
  if [[ "$analysis_ran" -eq 1 ]]; then
    echo "- \\`quartus_map --analysis_and_elaboration FPGA_Pocket_SegaCD\\`"
  else
    echo "- Not run (quartus_map unavailable)."
  fi
  echo
  echo "## Observed output"
  echo '```text'
  printf '%s\n' "$analysis_output"
  echo '```'
  echo
  echo "## Generated-output cleanup"
  if [[ ${#cleaned_items[@]} -eq 0 ]]; then
    echo "- No generated output directories/files were removed."
  else
    echo "- Removed generated outputs:"
    for item in "${cleaned_items[@]}"; do
      echo "  - $item"
    done
  fi
  echo
  echo "## Advisory status"
  if [[ "$analysis_ran" -eq 1 && $preflight_exit -eq 0 && $quartus_map_found -eq 1 && $analysis_exit -eq 0 ]]; then
    echo "- Completed: advisory analysis-only attempt captured in this report."
  elif [[ "$analysis_ran" -eq 1 && $quartus_map_found -eq 1 ]]; then
    echo "- Completed: quartus_map was run; check output for errors (advisory)."
  elif [[ $quartus_map_found -eq 0 ]]; then
    echo "- Not run: quartus_map unavailable."
  fi
  echo
  echo "## Notes"
  echo "- No full synthesis was run."
  echo "- No fitter was run."
  echo "- No assembler was run."
  echo "- No timing analysis was run."
  echo "- No APF packaging was run."
  echo "- No games were booted."
  echo "- Failure here is expected until full runtime activation and constraint work are complete."
} > "$REPORT_PATH"

echo "Result written to $REPORT_PATH"
exit 0
