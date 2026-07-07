# Next activation path after Task 6Q

Current milestone target remains blocked by missing local Quartus execution, so we
keep this stage as package/layout scaffolding.

## Immediate next steps (once Quartus-capable host is available)

1. Validate skeleton check remains PASS:
   - `tools/check_openfpga_package_skeleton.sh`
2. Add deterministic package copy step from `apf/` sources into
   `openfpga/FPGA_Pocket_SegaCD/apf/` for release packaging.
3. Add Quartus build/project hook to emit expected outputs into
   `openfpga/FPGA_Pocket_SegaCD/build/` (still no generated outputs committed
   until green-lit).
4. Restore/extend source-closure docs with exact manifest after real compile pass.

## Hard constraints

- No Sega-CD/32X at this stage.
- No save state support yet.
- No host-per-read ROM streaming.

