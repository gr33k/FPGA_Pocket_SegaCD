# MegaCD probe feature reductions

The first MegaCD Pocket probe keeps essential Genesis and MegaCD blocks but trims probe-only extras:

- no lightgun path in active probe logic
- no multitap enable path in active probe logic
- no SVP path in active probe logic
- no cheat/Game Genie path enabled by default
- no real disc streaming
- no CUE parsing
- no CHD
- no runtime CDDA streaming
- inherited SignalTap assignments removed from the repo-owned Pocket lane for the next attempt

Essential logic kept:

- Genesis main CPU
- Genesis VDP
- Genesis FM / PSG
- Sega CD sub-CPU
- MCD ASIC
- Program RAM
- Word RAM path
- CDC
- PCM
- BIOS interface

Reduction note:

- no fit rerun was done from the SignalTap cleanup alone because the harvested blocker is `369,766` block-memory bits over device capacity while the inherited `sld_hub` hierarchy accounts for only about `112` memory bits
- the next meaningful reduction is memory externalization, not another small wrapper trim
