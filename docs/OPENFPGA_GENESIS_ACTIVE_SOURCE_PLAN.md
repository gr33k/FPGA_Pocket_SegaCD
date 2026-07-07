# openFPGA-Genesis active-source build plan (Task 6X)

## 1. Source root

- `third_party/openFPGA-Genesis`

## 2. Active top candidates

- `third_party/openFPGA-Genesis/src/fpga/apf/apf_top.v`
- `third_party/openFPGA-Genesis/src/fpga/core/core_top.sv`

## 3. Runtime entry

- `third_party/openFPGA-Genesis/src/fpga/core/rtl/system.sv`

## 4. Required APF/Pocket support modules

- bridge command path
- data_loader
- data_unloader
- SDRAM
- sound_i2s
- PLL modules
- video/scaler path
- controller mapping path

## 5. Excluded

- `third_party/Genesis_MiSTer` runtime activation
- Sega CD
- 32X
- ROM/BIOS payloads
- generated bitstreams

## 6. Open questions

- whether to build directly from upstream Quartus project files
- whether to wrap upstream `apf_top.v` from this repo
- whether package metadata should be copied/adapted into this repo later
- whether upstream generated/release files are present and should stay ignored

## 7. Next compile action

Once Quartus installer exists:

1. Run analysis/elaboration only against the upstream source lane.
2. Capture first missing module/project-file errors.
3. Promote entries incrementally from this plan only.
