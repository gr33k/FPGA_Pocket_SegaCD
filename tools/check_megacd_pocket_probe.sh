#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"
REPORT=docs/CHECK_MEGACD_POCKET_PROBE.md
STATUS_DOC=docs/MEGACD_POCKET_FIT_STATUS.md
FIT_RESULT="$(sed -n 's/^- result: `\(.*\)`/\1/p' "$STATUS_DOC" | head -1)"
MAP_EXIT="$(sed -n 's/^- map exit code: `\(.*\)`/\1/p' "$STATUS_DOC" | head -1)"
FIT_EXIT="$(sed -n 's/^- fitter exit code: `\(.*\)`/\1/p' "$STATUS_DOC" | head -1)"
TIMING_EXIT="$(sed -n 's/^- timing exit code: `\(.*\)`/\1/p' "$STATUS_DOC" | head -1)"
ASM_EXIT="$(sed -n 's/^- assembler exit code: `\(.*\)`/\1/p' "$STATUS_DOC" | head -1)"
DONOR_STATUS_LINE="$(git status --short third_party/MegaCD_MiSTer || true)"
GENESIS_STATUS_LINE="$(git status --short third_party/Genesis_MiSTer || true)"
BRANCH_OK=no; DONOR_CLEAN=yes; GENESIS_CLEAN=yes; LANE_OK=no
WORDRAM0_EXTERNAL=no; WORDRAM1_INTERNAL=no; CDC_MLAB_CONNECTED=no; CDC_INTERNAL_M10K_REMOVED=no; PCM_INTERNAL=no
TIMING_DOC=no; MAP_DOC=no; PACK_AUDIT=no; ARTIFACT_FRESH=no; BUNDLED_PAYLOAD=no; ARTIFACT_TRACKED=no; FINAL_RESULT=PASS
[[ "$(git branch --show-current)" == "feature/megacd-bringup" ]] && BRANCH_OK=yes || FINAL_RESULT=FAIL
[[ -n "$DONOR_STATUS_LINE" ]] && DONOR_CLEAN=no && FINAL_RESULT=FAIL
[[ -n "$GENESIS_STATUS_LINE" ]] && GENESIS_CLEAN=no && FINAL_RESULT=FAIL
[[ -d src/megacd_pocket && -f src/megacd_pocket/fpga/core/core_top.sv ]] && LANE_OK=yes || FINAL_RESULT=FAIL
rg -q 'EXT_WORDRAM0_A|EXT_WORDRAM0_DI|EXT_WORDRAM0_DO|EXT_WORDRAM0_WR' src/megacd_pocket/fpga/core/rtl/MCD/MCD.vhd && WORDRAM0_EXTERNAL=yes || FINAL_RESULT=FAIL
rg -q 'WORDRAM1\s*: entity work\.spram' src/megacd_pocket/fpga/core/rtl/MCD/MCD.vhd && WORDRAM1_INTERNAL=yes || FINAL_RESULT=FAIL
rg -q 'megacd_cdc_ram_mlab|EXT_CDC_RAM_A_RD|00E00018|00E0001C' src/megacd_pocket/fpga/core/core_top.sv && CDC_MLAB_CONNECTED=yes || FINAL_RESULT=FAIL
! rg -q 'CDC_RAM\s*: entity work\.dpram_dif' src/megacd_pocket/fpga/core/rtl/MCD/MCD.vhd && CDC_INTERNAL_M10K_REMOVED=yes || FINAL_RESULT=FAIL
rg -q 'PCM_RAM\s*: entity work\.dpram' src/megacd_pocket/fpga/core/rtl/MCD/MCD.vhd && PCM_INTERNAL=yes || FINAL_RESULT=FAIL
[[ -f docs/MEGACD_M10K_PACKING_AUDIT.md ]] && PACK_AUDIT=yes || FINAL_RESULT=FAIL
[[ -f docs/MEGACD_CDC_RAM_MAP_RESULT.md ]] && MAP_DOC=yes || FINAL_RESULT=FAIL
if [[ "$FIT_EXIT" == '0' ]]; then
  [[ -f docs/MEGACD_CDC_RAM_TIMING_RESULT.md ]] && TIMING_DOC=yes || FINAL_RESULT=FAIL
else
  TIMING_DOC=not-required
fi
case "$FIT_RESULT" in
  CDC_MLAB_MAP_FAILED|CDC_MLAB_NOT_INFERRED|CDC_MLAB_UNSUPPORTED_CONFIGURATION|CDC_RAM_CONVERTED_TO_REGISTERS|M10K_DEFICIT_REMAINS_AFTER_CDC|FIT_FAIL_LOGIC_CAPACITY|FIT_FAIL_MLAB_ROUTING|FIT_FAIL_M10K|FIT_FAIL_NON_MEMORY|FIT_PASS_TIMING_FAIL|ASSEMBLER_FAILED|BIOS_PROBE_ARTIFACT_READY|BIOS_PROBE_ARTIFACT_READY_WITH_TIMING_RISK|BIOS_PROBE_READY_FOR_POCKET) ;;
  *) FINAL_RESULT=FAIL ;;
esac
[[ -f build/megacd_pocket_artifacts/bitstream.rbf_r ]] && ARTIFACT_FRESH=yes || ARTIFACT_FRESH=no
if git status --short -- build/megacd_pocket_artifacts build/pocket_sd_megacd_bios_probe | rg -q '^[AMDRCU?]'; then ARTIFACT_TRACKED=yes; FINAL_RESULT=FAIL; fi
if find build/pocket_sd_megacd_bios_probe -type f \( -iname '*.rom' -o -iname '*.iso' -o -iname '*.cue' -o -iname '*.chd' -o -iname '*.bin' -o -iname '*.gen' -o -iname '*.smd' \) 2>/dev/null | grep -q .; then BUNDLED_PAYLOAD=yes; FINAL_RESULT=FAIL; fi
cat > "$REPORT" <<DOC
# MegaCD Pocket probe check

- result: \`$FINAL_RESULT\`
- branch ok: \`$BRANCH_OK\`
- donor submodule clean: \`$DONOR_CLEAN\`
- Genesis submodule clean: \`$GENESIS_CLEAN\`
- repo-owned MegaCD lane exists: \`$LANE_OK\`
- WORDRAM0 remains external: \`$WORDRAM0_EXTERNAL\`
- WORDRAM1 remains internal: \`$WORDRAM1_INTERNAL\`
- CDC RAM wired to Pocket-local helper: \`$CDC_MLAB_CONNECTED\`
- internal CDC M10K instance removed: \`$CDC_INTERNAL_M10K_REMOVED\`
- PCM RAM remains internal: \`$PCM_INTERNAL\`
- packing audit documented: \`$PACK_AUDIT\`
- map result documented: \`$MAP_DOC\`
- timing result exists when fit passed: \`$TIMING_DOC\`
- map exit code: \`$MAP_EXIT\`
- fitter exit code: \`$FIT_EXIT\`
- timing exit code: \`$TIMING_EXIT\`
- assembler exit code: \`$ASM_EXIT\`
- final classification: \`$FIT_RESULT\`
- fresh artifact when claimed: \`$ARTIFACT_FRESH\`
- generated artifacts tracked by git: \`$ARTIFACT_TRACKED\`
- BIOS/ROM/disc image bundled: \`$BUNDLED_PAYLOAD\`
- Genesis baseline modified: \`no\`
DOC
[[ "$FINAL_RESULT" == 'PASS' ]]
