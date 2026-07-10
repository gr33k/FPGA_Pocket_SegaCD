# First Genesis package identity

- Old upstream-derived core path: `Cores/ericlewis.Genesis`
- New project core path: `Cores/gr33k.Genesis`
- New project platform file: `Platforms/gr33k.Genesis.json`

## Why it changed

The first staged package reused the upstream `openFPGA-Genesis` dist metadata directly, which placed the staged core under the upstream identity. This project now stages the Genesis-only Pocket smoke-test candidate under `gr33k.Genesis` to avoid name conflicts while preserving upstream attribution.

## Attribution

This package remains derivative of the upstream `openFPGA-Genesis` distribution and its wider openFPGA/MiSTer/fpgagen lineage. Upstream metadata remains the source for the staged package skeleton; only the staged package identity was renamed for this project.

## Scope

- Genesis only
- No Sega CD
- No 32X
- No ROM bundled
- No Pocket boot claim yet
- No runtime correctness claim yet
