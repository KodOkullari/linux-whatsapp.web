#!/usr/bin/env bash
set -Eeuo pipefail

PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
VERSION="$("${PROJECT_DIR}/bin/linux-whatsapp-web" version | awk '{print $2}')"
DIST_DIR="${PROJECT_DIR}/dist"
ARCHIVE="${DIST_DIR}/linux-whatsapp-web-${VERSION}.tar.gz"

mkdir -p "${DIST_DIR}"
tar \
  --exclude='./.git' \
  --exclude='./dist' \
  --transform="s,^\.,linux-whatsapp-web-${VERSION}," \
  -czf "${ARCHIVE}" \
  -C "${PROJECT_DIR}" .

printf '%s\n' "${ARCHIVE}"
