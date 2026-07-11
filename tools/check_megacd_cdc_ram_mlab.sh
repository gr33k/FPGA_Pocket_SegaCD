#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"
REPORT=docs/CHECK_MEGACD_CDC_RAM_MLAB.md
STATUS_DOC=docs/MEGACD_POCKET_FIT_STATUS.md
FIT_RESULT="$(sed -n 's/^- result: `\(.*\)`/\1/p' "$STATUS_DOC" | head -1)"
fail=0
module_file=yes; [[ -f src/megacd_pocket/fpga/core/rtl/pocket/megacd_cdc_ram_mlab.sv ]] || { module_file=no; fail=1; }
qsf_has=yes; rg -q 'megacd_cdc_ram_mlab\.sv' src/megacd_pocket/fpga/ap_core.qsf || { qsf_has=no; fail=1; }
external_ports=yes; rg -q 'EXT_CDC_RAM_A_RD|EXT_CDC_RAM_A_WR|EXT_CDC_RAM_DI|EXT_CDC_RAM_DO|EXT_CDC_RAM_WE' src/megacd_pocket/fpga/core/rtl/MCD/MCD.vhd || { external_ports=no; fail=1; }
internal_cdc_removed=yes; rg -q 'CDC_RAM\s*: entity work\.dpram_dif' src/megacd_pocket/fpga/core/rtl/MCD/MCD.vhd && { internal_cdc_removed=no; fail=1; }
wordram0_external=yes; rg -q 'EXT_WORDRAM0_A|EXT_WORDRAM0_DI|EXT_WORDRAM0_DO|EXT_WORDRAM0_WR' src/megacd_pocket/fpga/core/rtl/MCD/MCD.vhd || { wordram0_external=no; fail=1; }
wordram1_internal=yes; rg -q 'WORDRAM1\s*: entity work\.spram' src/megacd_pocket/fpga/core/rtl/MCD/MCD.vhd || { wordram1_internal=no; fail=1; }
pcm_internal=yes; rg -q 'PCM_RAM\s*: entity work\.dpram' src/megacd_pocket/fpga/core/rtl/MCD/MCD.vhd || { pcm_internal=no; fail=1; }
coretop_connected=yes; rg -q 'megacd_cdc_ram_mlab|EXT_CDC_RAM_A_RD|00E00018|00E0001C' src/megacd_pocket/fpga/core/core_top.sv || { coretop_connected=no; fail=1; }
tracked_artifacts=no
if git status --short -- build/megacd_pocket_artifacts build/pocket_sd_megacd_bios_probe | rg -q '^[AMDRCU?]'; then tracked_artifacts=yes; fail=1; fi
bundled_payload=no
if find build/pocket_sd_megacd_bios_probe -type f \( -iname '*.rom' -o -iname '*.iso' -o -iname '*.cue' -o -iname '*.chd' -o -iname '*.bin' -o -iname '*.gen' -o -iname '*.smd' \) 2>/dev/null | grep -q .; then bundled_payload=yes; fail=1; fi
submodules_clean=yes
if [[ -n "$(git status --short third_party/openFPGA-Genesis third_party/MegaCD_MiSTer 2>/dev/null)" ]]; then submodules_clean=no; fail=1; fi
cat > "$REPORT" <<DOC
# MegaCD CDC RAM MLAB check

- result: \`$([[ $fail -eq 0 ]] && echo PASS || echo FAIL)\`
- module file present: \`$module_file\`
- QSF includes CDC MLAB helper: \`$qsf_has\`
- MCD external CDC ports present: \`$external_ports\`
- internal CDC dpram removed: \`$internal_cdc_removed\`
- core_top wired to CDC MLAB helper: \`$coretop_connected\`
- WORDRAM0 remains external: \`$wordram0_external\`
- WORDRAM1 remains internal: \`$wordram1_internal\`
- PCM RAM remains internal: \`$pcm_internal\`
- generated artifacts tracked by git: \`$tracked_artifacts\`
- BIOS/ROM/disc payload bundled: \`$bundled_payload\`
- submodules clean: \`$submodules_clean\`
- latest fit classification: \`$FIT_RESULT\`
DOC
[[ $fail -eq 0 ]]
