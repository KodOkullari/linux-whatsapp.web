# Packaging

The primary distribution is the source repository and the deterministic source
archive built by:

```bash
./packaging/build-source-archive.sh
```

A dependency-light Debian package can be built without maintainer scripts:

```bash
./packaging/build-deb.sh
```

It installs only the CLI and documentation. It deliberately has no `postinst`
or `prerm`; after package installation, each normal user runs
`linux-whatsapp-web setup` themselves.

Additional Debian source metadata is included under `packaging/debian`.
A system package must never edit
an arbitrary user's Brave profile, Web App registration, IBus session, or login
data. After installing a future `.deb`, each user must run:

```bash
linux-whatsapp-web setup
```

The package remains a community preview until it is tested across more Ubuntu
versions and desktop environments.
