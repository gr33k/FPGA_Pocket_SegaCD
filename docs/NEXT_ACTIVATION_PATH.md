# Next activation path after Task 9A-X harvest

- stay on branch: `feature/megacd-bringup`
- do not relaunch the old MegaCD fit on the unchanged tree
- first real engineering step: externalize MegaCD internal RAMs from the repo-owned lane in `src/megacd_pocket/fpga/core/rtl/MCD/MCD.vhd`
- start with `WORDRAM0` and `WORDRAM1`
- then move `CDC_RAM`, `PCM_RAM`, and the `BRAM_*` path off internal block memory
- keep the known-good Genesis baseline on `main` untouched
- after the RAM refactor, rerun `tools/run_megacd_pocket_fit_probe.sh`
- only stage `tools/stage_megacd_bios_probe.sh` after a fresh assembler-generated `build/megacd_pocket_artifacts/bitstream.rbf_r` exists
