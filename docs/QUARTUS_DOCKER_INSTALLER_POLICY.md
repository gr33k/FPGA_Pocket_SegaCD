# Quartus installer policy for Docker-hosted build prep

## Firm rules

- Do not commit Intel Quartus installer artifacts.
- Do not commit installed Quartus directories.
- Do not commit Quartus license files.
- Do not publish or commit Docker images containing Quartus tool binaries.
- Do not commit generated Quartus outputs in this scaffold pass.

## Allowed in repo

- `docker/quartus/Dockerfile.ubuntu-quartus-base`
- helper shell scripts for mounting/building
- installer policy docs
- ignored working directories declared in `.gitignore`

## Policy notes

- The repo stores only build instructions and ignore metadata for toolchain packaging.
- Runtime outputs (bitstreams, Quartus DB directories, and reports) are kept out of
  version control until the explicit release workflow is approved.
- A future host run may still require temporary local Quartus output directories; these
  must stay under ignored paths.
