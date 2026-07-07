#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IMAGE_NAME="${IMAGE_NAME:-pocket-quartus-base}"
INSTALLER_HOST_DIR="/root/fpga/installers"
INSTALL_ROOT_HOST="/root/fpga/intelFPGA_lite"
DOCKERFILE="$ROOT_DIR/docker/quartus/Dockerfile.ubuntu-quartus-base"
DOCKERFILE_DIR="$ROOT_DIR/docker/quartus"
STATUS_PATH="$ROOT_DIR/docs/DOCKER_QUARTUS_INSTALL_STATUS.md"
HELP_PATH="$ROOT_DIR/docs/DOCKER_QUARTUS_INSTALLER_HELP.txt"
RUN_LOG_PATH="$ROOT_DIR/docs/DOCKER_QUARTUS_INSTALLER_RUN.log"
TIMESTAMP="$(date -u '+%Y-%m-%d %H:%M:%S UTC')"

log() {
  printf '%s\n' "$1" | tee -a "$STATUS_PATH"
}

: > "$STATUS_PATH"
{
  echo "# Docker Quartus Lite install status"
  echo "Generated: $TIMESTAMP"
  echo
  echo "Host: $(hostname)"
  echo "Install host dirs: installer=$INSTALLER_HOST_DIR, target=$INSTALL_ROOT_HOST"
  echo "Image: $IMAGE_NAME"
  echo "Dockerfile: $DOCKERFILE"
  echo
} > "$STATUS_PATH"

if ! command -v docker >/dev/null 2>&1; then
  log "ERROR: docker command not found in PATH."
  log "BLOCKED: cannot run Dockerized Quartus install without docker."
  log "install attempted: no"
  exit 0
fi

if [[ ! -d "$INSTALLER_HOST_DIR" ]]; then
  log "INFO: installer directory not found: $INSTALLER_HOST_DIR"
  log "create this directory and place a Quartus Lite installer inside before retrying."
  log "install attempted: no"
  log "BLOCKED: installer directory missing"
  exit 0
fi

INSTALLER_PATH=""
while IFS= read -r cand; do
  [[ -n "$cand" ]] && { INSTALLER_PATH="$cand"; break; }
done < <(find "$INSTALLER_HOST_DIR" -maxdepth 2 -type f \
  \( -iname "*quartus*.run" -o -iname "*quartus*.sh" -o -iname "*Quartus*.run" -o -iname "*Quartus*.sh" -o -iname "*Quartus*.tar" -o -iname "*Quartus*.tar.gz" \) \
  -print | sort)

if [[ -z "$INSTALLER_PATH" ]]; then
  log "installer found: no"
  log "installer search path: /root/fpga/installers"
  log "patterns: *quartus*.run, *quartus*.sh, *Quartus*.run, *Quartus*.sh, *Quartus*.tar, *Quartus*.tar.gz"
  log "BLOCKED: no installer found under /root/fpga/installers"
  log "install attempted: no"
  printf 'No Quartus installer found in %s\n' "$INSTALLER_HOST_DIR" > "$HELP_PATH"
  exit 0
fi

mkdir -p "$INSTALL_ROOT_HOST"

if [[ ! -f "$DOCKERFILE" ]]; then
  log "ERROR: missing docker image recipe: $DOCKERFILE"
  log "BLOCKED: cannot build/install without image recipe"
  exit 0
fi

if ! docker image inspect "$IMAGE_NAME" >/dev/null 2>&1; then
  docker build -t "$IMAGE_NAME" -f "$DOCKERFILE" "$DOCKERFILE_DIR"
fi

INSTALLER_BASENAME="$(basename "$INSTALLER_PATH")"
INSTALLER_CONTAINER_PATH="/installers/$INSTALLER_BASENAME"

log "installer found: yes"
log "installer path: $INSTALLER_PATH"
log "installer filename: $INSTALLER_BASENAME"
log "install attempted: no"

DOCKER_HELP_CMD="cd / && \"${INSTALLER_CONTAINER_PATH}\" --help"
set +e
docker run --rm -i \
  -v "$INSTALLER_HOST_DIR":/installers:ro \
  -v "$INSTALL_ROOT_HOST":"$INSTALL_ROOT_HOST" \
  "$IMAGE_NAME" bash -lc "$DOCKER_HELP_CMD" > "$HELP_PATH" 2>&1
HELP_EXIT=$?
set -e
if [[ $HELP_EXIT -ne 0 ]]; then
  log "installer --help exit: $HELP_EXIT"
else
  log "installer --help exit: 0"
fi

INSTALL_ARGS="${QUARTUS_INSTALL_ARGS:-}"
INSTALL_ATTEMPTED="no"
INSTALL_EXIT_CODE="0"

if [[ -z "$INSTALL_ARGS" ]]; then
  if grep -iqE "(unattended|silent|batch)" "$HELP_PATH"; then
    if grep -iq "accept_eula" "$HELP_PATH"; then
      INSTALL_ARGS="--mode unattended --accept_eula 1"
    else
      INSTALL_ARGS="--mode unattended"
    fi

    if grep -iq "installdir" "$HELP_PATH"; then
      INSTALL_ARGS="$INSTALL_ARGS --installdir /opt/intelFPGA_lite"
    fi
  else
    log "BLOCKED: installer does not advertise a confirmed unattended/silent path in --help output."
    log "Set QUARTUS_INSTALL_ARGS explicitly to run an installer command, or install manually."
    log "install attempted: no"
    exit 0
  fi
fi

log "installer args used: $INSTALL_ARGS"

INSTALL_ATTEMPTED="yes"
set +e
INSTALL_CMD="chmod +x \"$INSTALLER_CONTAINER_PATH\" && cd / && \"$INSTALLER_CONTAINER_PATH\" $INSTALL_ARGS"
docker run --rm -i \
  -v "$INSTALLER_HOST_DIR":/installers:ro \
  -v "$INSTALL_ROOT_HOST":"$INSTALL_ROOT_HOST" \
  "$IMAGE_NAME" bash -lc "$INSTALL_CMD" > "$RUN_LOG_PATH" 2>&1
INSTALL_EXIT_CODE=$?
set -e

log "install attempted: $INSTALL_ATTEMPTED"
log "install exit code: $INSTALL_EXIT_CODE"
log "install target: $INSTALL_ROOT_HOST"

QMAP_PATH="$(find "$INSTALL_ROOT_HOST" -path "*/quartus/bin/quartus_map" -type f 2>/dev/null | sort | head -n 1 || true)"
if [[ -z "$QMAP_PATH" ]]; then
  log "quartus_map found: no"
  log "BLOCKED: quartus_map not found after install attempt."
else
  log "quartus_map found: yes"
  log "quartus_map path: $QMAP_PATH"
  if [[ -x "$QMAP_PATH" ]]; then
    log "quartus_map --version: $("$QMAP_PATH" --version 2>/dev/null | tr '\n' ' ' | sed 's/[[:space:]]\+$//')"
  else
    log "quartus_map version: not executable"
  fi
fi

rm -f "$RUN_LOG_PATH"

exit 0
