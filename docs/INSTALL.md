# Installation

## 1. Install Brave

Use only Brave's [official Linux instructions](https://brave.com/linux/).
The native APT package is preferred upstream. This helper also supports the
official Snap. It never downloads or installs Brave for you.

## 2. Install this helper as your normal user

```bash
./install.sh
```

Do not use `sudo`. Files are installed below `~/.local` by default.

## 3. Install the official site as a Brave Web App

If a unique installed WhatsApp Web PWA is already present in the selected
profile, setup detects it. Otherwise Brave opens the official site:

1. Sign in using WhatsApp's normal linked-device flow.
2. In Brave select **Save and share → Install WhatsApp Web**.
3. Return to the terminal and press Enter.

The helper checks the PWA resources, copies a local icon from that installation,
and writes its own desktop entry. It never reads WhatsApp's IndexedDB or cookies.

## Multiple Brave profiles or Web Apps

Choose a profile explicitly:

```bash
linux-whatsapp-web setup --profile "Profile 1"
```

If more than one Web App candidate exists and automatic identification cannot
choose safely, setup stops and prints the candidates. After verifying the ID
belongs to the official WhatsApp Web installation, you can pass the visible
32-letter Chromium app ID (the helper still validates it against the current
official manifest identity):

```bash
linux-whatsapp-web setup --profile "Profile 1" --app-id APP_ID
```

## Custom installation prefix

```bash
./install.sh --prefix "$HOME/.local"
```

The launcher itself remains per-user under the XDG data directory.
