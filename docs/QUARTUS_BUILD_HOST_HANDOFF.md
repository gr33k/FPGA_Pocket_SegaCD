# Quartus build-host handoff (Genesis-only)

This repository is prepared for a Quartus-capable host, but no analysis is claimed
in this task.

## Host prerequisites

- `git`
- initialized submodules (`third_party/Genesis_MiSTer`)
- Quartus with `quartus_map` available
- local clone of this repository

## Host commands

```sh
git pull
git submodule update --init --recursive
tools/check_genesis_only_project_flow.sh
tools/check_openfpga_package_skeleton.sh
tools/validate_local_quartus_toolchain.sh
tools/run_quartus_analysis_only_if_available.sh
```

## First Quartus goal

- `quartus_map --analysis_and_elaboration` only.

## Do not run on this host path

- fitter
- assembler
- timing analysis
- full packaging
- any fake artifact generation

## Error capture

- Capture first returned error output and next-step decisions in your local result
  notes.
- Do not commit generated outputs from failed runs.

