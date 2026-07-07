# Task 7E: Dockerized Quartus installer/run workflow

This workflow keeps Quartus isolated in Docker while keeping the repo and all source checkout clean.

## What this workflow does

- Installs Intel Quartus Lite inside a container using a user-supplied installer.
- Installs Quartus into a host-persisted directory:
  - `/root/fpga/intelFPGA_lite`
- Runs the existing analysis-only wrapper from inside the container:
  - `tools/run_openfpga_genesis_analysis_only.sh`
  - `tools/check_openfpga_genesis_analysis_runner.sh`

## Important: installer still required

Docker does **not** provide the Intel installer.

- The installer must be provided by the operator and placed at:
  - `/root/fpga/installers`
- Supported filename patterns:
  - `*quartus*.run`, `*quartus*.sh`, `*Quartus*.run`, `*Quartus*.sh`, `*Quartus*.tar`, `*Quartus*.tar.gz`
- If no file is found, scripts will hard-stop and write blocker status.

## Install path (host)

- Quartus install output is mounted/persisted in:
  - `/root/fpga/intelFPGA_lite`
- Install script mount points:
  - `/root/fpga/installers` → `/installers` (read-only)
  - `/root/fpga/intelFPGA_lite` → `/opt/intelFPGA_lite` (read-write)

## Running install

```sh
cd /Data/dockerprojects/FPGA_Pocket_SegaCD
chmod +x tools/docker_install_quartus_lite.sh
tools/docker_install_quartus_lite.sh
```

Optional override for installer arguments:

```sh
QUARTUS_INSTALL_ARGS='--mode unattended --accept_eula 1 --installdir /opt/intelFPGA_lite' tools/docker_install_quartus_lite.sh
```

Outputs:

- `docs/DOCKER_QUARTUS_INSTALL_STATUS.md`
- `docs/DOCKER_QUARTUS_INSTALLER_HELP.txt`

## Running analysis-only through Docker

```sh
chmod +x tools/docker_run_openfpga_genesis_analysis_only.sh
tools/docker_run_openfpga_genesis_analysis_only.sh
```

Outputs:

- `docs/DOCKER_OPENFPGA_GENESIS_ANALYSIS_STATUS.md`

## Safety rules

- No fitter, assembler, timing, or bitstream generation.
- No ROM, BIOS, CD image, or large payload commits.
- No Quartus installer committed to git.
- No installed Quartus tree committed to git.
- No submodule/runtime source edits for `third_party/openFPGA-Genesis` or `third_party/Genesis_MiSTer`.

## Success criteria

- `docs/DOCKER_QUARTUS_INSTALL_STATUS.md` shows:
  - installer found
  - install attempted = yes
  - `quartus_map` found with executable path and version
- `tools/docker_run_openfpga_genesis_analysis_only.sh` runs analysis wrapper.
- `docs/DOCKER_OPENFPGA_GENESIS_ANALYSIS_STATUS.md` reports analysis execution state.

## Blocked criteria

- No installer in `/root/fpga/installers`.
- Host Docker unavailable.
- Installer reports no safe unattended option and no `QUARTUS_INSTALL_ARGS` override.
- `quartus_map` missing in mounted `/opt/intelFPGA_lite`.
