# Quartus Docker image notes

This folder contains the non-sensitive Quartus build-host skeleton used for
analysis-only builds on an external host.

## What this image provides

- Ubuntu-based shell with helper tooling for Quartus validation scripts.
- Mount points expected by the workflow:
  - `/work` for repo checkout
  - `/installers` for local, user-supplied Quartus installer artifacts
  - `/opt/intelFPGA_lite` for installed Quartus

## What this image does not provide

- No Quartus installation.
- No `.run/.zip/.tar` installer payloads.
- No Quartus license files.
- No generated bitstreams or APF build outputs.

## Build command

```sh
docker build -t pocket-quartus-base -f docker/quartus/Dockerfile.ubuntu-quartus-base docker/quartus
```

## Runtime command (example)

```sh
docker run --rm -it \
  -v "$PWD":/work \
  -v "$HOME/fpga/installers":/installers \
  pocket-quartus-base
```
