# Task 7A Quartus analysis-run status

Date: 2026-07-07

## Quartus discovery

- Local `quartus_map`: not found.
  - Checked `command -v quartus_map`.
  - Checked `find /Applications /opt /Users/phassold -path '*quartus/bin/quartus_map'` (bounded, no matches in checked locations).
- NAS `quartus_map`: not found.
  - Checked `command -v quartus_map` on `root@192.168.10.144`.
  - Checked `find /opt /root/fpga /Data /mnt /srv -path "*quartus/bin/quartus_map"` (no matches).
- Installer artifacts: not found.
  - Searched `/root/fpga/installers`, `/Data`, `/mnt`, `/srv`, `/opt` for `*quartus*.run` / `*quartus*.sh` / `*Quartus*.run` / `*Quartus*.sh`.
  - Only repository scripts containing `quartus` filenames were found.

## Runner execution

- Runner command: `tools/run_openfpga_genesis_analysis_only.sh`
- Command behavior remains: read-only source from `third_party/openFPGA-Genesis/src/fpga`, disposable work dir `build/openfpga_genesis_analysis_work/src/fpga`.
- Analysis status: BLOCKED.
- Blocker: `quartus_map not found`.
- Runner check report: `docs/OPENFPGA_GENESIS_ANALYSIS_RUNNER_CHECK.md`.

## Safety constraints check

- Fitter/assembler/timing/bitstream: not run.
- Analysis-only command only: `quartus_map ... --analysis_and_elaboration` in runner.
- `third_party/openFPGA-Genesis` remains clean/read-only in this flow.
- `third_party/Genesis_MiSTer` remains reference-only.
- Sega CD / 32X remain excluded.

## Evidence files

- `docs/OPENFPGA_GENESIS_ANALYSIS_ONLY_STATUS.md`
- `docs/OPENFPGA_GENESIS_ANALYSIS_ONLY_LOG.txt`

## Result

Task 7A currently blocked on Quartus availability; no RTL analysis started.
