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
analysis_exit=0
preflight_status="not run"
preflight_exit=0
selected_quartus_map=""
declare -a discovered_candidates

# preflight-first behavior
if [[ -x "$PRE_FLIGHT" ]]; then
  preflight_status="ran ($PRE_FLIGHT)"
  if ! "$PRE_FLIGHT"; then
    preflight_exit=$?
  fi
else
  preflight_status="skipped (missing or non-executable: $PRE_FLIGHT)"
  preflight_exit=0
  {
    echo "# Quartus Analysis-only Result"
    echo
    echo "## Date/time"
    echo "- $RUN_TIMESTAMP"
    echo
    echo "## Preflight"
    echo "- $preflight_status"
    echo "- preflight_exit_code: -"
    echo
    echo "## Quartus discovery"
    echo "- Preflight script missing; analysis attempt did not run."
    echo
    echo "## Command"
    echo "- Not run (preflight missing)."
    echo
    echo "## Observed output"
    echo '```text'
    echo "preflight script missing: $PRE_FLIGHT"
    echo '```'
    echo
    echo "## Generated-output cleanup"
    echo "- No generated outputs were checked/removed because preflight was required first and not available."
    echo
    echo "## Advisory status"
    echo "- Not run: preflight script unavailable."
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
fi

add_candidate() {
  local candidate="$1"
  if [[ -x "$candidate" ]]; then
    discovered_candidates+=("$candidate")
  fi
}

collect_candidates() {
  shopt -s nullglob

  if [[ -n "${QUARTUS_MAP:-}" ]]; then
    add_candidate "$QUARTUS_MAP"
  fi

  if [[ -n "${QUARTUS_ROOTDIR:-}" ]]; then
    add_candidate "$QUARTUS_ROOTDIR/bin/quartus_map"
    add_candidate "$QUARTUS_ROOTDIR/quartus/bin/quartus_map"
  fi

  local path_candidate
  if path_candidate="$(command -v quartus_map 2>/dev/null || true)"; then
    add_candidate "$path_candidate"
  fi

  local g
  for g in /opt/intelFPGA_lite/*/quartus/bin/quartus_map /opt/intelFPGA/*/quartus/bin/quartus_map \
           /Applications/IntelFPGA_lite/*/quartus/bin/quartus_map \
           /Applications/intelFPGA_lite/*/quartus/bin/quartus_map \
           /Applications/IntelFPGA/*/quartus/bin/quartus_map; do
    for path_candidate in $g; do
      add_candidate "$path_candidate"
    done
  done

  shopt -u nullglob
}

collect_candidates

if [[ ${#discovered_candidates[@]} -eq 0 ]]; then
  analysis_output="quartus_map unavailable via discovery; analysis not run."
else
  mapfile -t discovered_candidates < <(printf '%s
' "${discovered_candidates[@]}" | sort -u)
  selected_quartus_map="${discovered_candidates[0]}"
  quartus_map_found=1
  analysis_ran=1

  set +e
  analysis_output="$(cd "$ROOT_DIR/quartus" && "$selected_quartus_map" --analysis_and_elaboration FPGA_Pocket_SegaCD 2>&1)"
  analysis_exit=$?
  set -e
fi

# Cleanup generated outputs produced by analysis-only attempt.
for dir in output_files db incremental_db simulation greybox_tmp; do
  if [[ -d "$ROOT_DIR/quartus/$dir" ]]; then
    rm -rf "$ROOT_DIR/quartus/$dir"
    cleaned_items+=("$dir")
  fi
done

shopt -s nullglob
for ext in sof pof jic rpd rbf rbf_r; do
  for file in "$ROOT_DIR/quartus"/*."$ext"; do
    if [[ -f "$file" ]]; then
      rm -f "$file"
      cleaned_items+=("$(basename "$file")")
    fi
  done
done
shopt -u nullglob

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
  echo "## Quartus discovery"
  echo "- discovered_candidates:"
  if [[ ${#discovered_candidates[@]} -eq 0 ]]; then
    echo "  - none"
  else
    for candidate in "${discovered_candidates[@]}"; do
      echo "  - $candidate"
    done
  fi
  echo "- selected_candidate: ${selected_quartus_map:-none}"
  echo "- quartus_map found: $([[ $quartus_map_found -eq 1 ]] && echo yes || echo no)"
  echo
  echo "## Command"
  if [[ "$analysis_ran" -eq 1 ]]; then
    echo "- \`${selected_quartus_map}\` --analysis_and_elaboration FPGA_Pocket_SegaCD"
  else
    echo "- Not run (no Quartus toolchain discovered)."
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
    echo "- Not run: quartus_map unavailable/discovery failed."
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
