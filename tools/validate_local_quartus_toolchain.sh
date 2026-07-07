#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
REPORT_PATH="$ROOT_DIR/docs/QUARTUS_TOOLCHAIN_VALIDATION_RESULT.md"
RUN_TIMESTAMP="$(date -u '+%Y-%m-%d %H:%M:%S UTC')"

declare -a path_candidates filtered_candidates unique_candidates linux_candidates mac_candidates

quartus_map_path=""
status="PASS"
version_output=""

path_candidates=()
if [[ -n "${QUARTUS_MAP:-}" ]]; then
  path_candidates+=("${QUARTUS_MAP}")
fi
if [[ -n "${QUARTUS_ROOTDIR:-}" ]]; then
  path_candidates+=("${QUARTUS_ROOTDIR}/bin/quartus_map")
  path_candidates+=("${QUARTUS_ROOTDIR}/quartus/bin/quartus_map")
fi

if command -v quartus_map >/dev/null 2>&1; then
  path_candidates+=("$(command -v quartus_map)")
fi

shopt -s nullglob
linux_candidates=( /opt/intelFPGA_lite/*/quartus/bin/quartus_map /opt/intelFPGA/*/quartus/bin/quartus_map )
mac_candidates=( /Applications/IntelFPGA_lite/*/quartus/bin/quartus_map /Applications/intelFPGA_lite/*/quartus/bin/quartus_map /Applications/IntelFPGA/*/quartus/bin/quartus_map )
shopt -u nullglob

for c in "${linux_candidates[@]-}"; do
  path_candidates+=("$c")
done
for c in "${mac_candidates[@]-}"; do
  path_candidates+=("$c")
done

filtered_candidates=()
for cand in "${path_candidates[@]}"; do
  if [[ -x "$cand" ]]; then
    filtered_candidates+=("$cand")
  fi
done

unique_candidates=()
if ((${#filtered_candidates[@]:-0} > 0)); then
  declare -A seen=()
  for candidate in "${filtered_candidates[@]}"; do
    if [[ -n "${seen[$candidate]-}" ]]; then
      continue
    fi
    seen[$candidate]=1
    unique_candidates+=("$candidate")
  done
fi

if [[ ${#unique_candidates[@]} -eq 0 ]]; then
  status="FAIL"
else
  quartus_map_path="${unique_candidates[0]}"
  if ! version_output="$($quartus_map_path --version 2>&1)"; then
    status="FAIL"
  fi
fi

echo "Candidates found: ${#unique_candidates[@]}"
if [[ ${#unique_candidates[@]} -eq 0 ]]; then
  echo " - none"
else
  for item in "${unique_candidates[@]}"; do
    echo " - $item"
  done
fi

echo "Selected quartus_map: ${quartus_map_path:-<none>}"
if [[ "$status" == "PASS" ]]; then
  echo "Validation status: PASS"
else
  echo "Validation status: FAIL"
fi

echo "Validation result written to $REPORT_PATH"

{
  echo "# Quartus Toolchain Validation Result"
  echo
  echo "## Date/time"
  echo "- $RUN_TIMESTAMP"
  echo
  echo "## Environment values"
  echo "- QUARTUS_MAP: ${QUARTUS_MAP:-<unset>}"
  echo "- QUARTUS_ROOTDIR: ${QUARTUS_ROOTDIR:-<unset>}"
  echo
  echo "## Discovery order"
  echo "1. QUARTUS_MAP candidate:"
  if [[ -n "${QUARTUS_MAP:-}" ]]; then
    echo "   - ${QUARTUS_MAP}"
  else
    echo "   - <not set>"
  fi
  echo "2. QUARTUS_ROOTDIR candidates:"
  if [[ -n "${QUARTUS_ROOTDIR:-}" ]]; then
    echo "   - ${QUARTUS_ROOTDIR}/bin/quartus_map"
    echo "   - ${QUARTUS_ROOTDIR}/quartus/bin/quartus_map"
  else
    echo "   - <not set>"
  fi
  echo "3. PATH candidate:"
  if command -v quartus_map >/dev/null 2>&1; then
    echo "   - $(command -v quartus_map)"
  else
    echo "   - <none>"
  fi
  echo "4. Common Linux candidates:"
  if [[ ${#linux_candidates[@]-0} -eq 0 ]]; then
    echo "   - none"
  else
    for item in "${linux_candidates[@]-}"; do
      echo "   - $item"
    done
  fi
  echo "5. Common macOS candidates:"
  if [[ ${#mac_candidates[@]-0} -eq 0 ]]; then
    echo "   - none"
  else
    for item in "${mac_candidates[@]-}"; do
      echo "   - $item"
    done
  fi
  echo
  echo "## Executable candidates"
  if [[ ${#unique_candidates[@]} -eq 0 ]]; then
    echo "- none"
  else
    for item in "${unique_candidates[@]}"; do
      echo "- $item"
    done
  fi
  echo
  echo "## Selected quartus_map"
  echo "- ${quartus_map_path:-<none>}"
  echo
  echo "## quartus_map --version"
  if [[ -n "$version_output" ]]; then
    echo '```text'
    printf '%s\n' "$version_output"
    echo '```'
  else
    echo "- <not run>"
  fi
  echo
  echo "## Advisory validation status"
  echo "- $status"
  echo
  echo "## Notes"
  echo "- No analysis was run."
  echo "- No synthesis was run."
  echo "- No fitter was run."
  echo "- No assembler was run."
  echo "- No timing analysis was run."
  echo "- No APF packaging was run."
  echo "- No generated outputs were created."
  echo "- No games were booted."
} > "$REPORT_PATH"

exit 0
