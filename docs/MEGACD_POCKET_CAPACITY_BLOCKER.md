# MegaCD Pocket capacity blocker

- final classification: `POCKET_MEMORY_CAPACITY_EXCEEDED_AFTER_WORDRAM0`
- block memory bits after WORDRAM0 move: `2,475,110 / 3,153,920`
- exact bit reduction from baseline: `1,048,576`
- M10K blocks after WORDRAM0 move: `325 / 308`
- M10K overage: `17 blocks`
- total block memory implementation bits: `3,328,000 / 3,153,920`
- conclusion: `WORDRAM0 externalization solved the raw block-memory-bit limit, but fitter still fails because the design packs to too many M10K blocks`
- next safe externalization target: `CDC_RAM or PCM_RAM`
- explicitly not done in this task: `moving WORDRAM1 onto the same physical SRAM bus`
