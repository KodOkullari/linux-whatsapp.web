# Privacy

linux-whatsapp-web operates locally and does not run a server or telemetry.

The helper stores only:

- Brave executable path;
- selected Brave profile directory name and profile root path;
- public Chromium Web App ID;
- a copy of the locally installed Web App icon;
- its generated desktop entry.

It does not inspect, copy, upload, back up, modify, or delete WhatsApp messages,
cookies, tokens, QR codes, IndexedDB, Local Storage, Service Worker data, or
Brave profile databases. Network access to WhatsApp is performed by Brave, not
by this helper. The setup opens only the official `https://web.whatsapp.com/`
URL when manual Web App installation is needed.

Diagnostic output includes local executable and profile paths. Review and
redact them before publishing an issue.
