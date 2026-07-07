# Quartus Docker workflow validation status

Generated: 2026-07-07T05:50:18Z
Advisory check; exits 0 by design.

PASS: Docker command check started
WARN: docker command not found in PATH (expected on build host)
PASS: file exists: docker/quartus/Dockerfile.ubuntu-quartus-base
PASS: file exists: docker/quartus/README.md
PASS: file exists: docker/quartus/.gitignore
PASS: file exists: docs/FEDORA_NAS_DOCKER_QUARTUS_WORKFLOW.md
PASS: file exists: docs/QUARTUS_DOCKER_INSTALLER_POLICY.md
PASS: optional file exists: Task 6S scaffold summary doc
PASS: pattern present: installers/ in docker/quartus/.gitignore
PASS: pattern present: intelFPGA*/ in docker/quartus/.gitignore
PASS: pattern present: intelFPGA_lite*/ in docker/quartus/.gitignore
PASS: pattern present: *.run in docker/quartus/.gitignore
PASS: pattern present: *.tar in docker/quartus/.gitignore
PASS: pattern present: *.tar.gz in docker/quartus/.gitignore
PASS: pattern present: *.zip in docker/quartus/.gitignore
PASS: pattern present: *.deb in docker/quartus/.gitignore
PASS: pattern present: *.rpm in docker/quartus/.gitignore
PASS: pattern present: license* in docker/quartus/.gitignore
PASS: pattern present: *.dat in docker/quartus/.gitignore
PASS: pattern present: *.sof in docker/quartus/.gitignore
PASS: pattern present: *.pof in docker/quartus/.gitignore
PASS: pattern present: *.jic in docker/quartus/.gitignore
PASS: pattern present: *.rpd in docker/quartus/.gitignore
PASS: pattern present: *.rbf in docker/quartus/.gitignore
PASS: pattern present: *.rbf_r in docker/quartus/.gitignore
PASS: pattern present: output_files/ in docker/quartus/.gitignore
PASS: pattern present: db/ in docker/quartus/.gitignore
PASS: pattern present: incremental_db/ in docker/quartus/.gitignore
PASS: pattern present: simulation/ in docker/quartus/.gitignore
PASS: pattern present: greybox_tmp/ in docker/quartus/.gitignore
PASS: root .gitignore includes installers/
PASS: root .gitignore includes intelFPGA*/
PASS: root .gitignore includes intelFPGA_lite*/
PASS: root .gitignore includes *.run
PASS: root .gitignore includes *.tar
PASS: root .gitignore includes *.tar.gz
PASS: root .gitignore includes *.zip
PASS: root .gitignore includes *.deb
PASS: root .gitignore includes *.rpm
PASS: root .gitignore includes license*
PASS: root .gitignore includes *.dat
PASS: root .gitignore includes *.sof
PASS: root .gitignore includes *.pof
PASS: root .gitignore includes *.jic
PASS: root .gitignore includes *.rpd
PASS: root .gitignore includes *.rbf
PASS: root .gitignore includes *.rbf_r
PASS: root .gitignore includes output_files/
PASS: root .gitignore includes db/
PASS: root .gitignore includes incremental_db/
PASS: root .gitignore includes simulation/
PASS: root .gitignore includes greybox_tmp/
PASS: root .gitignore includes *.fit.*
PASS: root .gitignore includes *.sta.*

## Summary
- PASS-like checks: 53
- WARN-like checks: 1
- Status: CHECKED

# Quartus Docker dry-run status

Generated: 2026-07-07T05:50:19Z
Image: pocket-quartus-base
Dockerfile: /Users/phassold/Projects/FPGA_Pocket_SegaCD/docker/quartus/Dockerfile.ubuntu-quartus-base
docker build -t pocket-quartus-base -f /Users/phassold/Projects/FPGA_Pocket_SegaCD/docker/quartus/Dockerfile.ubuntu-quartus-base /Users/phassold/Projects/FPGA_Pocket_SegaCD/docker/quartus
docker run --rm -it -v /Users/phassold/Projects/FPGA_Pocket_SegaCD:/work -v /Users/phassold/fpga/installers:/installers pocket-quartus-base bash -lc cd /work && git submodule update --init --recursive && find /opt -iname quartus_map -type f 2>/dev/null || true
RUN_DOCKER_BUILD != 1; skipped docker build.
RUN_DOCKER_CONTAINER != 1; skipped docker run.

## Notes
- No Quartus installer is required by this script.
- No Quartus execution is performed by this helper.
- Status file is informational only; no source files are modified.
