# Mixed-language notes (documentation only)

Genesis_MiSTer runtime integration is expected to require mixed-language support:

- Verilog/SystemVerilog for core logic and many imported modules.
- VHDL dependencies for part of the runtime toolchain.

What this means for this milestone:

- `iverilog` / `Verilator` are useful for constrained, local probe work.
- They are not sufficient for validating the final mixed-language compile path.
- The final mixed-language setup belongs to the future Quartus/openFPGA project configuration.
- We do **not** modify or convert imported runtime RTL to make a local probe pass.
- We do **not** stub/replace missing mixed-language dependencies only to pass a probe.
- Imported `third_party/Genesis_MiSTer` remains read-only for this phase.
- APF compatibility/wrapper logic remains outside `third_party`.

Current constraints:

- No real Quartus project exists yet.
- No `.qpf/.qsf/.sdc/.tcl` project files are added now.
- No synthesis is attempted in this task.
- No build/runtime claims are made from this step.

