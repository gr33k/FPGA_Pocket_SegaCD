# Quartus Docker Workflow (Project Utilities)

This directory contains the optional Docker scaffold for Quartus-host execution on a
non-native build machine (for example, Fedora NAS). It does not install Quartus or
store any proprietary Intel files in the repository.

## Current scope

- Build and validation workflow scaffolding for Task 6S.
- No Quartus binaries, license files, or bitstream outputs are checked in.
- No runtime or APF synthesis logic is added here.

## Paths

- `docker/quartus/Dockerfile.ubuntu-quartus-base`
- `docker/quartus/README.md`
- `docker/quartus/.gitignore`
- `docs/FEDORA_NAS_DOCKER_QUARTUS_WORKFLOW.md`
- `tools/check_quartus_docker_workflow.sh`
- `tools/run_quartus_docker_dryrun.sh`

## Check commands

```sh
chmod +x tools/check_quartus_docker_workflow.sh
chmod +x tools/run_quartus_docker_dryrun.sh
tools/check_quartus_docker_workflow.sh
tools/run_quartus_docker_dryrun.sh
```

## Repository rules

- Generated Quartus artifacts remain ignored and are not committed.
- Intel Quartus installer files are downloaded outside this repo and mounted at run time.
- This scaffold is a helper only; real synthesis is still blocked until the external
  Quartus-capable host is used.
