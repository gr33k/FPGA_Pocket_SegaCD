# Next activation path after Task 9B

- stay on branch: `feature/megacd-bringup`
- do not relaunch the old pre-WordRAM0 fit
- do not move `WORDRAM1` onto the same Pocket SRAM bus in the next step
- next safe memory-reduction target: `CDC_RAM` or `PCM_RAM`
- goal of the next step: reduce `M10K blocks` from `325` to `308` or lower
- keep the known-good Genesis baseline on `main` untouched
- only stage `tools/stage_megacd_bios_probe.sh` after a fresh assembler-generated `build/megacd_pocket_artifacts/bitstream.rbf_r` exists
