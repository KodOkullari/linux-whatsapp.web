# Security Policy

## Supported versions

Security fixes are made on the latest tagged release and the default branch.

## Reporting

Please use GitHub's private security advisory feature instead of a public issue
for suspected vulnerabilities. Do not include real WhatsApp QR codes, cookies,
tokens, phone numbers, messages, screenshots, or browser databases in a report.

## Security boundaries

This project intentionally:

- runs setup and repair operations only as a normal user;
- does not install browser packages or change system repositories;
- never reads or copies WhatsApp authentication/session databases;
- never automates messages, QR scanning, page content, or account actions;
- keeps IBus repair separate, opt-in, and limited to `ibus restart`;
- removes only exact project-owned paths.

The project launches an external browser and the official WhatsApp Web service.
Their security, availability, privacy policies, and account behavior remain
outside this project's control.
