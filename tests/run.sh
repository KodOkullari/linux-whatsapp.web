#!/usr/bin/env bash
set -Eeuo pipefail

PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
CLI="${PROJECT_DIR}/bin/linux-whatsapp-web"
PASSED=0

ok() {
  PASSED=$((PASSED + 1))
  printf 'ok %d - %s\n' "${PASSED}" "$1"
}

fail() {
  printf 'not ok - %s\n' "$1" >&2
  exit 1
}

assert_file() { [[ -f "$1" ]] || fail "missing file: $1"; }
assert_not_file() { [[ ! -f "$1" ]] || fail "unexpected file: $1"; }
assert_contains() { grep -Fq -- "$2" "$1" || fail "'$2' not found in $1"; }

printf 'TAP version 13\n'

bash -n "${CLI}" "${PROJECT_DIR}/install.sh" "${PROJECT_DIR}/uninstall.sh"
ok "shell syntax"

VERSION="$("${CLI}" version | awk '{print $2}')"
[[ "${VERSION}" == "0.1.1" ]] || fail "unexpected version"
ok "version command"

TEMP_ROOT="$(mktemp -d)"
trap 'rm -rf -- "${TEMP_ROOT}"' EXIT
TEST_HOME="${TEMP_ROOT}/home"
TEST_BIN="${TEMP_ROOT}/fake-brave"
PROFILE_ROOT="${TEMP_ROOT}/brave-root"
APP_ID="hnpfjngllnobngcgfapefoaidbinmjnm"
mkdir -p \
  "${TEST_HOME}" \
  "${PROFILE_ROOT}/Default/Web Applications/Manifest Resources/${APP_ID}/Icons"

# shellcheck disable=SC2016
printf '#!/usr/bin/env bash\nprintf "%%s\\n" "$@" > "${FAKE_BRAVE_LOG:?}"\n' > "${TEST_BIN}"
chmod 0755 "${TEST_BIN}"
printf 'not-a-real-png-fixture\n' > "${PROFILE_ROOT}/Default/Web Applications/Manifest Resources/${APP_ID}/Icons/256.png"

export HOME="${TEST_HOME}"
export XDG_CONFIG_HOME="${TEST_HOME}/xdg-config"
export XDG_DATA_HOME="${TEST_HOME}/xdg-data"
export FAKE_BRAVE_LOG="${TEMP_ROOT}/brave.log"
export LINUX_WHATSAPP_WEB_LAUNCHER="${CLI}"

"${CLI}" setup \
  --browser "${TEST_BIN}" \
  --profile-root "${PROFILE_ROOT}" \
  --profile Default \
  --yes >/dev/null

CONFIG="${XDG_CONFIG_HOME}/linux-whatsapp-web/config"
DESKTOP="${XDG_DATA_HOME}/applications/linux-whatsapp-web.desktop"
ICON="${XDG_DATA_HOME}/icons/hicolor/256x256/apps/linux-whatsapp-web.png"
assert_file "${CONFIG}"
assert_file "${DESKTOP}"
assert_file "${ICON}"
assert_contains "${CONFIG}" "APP_ID=${APP_ID}"
assert_contains "${DESKTOP}" "StartupWMClass=crx_${APP_ID}"
assert_contains "${DESKTOP}" "Exec=\"${CLI}\" launch"
ok "isolated setup and PWA detection"

OTHER_APP_ID="aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
OTHER_ROOT="${TEMP_ROOT}/other-brave-root"
mkdir -p "${OTHER_ROOT}/Default/Web Applications/Manifest Resources/${OTHER_APP_ID}/Icons"
if "${CLI}" setup \
  --browser "${TEST_BIN}" \
  --profile-root "${OTHER_ROOT}" \
  --profile Default \
  --yes >"${TEMP_ROOT}/wrong-app.out" 2>"${TEMP_ROOT}/wrong-app.err"; then
  fail "setup accepted an unrelated sole PWA"
