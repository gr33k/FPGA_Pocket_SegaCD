# MegaCD BIOS probe hardware checklist

## A. Core visibility

- probe core appears beneath Genesis
- Core Settings opens
- BIOS browser appears on startup

## B. BIOS load

- user selects bios_CD_U.bin first
- BIOS file size is exactly 131072 bytes
- BIOS load completes
- BIOS Bytes value reaches 131072
- Mode Flags bit 6 becomes 1

## C. Runtime diagnostics

- Core Status value changes after BIOS load
- Memory Flags value changes after BIOS load
- Mode Flags reflects BIOS mode with CART ROM_MODE off and MCD enable on
- BIOS Last Addr reaches 0x0001FFFE
- BIOS First Word is non-zero
- BIOS Last Word is non-zero
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
