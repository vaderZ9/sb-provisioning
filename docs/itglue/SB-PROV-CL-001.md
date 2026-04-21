# SB-PROV-CL-001 — Deployment Checklist

**Document type:** Checklist
**Status:** DRAFT — not yet validated
**Last updated:** 2026-04-20

---

## Pre-deployment

### Hardware
- [ ] Machine is x86_64
- [ ] TPM 2.0 present and enabled in BIOS
- [ ] UEFI boot mode confirmed (no legacy/CSM)
- [ ] Secure Boot capable
- [ ] Serial number and asset tag recorded

### Environment
- [ ] Ubuntu 24.04 LTS ISO SHA256 verified
- [ ] Provisioning media prepared
- [ ] Network available

---

## During installation
- [ ] Autoinstall loaded (not manual install)
- [ ] Partition layout matches spec
- [ ] LUKS2 container created on sda3
- [ ] LVM volumes created inside LUKS

---

## Post-installation

### Encryption
- [ ] TPM2 enrollment confirmed (systemd-cryptenroll)
- [ ] Auto-unlock on reboot — no passphrase prompt
- [ ] All LVM volumes mounted correctly

### Hardening
- [ ] CIS Level 1 playbook applied
- [ ] OpenSCAP scan completed
- [ ] Score recorded: ____%
- [ ] Exceptions documented in hardening/cis-l1/exceptions.md

### Final
- [ ] SSH access confirmed
- [ ] Network connectivity confirmed
- [ ] Hostname set correctly
- [ ] Asset recorded in IT Glue

---

## Sign-off
Provisioned by: ________________
Date: ________________
Ticket #: ________________
OpenSCAP score: ________________
Notes: ________________

*Attach completed checklist to Autotask ticket for the deployment.*
