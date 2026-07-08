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
REPORT_INVENTORY_PATH="$ROOT_DIR/docs/OPENFPGA_GENESIS_QUARTUS_REPORT_INVENTORY.txt"
RUN_TIMESTAMP="$(date -u '+%Y-%m-%d %H:%M:%S UTC')"

clean_generated_dirs=("output_files" "db" "incremental_db" "greybox_tmp" "simulation")
clean_generated_items=()

PATTERN_RE='Warning \(12241\)|Connectivity|connectivity|no driver|never assigned|default initial value|constant value overflow|Warning \(10259\)|Warning \(10030\)|Warning \(10858\)|sdram\.sv|core_bridge_cmd\.v|core_top\.sv|jt12_pm\.v'
EVIDENCE_FILE_TYPES=("*.rpt" "*.summary" "*.map.*" "*.smsg" "*.qmsg" "*.txt" "*.htm" "*.html" "*.xml" "*.json")

append_status() { printf '%s\n' "${1:-}" >> "$STATUS_PATH"; }
write_status_header() {
  {
    echo "# openFPGA-Genesis analysis-only status"
    echo "Generated: $RUN_TIMESTAMP"
    echo
  } > "$STATUS_PATH"
}

collect_quartus_map_candidates() {
  local all_candidates=""
  local path_candidate="$(command -v quartus_map 2>/dev/null || true)"
  if [[ -n "$path_candidate" ]]; then
    all_candidates+="${path_candidate}"$'\n'
  fi

  if [[ -n "${QUARTUS_MAP:-}" && -x "${QUARTUS_MAP:-}" ]]; then
    all_candidates+="${QUARTUS_MAP}"$'\n'
  fi

  if [[ -n "${QUARTUS_ROOTDIR:-}" ]]; then
    local candidate="$QUARTUS_ROOTDIR/bin/quartus_map"
    [[ -x "$candidate" ]] && all_candidates+="${candidate}"$'\n' || true
    candidate="$QUARTUS_ROOTDIR/quartus/bin/quartus_map"
    [[ -x "$candidate" ]] && all_candidates+="${candidate}"$'\n' || true
  fi

  local base
  for base in /opt/intelFPGA_lite /root/fpga/intelFPGA_lite /opt/intelFPGA; do
    for glob in "$base"/*/quartus/bin/quartus_map "$base"/*/*/quartus/bin/quartus_map "$base"/*/*/*/quartus/bin/quartus_map "$base"/Intel*/*/quartus/bin/quartus_map; do
      [[ -f "$glob" && -x "$glob" ]] && all_candidates+="${glob}"$'\n' || true
    done
  done

  local map_candidates
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

write_inventory_file() {
  mkdir -p "$(dirname "$REPORT_INVENTORY_PATH")"
  {
    echo "# Quartus report inventory"
    echo "Generated: $RUN_TIMESTAMP"
    echo "Work dir: $WORK_FPGA_DIR"
  } > "$REPORT_INVENTORY_PATH"

  local count=0
  local f size ftype
  while IFS= read -r -d '' f; do
    size="$(stat -c '%s' "$f" 2>/dev/null || stat -f '%z' "$f" 2>/dev/null || echo 0)"
    if command -v file >/dev/null 2>&1; then
      ftype="$(file -b "$f" 2>/dev/null | tr -d '\r\n' | sed 's/[[:space:]]\+/ /g')"
    else
      ftype="unavailable"
    fi
    echo "- $(printf "%s" "$f" | sed "s#^$ROOT_DIR/##") | size=${size} bytes | type=${ftype}" >> "$REPORT_INVENTORY_PATH"
    count=$((count + 1))
  done < <(find "$WORK_FPGA_DIR" "$WORK_FPGA_DIR/output_files" "$WORK_FPGA_DIR/db" "$WORK_FPGA_DIR/incremental_db" "$WORK_FPGA_DIR/greybox_tmp" "$WORK_FPGA_DIR/simulation" -type f -print0 2>/dev/null | sort -z)

  sed -i "1aTotal files: $count" "$REPORT_INVENTORY_PATH"
}

collect_evidence_files() {
  local -a all_files=()
  local -A seen

  local dir path pattern
  for dir in "$WORK_FPGA_DIR/output_files" "$WORK_FPGA_DIR/db" "$WORK_FPGA_DIR/incremental_db" "$WORK_FPGA_DIR/greybox_tmp" "$WORK_FPGA_DIR/simulation"; do
    if [[ -d "$dir" ]]; then
      while IFS= read -r -d '' path; do
        all_files+=("$path")
      done < <(find "$dir" -type f -size -6M -print0)
    fi
  done

  if [[ -d "$WORK_FPGA_DIR" ]]; then
    for pattern in "${EVIDENCE_FILE_TYPES[@]}"; do
      shopt -s nullglob
      for path in "$WORK_FPGA_DIR"/$pattern; do
        all_files+=("$path")
      done
      shopt -u nullglob
    done

    shopt -s nullglob
    for path in "$WORK_FPGA_DIR"/*.v "$WORK_FPGA_DIR"/*.sv "$WORK_FPGA_DIR"/*.svh; do
      [[ -f "$path" ]] && all_files+=("$path")
    done
    shopt -u nullglob
  fi

  for path in "${all_files[@]}"; do
    [[ -f "$path" ]] || continue
    if [[ -z "${seen[$path]+x}" ]]; then
      seen[$path]=1
      printf '%s\n' "$path"
    fi
  done
}

scan_for_terms() {
  local file="$1"
  local -a matches=()
  local line

  while IFS= read -r line; do
    matches+=("$line")
  done < <(grep -aE -i -n -e "$PATTERN_RE" "$file" 2>/dev/null || true)

  if (( ${#matches[@]} == 0 )) && command -v strings >/dev/null 2>&1; then
    while IFS= read -r line; do
      matches+=("$line")
    done < <(strings "$file" 2>/dev/null | grep -nE -i -e "$PATTERN_RE" || true)
  fi

  if (( ${#matches[@]} > 0 )); then
    printf '## %s\n' "$file"
    printf '```text\n'
    printf '%s\n' "${matches[@]}"
    printf '```\n'
    return 0
  fi
  return 1
}

capture_connectivity_reports() {
  local -a evidence_files=()
  local -a log_lines=()
  local -a matched_files=()
  local file match_count=0
  local has_log_fallback=0

  while IFS= read -r -d $'\n' file; do
    [[ -n "$file" ]] && evidence_files+=("$file")
  done < <(collect_evidence_files)

  write_inventory_file

  {
    echo "# Quartus connectivity and warning capture"
    echo "Generated: $RUN_TIMESTAMP"
    echo "Work dir: $WORK_FPGA_DIR"
    echo "Analysis ran: $ANALYSIS_RAN"
    echo "Analysis exit code: $ANALYSIS_EXIT"
    echo "Quartus version: ${quartus_version:-not-available}"
    echo "Exact command: ${command_line[*]}"
    echo "Generated file inventory count: ${#evidence_files[@]}"
    echo "Report inventory file: $REPORT_INVENTORY_PATH"
    echo "Connectivity evidence file: $CONNECTIVITY_WARNINGS_PATH"
    echo "Log fallback used: no"
    echo
    echo "## Report inventory"
    sed -n '1,260p' "$REPORT_INVENTORY_PATH"
    echo
    echo "## Matched report excerpts"
  } > "$CONNECTIVITY_WARNINGS_PATH"

  for file in "${evidence_files[@]}"; do
    if scan_for_terms "$file" >> "$CONNECTIVITY_WARNINGS_PATH"; then
      matched_files+=("$file")
      match_count=$((match_count + 1))
    fi
  done

  if [[ -f "$LOG_PATH" ]]; then
    while IFS= read -r line; do
      log_lines+=("$line")
    done < <(grep -nE -i -e "Warning \\(12241\\)|Warning \\(10259\\)|Warning \\(10030\\)|Warning \\(10858\\)|Connectivity Checks|Connectivity|connectivity|no driver|never assigned|default initial value|constant value overflow|sdram\\.sv|core_bridge_cmd\\.v|core_top\\.sv|jt12_pm\\.v" "$LOG_PATH" || true)
    if (( ${#log_lines[@]} > 0 )); then
      has_log_fallback=1
      sed -i 's/Log fallback used: no/Log fallback used: yes/' "$CONNECTIVITY_WARNINGS_PATH"
      {
        echo
        echo "## Quartus log evidence"
        echo '```text'
        printf '%s\n' "${log_lines[@]}"
        echo '```'
      } >> "$CONNECTIVITY_WARNINGS_PATH"
    fi
  fi

  if (( match_count == 0 )); then
    {
      echo
      echo "No detailed connectivity detail was captured from generated reports before cleanup."
      echo "Matched report terms in generated files: 0"
      echo "Inspection list used: output_files/db/incremental_db/greybox_tmp/simulation files, extensions .rpt .summary .map.* .smsg .qmsg .txt .htm .html .xml .json and <=5MB files under db/output_files/incremental_db; plus root src files."
      echo "Reason: no pattern matches in collected generated files."
    } >> "$CONNECTIVITY_WARNINGS_PATH"
  else
    {
      echo
      echo "Matched report terms in generated files: $match_count"
      echo "Matched files:"
      printf ' - %s\n' "${matched_files[@]}"
    } >> "$CONNECTIVITY_WARNINGS_PATH"
  fi

  append_status "Captured connectivity evidence into: $CONNECTIVITY_WARNINGS_PATH"
  append_status "Captured report inventory into: $REPORT_INVENTORY_PATH"
}

cleanup_generated_outputs() {
  local d item
  local removed=0
  for d in "${clean_generated_dirs[@]}"; do
    if [[ -d "$WORK_FPGA_DIR/$d" ]]; then
      rm -rf "$WORK_FPGA_DIR/$d"
      clean_generated_items+=("$WORK_FPGA_DIR/$d")
      removed=1
    fi
  done

  local f
  for f in "$WORK_FPGA_DIR"/*.{sof,pof,jic,rpd,rbf,rbf_r}; do
    [[ -f "$f" ]] || continue
    rm -f "$f"
    clean_generated_items+=("$f")
    removed=1
  done

  if (( removed == 1 )); then
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

write_status_header
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
  append_status "QIP/SDC assignments: $(grep -c '^set_global_assignment -name QIP_FILE\\|^set_global_assignment -name SDC_FILE' "$UPSTREAM_QSF" || true)"
else
  append_status "WARNING: upstream qsf missing: $UPSTREAM_QSF"
fi

append_status
append_status "Discovery:"
selected_quartus_map="$(collect_quartus_map_candidates || true)"
ANALYSIS_EXIT="n/a"
ANALYSIS_RAN="no"
quartus_version=""

if [[ -n "$selected_quartus_map" && -x "$selected_quartus_map" ]]; then
  append_status "Selected quartus_map: $selected_quartus_map"
  quartus_version="$($selected_quartus_map --version 2>/dev/null | head -n 1 || true)"
  [[ -n "$quartus_version" ]] && append_status "Quartus version: $quartus_version"

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
  cleanup_generated_outputs
else
  append_status "BLOCKER: quartus_map not found"
  append_status "No quartus_map available from PATH or known install locations."
  : > "$LOG_PATH"
  ANALYSIS_RAN="no"
  append_status "No work directory was created because Quartus was unavailable."
  {
    echo "No detailed connectivity report found before cleanup."
    echo "No connectivity capture reason: Quartus analysis was not executed in this run."
    echo "No connectivity capture reason: Work dir did not exist because analysis was blocked."
  } > "$CONNECTIVITY_WARNINGS_PATH"
  append_status "Connectivity evidence skipped because Quartus was not run."
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
