#!/usr/bin/env bash
set -euo pipefail

DOC=docs/NO_QUARTUS_LINT_PROBE_RESULT.md
FILELIST=apf/src/fpga/filelists/genesis_runtime_candidate.f
TIMESTAMP="$(date -u +'%Y-%m-%d %H:%M:%S UTC')"
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

{
  echo "# No-Quartus Genesis Runtime Lint Probe"
  echo "Run timestamp: ${TIMESTAMP}"
  echo "Repository: $(basename "${REPO_ROOT}")"
  echo "Candidate runtime filelist: ${FILELIST}"
  echo "Note: This probe is advisory and never claims compile success."
  echo
} > "$DOC"

if [ ! -f "$FILELIST" ]; then
  echo "Probe status: filelist missing" >> "$DOC"
  echo "Error: ${FILELIST} was not found." >> "$DOC"
  exit 0
fi

SCHEME_TMP="$(mktemp -t 6m_probe.XXXXXX)"
TRUST_TMP="$(mktemp -t 6m_probe_files.XXXXXX)"
trap 'rm -f "$SCHEME_TMP" "$TRUST_TMP"' EXIT

{
  echo "apf/src/fpga/core/core_top.v"
  echo "apf/src/fpga/core/rom_preload_ingress_stub.v"
  echo "apf/src/fpga/core/rom_local_service_stub.v"
  echo "apf/src/fpga/core/rom_tiny_local_ram_stub.v"
  echo "apf/apf_genesis_base.sv"
} > "$SCHEME_TMP"

# Add candidate runtime files. Keep only non-comment, non-empty lines.
sed 's/\r$//' "$FILELIST" | awk '$0 !~ /^[[:space:]]*#/ && $0 !~ /^[[:space:]]*$/ { print }' >> "$SCHEME_TMP"

# Deduplicate while preserving order (best effort)
awk '{ if (!seen[$0]++) print $0 }' "$SCHEME_TMP" > "$TRUST_TMP"

if command -v verilator >/dev/null 2>&1; then
  echo "Tool selected: verilator" >> "$DOC"
  echo "Command: verilator --lint-only --language 1800-2017 --bbox-sys -Wall" >> "$DOC"
  echo "Probe files:" >> "$DOC"
  sed -n 's/^/  - /' "$TRUST_TMP" >> "$DOC"
  echo >> "$DOC"
  if ! xargs -a "$TRUST_TMP" verilator --lint-only --language 1800-2017 --bbox-sys -Wall >> "$DOC" 2>&1; then
    echo "Status: completed with expected probe failures (non-fatal)" >> "$DOC"
  else
    echo "Status: completed without parser/runtime errors" >> "$DOC"
  fi
  exit 0
fi

if command -v iverilog >/dev/null 2>&1; then
  echo "Tool selected: iverilog" >> "$DOC"
  echo "Command: iverilog -g2012 -t null -E" >> "$DOC"
  echo "Probe files:" >> "$DOC"
  sed -n 's/^/  - /' "$TRUST_TMP" >> "$DOC"
  echo >> "$DOC"
  if ! xargs -a "$TRUST_TMP" iverilog -g2012 -t null -E >> "$DOC" 2>&1; then
    echo "Status: completed with expected probe failures (non-fatal)" >> "$DOC"
  else
    echo "Status: completed without parser/runtime errors" >> "$DOC"
  fi
  exit 0
fi

echo "Tool selected: none" >> "$DOC"
echo "Status: not run" >> "$DOC"
echo "No supported lint tool available (verilator or iverilog)." >> "$DOC"
echo "Action: run this probe after installing a supported tool." >> "$DOC"
