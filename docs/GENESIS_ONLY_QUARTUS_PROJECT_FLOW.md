# Genesis-only Quartus project flow (host guidance)

This flow is for a Quartus-capable host only.

## 1) Enter project directory

```sh
cd /path/to/FPGA_Pocket_SegaCD/quartus
```

## 2) Open/create the project

- Use Quartus GUI or CLI to open `FPGA_Pocket_SegaCD.qsf` in a new project context.

## 3) Apply project skeleton

```sh
# Host-side guidance (exact Quartus command form depends on your local environment)
quartus_sh --flow compile \
  -c FPGA_Pocket_SegaCD
```

## 4) Apply scaffold/runtime source lists in order

Apply in this sequence before analysis/elaboration:

1. `files_apf_scaffold.qsf`
2. `files_genesis_runtime.qsf`
3. `files_constraints.qsf`

## 5) Run analysis/elaboration only

- Run a host-equivalent equivalent analysis/elaboration command (no fitter).
- Capture missing-module/ordering/constraint errors.
- Stop at first-pass blockers and update source list only by evidence.

## 6) What not to run (in this milestone)

- No fitter
- No assembler
- No timing analysis
- No openFPGA packaging output generation
- No synthesis claiming until evidence proves readiness

## 7) Hygiene after run

- Confirm no generated `quartus` artifacts are committed (`*.sof`, `*.pof`, `quartus/db`, `quartus/output_files`, etc.).
- Keep the pre-check docs aligned with what the host emits.

## 8) Recovery path when no toolchain

If Quartus is unavailable:

- Re-run local no-Quartus check only.
- Update status docs with blocker state.
- Retry flow from Step 1 on a supported host.
