# APF Scaffold Active Source Status

## Active APF scaffold sources

- `apf/src/fpga/core/core_top.v`
- `apf/src/fpga/core/rom_preload_ingress_stub.v`
- `apf/src/fpga/core/rom_local_service_stub.v`
- `apf/src/fpga/core/rom_tiny_local_ram_stub.v`
- `apf/apf_genesis_base.sv`

These are the only files activated via `quartus/files_apf_scaffold.qsf` as of Task 6A-6B.

## Inactive runtime source root

- `quartus/files_genesis_runtime.qsf` remains a non-buildable placeholder.
- No `third_party/Genesis_MiSTer` runtime files are active in Quartus scaffolds yet.

## Inactive runtime dependencies

- Full Genesis runtime (`rtl/system.sv` and required upstream modules) is not active in this scaffold.
- Runtime dependency activation is planned for later tasks.

## Inactive constraints

- `quartus/FPGA_Pocket_SegaCD.sdc`
- `quartus/files_constraints.qsf`

## Inactive APF packaging

- No Quartus/openFPGA package/tcl wrapper is active.
- No synthesis/build automation has been enabled.

## Key limitation

`apf/apf_genesis_base.sv` still depends on imported runtime entry points such as `system.sv`.
A structural scaffold can be prepared, but real runtime compilation is still expected to fail until runtime sources are activated.

## Explicit non-goals

- No synthesis success is claimed.
- No gameplay boot is claimed.
- No Sega-CD / 32X runtime path is active.
- No memory-controller integration is active.
