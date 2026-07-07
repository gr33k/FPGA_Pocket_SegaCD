#!/usr/bin/env bash
set -euo pipefail

DOC=docs/GENESIS_RUNTIME_FIRST_COMPILE_ERRORS.md
FILELIST=apf/src/fpga/core/genesis_runtime_compile_probe.draft.f
REPO_NAME="$(basename "$(git rev-parse --show-toplevel 2>/dev/null || pwd)")"
TIMESTAMP="$(date -u +"%Y-%m-%d %H:%M:%S UTC")"

{
  echo "# Genesis Runtime First Compile Probe"
  echo ""
  echo "Run timestamp: ${TIMESTAMP}"
  echo ""
  echo "Repository: ${REPO_NAME}"
  echo "Filelist: ${FILELIST}"
  echo ""
} > "$DOC"

echo "This probe only covers Verilog/SystemVerilog-capable tools. VHDL dependencies require a mixed-language flow." | tee -a "$DOC"

echo ""
echo ""
if [[ ! -f "$FILELIST" ]]; then
  {
    echo "Probe status: filelist missing"
    echo "Error: ${FILELIST} not found; cannot run compile probe."
  } >> "$DOC"
  exit 0
fi

FILES=()
while IFS= read -r line; do
  if [[ ! -z "$line" && ! "$line" =~ ^[[:space:]]*$ && ! "$line" =~ ^[[:space:]]*# ]]; then
    FILES+=("$line")
  fi
done < "$FILELIST"

if [[ ${#FILES[@]} -eq 0 ]]; then
  {
    echo "Probe status: filelist empty"
    echo "Error: ${FILELIST} has no active source entries."
  } >> "$DOC"
  exit 0
fi

if command -v verilator >/dev/null 2>&1; then
  echo "Tool selected: verilator" | tee -a "$DOC"
  echo "Command: verilator --lint-only --language 1800-2017 --bbox-sys -Wall" | tee -a "$DOC"
  CMD=(verilator --lint-only --language 1800-2017 --bbox-sys -Wall)
  CMD+=("${FILES[@]}")
  echo "Probe command line: ${CMD[*]}" | tee -a "$DOC"
  echo "" >> "$DOC"
  if ! { "${CMD[@]}"; } >> "$DOC" 2>&1; then
    echo "Status: probe captured (non-fatal)" >> "$DOC"
    echo "First meaningful failures are captured above for compile dependency triage." >> "$DOC"
    echo "Note: no imported Genesis_MiSTer RTL was modified for this probe." >> "$DOC"
    echo "Note: mixed-language flow is still required for VHDL-backed dependencies." >> "$DOC"
  else
    echo "Status: command completed with no reported errors" >> "$DOC"
    echo "Note: this is uncommon at this stage; still treat as advisory only." >> "$DOC"
    echo "No source-file changes were made." >> "$DOC"
  fi
  exit 0
fi
if command -v iverilog >/dev/null 2>&1; then
  echo "Tool selected: iverilog" | tee -a "$DOC"
  echo "Command: iverilog -g2012 -t null -E" | tee -a "$DOC"
  CMD=(iverilog -g2012 -t null -E)
  CMD+=("${FILES[@]}")
  echo "Probe command line: ${CMD[*]}" | tee -a "$DOC"
  echo "" >> "$DOC"
  if ! { "${CMD[@]}"; } >> "$DOC" 2>&1; then
    echo "Status: probe captured (non-fatal)" >> "$DOC"
    echo "First meaningful failures are captured above for compile dependency triage." >> "$DOC"
    echo "VHDL/Verilog mixed-flow limitations may apply with this tool." >> "$DOC"
    echo "Note: no imported Genesis_MiSTer RTL was modified for this probe." >> "$DOC"
    echo "Note: mixed-language flow is still required for VHDL-backed dependencies." >> "$DOC"
  else
    echo "Status: command completed with no reported errors" >> "$DOC"
    echo "Note: this is uncommon at this stage; still treat as advisory only." >> "$DOC"
    echo "No source-file changes were made." >> "$DOC"
  fi
  exit 0
fi

echo "Tool selected: none" >> "$DOC"
echo "Probe not run: no supported compile/lint tool found (verilator or iverilog)." >> "$DOC"
echo "Status: not run locally" >> "$DOC"
echo "Command attempted: none (no supported tool available)." >> "$DOC"
echo "Next step: run this script on a host with verilator or iverilog." >> "$DOC"
echo "" >> "$DOC"
echo "No supported compile/lint tool found (verilator or iverilog). Skipping compile probe." | tee -a "$DOC"
echo "" >> "$DOC"
echo "Note: imported Genesis_MiSTer RTL was not modified for this probe." >> "$DOC"
echo "Note: runtime module list remains draft and first-error output is advisory only." >> "$DOC"
echo "Note: Verilog/SystemVerilog tools are not sufficient for VHDL dependencies." >> "$DOC"
echo "" >> "$DOC"
echo "Non-fatal: compile probe requires supported local tools and mixed-language flow for full runtime." >> "$DOC"
exit 0
