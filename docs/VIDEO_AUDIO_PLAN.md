# Video and Audio Plan

## Video plan

### Scope (this milestone)
- Route Genesis raw outputs directly into the APF video pipeline.
- Do not add filtering, advanced scaler policy, or dynamic menu/OSD blending at this stage.

### Mapped signals
- `video_r/g/b` (Genesis raw color) -> APF RGB path.
- `video_de` (Display Enable) -> APF DE.
- `video_vs` (Vertical Sync) -> APF VSYNC.
- `video_hs` (Horizontal Sync) -> APF HSYNC.

### Deferred work
- Scaler/filtering behavior is deferred.
- No custom image processing or post-processing pipeline added yet.
- Keep output stable/explicit and conservative to allow raw signal verification.

## Audio plan

### Scope (this milestone)
- Use internal Genesis left/right sample path.
- Keep APF audio serializer/handshake as stubbed/documented plumbing.
- Validate signal width/order compatibility before enabling advanced shaping.

### Routed behavior
- Genesis left sample -> APF audio left channel path.
- Genesis right sample -> APF audio right channel path.

### Deferred work
- No filter implementation yet.
- No additional mixing/effects.
- No dynamic sample-rate adaptation beyond existing runtime default contract.

## Non-goals for this milestone
- No Sega CD audio channel work.
- No filter/LPF or DSP rewrite in APF layer.
- No host side per-sample manipulation.
