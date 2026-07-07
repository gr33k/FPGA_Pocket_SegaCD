# Docker openFPGA Genesis analysis-only status

Date: 2026-07-07

## Current run

- repo mount: `/Data/dockerprojects/FPGA_Pocket_SegaCD` → `/work`
- quartus install mount: `/root/fpga/intelFPGA_lite` → `/opt/intelFPGA_lite`
- action: blocked
- reason: `quartus_map` missing from mounted `/opt/intelFPGA_lite`
- analysis wrapper run: no
- fitter/assembler/timing/bitstream: no

## Required follow-up

- Run Dockerized install flow first so `quartus_map` becomes available.
