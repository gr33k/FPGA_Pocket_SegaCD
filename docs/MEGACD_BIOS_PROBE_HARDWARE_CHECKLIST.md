# MegaCD BIOS probe hardware checklist

## A. Genesis regression

- core appears under Genesis
- Sonic the Hedgehog loads
- video works
- audio works
- controls work
- no black screen
- no reset loop

## B. Memory diagnostics

- external WORDRAM0 enabled flag set
- WORDRAM0 read/write activity flags change
- CDC MLAB implementation enabled flag set
- CDC RAM read activity seen
- CDC RAM write activity seen
- no crash during MCD initialization

## C. BIOS probe

- user selects a Sega CD BIOS
- BIOS load completes
- MegaCD mode enables
- MCD reset releases
- sub-68000 activity changes
- BIOS video appears
- insert-disc or no-disc state appears
- no disc gameplay claim
