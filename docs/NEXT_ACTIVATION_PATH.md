# Next activation path

1. Use the staged Pocket package at `build/pocket_sd_megacd_bios_probe/Cores/Gr33k.SegaCDBiosProbe`.
2. If the Pocket SD is mounted on the Mac, replace only `/Volumes/ANALOGUE/Cores/Gr33k.SegaCDBiosProbe`.
3. Preserve `bios_CD_E.bin`, `bios_CD_J.bin`, and `bios_CD_U.bin` in `/Volumes/ANALOGUE/Assets/genesis/common`.
4. Insert the SD into the Pocket.
5. Launch `openFPGA -> Console -> Genesis -> SegaCDBiosProbe by Gr33k`.
6. Select `bios_CD_U.bin` first.
7. Record Core Status, BIOS Bytes, Memory Flags, Mode Flags, BIOS Last Addr, BIOS First Word, BIOS Last Word, video result, and whether the Pocket menu stays accessible.
8. If BIOS execution begins but later fails during CDD initialization, keep the no-disc stub unchanged and treat that as the next task.
