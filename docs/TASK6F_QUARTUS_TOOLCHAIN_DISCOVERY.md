# Task 6F: Quartus toolchain discovery

## Why Task 6F exists
Task 6E reported a clean preflight but no analysis run because `quartus_map` was not discoverable in this environment. That can happen even when Quartus is installed if binaries are outside `PATH`.

Task 6F makes the analysis runner resilient to installation/layout differences so the check can discover Quartus in common local setups without changing source files.

## Why discovery is needed
`quartus_map` can be unavailable to commands when:
- Quartus launch scripts were never sourced.
- The shell session did not inherit IDE-installed environment variables.
- The install is under versioned directories like `intelFPGA_lite` and not PATH-rooted.
- Only `qenv.sh`/`quartus_setenv` style setup exists.

## Updated discovery order
1. `QUARTUS_MAP` environment variable, if set and executable.
2. `QUARTUS_ROOTDIR` environment variable, checking:
   - `$QUARTUS_ROOTDIR/bin/quartus_map`
   - `$QUARTUS_ROOTDIR/quartus/bin/quartus_map`
3. `PATH` lookup (`command -v quartus_map`).
4. Common Linux locations:
   - `/opt/intelFPGA_lite/*/quartus/bin/quartus_map`
   - `/opt/intelFPGA/*/quartus/bin/quartus_map`
5. Common macOS locations:
   - `/Applications/IntelFPGA_lite/*/quartus/bin/quartus_map`
   - `/Applications/intelFPGA_lite/*/quartus/bin/quartus_map`
   - `/Applications/IntelFPGA/*/quartus/bin/quartus_map`

If multiple candidates are found, the first one in sorted order is selected. All discovered candidates are recorded in the result report.

## How to override discovery
You can force the runner to use a specific binary without editing scripts:

- `export QUARTUS_MAP=/path/to/desired/quartus_map`
- `export QUARTUS_ROOTDIR=/path/to/quartus/root`

`QUARTUS_MAP` has highest priority.

## Why this remains analysis-only
The runner still executes only:
- `quartus_map --analysis_and_elaboration FPGA_Pocket_SegaCD`

It never runs fitter, assembler, timing analysis, full synthesis, or APF packaging in this milestone.

## Why failure is still expected
Runtime integration is still inactive (`files_genesis_runtime.qsf` remains placeholder) and constraint files are still non-build markers. Full compile success is intentionally not expected from this scaffold stage.

## Why Genesis runtime remains read-only
`third_party/Genesis_MiSTer` is still imported only as an inactive source target and is not modified by this task.

## Exclusions retained
- No Sega CD/Mega-CD path is added.
- No 32X path is added.
- No SDRAM/PSRAM/SRAM memory-controller integration is added.

## Next task
Task 6G should classify any analysis errors into:
- APF scaffold issues,
- missing Genesis runtime dependency issues,
- constraint/project setup issues,
- expected-not-yet-active issues,
then update the source activation plan without modifying imported runtime RTL.
