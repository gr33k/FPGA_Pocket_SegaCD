# APF JSON Schema Notes

This repository uses APF-standard JSON definition files for milestone scaffolding.

## Files switched to APF schema
- `apf/core.json` follows the APF `core` schema (`magic: APF_VER_1`).
- `apf/data.json` defines a single primary data slot for Genesis ROM assets.
- `apf/input.json` maps one default controller.
- `apf/video.json` defines one conservative 320x224 scaler mode.
- `apf/audio.json` uses the APF audio skeleton.
- `apf/interact.json` is stubbed with an empty `variables` list.
- `apf/variants.json` defines a single `Genesis-only` variant with default bitstream selection.

## Explicit milestones in this JSON set
- No Sega CD BIOS slot.
- No separate Sega CD image slot.
- No save slot or nonvolatile save descriptor.
- No memory-controller/loader behavior is encoded in these JSON files yet.

## Notes migration from prior ad-hoc JSON
- Project status notes were moved to markdown docs:
  - `apf/README_APF_STATUS.md`
  - `docs/REPO_STATUS.md`
- The previous non-APF helper JSON artifacts used for milestones were removed:
  - `metadata.json`
  - `apf_data_slot.json`
  - `video_test_pattern.json`
  - `silent_audio.json`

## Next milestone steps
- Keep `apf/core.json`/`data.json`/`input.json` stable until first Pocket boot smoke.
- Wire actual Bridge input/data behaviors once bus contract is finalized.
