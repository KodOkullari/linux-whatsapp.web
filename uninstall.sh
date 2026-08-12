#!/usr/bin/env bash
set -Eeuo pipefail

PREFIX="${HOME:?HOME is not set}/.local"
ASSUME_YES=false

while (( $# )); do
  case "$1" in
    --prefix) [[ $# -ge 2 ]] || { echo "--prefix requires a path" >&2; exit 2; }; PREFIX="$2"; shift 2 ;;
    --yes) ASSUME_YES=true; shift ;;
    --help|-h) echo "Usage: ./uninstall.sh [--prefix PATH] [--yes]"; exit 0 ;;
    *) echo "Unknown option: $1" >&2; exit 2 ;;
  esac
done

[[ "${EUID}" -ne 0 ]] || { echo "Do not run this uninstaller as root or with sudo." >&2; exit 1; }

HELPER="${PREFIX}/bin/linux-whatsapp-web"
if [[ -x "${HELPER}" ]]; then
  if [[ "${ASSUME_YES}" == true ]]; then
    "${HELPER}" uninstall --yes
  else
    "${HELPER}" uninstall
  fi
else
  echo "Installed helper not found; removing only known project-owned files."
  rm -f -- \
    "${XDG_DATA_HOME:-${HOME}/.local/share}/applications/linux-whatsapp-web.desktop" \
    "${XDG_DATA_HOME:-${HOME}/.local/share}/icons/hicolor/256x256/apps/linux-whatsapp-web.png" \
    "${XDG_CONFIG_HOME:-${HOME}/.config}/linux-whatsapp-web/config"
  rmdir --ignore-fail-on-non-empty "${XDG_CONFIG_HOME:-${HOME}/.config}/linux-whatsapp-web" 2>/dev/null || true
fi

rm -f -- "${HELPER}"
rm -f -- \
  "${PREFIX}/share/doc/linux-whatsapp-web/README.md" \
  "${PREFIX}/share/doc/linux-whatsapp-web/LICENSE" \
  "${PREFIX}/share/doc/linux-whatsapp-web/SECURITY.md"
rmdir --ignore-fail-on-non-empty "${PREFIX}/share/doc/linux-whatsapp-web" 2>/dev/null || true
echo "linux-whatsapp-web program files removed. Browser and WhatsApp data were not touched."