fi
assert_contains "${TEMP_ROOT}/wrong-app.err" "none matches the current official WhatsApp Web ID"
ok "unrelated sole PWA is rejected"

if "${CLI}" setup \
  --browser "${TEST_BIN}" \
  --profile-root "${OTHER_ROOT}" \
  --profile Default \
  --app-id "${OTHER_APP_ID}" \
  --yes >"${TEMP_ROOT}/wrong-explicit.out" 2>"${TEMP_ROOT}/wrong-explicit.err"; then
  fail "setup accepted an explicitly supplied unrelated PWA"
fi
assert_contains "${TEMP_ROOT}/wrong-explicit.err" "does not match the current official WhatsApp Web manifest ID"
ok "unrelated explicit PWA is rejected"

if command -v desktop-file-validate >/dev/null 2>&1; then
  desktop-file-validate "${DESKTOP}"
  ok "desktop entry validation"
fi

"${CLI}" doctor --json > "${TEMP_ROOT}/doctor.json"
python3 - "${TEMP_ROOT}/doctor.json" <<'PY'
import json, sys
data = json.load(open(sys.argv[1], encoding="utf-8"))
assert data["configured"] is True
assert data["browser"]["ok"] is True
assert data["profile"]["ok"] is True
assert data["pwa"]["ok"] is True
assert data["desktop_entry"]["ok"] is True
PY
ok "machine-readable doctor output"

"${CLI}" launch
assert_contains "${FAKE_BRAVE_LOG}" "--profile-directory=Default"
assert_contains "${FAKE_BRAVE_LOG}" "--app-id=${APP_ID}"
ok "launch uses selected profile and PWA"

"${CLI}" setup \
  --browser "${TEST_BIN}" \
  --profile-root "${PROFILE_ROOT}" \
  --profile Default \
  --yes >/dev/null
assert_file "${CONFIG}"
ok "setup is idempotent"

SENTINEL="${PROFILE_ROOT}/Default/Cookies"
printf 'do-not-touch\n' > "${SENTINEL}"
BEFORE="$(sha256sum "${SENTINEL}")"
"${CLI}" uninstall --yes >/dev/null
AFTER="$(sha256sum "${SENTINEL}")"
[[ "${BEFORE}" == "${AFTER}" ]] || fail "browser profile sentinel changed"
assert_not_file "${CONFIG}"
assert_not_file "${DESKTOP}"
assert_not_file "${ICON}"
ok "uninstall preserves browser profile data"

if rg -n --hidden \
  -g '!tests/run.sh' \
  -g '!docs/**' \
  -g '!README.md' \
  -g '!.gitignore' \
  -e '/home/mmtcbc' \
  -e '/snap/brave/[0-9]+' \
  "${PROJECT_DIR}"; then
  fail "machine-specific path found"
fi
ok "no machine-specific user or Snap revision paths"

if find "${PROJECT_DIR}" -type f \( \
  -iname 'Cookies' -o \
  -iname 'Login Data' -o \
  -iname '*.ldb' -o \
  -iname '*.sqlite' -o \
  -iname '*.sqlite3' \
  \) -print -quit | grep -q .; then
  fail "browser database material found in project"
fi
ok "no browser database payloads"

"${PROJECT_DIR}/packaging/build-source-archive.sh" >/dev/null
"${PROJECT_DIR}/packaging/build-deb.sh" >/dev/null
DEB_ROOT_MODE="$(dpkg-deb --fsys-tarfile "${PROJECT_DIR}/dist/linux-whatsapp-web_${VERSION}_all.deb" | tar -tvf - | awk 'NR == 1 {print $1}')"
[[ "${DEB_ROOT_MODE}" == "drwxr-xr-x" ]] || fail "Debian package root permissions are ${DEB_ROOT_MODE}"
(
  cd "${PROJECT_DIR}/dist"
  sha256sum ./*.tar.gz ./*.deb > SHA256SUMS.test
  sha256sum -c SHA256SUMS.test >/dev/null
)
ok "release packages have safe root permissions and portable checksums"

printf '1..%d\n' "${PASSED}"
