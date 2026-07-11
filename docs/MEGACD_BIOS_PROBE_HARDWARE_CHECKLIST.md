# MegaCD BIOS probe hardware checklist

## A. Core visibility

- probe core appears beneath Genesis
- Core Settings opens
- BIOS browser appears on startup

## B. BIOS load

- user selects one Sega CD BIOS
- BIOS file size is exactly 131072 bytes
- BIOS load completes
- BIOS Bytes value increases from zero

## C. Runtime diagnostics

- Core Status value changes after BIOS load
- Memory Flags value changes after BIOS load
- WordRAM Address changes from zero
- CDC Read Address changes from zero
- CDC Write Address changes from zero

## D. User-visible result

- video output present
- audio output present or explicitly silent
- insert-disc or no-disc screen appears
- no black screen
- no reset loop
- no freeze
- Pocket menu remains accessible
