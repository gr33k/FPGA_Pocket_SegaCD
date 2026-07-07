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

## Scope constraints kept

- No Sega-CD/Mega-CD runtime paths
- No save-state implementation
- No VGM/CDDA/PCM sub-systems
- No real APF data-slot host streaming at runtime
- No generated Quartus bitstreams in source closure

## Runtime source direction (Task 6V)

- Active runtime source direction is now `third_party/openFPGA-Genesis` as a submodule target.
- `third_party/Genesis_MiSTer` is retained only as an historical reference in docs/manifests.
- Runtime build activation remains deferred until the openFPGA submodule is available.

## Task 6Q additions (non-breaking)

- Package skeleton directory and readmes added as inactive placeholders.
- New non-blocking skeleton checker added.
- Status/docs updated to capture the package layout as a hard boundary.

## Closure note

The closure remains APF-runtime scaffold only and does not include imported
Genesis_MiSTer runtime files yet.
