# Quartus build-host handoff (Genesis-only)

This repository is prepared for a Quartus-capable host, but no analysis is claimed
in this task.

## Preferred host execution path (Task 6S+)

- Use Fedora NAS Docker workflow by default:
  - `tools/check_quartus_docker_workflow.sh`
  - `tools/run_quartus_docker_dryrun.sh`
  - `docker build ...` + `docker run ...` as documented in
    `docs/FEDORA_NAS_DOCKER_QUARTUS_WORKFLOW.md`
  - inside container: `tools/validate_local_quartus_toolchain.sh`
  - inside container: `tools/run_quartus_analysis_only_if_available.sh`

## Host prerequisites

- `git`
- initialized submodules (`third_party/Genesis_MiSTer`)
- Quartus with `quartus_map` available
- local clone of this repository

## Native host fallback

- If Docker is unavailable locally, run the same check commands directly on a native
  Quartus-capable host and keep the same non-run steps.

## Host commands

```sh
cd /path/to/repo
tools/check_quartus_docker_workflow.sh
tools/run_quartus_docker_dryrun.sh
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
- any Quartus-generated outputs in git-tracked paths

## Error capture

- Capture first returned error output and next-step decisions in your local result
  notes.
- Do not commit generated outputs from failed runs.
- Keep first run to analysis/elaboration only.
