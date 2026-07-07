# Local Quartus Setup

## Check Quartus availability

```bash
which quartus_map
quartus_map --version
```

If this prints a valid path and version, Quartus may already be discoverable.

## Set explicit Quartus path

### QUARTUS_MAP

```bash
export QUARTUS_MAP=/path/to/quartus_map
```

### QUARTUS_ROOTDIR

```bash
export QUARTUS_ROOTDIR=/path/to/quartus
```

`QUARTUS_MAP` is preferred when present; otherwise `QUARTUS_ROOTDIR` is used as fallback by the local validation/check scripts.

## macOS example

```bash
export QUARTUS_ROOTDIR=/Applications/IntelFPGA_lite/22.1std/quartus
export QUARTUS_MAP=/Applications/IntelFPGA_lite/22.1std/quartus/bin/quartus_map
```

## Linux example

```bash
export QUARTUS_ROOTDIR=/opt/intelFPGA_lite/22.1std/quartus
export QUARTUS_MAP=/opt/intelFPGA_lite/22.1std/quartus/bin/quartus_map
```

## Validation command

```bash
tools/validate_local_quartus_toolchain.sh
```

## Analysis command after validation

```bash
tools/run_quartus_analysis_only_if_available.sh
```

## Important constraints

- Do not run full synthesis in this milestone.
- Do not run fitter.
- Do not run assembler.
- Do not generate APF packaging output.
- This workflow is advisory until toolchain discovery and analysis results are verified.
- Do not commit generated Quartus outputs.
