# MiSTer scaffold demotion note

The earlier MiSTer/Genesis_MiSTer scaffold is now demoted from main implementation path to research/supporting material.

Reason:
- Existing Analogue Pocket/openFPGA Genesis cores already implement the Pocket-specific APF integration.
- Recreating bridge/data slots, SDRAM ROM loading, video/scaler, audio, and controller mapping from raw MiSTer first is slower.

Keep:
- interface notes
- source closure notes
- Quartus/Docker prep
- package skeleton/staging workflow
- lessons learned

Stop:
- expanding the old stub ROM preload path as the main runtime path
- building custom Pocket video/audio/controller adapters from scratch before evaluating upstream Pocket Genesis code
