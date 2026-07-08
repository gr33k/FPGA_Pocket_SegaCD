#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UPSTREAM_DIR="$ROOT_DIR/third_party/openFPGA-Genesis/src/fpga"
UPSTREAM_QPF="$UPSTREAM_DIR/ap_core.qpf"
UPSTREAM_QSF="$UPSTREAM_DIR/ap_core.qsf"
WORK_ROOT_DIR="$ROOT_DIR/build/openfpga_genesis_analysis_work"
WORK_FPGA_DIR="$WORK_ROOT_DIR/src/fpga"
STATUS_PATH="$ROOT_DIR/docs/OPENFPGA_GENESIS_ANALYSIS_ONLY_STATUS.md"
LOG_PATH="$ROOT_DIR/docs/OPENFPGA_GENESIS_ANALYSIS_ONLY_LOG.txt"
CONNECTIVITY_WARNINGS_PATH="$ROOT_DIR/docs/OPENFPGA_GENESIS_CONNECTIVITY_WARNINGS.txt"
RUN_TIMESTAMP="$(date -u '+%Y-%m-%d %H:%M:%S UTC')"

clean_generated_dirs=("output_files" "db" "incremental_db" "greybox_tmp" "simulation")
clean_generated_items=()

PATTERN_RE='Warning \(12241\)|Connectivity|connectivity|no driver|never assigned|default initial value|constant value overflow|Warning \(10259\)|Warning \(10030\)|Warning \(10858\)'
SEARCH_PATH_PATTERNS=(
  "output_files/*.rpt"
  "output_files/*.summary"
  "output_files/*.map.*"
  "*.rpt"
  "*.summary"
  "db/*.rpt"
  "db/*.txt"
)

