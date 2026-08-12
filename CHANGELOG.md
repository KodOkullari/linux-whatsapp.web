# Changelog

All notable changes to this project are documented here.

## 0.1.1 - 2026-08-12

- Make release checksum filenames portable after download.
- Ensure the Debian package filesystem root has standard `0755` permissions.
- Add regression tests for both packaging properties.
- Update the official GitHub checkout action after Dependabot and CI verification.

## 0.1.0 - 2026-08-12

Initial community preview:

- Brave native/Snap and per-profile PWA discovery;
- deterministic validation of the official WhatsApp Web App ID;
- per-user XDG desktop launcher with correct PWA window class;
- read-only human and JSON diagnostics;
- explicit, user-only IBus input repair;
- conservative uninstall that preserves browser and WhatsApp data;
- isolated integration tests, ShellCheck CI, source archive, and `.deb` package.
