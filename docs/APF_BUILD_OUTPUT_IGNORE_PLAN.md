# APF build output ignore plan (documentation only)

This document captures generated artifacts that should be ignored once Quartus/openFPGA project files are introduced.

Task 5S introduced this planning list.
Task 5T implemented the ignore rules in `.gitignore`.

## Future generated directories

- `build/`
- `output_files/`
- `db/`
- `incremental_db/`
- `simulation/`
- `greybox_tmp/`

## Future generated files

- `*.sof`
- `*.pof`
- `*.jic`
- `*.rpd`
- `*.rbf`
- `*.rbf_r`
- `*.fit.*`
- `*.sta.*`
- `*.map.*`
- `*.asm.*`
- `*.flow.*`
- `*.qws`
- `*.qpf` backup files
- `*.qsf` backup files
- `*.bak`
- `*.smsg`
- `*.summary`
- `*.done`
- `*.pin`
- `*.qdf`
- `*.qpf.bak`
- `*.qsf.bak`
- `*.sdc.bak`
- `*.tcl.bak`

## Why this is deferred

- The repo currently has no active Quartus project to validate generated-file locations.
- `.gitignore` now contains these patterns and backup variants; they will be revisited once the project skeleton files are created.
