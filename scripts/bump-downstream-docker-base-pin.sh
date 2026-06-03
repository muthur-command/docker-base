#!/usr/bin/env bash
# Bump pinned docker-base GHCR image tags in downstream MCOS repositories.
#
# Usage: bump-downstream-docker-base-pin.sh <repo-name> <checkout-root> <version>
#   version: GitHub release tag (mc_ prefix is stripped for pin values)
#
# Image tag shapes must stay in sync with .github/workflows/builder.yml (ALPINE_LATEST, PYTHON_LATEST).

set -euo pipefail

REPO="${1:?repo name required}"
ROOT="${2:?checkout root required}"
VER="${3:?version required}"
VER="${VER#mc_}"

# Keep in sync with docker-base/.github/workflows/builder.yml env
ALPINE_LATEST="3.23"
PYTHON_LATEST="3.14"

BASE_TAG="${ALPINE_LATEST}-${VER}"
BASE_PYTHON_TAG="${PYTHON_LATEST}-alpine${ALPINE_LATEST}-${VER}"

log() { echo "[bump-downstream-docker-base-pin] $*"; }

bump_base_python() {
  local image="ghcr.io/muthur-command/base-python:${BASE_PYTHON_TAG}"
  local df="${ROOT}/Dockerfile"
  local wf="${ROOT}/.github/workflows/builder.yml"
  [[ -f "${df}" ]] || {
    log "missing ${df}"
    exit 1
  }
  [[ -f "${wf}" ]] || {
    log "missing ${wf}"
    exit 1
  }
  sed -i -E "s|^ARG BUILD_FROM=ghcr\\.io/muthur-command/base-python:.*|ARG BUILD_FROM=${image}|" "${df}"
  sed -i -E "s|cosign-base-verify: ghcr\\.io/muthur-command/base-python:.*|cosign-base-verify: ${image}|" "${wf}"
  log "updated base-python pin to ${BASE_PYTHON_TAG} in Dockerfile and builder.yml"
}

bump_base() {
  local image="ghcr.io/muthur-command/base:${BASE_TAG}"
  local df="${ROOT}/Dockerfile"
  local wf="${ROOT}/.github/workflows/builder.yml"
  [[ -f "${df}" ]] || {
    log "missing ${df}"
    exit 1
  }
  [[ -f "${wf}" ]] || {
    log "missing ${wf}"
    exit 1
  }
  sed -i -E "s|^ARG BUILD_FROM=ghcr\\.io/muthur-command/base:.*|ARG BUILD_FROM=${image}|" "${df}"
  sed -i -E "s|cosign-base-verify: ghcr\\.io/muthur-command/base:.*|cosign-base-verify: ${image}|" "${wf}"
  log "updated base pin to ${BASE_TAG} in Dockerfile and builder.yml"
}

case "${REPO}" in
  supervisor | docker)
    bump_base_python
    ;;
  plugin-audio | plugin-dns | plugin-cli | plugin-multicast | plugin-observer)
    bump_base
    ;;
  *)
    log "unknown repo: ${REPO}"
    exit 1
    ;;
esac
