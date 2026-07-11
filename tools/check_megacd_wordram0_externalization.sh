#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"
report="docs/CHECK_MEGACD_WORDRAM0_EXTERNALIZATION.md"
fail=0
review=0
file_exists=no; [[ -f src/megacd_pocket/fpga/core/rtl/pocket/pocket_wordram0_sram.sv ]] && file_exists=yes || fail=1
qsf_has=no; rg -q 'pocket_wordram0_sram\.sv' src/megacd_pocket/fpga/ap_core.qsf && qsf_has=yes || fail=1
wordram0_removed=yes; rg -q 'WORDRAM0\s*: entity work\.spram' src/megacd_pocket/fpga/core/rtl/MCD/MCD.vhd && { wordram0_removed=no; fail=1; }
wordram1_present=no; rg -q 'WORDRAM1\s*: entity work\.spram' src/megacd_pocket/fpga/core/rtl/MCD/MCD.vhd && wordram1_present=yes || fail=1
mcd_ports=no; rg -q 'EXT_WORDRAM0_A|EXT_WORDRAM0_DI|EXT_WORDRAM0_DO|EXT_WORDRAM0_WR' src/megacd_pocket/fpga/core/rtl/MCD/MCD.vhd && mcd_ports=yes || fail=1
coretop_connected=no; rg -q 'pocket_wordram0_sram|EXT_WORDRAM0_A|00E00010|00E00014' src/megacd_pocket/fpga/core/core_top.sv && coretop_connected=yes || fail=1
sram_tied_off=no; rg -q "assign sram_a = 'h0|assign sram_oe_n = 1'b1; assign sram_we_n = 1'b1" src/megacd_pocket/fpga/core/core_top.sv && sram_tied_off=yes
[[ "$sram_tied_off" == yes ]] && fail=1
duplicate_drivers=no
core_top_driver_count=$(rg -n 'assign sram_a|assign sram_dq|assign sram_oe_n|assign sram_we_n|assign sram_ub_n|assign sram_lb_n' src/megacd_pocket/fpga/core/core_top.sv | wc -l | tr -d ' ')
adapter_driver_count=$(rg -n 'assign sram_a|assign sram_dq|assign sram_oe_n|assign sram_we_n|assign sram_ub_n|assign sram_lb_n' src/megacd_pocket/fpga/core/rtl/pocket/pocket_wordram0_sram.sv | wc -l | tr -d ' ')
[[ "$core_top_driver_count" -gt 5 || "$adapter_driver_count" -ne 6 ]] && { duplicate_drivers=yes; fail=1; }
sub_open_clean=yes; [[ -n "$(git status --short third_party/openFPGA-Genesis || true)" ]] && { sub_open_clean=no; fail=1; }
sub_mcd_clean=yes; [[ -n "$(git status --short third_party/MegaCD_MiSTer || true)" ]] && { sub_mcd_clean=no; fail=1; }
tracked_payloads=no
if git ls-files | rg -q '\.(rom|iso|cue|chd|bin|gen|smd)$'; then tracked_payloads=yes; review=1; fi
result=PASS
[[ $fail -eq 1 ]] && result=FAIL
[[ $fail -eq 0 && $review -eq 1 ]] && result=REVIEW
cat > "$report" <<DOC
# MegaCD WordRAM0 externalization check

- result: \`$result\`
- adapter exists: \`$file_exists\`
- QSF includes adapter: \`$qsf_has\`
- WORDRAM0 internal spram removed: \`$wordram0_removed\`
- WORDRAM1 internal spram remains: \`$wordram1_present\`
- MCD exposes external bank-zero ports: \`$mcd_ports\`
- core top connects external bank-zero: \`$coretop_connected\`
- physical SRAM tied off: \`$sram_tied_off\`
- duplicate SRAM driver risk: \`$duplicate_drivers\`
- openFPGA submodule clean: \`$sub_open_clean\`
- MegaCD donor submodule clean: \`$sub_mcd_clean\`
- tracked BIOS/ROM/disc payloads: \`$tracked_payloads\`
DOC
exit 0
