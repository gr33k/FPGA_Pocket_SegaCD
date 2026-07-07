#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPORT_PATH="$ROOT_DIR/docs/DOCKER_QUARTUS_VALIDATION_STATUS.md"

IMAGE_NAME="${IMAGE_NAME:-pocket-quartus-base}"
DOCKERFILE="$ROOT_DIR/docker/quartus/Dockerfile.ubuntu-quartus-base"
BUILD_CMD=(docker build -t "$IMAGE_NAME" -f "$DOCKERFILE" "$ROOT_DIR/docker/quartus")
RUN_CMD=(docker run --rm -it -v "$ROOT_DIR":/work -v "$HOME/fpga/installers":/installers "$IMAGE_NAME" bash -lc "cd /work && git submodule update --init --recursive && find /opt -iname quartus_map -type f 2>/dev/null || true")

RUN_DOCKER_BUILD="${RUN_DOCKER_BUILD:-0}"
RUN_DOCKER_CONTAINER="${RUN_DOCKER_CONTAINER:-0}"

cat <<EOF
Quartus Docker dry-run helper
Generated: $(date -u '+%Y-%m-%dT%H:%M:%SZ')

Dry-run mode is enabled unless RUN_DOCKER_BUILD=1 or RUN_DOCKER_CONTAINER=1.
EOF

{
  echo "# Quartus Docker dry-run status"
  echo
  echo "Generated: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  echo "Image: ${IMAGE_NAME}"
  echo "Dockerfile: ${DOCKERFILE}"
} >> "$REPORT_PATH"

echo "Build command:"
printf '  %q' "${BUILD_CMD[@]}"
echo
echo "${BUILD_CMD[@]}" >> "$REPORT_PATH"
echo "Run command:"
printf '  %q' "${RUN_CMD[@]}"
echo
echo "${RUN_CMD[@]}" >> "$REPORT_PATH"

if [[ "$RUN_DOCKER_BUILD" == "1" ]]; then
  "${BUILD_CMD[@]}"
else
  echo "RUN_DOCKER_BUILD != 1; skipping docker build."
  echo "RUN_DOCKER_BUILD != 1; skipped docker build." >> "$REPORT_PATH"
fi

if [[ "$RUN_DOCKER_CONTAINER" == "1" ]]; then
  "${RUN_CMD[@]}"
else
  echo "RUN_DOCKER_CONTAINER != 1; skipping docker run."
  echo "RUN_DOCKER_CONTAINER != 1; skipped docker run." >> "$REPORT_PATH"
fi

{
  echo
  echo "## Notes"
  echo "- No Quartus installer is required by this script."
  echo "- No Quartus execution is performed by this helper."
  echo "- Status file is informational only; no source files are modified."
} >> "$REPORT_PATH"

exit 0
