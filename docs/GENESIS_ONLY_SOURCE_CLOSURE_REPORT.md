# Genesis-only source-closure report

Report date: 2026-07-06

## Source modules in scope

- APF wrapper scaffolding:
  - `apf/src/fpga/core/core_top.v`
  - `apf/src/fpga/core/rom_local_service_stub.v`
  - `apf/src/fpga/core/rom_preload_ingress_stub.v`
  - `apf/src/fpga/core/rom_tiny_local_ram_stub.v`
  - `apf/src/fpga/core/apf_scaffold_sources.f`
- Package and docs:
  - `openfpga/FPGA_Pocket_SegaCD/`
  - docs/*6Q task files
- Runtime integration focus:
  - `third_party/openFPGA-Genesis`

## Scope constraints kept

- No Sega-CD/Mega-CD runtime paths
- No save-state implementation
- No VGM/CDDA/PCM sub-systems
- No real APF data-slot host streaming at runtime
- No generated Quartus bitstreams in source closure

## OpenFPGA-Genesis source focus

- Primary runtime source direction is `third_party/openFPGA-Genesis` and this is now the active focus for the next activation pass.
- `third_party/Genesis_MiSTer` is retained as historical/reference material only.
- Runtime build activation remains deferred until full Quartus-capable lane activation is executed.
- Closure tasks now begin with:
  - module/path confirmation in `docs/OPENFPGA_GENESIS_SOURCE_MANIFEST.md`
  - submodule status in `docs/OPENFPGA_GENESIS_SUBMODULE_STATUS.md`

## Task 6Q additions (non-breaking)

- Package skeleton directory and readmes added as inactive placeholders.
- New non-blocking skeleton checker added.
- Status/docs updated to capture the package layout as a hard boundary.

## Closure note

The closure remains APF-runtime scaffold-only with a new primary source-lane focus:
`third_party/openFPGA-Genesis` for future compile-driven activation.
