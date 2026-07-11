# First Genesis ROM test plan
Generated: 2026-07-11 00:35:26 UTC

- Current package registers as a separate Sega CD platform.
- Current core implementation is still Genesis only.
- Place one known-good Genesis ROM manually in Assets/segacd/common for the first test.
- Do not copy the ROM into git.
- Do not test Sega CD or 32X content yet.

## First checks
- Sega CD appears in the Console list
- The core opens
- A known-good Genesis ROM can be selected from the staged asset path
- Video either appears or black screens
- Controls respond
- Audio is present
