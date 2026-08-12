# linux-whatsapp.web

[Türkçe belge](docs/README.tr.md)

A small, auditable Linux helper for running the **official WhatsApp Web** site
as an installed Brave Web App. It also diagnoses the stale IBus socket problem
that can make sandboxed Chromium applications stop accepting keyboard input.

> **Independent project:** This project is not affiliated with, endorsed by,
> sponsored by, or an official product of WhatsApp LLC, Meta Platforms, Inc.,
> or Brave Software, Inc. WhatsApp and Brave are trademarks of their respective
> owners. This project does not distribute or modify WhatsApp or Brave.

## What it does

- detects the official Brave native package or Brave Snap;
- finds the WhatsApp Web PWA without hard-coded user paths;
- creates a correctly grouped Linux desktop launcher;
- checks Brave, the selected profile, the PWA, the launcher, and IBus;
- offers an explicit, user-only `ibus restart` repair for failed keyboard input;
- removes only its own launcher, icon copy, configuration, and program files.

## What it deliberately does not do

- no unofficial WhatsApp client or modified web page;
- no automated messages, scraping, DOM injection, or QR automation;
- no cookie, token, browser profile, message, or IndexedDB copying;
- no automatic Brave installation, profile migration, or IBus restart;
- no WhatsApp or Brave binaries, logos, or session data in this repository.

## Requirements

- Linux desktop with Bash 4+, Python 3, and desktop-file support;
- [Brave installed from its official Linux packages](https://brave.com/linux/)
  (native packages are preferred; the official Snap is supported);
- an existing WhatsApp account and a phone for the normal linked-device flow.

## Install

```bash
git clone https://github.com/KodOkullari/linux-whatsapp.web.git
cd linux-whatsapp.web
./install.sh
```

The setup opens only `https://web.whatsapp.com/` if the Web App has not been
installed yet. In Brave choose **Save and share → Install WhatsApp Web**, then
return to the terminal and press Enter. See [the detailed installation guide](docs/INSTALL.md).

After setup, launch **WhatsApp Web** from the application menu.

### Ubuntu/Debian package

Tagged releases also include a small, architecture-independent `.deb`:

```bash
sudo apt install ./linux-whatsapp-web_0.1.1_all.deb
linux-whatsapp-web setup
```

The package installs only the helper and documentation. Its installation does
not open Brave, restart IBus, or touch any user/browser profile.

## Commands

```text
linux-whatsapp-web setup
linux-whatsapp-web launch
linux-whatsapp-web doctor
linux-whatsapp-web doctor --json
linux-whatsapp-web repair-input
linux-whatsapp-web repair-input --apply
linux-whatsapp-web uninstall
```

`repair-input` is a dry run. Only `repair-input --apply` restarts IBus, and it
prints a warning first. Save any unfinished composition text before using it.

## Privacy

The stored configuration contains only the Brave executable path, profile
directory name, profile root path, and the public Chromium Web App ID. It does
not contain WhatsApp credentials or content. Diagnostic output intentionally
avoids browser database contents. Read [PRIVACY.md](docs/PRIVACY.md) before
posting diagnostics publicly.

## Uninstall

```bash
./uninstall.sh
```

This does **not** uninstall Brave, remove the Brave Web App, log you out, or
delete browser/site data. Manage the installed Web App separately at
`brave://apps` if you choose to remove it.

## Support and limitations

This project was developed and live-tested on Ubuntu 24.04 with GNOME/X11 and
Brave Snap. The included isolated tests cover both native and Snap path layouts.
Wayland and other desktop environments should work, but need wider community
testing. WhatsApp Web and Brave can change independently; compatibility is not
guaranteed.

- [Troubleshooting](docs/TROUBLESHOOTING.md)
- [Security policy](SECURITY.md)
- [Contributing](CONTRIBUTING.md)

## Upstream references

- [WhatsApp's desktop download page](https://www.whatsapp.com/download/desktop)
- [Brave: install and use Web Apps](https://support.brave.app/hc/en-us/articles/39077114659597-How-do-I-install-and-use-Web-Apps-in-Brave)
- [Brave Linux installation](https://brave.com/linux/)
- [Chromium Web App identifier implementation](https://chromium.googlesource.com/chromium/src/+/refs/heads/main/chrome/browser/web_applications/app_id_helpers.cc)
- [IBus command documentation](https://man.archlinux.org/man/ibus.1.en)

## License

Project code and original documentation are available under the [MIT License](LICENSE).
See [third-party notices](THIRD_PARTY_NOTICES.md) for upstream names and links.
