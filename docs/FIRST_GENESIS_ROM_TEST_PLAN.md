# First Genesis ROM test plan
Generated: 2026-07-10 21:41:02 UTC

- Test Genesis only.
- Do not test Sega CD.
- Do not test 32X.
- Use one small known-good Genesis .bin or .gen ROM.
- Do not copy the ROM into git or the staged package.

## First hardware checks
- Core appears in Pocket menu
- ROM browser opens
- ROM loads
- Video syncs
- Controls respond
- Audio is present

## Failure recording
Record the exact first failure: missing core, load failure, black screen, no controls, no audio, crash, or reset loop.
