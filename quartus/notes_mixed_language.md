# Mixed-language notes (documentation only)

Genesis_MiSTer runtime integration is expected to require mixed-language support.

- Verilog/SystemVerilog for core logic and many imported modules.
- VHDL dependencies for part of the runtime toolchain.

What this means now:

- `iverilog` / `Verilator` are useful for constrained, local probe work.
- They are not sufficient for validating the final mixed-language compile path.
- The placeholder `.qpf/.qsf/.sdc` files do not solve mixed-language file ordering yet.
- VHDL handling is still deferred to a future real Quartus/openFPGA flow.
- We do **not** modify or convert imported runtime RTL to make a local probe pass.
- We do **not** add fake/semi-real mixed-language adapters in this phase.
- Imported `third_party/Genesis_MiSTer` remains read-only for now.
- APF compatibility/wrapper logic remains outside `third_party`.

Current constraints:

- The file set created in Task 5W is non-buildable placeholder structure only.
- No real Quartus build exists in this milestone.
- No runtime compilation success is claimed.
- No game booting is claimed.

## Explicit blockers carried forward

- VHDL file ordering and dependency inclusion are not finalized.
- APF package, pinmap finalization, and timing closure remain pending.
