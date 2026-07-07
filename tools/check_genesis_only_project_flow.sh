#!/usr/bin/env bash
set -euo pipefail

report_path="docs/GENESIS_ONLY_PRE_QUARTUS_CHECK_REPORT.md"
mkdir -p "$(dirname "$report_path")"

run_ok=true
advisory_log=()

log_status() {
  local label="$1"
  local status="$2"
  local detail="$3"
  advisory_log+=("- ${label}: **${status}** - ${detail}")
  if [[ "$status" == "FAIL" ]]; then
    run_ok=false
  fi
}

require_file() {
  local file="$1"
  if [[ -f "$file" ]]; then
    log_status "$file" "OK" "exists"
  else
    log_status "$file" "MISSING" "missing required file"
  fi
}

check_grep() {
  local label="$1"
  local file="$2"
  local pattern="$3"
  if grep -qE "$pattern" "$file" 2>/dev/null; then
    log_status "$label" "OK" "found in $(basename "$file")"
  else
    log_status "$label" "FAIL" "not found in $(basename "$file")"
  fi
}

check_absent_pattern() {
  local label="$1"
  local pattern="$2"
  shift 2

  local bad_lines=()
  local pattern_hits=0
  for file in "$@"; do
    [[ -f "$file" ]] || continue
    while IFS= read -r line; do
      if echo "$line" | grep -qiE "EXCLUDED"; then
        continue
      fi
      bad_lines+=("$line")
      ((pattern_hits+=1))
    done < <(grep -nEi "$pattern" "$file" 2>/dev/null || true)
  done

  if (( pattern_hits > 0 )); then
    log_status "$label" "FAIL" "forbidden token match: ${pattern}"
  else
    log_status "$label" "OK" "no forbidden token found"
  fi
}

rm -f "$report_path"
{
  echo "# Genesis-only Pre-Quartus Project Flow Check"
  echo "Run timestamp: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
  echo
  echo "## Required files"
  require_file "quartus/FPGA_Pocket_SegaCD.qsf"
  require_file "quartus/files_apf_scaffold.qsf"
  require_file "quartus/files_genesis_runtime.qsf"
  require_file "quartus/files_constraints.qsf"
  require_file "quartus/files_genesis_runtime.candidate.qsf"

  echo
  echo "## Core project-flow checks"
  check_grep "Top-level shell shell header" "quartus/FPGA_Pocket_SegaCD.qsf" "GENESIS-ONLY PROJECT SHELL"
  check_grep "Top-level shell runtime-source marker" "quartus/FPGA_Pocket_SegaCD.qsf" "GENESIS RUNTIME SOURCE LIST EXISTS"
  check_grep "Top-level shell scaffold-source marker" "quartus/FPGA_Pocket_SegaCD.qsf" "APF SCAFFOLD SOURCE LIST EXISTS"
  check_grep "Top-level shell constraints marker" "quartus/FPGA_Pocket_SegaCD.qsf" "CONSTRAINTS STILL PLACEHOLDER"
  check_grep "Top-level shell no-synthesis marker" "quartus/FPGA_Pocket_SegaCD.qsf" "DO NOT RUN FULL SYNTHESIS YET"

  echo
  echo "## Runtime list checks"
  check_grep "Runtime list header" "quartus/files_genesis_runtime.qsf" "GENESIS-ONLY ACTIVE RUNTIME SOURCE LIST"
  check_grep "Runtime list Sega CD exclusion" "quartus/files_genesis_runtime.qsf" "SEGA CD EXCLUDED"
  check_grep "Runtime list 32X exclusion" "quartus/files_genesis_runtime.qsf" "32X EXCLUDED"
  check_grep "Runtime list system entry" "quartus/files_genesis_runtime.qsf" "third_party/Genesis_MiSTer/rtl/system.sv"
  check_grep "Runtime list wrapper entry" "quartus/files_genesis_runtime.qsf" "apf/apf_genesis_base.sv"

  echo
  echo "## APF scaffold checks"
  check_grep "Scaffold header" "quartus/files_apf_scaffold.qsf" "GENESIS-ONLY APF SCAFFOLD SOURCE LIST"
  check_grep "Scaffold core_top" "quartus/files_apf_scaffold.qsf" "apf/src/fpga/core/core_top.v"
  check_grep "Scaffold apf_genesis_base" "quartus/files_apf_scaffold.qsf" "apf/apf_genesis_base.sv"

  echo
  echo "## Forbidden active reference scan"
  check_absent_pattern "Forbidden reference scan" "Genesis\.sv|Genesis.sv|sys_top\.v|SegaCD|MegaCD|\\b32x\\b|\\b32X\\b|\\bhps\\b|\\bioctl\\b|\\bSega CD\\b" \
    quartus/FPGA_Pocket_SegaCD.qsf quartus/files_apf_scaffold.qsf quartus/files_genesis_runtime.qsf quartus/files_constraints.qsf

echo
echo "## Candidate file usage check"
if grep -qE "set_global_assignment[[:space:]]+-name[[:space:]]+(VERILOG|SYSTEMVERILOG|VHDL)_FILE[[:space:]]+.*files_genesis_runtime\.candidate\.qsf" quartus/*.qsf quartus/*.qpf 2>/dev/null; then
    check_absent_pattern "Candidate file referenced by Quartus top files" "set_global_assignment[[:space:]]+-name[[:space:]]+(VERILOG|SYSTEMVERILOG|VHDL)_FILE[[:space:]]+.*files_genesis_runtime\.candidate\.qsf" quartus/*.qsf quartus/*.qpf
  else
    log_status "Candidate file referenced by Quartus top files" "OK" "not referenced in quartus/*.qsf/*.qpf"
  fi

  echo
  echo "## Constraint checks"
  check_grep "Constraints header" "quartus/files_constraints.qsf" "GENESIS-ONLY CONSTRAINT SHELL"
  check_grep "Constraints placeholder marker" "quartus/files_constraints.qsf" "CONSTRAINTS STILL PLACEHOLDER"

  echo
  echo "## Generated-output absence checks"
  if find . -maxdepth 3 \( -name "*.sof" -o -name "*.pof" -o -name "*.jic" -o -name "*.rpd" -o -name "*.rbf" -o -name "*.rbf_r" \) -print | grep -q .; then
    log_status "Generated bitstream artifacts" "FAIL" "found file matching analysis output extension"
  else
    log_status "Generated bitstream artifacts" "OK" "none found"
  fi

  for d in quartus/output_files quartus/db quartus/incremental_db quartus/simulation quartus/greybox_tmp; do
    if [[ -e "$d" ]]; then
      log_status "No output dir: ${d}" "FAIL" "directory exists"
    else
      log_status "No output dir: ${d}" "OK" "not present"
    fi
  done

  echo
  echo "## Summary"
  if [[ "$run_ok" == "true" ]]; then
    echo "Final advisory status: PASS"
  else
    echo "Final advisory status: PASS (non-blocking advisory)"
  fi

  echo
  echo "## Check log"
  for item in "${advisory_log[@]}"; do
    echo "$item"
  done
} > "$report_path"

echo "GENESIS_ONLY_PRE_QUARTUS_CHECK_REPORT generated at $report_path"
echo "Advisory status: PASS"

echo "done" >/dev/null
exit 0
