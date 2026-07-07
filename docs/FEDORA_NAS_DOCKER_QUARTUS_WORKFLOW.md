# Fedora NAS Docker Quartus workflow (Genesis-only scaffold)

## Prerequisites

- Fedora NAS with Docker installed.
- This repository cloned and writable on the NAS.
- Quartus installer downloaded by the user outside git (do not commit it).
- `git` and `git-lfs` available on the host.

## Build the base image

```sh
docker build -t pocket-quartus-base \
  -f docker/quartus/Dockerfile.ubuntu-quartus-base \
  docker/quartus
```

## Run container with mounts

```sh
docker run --rm -it \
  -v "$PWD":/work \
  -v "$HOME/fpga/installers":/installers \
  pocket-quartus-base bash
```

## Inside container

```sh
cd /work
git submodule update --init --recursive
find /opt -iname quartus_map -type f 2>/dev/null || true
```

## Installer policy

The installer is always user-provided and mounted at `/installers`.
It is not to be added to git.

Expected local policy:
- Download Quartus installer directly from Intel to a user-local directory.
- Do not commit `.run/.zip/.tar/.tar.gz/.rpm/.deb` files.
- Mount installer into container when needed.
- Install toolchain in `/opt/intelFPGA_lite` (or mount/point to that path).

## Validation commands (container-safe)

```sh
tools/validate_local_quartus_toolchain.sh
tools/run_quartus_analysis_only_if_available.sh
```

## Note

This stage remains analysis/elaboration-only planning and preflight for Task 6T and
beyond. It does not run full synthesis or produce a bitstream in this repository.
