# Genesis bitstream A/B comparison

- upstream bitstream:                                               third_party/openFPGA-Genesis/dist/Cores/ericlewis.Genesis/bitstream.rbf_r
- local bitstream:   build/genesis_first_boot_artifacts/bitstream.rbf_r
- upstream bitstream size: 2021076
- local bitstream size: 2021076
- upstream SHA-256: 3867ec0207fdcb741a51c01b905ab8ae2217bd31274a991d1392f070cb795689
- local SHA-256: 3867ec0207fdcb741a51c01b905ab8ae2217bd31274a991d1392f070cb795689
- identical: yes
- first differing offsets: none

Result: BITSTREAMS_IDENTICAL

Conclusion:
- The upstream prebuilt Genesis bitstream and the locally staged Task 8A bitstream are byte-for-byte identical.
- No hardware A/B package split is useful for this task because both diagnostic packages would exercise the same bitstream.
- Do not conclude correctness from binary identity alone; the remaining black-screen investigation should focus on package metadata, ROM loading, reset release, or runtime behavior.

Final classification for Task 8E:
- BITSTREAMS_IDENTICAL_BLACK_SCREEN_RUNTIME_REVIEW_REQUIRED
