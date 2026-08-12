#!/usr/bin/env bash
set -Eeuo pipefail

PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
VERSION="$("${PROJECT_DIR}/bin/linux-whatsapp-web" version | awk '{print $2}')"
DIST_DIR="${PROJECT_DIR}/dist"
BUILD_DIR="$(mktemp -d)"
trap 'rm -rf -- "${BUILD_DIR}"' EXIT

command -v dpkg-deb >/dev/null 2>&1 || {
  echo "dpkg-deb is required to build the Debian package." >&2
  exit 1
}

install -d \
  "${BUILD_DIR}/DEBIAN" \
  "${BUILD_DIR}/usr/bin" \
  "${BUILD_DIR}/usr/share/doc/linux-whatsapp-web"
chmod 0755 "${BUILD_DIR}"
install -m 0644 "${PROJECT_DIR}/packaging/deb/DEBIAN/control" "${BUILD_DIR}/DEBIAN/control"
install -m 0755 "${PROJECT_DIR}/bin/linux-whatsapp-web" "${BUILD_DIR}/usr/bin/linux-whatsapp-web"
install -m 0644 \
  "${PROJECT_DIR}/README.md" \
  "${PROJECT_DIR}/LICENSE" \
  "${PROJECT_DIR}/SECURITY.md" \
  "${PROJECT_DIR}/THIRD_PARTY_NOTICES.md" \
  "${BUILD_DIR}/usr/share/doc/linux-whatsapp-web/"
install -m 0644 \
  "${PROJECT_DIR}/docs/README.tr.md" \
  "${PROJECT_DIR}/docs/INSTALL.md" \
  "${PROJECT_DIR}/docs/TROUBLESHOOTING.md" \
  "${PROJECT_DIR}/docs/PRIVACY.md" \
  "${BUILD_DIR}/usr/share/doc/linux-whatsapp-web/"

mkdir -p "${DIST_DIR}"
PACKAGE="${DIST_DIR}/linux-whatsapp-web_${VERSION}_all.deb"
dpkg-deb --root-owner-group --build "${BUILD_DIR}" "${PACKAGE}" >/dev/null
printf '%s\n' "${PACKAGE}"
