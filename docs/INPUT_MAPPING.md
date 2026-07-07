# Input Mapping Plan

## Scope
This defines the conservative input contract for the current Genesis-only APF feasibility milestone.

## Controller count and mode
- Exactly one controller.
- No multitap.
- No mouse.
- No lightgun.

## Genesis pad wiring target
- Use the existing 12-bit Genesis pad shape in the runtime path.
- D-pad mapped directly to APF D-pad inputs.
- Face buttons mapped to Genesis A/B/C.
- Start mapped to Genesis Start.
- Mode/X/Y/Z are wired in the wrapper when exposed by APF input signals (`cont1_key[14]`, `cont1_trig[0:2]`) using conservative defaults.

## Planned APF→Genesis mapping

Recommended default mapping:
- `pad_up` → Genesis D-pad Up
- `pad_down` → Genesis D-pad Down
- `pad_left` → Genesis D-pad Left
- `pad_right` → Genesis D-pad Right
- `pad_btn_a` → Genesis A
- `pad_btn_b` → Genesis B
- `pad_btn_x` → Genesis C
- `pad_btn_start` → Genesis Start
- `pad_btn_select` no longer reserved: Mode/X/Y/Z are now explicitly mapped in core adapter as conservative scaffold inputs.

## Implementation state
- Keep mapping in APF JSON and wrapper adapter as a conservative skeleton.
- Keep X/Y/Z/Mode adapter wiring scoped to the APF scaffold defaults; JSON-level semantic policy is still deferred until later controller policy validation.
- No other controller types are instantiated in this milestone.

## Notes
- This plan intentionally does not implement multitap, mouse, or lightgun logic.
- This avoids behavior changes beyond Genesis pad parity while APF core porting is being verified.
