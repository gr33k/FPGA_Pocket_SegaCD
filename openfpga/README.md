# OpenFPGA Package Skeleton (Genesis-only scaffold)

This directory is a non-built, source-only package layout draft for the
Genesis-only APF scaffold. It keeps the buildable artifacts and metadata
separate so the Quartus/APF packaging handoff can happen cleanly once toolchain
integration is enabled.

Current status:

- No FPGA bitstream/binary output is present.
- No BIOS/CD/ISO payloads are included.
- No Sega-CD or 32X payloads are wired.
- Runtime ROM load is still scaffolded and does not stream from host on runtime
  accesses.

## Layout intent

- `openfpga/FPGA_Pocket_SegaCD/` is the intended package root for this core.
- Subdirectories contain only scaffold placeholders and documentation.
- Source remains in `apf/`, runtime wiring remains under `apf/src/fpga/core`.
- Runtime synthesis sources and third-party RTL are intentionally out-of-scope in this
  milestone.

See `docs/POCKET_FILE_LAYOUT_GENESIS_ONLY.md` and
`docs/TASK6Q_OPENFPGA_PACKAGE_SKELETON.md` for the detailed layout plan.

