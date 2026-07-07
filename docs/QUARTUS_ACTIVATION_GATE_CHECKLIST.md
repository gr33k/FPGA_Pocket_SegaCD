# Quartus Activation Gate Checklist (Task 5Y)

Gate status after Task 5Z:

- Task 5Z conversion status: `qpf` + `qsf` converted to active skeleton shell (non-run).
- Remaining gates are **pending** until the validator and integration flow are updated for split active/placeholder policy.

All gates below are required before further active conversion in later phases.

1. Hygiene validation passes (current state: pending for mixed policy)
- Run `tools/check_quartus_placeholder_hygiene.sh`
- Inspect `docs/QUARTUS_PLACEHOLDER_HYGIENE_REPORT.md` for `Overall status: PASS` and zero fails once Task 6A updates policy.

2. Submodule is initialized
- Run `git submodule update --init --recursive`

3. Genesis_MiSTer submodule is clean
- Run `git -C third_party/Genesis_MiSTer status --short`
- Expected output: clean (no local edits)

4. Pinned commit is confirmed
- Run `git -C third_party/Genesis_MiSTer rev-parse HEAD`
- Expected commit: `adc0c42cfb1fa5d484cc8566767f7d68982bc44a` for current milestone tracking

5. APF top exists
- Confirm `apf/src/fpga/core/core_top.v` is present

6. APF wrapper boundary exists
- Confirm `apf/apf_genesis_base.sv` is present

7. Runtime root exists
- Confirm `third_party/Genesis_MiSTer/rtl/system.sv` exists

8. Simulation stub is excluded
- Confirm `apf/src/fpga/sim/apf_genesis_base_stub.sv` is not added to active project source lists

9. Forbidden sources remain excluded
- `third_party/Genesis_MiSTer/Genesis.sv`
- `third_party/Genesis_MiSTer/sys/sys_top.v`
- `HPS/IOCTL`
- `SegaCD` / `Mega-CD`
- `32X`

10. Generated-output directories are absent
- `build/`
- `output_files/`
- `db/`
- `incremental_db/`
- `simulation/`
- `greybox_tmp/`

11. Generated binary outputs are absent
- `*.sof`
- `*.pof`
- `*.jic`
- `*.rpd`
- `*.rbf`
- `*.rbf_r`

12. VHDL/mixed-language strategy is documented
- Confirm `quartus/notes_mixed_language.md` and project notes references are current

13. No synthesis has been run
- No Quartus or equivalent build invocation executed in this milestone

14. No games are claimed to boot
- No documentation or commit message should claim playable boot status before real integration

Gate status remains advisory until active source/constraint conversion proceeds beyond Task 5Z.
