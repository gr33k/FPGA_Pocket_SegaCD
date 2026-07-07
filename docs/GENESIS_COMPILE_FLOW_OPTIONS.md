# Genesis Compile Flow Options

## Task 5R update

- Task 5R adds that the likely long-term route is a Quartus/openFPGA project skeleton that owns final file ordering and mixed-language integration.
- This task still does not create any Quartus project files.
- The current runtime source lists remain inactive and are planning-only.

## Recommended near-term flow

1. Keep APF scaffold simulation tests (`Task 5F` and `Task 5H`) separate.
2. Keep real-runtime source-list drafts inactive (`.draft.f`) and planning-only.
3. Use Verilator or iverilog only for limited APF/SystemVerilog probing.
4. Keep mixed-language runtime files out of any activated synthesis flow until a project-capable flow is ready.
5. Treat VHDL-backed runtime dependencies as compile-flow blockers for local Verilog-only probes.

## Recommended later flow

1. Build a Quartus/openFPGA project skeleton at the integration boundary.
2. Add APF wrapper files and APF-specific glue.
3. Add imported `third_party/Genesis_MiSTer` runtime files in confirmed dependency order.
4. Add VHDL files through Quartus’s mixed-language mechanism.
5. Keep `third_party/Genesis_MiSTer` read-only and implement compatibility only in APF wrappers/adapters.

## Explicit constraints

- No game-boot milestone is claimed by this milestone.
- No synthesis success is claimed in this phase.
- No full runtime compile success is claimed in this phase.
- Sega CD/32X paths are intentionally excluded.
