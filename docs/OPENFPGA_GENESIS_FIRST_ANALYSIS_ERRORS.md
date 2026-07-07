# Task 7B: openFPGA Genesis first-analysis errors

## Status

- Analysis-elaboration did not run.
- Blocker: no Quartus Lite installer and no `quartus_map` available on NAS.

## Local status

- `command -v quartus_map`: no output.
- Local install search found no `quartus_map` binary in checked paths.

## NAS status

- `command -v quartus_map`: no output.
- `find /opt /root/fpga /Data /mnt /srv -path "*quartus/bin/quartus_map"` returned no hits.
- Installer search under:
  - `/root/fpga/installers`
  - `/Data`
  - `/mnt`
  - `/srv`
  - `/opt`
  found no installer (`*.run`, `*.sh`, `*.tar`, `*.tar.gz`).

## Error evidence

No Quartus compile was executed, so there are no Quartus diagnostics to classify yet.

## Recommended next action

1. Place Quartus Prime Lite installer into `/root/fpga/installers`.
2. Re-run documented install flow, then:
   - `tools/run_openfpga_genesis_analysis_only.sh`
   - `tools/check_openfpga_genesis_analysis_runner.sh`
3. If Quartus runs and fails, capture first meaningful errors into this file and classify the primary root cause.
