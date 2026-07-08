# openFPGA Genesis analysis warning summary

Generated: 2026-07-08 06:20:14 UTC
Source: docs/OPENFPGA_GENESIS_ANALYSIS_ONLY_LOG.txt

Total warnings: 72

## By warning code

- code 10030: 13
  - class: needs review before fitter
  - example(s):
    - Warning (10030): Net "rom_data2" at core_top.sv(870) has no driver or initial value, using a default initial value '0' File: /work/build/openfpga_genesis_analysis_work/src/fpga/core/core_top.sv Line: 870
    - Warning (10030): Net "rom_rdack2" at core_top.sv(872) has no driver or initial value, using a default initial value '0' File: /work/build/openfpga_genesis_analysis_work/src/fpga/core/core_top.sv Line: 872
    - Warning (10030): Net "host_4C" at core_bridge_cmd.v(116) has no driver or initial value, using a default initial value '0' File: /work/build/openfpga_genesis_analysis_work/src/fpga/core/core_bridge_cmd.v Line: 116

- code 10036: 12
  - class: likely harmless inherited upstream warning
  - example(s):
    - Warning (10036): Verilog HDL or VHDL warning at core_top.sv(454): object "cs_m30_map_enable" assigned a value but never read File: /work/build/openfpga_genesis_analysis_work/src/fpga/core/core_top.sv Line: 454
    - Warning (10036): Verilog HDL or VHDL warning at core_bridge_cmd.v(109): object "host_24" assigned a value but never read File: /work/build/openfpga_genesis_analysis_work/src/fpga/core/core_bridge_cmd.v Line: 109
    - Warning (10036): Verilog HDL or VHDL warning at core_bridge_cmd.v(110): object "host_28" assigned a value but never read File: /work/build/openfpga_genesis_analysis_work/src/fpga/core/core_bridge_cmd.v Line: 110

- code 10230: 32
  - class: likely harmless inherited upstream warning
  - example(s):
    - Warning (10230): Verilog HDL assignment warning at core_top.sv(460): truncated value with size 32 to match size of target (12) File: /work/build/openfpga_genesis_analysis_work/src/fpga/core/core_top.sv Line: 460
    - Warning (10230): Verilog HDL assignment warning at core_top.sv(462): truncated value with size 32 to match size of target (16) File: /work/build/openfpga_genesis_analysis_work/src/fpga/core/core_top.sv Line: 462
    - Warning (10230): Verilog HDL assignment warning at core_top.sv(525): truncated value with size 32 to match size of target (10) File: /work/build/openfpga_genesis_analysis_work/src/fpga/core/core_top.sv Line: 525

- code 10259: 1
  - class: needs review before fitter
  - example(s):
    - Warning (10259): Verilog HDL error at sdram.sv(82): constant value overflow File: /work/build/openfpga_genesis_analysis_work/src/fpga/core/rtl/sdram.sv Line: 82

- code 10762: 4
  - class: likely harmless inherited upstream warning
  - example(s):
    - Warning (10762): Verilog HDL Case Statement warning at core_top.sv(303): can't check case statement for completeness because the case expression has too many possible states File: /work/build/openfpga_genesis_analysis_work/src/fpga/core/core_top.sv Line: 303
    - Warning (10762): Verilog HDL Case Statement warning at core_top.sv(466): can't check case statement for completeness because the case expression has too many possible states File: /work/build/openfpga_genesis_analysis_work/src/fpga/core/core_top.sv Line: 466
    - Warning (10762): Verilog HDL Case Statement warning at core_bridge_cmd.v(185): can't check case statement for completeness because the case expression has too many possible states File: /work/build/openfpga_genesis_analysis_work/src/fpga/core/core_bridge_cmd.v Line: 185

- code 10858: 5
  - class: needs review before fitter
  - example(s):
    - Warning (10858): Verilog HDL warning at core_bridge_cmd.v(116): object host_4C used but never assigned File: /work/build/openfpga_genesis_analysis_work/src/fpga/core/core_bridge_cmd.v Line: 116
    - Warning (10858): Verilog HDL warning at core_bridge_cmd.v(137): object target_20 used but never assigned File: /work/build/openfpga_genesis_analysis_work/src/fpga/core/core_bridge_cmd.v Line: 137
    - Warning (10858): Verilog HDL warning at core_bridge_cmd.v(138): object target_24 used but never assigned File: /work/build/openfpga_genesis_analysis_work/src/fpga/core/core_bridge_cmd.v Line: 138

- code 12241: 1
  - class: needs review before fitter
  - example(s):
    - Warning (12241): 48 hierarchies have connectivity warnings - see the Connectivity Checks report folder

- code 113027: 2
  - class: likely harmless inherited upstream warning
  - example(s):
    -     Warning (113027): Addresses ranging from 0 to 223 are not initialized File: /work/build/openfpga_genesis_analysis_work/src/fpga/apf/build_id.mif Line: 1
    -     Warning (113027): Addresses ranging from 227 to 255 are not initialized File: /work/build/openfpga_genesis_analysis_work/src/fpga/apf/build_id.mif Line: 1

- code 113028: 1
  - class: likely harmless inherited upstream warning
  - example(s):
    - Warning (113028): 253 out of 256 addresses are uninitialized. The Quartus Prime software will initialize them to "0". There are 2 warnings found, and 2 warnings are reported. File: /work/build/openfpga_genesis_analysis_work/src/fpga/apf/build_id.mif Line: 1

- code 287013: 1
  - class: likely harmless inherited upstream warning
  - example(s):
    - Warning (287013): Variable or input pin "outclock" is defined but never used. File: /work/build/openfpga_genesis_analysis_work/src/fpga/db/dpram_f092.tdf Line: 34

## Class totals
- likely harmless: 52
- needs review before fitter: 20
- likely fitter blocker: 0
- unknown: 0

## Detection highlights
- connectivity warnings detected: code 12241
- truncation warnings detected: code 10230
- inference/latch/driver warnings detected: codes 10030, 10036, 10858
- IP/QIP/device-family warnings: none identified in current log

## Fitter-readiness recommendation

Decision: **REVIEW_WARNINGS_FIRST**

Reason: Warnings are present that should be reviewed before fitter because they may affect runtime behavior or interface stubs.

- Review 12241 connectivity warnings first, especially around bridge/APF stubs.
- Review 10030/10858 no-driver/unused signal warnings for stub/interface effects.
- Re-run this classifier before any fitter attempt.
