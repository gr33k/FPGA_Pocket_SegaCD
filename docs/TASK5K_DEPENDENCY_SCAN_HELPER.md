# Task 5K: Dependency scan helper

## Why this helper exists

Task 5J introduced an initial dependency-inspection result, but it was based on a
small manual pass. This helper provides a repeatable, read-only way to:

- list module declarations in present Verilog/SystemVerilog files,
- list likely module instantiation sites,
- surface missing modules before attempting a compile pass,
- keep excluded legacy/runtime areas visible and explicit.

It is meant to support a staged dependency planning workflow while keeping
imported runtime RTL unmodified.

## What it can detect

- Declared modules (`module ...`) in `.v` / `.sv` files.
- Suspected instantiation sites via a conservative text pattern (`module_name instance_name (...)` style).
- Scanned roots:
  - `apf/`
  - `apf/src/fpga/core/`
  - `apf/src/fpga/sim/`
  - any `rtl/` directories discovered under the chosen root.
- Separate listing of VHDL files (`.vhd`, `.vhdl`) encountered; full VHDL module parsing is not attempted.

## What it cannot detect (and why)

- It is not a full parser: multiline instantiation formatting, macros, generates,
  and complex parameterized forms can be missed or produce false positives.
- It cannot validate runtime semantics, timing, or compile legality.
- It cannot infer `include`/`generate`/`ifdef` behavior beyond simple comment stripping.
- It cannot resolve whether a name is a library package/type/function from VHDL.

Because of these limits, its results are **advisory only**.

## Why advisory results are still useful

- The script quickly highlights missing boundary modules (for example `system`)
  and helps keep the manifest aligned with what is actually present in the repo.
- It is useful for deciding which paths to add before a full compile pass.

## Why compile errors remain the final truth

- Only a real compile/elaboration pass can confirm:
  - true module visibility and scope,
  - duplicate/conflicting definitions,
  - parameter/wire-width mismatches,
  - exact transitive dependencies.

## Why imported Genesis_MiSTer RTL still must be added later

- This project intentionally keeps imported Genesis_MiSTer as external source
  territory for this milestone.
- Scanning existing APF scaffold files cannot replace bringing those files in.
- The dependency probe remains a planning aid; it does not substitute for actual
  runtime source import and compile iteration.

## Expected output categories

- Declared modules
- Suspected instantiations
- Missing / external-expected modules
- Intentionally excluded notes
- Unknown/advisory items
- Files scanned

`system` is expected to remain missing until imported `rtl/system.sv` (or equivalent) is added.
