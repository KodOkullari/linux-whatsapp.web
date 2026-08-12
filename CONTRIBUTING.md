# Contributing

Contributions are welcome, especially reproducible tests from different Linux
desktop environments and official Brave packaging formats.

Before opening a pull request:

```bash
./tests/run.sh
```

Keep the helper dependency-light and auditable. Do not add:

- WhatsApp or Brave logos/binaries;
- cookies, QR codes, profiles, session databases, or diagnostic archives;
- message automation, scraping, DOM injection, or reverse-engineered APIs;
- automatic root actions, browser installation, profile migration, or data deletion.

Document behavior changes in both the English README and the Turkish guide when
they affect users. New destructive actions are out of scope.