collect_quartus_map_candidates() {
  local candidate=""
  local all_candidates=""
  local map_candidates

  local path_candidate=""
  path_candidate="$(command -v quartus_map 2>/dev/null || true)"
  if [[ -n "$path_candidate" ]]; then
    all_candidates="${all_candidates}${path_candidate}"$'\n'
  fi

  if [[ -n "${QUARTUS_MAP:-}" && -x "${QUARTUS_MAP:-}" ]]; then
    all_candidates="${all_candidates}${QUARTUS_MAP}"$'\n'
  fi

  if [[ -n "${QUARTUS_ROOTDIR:-}" ]]; then
    candidate="$QUARTUS_ROOTDIR/bin/quartus_map"
    [[ -x "$candidate" ]] && all_candidates="${all_candidates}${candidate}"$'\n' || true
    candidate="$QUARTUS_ROOTDIR/quartus/bin/quartus_map"
    [[ -x "$candidate" ]] && all_candidates="${all_candidates}${candidate}"$'\n' || true
  fi

  for base in /opt/intelFPGA_lite /root/fpga/intelFPGA_lite /Users/phassold/intelFPGA_lite /Applications; do
    for glob in "$base"/*/quartus/bin/quartus_map "$base"/*/*/quartus/bin/quartus_map "$base"/*/quartus/bin/quartus_map; do
      [[ -f "$glob" && -x "$glob" ]] && all_candidates="${all_candidates}${glob}"$'\n' || true
    done
  done

  map_candidates="$(printf "%s" "$all_candidates" | awk 'NF && !seen[$0]++')"
  if [[ -z "$map_candidates" ]]; then
    echo ""
    return 1
  fi

  printf '%s\n' "$map_candidates" | awk 'NR==1'
  return 0
}

prepare_work_dir() {
  rm -rf "$WORK_ROOT_DIR"
  mkdir -p "$WORK_FPGA_DIR"
  cp -R "$UPSTREAM_DIR"/. "$WORK_FPGA_DIR"/
}

cleanup_generated_outputs() {
  local d
  local removed=0
  local item

  for d in "${clean_generated_dirs[@]}"; do
    if [[ -d "$WORK_FPGA_DIR/$d" ]]; then
      rm -rf "$WORK_FPGA_DIR/$d"
      clean_generated_items+=("$WORK_FPGA_DIR/$d")
      removed=1
    fi
  done

  for f in "$WORK_FPGA_DIR"/*.{sof,pof,jic,rpd,rbf,rbf_r}; do
    [[ -f "$f" ]] || continue
    rm -f "$f"
    clean_generated_items+=("$f")
    removed=1
  done

  if [[ "$removed" -eq 1 ]]; then
    append_status "Generated-output warning: cleanup removed Quartus artifacts from work project."
    append_status "Do not commit generated Quartus outputs."
    append_status "Cleaned items:"
    for item in "${clean_generated_items[@]}"; do
      append_status "- $item"
    done
  else
    append_status "No generated Quartus output directories/files were detected for cleanup."
  fi
}

collect_candidate_report_files() {
  local -n out_arr=$1
  local base_dir="$WORK_FPGA_DIR"
  local pattern
  shopt -s nullglob
  for pattern in "${SEARCH_PATH_PATTERNS[@]}"; do
    for f in "$base_dir/$pattern"; do
      [[ -f "$f" ]] && out_arr+=("$f")
    done
  done

  for f in "$base_dir"/output_files/*/*.rpt "$base_dir"/output_files/*/*.txt "$base_dir"/db/*.rpt "$base_dir"/db/*.txt; do
    [[ -f "$f" ]] && out_arr+=("$f")
  done
  shopt -u nullglob

  local deduped
  deduped="$(printf '%s\n' "${out_arr[@]}" | awk 'NF && !seen[$0]++')"
  mapfile -t out_arr <<< "$deduped"
}

capture_connectivity_reports() {
  local -a report_files=()
  local f
  local -a matches=()
  collect_candidate_report_files report_files

  mkdir -p "$(dirname "$CONNECTIVITY_WARNINGS_PATH")"

  {
    echo "# Quartus connectivity warning evidence"
    echo "Generated: $RUN_TIMESTAMP"
    echo "Work dir: $WORK_FPGA_DIR"
    echo "Pattern: $PATTERN_RE"
    echo
    echo "Analysis status captured: ${ANALYSIS_RAN}"
    echo "Analysis exit code: ${ANALYSIS_EXIT}"
    echo
    echo "## Report inventory"
    if [[ ${#report_files[@]} -eq 0 ]]; then
      echo "- No files matched search inventory patterns"
    else
      for f in "${report_files[@]}"; do
        echo "- $f"
      done
    fi
    echo
  } > "$CONNECTIVITY_WARNINGS_PATH"

  for f in "${report_files[@]}"; do
    [[ -f "$f" ]] || continue
    mapfile -t matches < <(rg -n -e "$PATTERN_RE" "$f" 2>/dev/null || true)
    [[ ${#matches[@]} -eq 0 ]] && continue

    {
      echo "## ${f}"
      echo
      echo "### Matched lines"
      for line in "${matches[@]}"; do
        echo "$line"
      done
      echo
      echo '```text'
      rg -n -e "$PATTERN_RE" "$f" 2>/dev/null || true
      echo '```'
      echo
    } >> "$CONNECTIVITY_WARNINGS_PATH"
  done

  if ! rg -q -e "$PATTERN_RE" "${report_files[@]}" 2>/dev/null; then
    {
      echo "No detailed connectivity detail was captured before cleanup because no report files in the work dir matched warning/file search patterns."
      echo "Reason: rg returned no hits for the connectivity terms before artifact cleanup."
      echo "Inspection list used: output_files/*.rpt, output_files/*.summary, output_files/*.map.*, *.rpt, *.summary, db/*.rpt, db/*.txt"
    } >> "$CONNECTIVITY_WARNINGS_PATH"
  fi

  if [[ -f "$LOG_PATH" ]]; then
    mapfile -t log_matches < <(grep -nE "Warning \\(12241\\)|Warning \\(10259\\)|Warning \\(10030\\)|Warning \\(10858\\)|Connectivity Checks|connectivity|Connectivity|no driver|never assigned|default initial value|constant value overflow" "$LOG_PATH" || true)
    if [[ ${#log_matches[@]} -gt 0 ]]; then
      {
        echo
        echo "## Quartus log evidence"
        echo '```text'
        printf '%s\n' "${log_matches[@]}"
        echo '```'
      } >> "$CONNECTIVITY_WARNINGS_PATH"
    fi
  fi



  append_status "Captured connectivity evidence into: $CONNECTIVITY_WARNINGS_PATH"
}

write_header() {
  {
    echo "# openFPGA-Genesis analysis-only status"
    echo "Generated: $RUN_TIMESTAMP"
    echo
  } > "$STATUS_PATH"
}

append_status() {
  local line="${1:-}"
  printf '%s\n' "$line" >> "$STATUS_PATH"
}

write_header
append_status "Runner: safe analysis-only for upstream openFPGA-Genesis lane"
append_status "Upstream dir: $UPSTREAM_DIR"
append_status "Upstream qpf: $UPSTREAM_QPF"
append_status "Upstream qsf: $UPSTREAM_QSF"
append_status "Work dir: $WORK_FPGA_DIR"

if [[ -f "$UPSTREAM_QPF" ]]; then
  append_status "PROJECT_REVISION found: $(grep -Eo 'PROJECT_REVISION\\s*=\\s*\"[^\"]+\"' "$UPSTREAM_QPF" || true)"
else
  append_status "WARNING: upstream qpf missing: $UPSTREAM_QPF"
fi

if [[ -f "$UPSTREAM_QSF" ]]; then
  append_status "TOP_LEVEL_ENTITY: $(grep -Eo 'TOP_LEVEL_ENTITY[[:space:]]+apf_top' "$UPSTREAM_QSF" || true)"
  append_status "DEVICE: $(grep -Eo 'set_global_assignment[[:space:]]+-name[[:space:]]+DEVICE[[:space:]]+[A-Za-z0-9]+' "$UPSTREAM_QSF" || true)"
  append_status "QIP/SDC assignments: $(grep -c '^set_global_assignment -name QIP_FILE\|^set_global_assignment -name SDC_FILE' "$UPSTREAM_QSF" || true)"
else
  append_status "WARNING: upstream qsf missing: $UPSTREAM_QSF"
fi

append_status
append_status "Discovery:"
selected_quartus_map="$(collect_quartus_map_candidates || true)"
ANALYSIS_EXIT="n/a"
ANALYSIS_RAN="no"

if [[ -n "$selected_quartus_map" && -x "$selected_quartus_map" ]]; then
  append_status "Selected quartus_map: $selected_quartus_map"
  : > "$LOG_PATH"
  prepare_work_dir

  command_line=("$selected_quartus_map" --read_settings_files=on --write_settings_files=off ap_core -c ap_core --analysis_and_elaboration)
  append_status "Command: ${command_line[*]}"
  append_status

  if (cd "$WORK_FPGA_DIR" && "${command_line[@]}" > "$LOG_PATH" 2>&1); then
    append_status "BLOCKER: none"
    append_status "Analysis exit: 0"
    ANALYSIS_EXIT="0"
  else
    ANALYSIS_EXIT=$?
    append_status "Analysis exit: $ANALYSIS_EXIT"
  fi

  ANALYSIS_RAN="yes"
  append_status "Analysis ran: yes"
  capture_connectivity_reports
  append_status "Log file: $LOG_PATH"
  cleanup_generated_outputs
else
  append_status "BLOCKER: quartus_map not found"
  append_status "No quartus_map available from PATH or known install locations."
  : > "$LOG_PATH"
  append_status "No work directory was created because Quartus was unavailable."
  ANALYSIS_RAN="no"
  echo "No detailed connectivity report found before cleanup." > "$CONNECTIVITY_WARNINGS_PATH"
  append_status "Connectivity evidence skipped because Quartus did not run."
  echo "No connectivity capture reason: Quartus analysis not executed in this run." >> "$CONNECTIVITY_WARNINGS_PATH"
  echo "No connectivity capture reason: Work dir did not exist because analysis was blocked." >> "$CONNECTIVITY_WARNINGS_PATH"
fi

append_status
append_status "Safety confirmation: no quartus_fit/asm/sta/cpf invocation."
append_status "No synthesis/fitter/assembler/timing/bitstream generation was requested."
append_status "No APF packaging was requested."

if [[ "$ANALYSIS_RAN" == "yes" ]]; then
  append_status "Analysis status: complete (pre-fit/elab only)"
else
  append_status "Analysis status: blocked (tool missing)"
fi

exit 0
