# Troubleshooting

## Keyboard works elsewhere but not in Brave / WhatsApp Web

First run the read-only check:

```bash
linux-whatsapp-web doctor
```

If the IBus address is missing or points to a missing Unix socket, save any
unfinished composition text and preview the repair:

```bash
linux-whatsapp-web repair-input
```

Apply it only after reading the warning:

```bash
linux-whatsapp-web repair-input --apply
```

Then close every Brave window and start WhatsApp Web again. The repair uses the
documented `ibus restart` command in the current user session. It does not kill
processes, delete sockets or caches, reset IBus configuration, or use root.

## QR code appears again

Do not copy profiles, cookies, or session databases. Verify that you always open
the same Brave profile and that Brave is not configured to delete site data for
`web.whatsapp.com` on exit. Site data can be inspected from Brave settings.
Re-link using the normal WhatsApp flow if the session was intentionally removed.

## Launcher opens the wrong window

Run setup again. The generated desktop entry uses the installed PWA's
`crx_<app-id>` window class so GNOME/KDE can group the correct window.

## PWA is not found

Confirm the app exists at `brave://apps`, then rerun setup with the correct
profile name. With multiple Web Apps you may need the explicit `--app-id` shown
in the setup diagnostic.

## Safe issue reports

Run:

```bash
linux-whatsapp-web doctor --json
```

Review the output before posting it. Redact user names and home/profile paths if
desired. Never upload screenshots containing QR codes, phone numbers, chats, or
the contents of browser profile databases.
