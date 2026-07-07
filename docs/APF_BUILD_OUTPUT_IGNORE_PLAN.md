# APF build output ignore plan (documentation only)

This document captures generated artifacts that should be ignored once Quartus/openFPGA project files are introduced.
It is a planning document only for Task 5S and does **not** modify `.gitignore`.

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

## Why this is deferred

- The repo currently has no active Quartus project to validate generated-file locations.
- These patterns become actionable in Task 5T when `.gitignore` hygiene is added.
- This document should be revisited after project skeleton files are introduced and output paths are confirmed.
