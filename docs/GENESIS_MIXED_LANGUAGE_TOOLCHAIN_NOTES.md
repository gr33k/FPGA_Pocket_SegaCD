# Genesis Mixed-Language Toolchain Notes

## Task 5R update

- Task 5R establishes Quartus/openFPGA project planning as the preferred future mixed-language integration path.
- Verilator and iverilog remain limited, advisory probes only.

## Option 1: Quartus project flow (recommended long-term)

- Most likely required eventually for Analogue Pocket/openFPGA build.
- Can handle mixed-language flow with correct project setup.
- Should own final synthesis file order and device-level integration.
- Not created or edited in this task.

## Option 2: GHDL + Verilog/SystemVerilog bridge strategy

- Useful to validate VHDL units and inspect VHDL-level dependency shape.
- Not typically a complete substitute for full vendor FPGA synthesis flow.
- Helpful as a future investigation path, especially to isolate VHDL failures.

## Option 3: Verilator-only probe

- Useful for Verilog/SystemVerilog lint/probe and APF boundary sanity.
- Does not process VHDL-backed runtime modules.
- Best used for scaffold-only sanity and fast pre-checks.

## Option 4: iverilog-only probe

- Useful for limited Verilog/SystemVerilog syntax checks.
- Not suitable for VHDL support.
- May also be limited for full SystemVerilog constructs used in runtime.

## Option 5: Commercial mixed-language simulators

- Examples: Questa, ModelSim, Riviera, etc.
- Can handle mixed-language simulation depending on license and configuration.
- Useful for deeper mixed-language verification in a future stage.
- Not configured in this repo at this time.
