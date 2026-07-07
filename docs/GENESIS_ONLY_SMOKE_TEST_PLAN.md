# Genesis-only smoke-test plan

This milestone keeps smoke-test scope strictly local and deterministic.

## Scope

- Validate package skeleton structure.
- Validate that no disallowed payloads are accidentally introduced.
- Keep all behavior within APF scaffold and existing Genesis-only stubs.

## Planned checks (manual/local)

1. Run APF package skeleton check:
   - `tools/check_openfpga_package_skeleton.sh`
2. Confirm no generated Quartus/openFPGA artifacts are added:
   - search for `*.sof`, `*.pof`, `*.jic`, `*.rbf`, `*.rbf_r`, `*.prj` under
     package/build paths
3. Confirm placeholder-only package folders remain intact.
4. Confirm status docs updated for active blockers and next action path.

## Not covered in this task

- Real synthesis/implementation
- BIOS/CD slots
- Save-state paths
- Sega-CD, 32X, host-per-read ROM streaming

## Expected outcome

- `PASS` for structural cleanliness and deterministic non-binary package layout.
- Clear next-step pointer to Quartus-enabled build tasks once toolchain is available.

