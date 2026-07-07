# APF Scaffold Smoke Presets (Documentation-only)

Use this file as a human-readable preset reference for local builds and smoke-test invocation.

These are documentation presets only unless your build system is wired to apply them.

## Preset A — "Conservative inert"

- `ENABLE_GENESIS_STUB_RUN = 0`
- `ENABLE_PRELOAD_INGRESS_STUB = 0`
- `ENABLE_FAKE_ROM_FOR_SMOKE_TEST = 0`
- `ENABLE_TINY_LOCAL_ROM_RAM = 0`

Expected behavior:
- Core stays in reset.
- No ROM data service activity.
- Deterministic baseline for compile and tie-off checks.

Use when:
- First-pass compile sanity.
- No intentional ROM-path simulation.

## Preset B — "Fake ROM smoke"

- `ENABLE_GENESIS_STUB_RUN = 1`
- `ENABLE_PRELOAD_INGRESS_STUB = 0`
- `ENABLE_FAKE_ROM_FOR_SMOKE_TEST = 1`
- `ENABLE_TINY_LOCAL_ROM_RAM = 0`

Expected behavior:
- Reset can run.
- ROM returns fixed inert values (`16'hFFFF`) under request.
- No preload ingress.
- Structural smoke only.

Use when:
- You need a released-reset structural build with no preload plumbing dependency.

## Preset C — "Tiny local RAM smoke"

- `ENABLE_GENESIS_STUB_RUN = 1`
- `ENABLE_PRELOAD_INGRESS_STUB = 1`
- `ENABLE_FAKE_ROM_FOR_SMOKE_TEST = 0`
- `ENABLE_TINY_LOCAL_ROM_RAM = 1`

Expected behavior:
- Debug bridge ingress can write tiny ROM words.
- `preload_commit` can mark preload complete.
- Tiny local ROM services `rom_req`/`rom_addr` reads.

Use when:
- Verifying path: bridge ingress → ROM local service → tiny RAM readback.

## Important warning

These presets are not automatic unless your build scripts pass parameter overrides.
Without that wiring, `core_top` defaults remain inert.

## Future Quartus/APF build integration note

When a build config file is added:
- Add a parameter/preset selection surface near top-level target definition.
- Map the selected preset to top-level overrides for:
  - `ENABLE_GENESIS_STUB_RUN`
  - `ENABLE_PRELOAD_INGRESS_STUB`
  - `ENABLE_FAKE_ROM_FOR_SMOKE_TEST`
  - `ENABLE_TINY_LOCAL_ROM_RAM`
- Keep these overrides temporary and documented.
