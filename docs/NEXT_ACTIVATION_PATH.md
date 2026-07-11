# Next activation path after Task 9C

- stay on branch: `feature/megacd-bringup`
- do not relaunch the old pre-WordRAM0 fit
- WORDRAM0 remains external on Pocket SRAM
- WORDRAM1 remains internal
- PCM RAM remains internal
- CDC RAM is now Pocket-local MLAB-backed
- current result: `BIOS_PROBE_ARTIFACT_READY`
- staged Pocket folder: `build/pocket_sd_megacd_bios_probe/`
- next human action: copy the staged folder to the Pocket SD root, provide one Sega CD BIOS externally, and run the BIOS/no-disc hardware probe
- do not claim disc service, CUE/CHD support, CDDA, or 32X
