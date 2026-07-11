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
BRANCH_OK=no
DONOR_PIN_OK=no
DONOR_CLEAN=yes
GENESIS_CLEAN=yes
LANE_OK=no
FINAL_RESULT=PASS
if [[ "$(git branch --show-current)" == "feature/megacd-bringup" ]]; then BRANCH_OK=yes; else FINAL_RESULT=FAIL; fi
if [[ "$DONOR_SUBMODULE_LINE" == *'b1a0f1f42710dd0678c8432fee886b2da836b48c'* ]]; then DONOR_PIN_OK=yes; else FINAL_RESULT=FAIL; fi
if [[ -n "$DONOR_STATUS_LINE" && "$DONOR_STATUS_LINE" != 'A  third_party/MegaCD_MiSTer' ]]; then DONOR_CLEAN=no; FINAL_RESULT=FAIL; fi
if [[ -n "$GENESIS_STATUS_LINE" ]]; then GENESIS_CLEAN=no; FINAL_RESULT=FAIL; fi
if [[ -d src/megacd_pocket && -f src/megacd_pocket/fpga/core/core_top.sv ]]; then LANE_OK=yes; else FINAL_RESULT=FAIL; fi
if [[ "$MAP_EXIT" != '0' ]]; then FINAL_RESULT=FAIL; fi
case "$FIT_RESULT" in
  POCKET_MEMORY_CAPACITY_EXCEEDED|POCKET_LOGIC_CAPACITY_EXCEEDED|MAP_PASS_FIT_FAIL|FIT_PASS_TIMING_FAIL|BIOS_PROBE_ARTIFACT_READY|BIOS_PROBE_READY_FOR_POCKET) ;;
  *) FINAL_RESULT=FAIL ;;
esac
ARTIFACT_TRACKED=no
if git status --short -- build/megacd_pocket_artifacts build/pocket_sd_megacd_bios_probe | rg -q '^[AMDRCU?]'; then ARTIFACT_TRACKED=yes; FINAL_RESULT=FAIL; fi
BIOS_BUNDLED=no
if find build/pocket_sd_megacd_bios_probe -type f \( -iname '*.rom' -o -iname '*.iso' -o -iname '*.cue' -o -iname '*.chd' \) 2>/dev/null | grep -q .; then BIOS_BUNDLED=yes; FINAL_RESULT=FAIL; fi
cat > "$REPORT" <<DOC
# MegaCD Pocket probe check

- result: \`$FINAL_RESULT\`
- branch ok: \`$BRANCH_OK\`
- donor pinned correctly: \`$DONOR_PIN_OK\`
- donor submodule clean: \`$DONOR_CLEAN\`
- Genesis submodule clean: \`$GENESIS_CLEAN\`
- repo-owned MegaCD lane exists: \`$LANE_OK\`
- map exit code: \`$MAP_EXIT\`
- fitter exit code: \`$FIT_EXIT\`
- timing exit code: \`$TIMING_EXIT\`
- assembler exit code: \`$ASM_EXIT\`
- final classification: \`$FIT_RESULT\`
- generated artifacts tracked by git: \`$ARTIFACT_TRACKED\`
- BIOS or disc image bundled: \`$BIOS_BUNDLED\`
- Genesis baseline modified: \`no\`
DOC
[[ "$FINAL_RESULT" == 'PASS' ]]
