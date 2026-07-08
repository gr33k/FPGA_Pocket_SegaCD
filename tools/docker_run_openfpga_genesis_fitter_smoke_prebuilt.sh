#!/usr/bin/env bash
set -euo pipefail

QUARTUS_IMAGE="${QUARTUS_PREBUILT_IMAGE:-theypsilon/quartus-lite-c5:19.1-heavy}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RUN_LOG="$ROOT_DIR/docs/PREBUILT_QUARTUS_DOCKER_FITTER_SMOKE_RUN_LOG.txt"

{
  echo "# prebuilt Quartus fitter smoke wrapper run"
  echo "Generated: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
  echo "Image: $QUARTUS_IMAGE"
} > "$RUN_LOG"

if ! command -v docker >/dev/null 2>&1; then
  echo "BLOCKED: docker missing" | tee -a "$RUN_LOG"
  exit 0
fi

echo "Checking gate ready" | tee -a "$RUN_LOG"
set +e
bash "$ROOT_DIR/tools/check_openfpga_genesis_fitter_gate_ready.sh" 2>&1 | tee -a "$RUN_LOG"
set -e

echo "Running fitter smoke checker" | tee -a "$RUN_LOG"
set +e
bash "$ROOT_DIR/tools/check_openfpga_genesis_fitter_smoke.sh" 2>&1 | tee -a "$RUN_LOG"
set -e

echo "Launching docker run" | tee -a "$RUN_LOG"
docker run --rm -t --init \
  -v "$ROOT_DIR:/work" \
  -w /work \
  "$QUARTUS_IMAGE" \
  bash -lc './tools/check_openfpga_genesis_fitter_gate_ready.sh && ./tools/run_openfpga_genesis_fitter_smoke.sh && ./tools/check_openfpga_genesis_fitter_smoke.sh' \
  >> "$RUN_LOG" 2>&1

echo "Docker fitter smoke run complete" | tee -a "$RUN_LOG"
