#!/usr/bin/env bash
set -Eeuo pipefail

PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PREFIX="${HOME:?HOME is not set}/.local"
RUN_SETUP=true

usage() {
  cat <<'EOF'
Usage: ./install.sh [--prefix PATH] [--no-setup]

Installs the helper for the current user. Do not run with sudo.
EOF
}

while (( $# )); do
  case "$1" in
    --prefix) [[ $# -ge 2 ]] || { echo "--prefix requires a path" >&2; exit 2; }; PREFIX="$2"; shift 2 ;;
    --no-setup) RUN_SETUP=false; shift ;;
    --help|-h) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
done

[[ "${EUID}" -ne 0 ]] || { echo "Do not run this installer as root or with sudo." >&2; exit 1; }
[[ -f "${PROJECT_DIR}/bin/linux-whatsapp-web" ]] || { echo "Project files are incomplete." >&2; exit 1; }

install -d "${PREFIX}/bin" "${PREFIX}/share/doc/linux-whatsapp-web"
install -m 0755 "${PROJECT_DIR}/bin/linux-whatsapp-web" "${PREFIX}/bin/linux-whatsapp-web"
install -m 0644 \
  "${PROJECT_DIR}/README.md" \
  "${PROJECT_DIR}/LICENSE" \
  "${PROJECT_DIR}/SECURITY.md" \
  "${PREFIX}/share/doc/linux-whatsapp-web/"

printf 'Installed: %s\n' "${PREFIX}/bin/linux-whatsapp-web"
case ":${PATH}:" in
  *":${PREFIX}/bin:"*) ;;
  *) printf 'Add this directory to PATH: %s\n' "${PREFIX}/bin" ;;
esac

if [[ "${RUN_SETUP}" == true ]]; then
  LINUX_WHATSAPP_WEB_LAUNCHER="${PREFIX}/bin/linux-whatsapp-web" \
    "${PREFIX}/bin/linux-whatsapp-web" setup
else
  printf 'Next: %s setup\n' "${PREFIX}/bin/linux-whatsapp-web"
fi
