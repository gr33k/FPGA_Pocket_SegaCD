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
DONOR_SUBMODULE_LINE="$(git submodule status --recursive third_party/MegaCD_MiSTer 2>/dev/null || true)"
DONOR_STATUS_LINE="$(git status --short third_party/MegaCD_MiSTer || true)"
GENESIS_STATUS_LINE="$(git status --short third_party/Genesis_MiSTer || true)"
BRANCH_OK=no; DONOR_PIN_OK=no; DONOR_CLEAN=yes; GENESIS_CLEAN=yes; LANE_OK=no
WORDRAM0_EXTERNAL=no; WORDRAM1_INTERNAL=no; SRAM_ACTIVE=no; MEMORY_DOC=no; TIMING_DOC=no; ARTIFACT_FRESH=no
FINAL_RESULT=PASS
[[ "$(git branch --show-current)" == "feature/megacd-bringup" ]] && BRANCH_OK=yes || FINAL_RESULT=FAIL
[[ "$DONOR_SUBMODULE_LINE" == *'b1a0f1f42710dd0678c8432fee886b2da836b48c'* ]] && DONOR_PIN_OK=yes || FINAL_RESULT=FAIL
[[ -n "$DONOR_STATUS_LINE" ]] && DONOR_CLEAN=no && FINAL_RESULT=FAIL
[[ -n "$GENESIS_STATUS_LINE" ]] && GENESIS_CLEAN=no && FINAL_RESULT=FAIL
[[ -d src/megacd_pocket && -f src/megacd_pocket/fpga/core/core_top.sv ]] && LANE_OK=yes || FINAL_RESULT=FAIL
rg -q 'EXT_WORDRAM0_A|EXT_WORDRAM0_DI|EXT_WORDRAM0_DO|EXT_WORDRAM0_WR' src/megacd_pocket/fpga/core/rtl/MCD/MCD.vhd && WORDRAM0_EXTERNAL=yes || { WORDRAM0_EXTERNAL=no; FINAL_RESULT=FAIL; }
rg -q 'WORDRAM1\s*: entity work\.spram' src/megacd_pocket/fpga/core/rtl/MCD/MCD.vhd && WORDRAM1_INTERNAL=yes || { WORDRAM1_INTERNAL=no; FINAL_RESULT=FAIL; }
rg -q 'pocket_wordram0_sram|assign sram_a = wordram0_sram_a' src/megacd_pocket/fpga/core/core_top.sv && SRAM_ACTIVE=yes || { SRAM_ACTIVE=no; FINAL_RESULT=FAIL; }
[[ -f docs/MEGACD_WORDRAM0_MAP_RESULT.md ]] && MEMORY_DOC=yes || FINAL_RESULT=FAIL
if [[ "$FIT_EXIT" == '0' ]]; then
  [[ -f docs/MEGACD_WORDRAM0_TIMING_RESULT.md ]] && TIMING_DOC=yes || { TIMING_DOC=no; FINAL_RESULT=FAIL; }
else
  TIMING_DOC=not-required
fi
case "$FIT_RESULT" in
  WORDRAM0_EXTERNALIZATION_MAP_FAILED|WORDRAM0_MEMORY_REDUCTION_NOT_REALIZED|POCKET_MEMORY_CAPACITY_EXCEEDED_AFTER_WORDRAM0|FIT_FAIL_NON_MEMORY|POCKET_SRAM_INTERFACE_BLOCKED|FIT_PASS_TIMING_FAIL|BIOS_PROBE_ARTIFACT_READY|BIOS_PROBE_ARTIFACT_READY_WITH_TIMING_RISK|BIOS_PROBE_READY_FOR_POCKET) ;;
  *) FINAL_RESULT=FAIL ;;
esac
[[ -f build/megacd_pocket_artifacts/bitstream.rbf_r ]] && ARTIFACT_FRESH=yes || ARTIFACT_FRESH=no
ARTIFACT_TRACKED=no
if git status --short -- build/megacd_pocket_artifacts build/pocket_sd_megacd_bios_probe | rg -q '^[AMDRCU?]'; then ARTIFACT_TRACKED=yes; FINAL_RESULT=FAIL; fi
BUNDLED_PAYLOAD=no
if find build/pocket_sd_megacd_bios_probe -type f \( -iname '*.rom' -o -iname '*.iso' -o -iname '*.cue' -o -iname '*.chd' -o -iname '*.bin' -o -iname '*.gen' -o -iname '*.smd' \) 2>/dev/null | grep -q .; then BUNDLED_PAYLOAD=yes; FINAL_RESULT=FAIL; fi
cat > "$REPORT" <<DOC
# MegaCD Pocket probe check

- result: \`$FINAL_RESULT\`
- branch ok: \`$BRANCH_OK\`
- donor pinned correctly: \`$DONOR_PIN_OK\`
- donor submodule clean: \`$DONOR_CLEAN\`
- Genesis submodule clean: \`$GENESIS_CLEAN\`
- repo-owned MegaCD lane exists: \`$LANE_OK\`
- WORDRAM0 externalized: \`$WORDRAM0_EXTERNAL\`
- WORDRAM1 remains internal: \`$WORDRAM1_INTERNAL\`
- Pocket SRAM actively connected: \`$SRAM_ACTIVE\`
- memory reduction documented: \`$MEMORY_DOC\`
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
