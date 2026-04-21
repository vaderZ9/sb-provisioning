#!/bin/bash
set -euo pipefail

echo "[*] Scaffolding sb-provisioning repo..."

# Directory structure
mkdir -p docs/itglue
mkdir -p autoinstall
mkdir -p hardening/cis-l1
mkdir -p hardening/reports
mkdir -p pxe

# .gitignore
cat > .gitignore << 'GITIGNORE'
hardening/reports/
.DS_Store
*.key
*.pem
*.secret
GITIGNORE

# README
cat > README.md << 'README'
# sb-provisioning

ServiceByte bare metal provisioning pipeline for x86_64 pentesting/vulnerability scanner appliances.

## Status
- [x] Phase 0: Planning and toolchain setup
- [ ] Phase 1: Proxmox VM test environment (UEFI + swtpm TPM2)
- [ ] Phase 2: Ubuntu 24.04 autoinstall with LVM-on-LUKS + TPM2 auto-unlock
- [ ] Phase 3: CIS Level 1 hardening, scored with OpenSCAP
- [ ] Phase 4: PXE boot automation

## Repo structure
| Directory | Contents |
|-----------|----------|
| autoinstall/ | Ubuntu 24.04 autoinstall configs (user-data, meta-data) |
| docs/itglue/ | IT Glue-ready markdown documentation |
| hardening/cis-l1/ | CIS L1 playbook, exceptions, scan script |
| pxe/ | Phase 4 placeholder |

## Quick links
- [Architecture decisions](docs/itglue/SB-PROV-SOP-001.md)
- [Execution runbook](docs/itglue/SB-PROV-RB-001.md)
- [Deployment checklist](docs/itglue/SB-PROV-CL-001.md)
- [Changelog](CHANGELOG.md)

## Environment
- Test: Proxmox cluster, UEFI VMs with swtpm TPM2 emulation
- Target: x86_64 laptops with TPM 2.0
- OS: Ubuntu 24.04 LTS
- Architecture: x86_64 only
README

# CHANGELOG
cat > CHANGELOG.md << 'CHANGELOG'
# Changelog

## Session 2026-04-20
**Goal:** Project setup — documentation structure, toolchain, GitHub repo scaffold
**Result:** PASS
**What broke:** obsidian-mcp-tools did not auto-write Claude Desktop MCP config
**Fix:** Manually added mcpServers block to ~/Library/Application Support/Claude/claude_desktop_config.json
**Config change:** N/A
**Commit:** initial scaffold
CHANGELOG

# autoinstall/meta-data
cat > autoinstall/meta-data << 'METADATA'
instance-id: sb-prov-test-001
local-hostname: sb-appliance
METADATA

# autoinstall/user-data
cat > autoinstall/user-data << 'USERDATA'
#cloud-config
# Ubuntu 24.04 autoinstall config
# STATUS: PLACEHOLDER — not validated
# Phase 2 will populate this with full LVM-on-LUKS partition layout
autoinstall:
  version: 1
  # Full config to be built and validated in Phase 2
USERDATA

# autoinstall/README.md
cat > autoinstall/README.md << 'AUTOREADME'
# Autoinstall configs

Ubuntu 24.04 Subiquity autoinstall configuration.

## Files
- `user-data` — main autoinstall config (cloud-init format)
- `meta-data` — instance metadata

## Status
Placeholder. Full config developed and validated in Phase 2.

## Target partition layout
| Volume    | Size      | Mount     | Notes                     |
|-----------|-----------|-----------|---------------------------|
| sda1      | 512MB     | /boot/efi | vfat, EFI System Partition|
| sda2      | 1GB       | /boot     | ext4, unencrypted         |
| sda3      | remaining | LUKS2     | one container, LVM inside |
| lv-root   | 20GB      | /         |                           |
| lv-var    | 30GB      | /var      | scan databases, tool output|
| lv-varlog | 5GB       | /var/log  | CIS requirement           |
| lv-vartmp | 2GB       | /var/tmp  | CIS requirement           |
| lv-tmp    | 4GB       | /tmp      | CIS requirement           |
| lv-home   | 5GB       | /home     | CIS requirement           |
| lv-swap   | 4GB       | swap      |                           |
AUTOREADME

# hardening/cis-l1/exceptions.md
cat > hardening/cis-l1/exceptions.md << 'EXCEPTIONS'
# CIS Level 1 Exceptions

Controls intentionally not applied, with justification.

## Format
| Control ID | Description | Reason | Approved by |
|------------|-------------|--------|-------------|
| | | | |

*Populated during Phase 3 testing.*
EXCEPTIONS

# hardening/cis-l1/scan.sh
cat > hardening/cis-l1/scan.sh << 'SCAN'
#!/bin/bash
# OpenSCAP CIS Level 1 audit script
# STATUS: PLACEHOLDER — validated in Phase 3
#
# Usage: sudo ./scan.sh
# Output: HTML report saved to /tmp/scap-report-YYYYMMDD-HHMM.html

set -euo pipefail

PROFILE="xccdf_org.ssgproject.content_profile_cis_level1_server"
DATASTREAM="/usr/share/xml/scap/ssg/content/ssg-ubuntu2404-ds.xml"
REPORT="/tmp/scap-report-$(date +%Y%m%d-%H%M).html"
RESULTS="/tmp/scap-results-$(date +%Y%m%d-%H%M).xml"

echo "[*] Running OpenSCAP CIS Level 1 audit..."
echo "[*] Profile: $PROFILE"
echo "[*] Report: $REPORT"

oscap xccdf eval \
  --profile "$PROFILE" \
  --report "$REPORT" \
  --results "$RESULTS" \
  "$DATASTREAM" || true

echo "[*] Done. Open $REPORT in a browser to review results."
echo "[*] Copy report to hardening/reports/ for record keeping."
SCAN
chmod +x hardening/cis-l1/scan.sh

# hardening/cis-l1/README.md
cat > hardening/cis-l1/README.md << 'HARDREADME'
# CIS Level 1 Hardening

## Tools
- Applicator: ansible-lockdown/UBUNTU24-CIS
- Scoring: OpenSCAP with SSG Ubuntu 24.04 datastream

## Files
- `apply.yml` — Ansible playbook (Phase 3)
- `exceptions.md` — documented exceptions with justification
- `scan.sh` — OpenSCAP audit runner

## Reports
Scan output saved to `hardening/reports/` locally.
That directory is gitignored — reports stay on the provisioning machine.

## Status
Placeholder. Developed and validated in Phase 3.
HARDREADME

# pxe/README.md
cat > pxe/README.md << 'PXEREADME'
# PXE Boot Automation

Phase 4 placeholder.

## Planned contents
- iPXE/netboot configuration
- TFTP + HTTP server setup
- Autoinstall serving over HTTP
- Post-install hook chaining (TPM enroll + CIS hardening)
PXEREADME

# docs/itglue/SB-PROV-SOP-001.md
cat > docs/itglue/SB-PROV-SOP-001.md << 'SOP'
# SB-PROV-SOP-001 — Architecture and Design Decisions

**Document type:** Standard Operating Procedure
**Status:** DRAFT — not yet validated
**Last updated:** 2026-04-20

---

## Purpose
The "why" document. Records architectural decisions and security rationale.
For step-by-step execution see SB-PROV-RB-001.

---

## Problem statement
ServiceByte deploys x86_64 laptops as pentesting and vulnerability scanner appliances.
Manual provisioning is inconsistent, time-consuming, and not reproducible by other technicians.
This pipeline automates the full lifecycle from bare metal to hardened, encrypted, production-ready system.

---

## Key decisions

### Disk layout: LVM on LUKS
One LUKS2 container on sda3, LVM VG inside. Single TPM2 unlock event opens all volumes at boot.
Chosen over LUKS-on-LVM: one TPM2 enrollment, simpler recovery, standard Ubuntu autoinstall support.

### Boot: UEFI + Secure Boot only
Required for TPM2 PCR 7 sealing (Secure Boot state measurement).
SeaBIOS excluded — PCR layout incompatible with systemd-cryptenroll.

### TPM2 binding: systemd-cryptenroll
Upstream-preferred method, ships with Ubuntu 24.04.
Pending Phase 2 validation vs clevis-tpm2.

### PCR policy: PCR 0+7 baseline
PCR 0 = firmware, PCR 7 = Secure Boot state.
Pending Phase 2 validation — evaluate tightening after testing.

### Hardening: ansible-lockdown/UBUNTU24-CIS + OpenSCAP
ansible-lockdown as idempotent applicator, OpenSCAP for scoring and audit.
Pending Phase 3 validation.

---

## Threat model
Primary concern: data privacy on pentesting/vulnerability scanner appliance.
LUKS2 encryption protects scan data, credentials, and findings if device is lost or stolen.
TPM2 binding prevents offline attacks against the LUKS header.

---

## Open questions
- systemd-cryptenroll vs clevis-tpm2 — final decision pending Phase 2
- PCR register selection — evaluate tightening after Phase 2
- CIS exceptions required for appliance — pending Phase 3

---

*Decisions marked pending are confirmed through testing, not assumed.*
SOP

# docs/itglue/SB-PROV-RB-001.md
cat > docs/itglue/SB-PROV-RB-001.md << 'RB'
# SB-PROV-RB-001 — Tech Execution Runbook

**Document type:** Runbook
**Status:** DRAFT — not yet validated
**Audience:** ServiceByte technicians (Broderic, Jose G)
**Last updated:** 2026-04-20

---

## Purpose
Step-by-step execution guide for provisioning a bare metal x86_64 machine.
Every step includes expected output so you know if something went wrong.
Nothing here is theoretical — steps are added after successful validation only.

---

## Prerequisites
- [ ] Machine is x86_64
- [ ] TPM 2.0 present and enabled in BIOS
- [ ] UEFI boot mode confirmed (no legacy/CSM)
- [ ] Secure Boot capable
- [ ] Ubuntu 24.04 LTS ISO verified (SHA256 checked)
- [ ] Network available during provisioning

---

## Phase 1 — Boot and install
*To be completed after Phase 2 validation*

---

## Phase 2 — Verify encryption and TPM binding
*To be completed after Phase 2 validation*

---

## Phase 3 — Apply and verify CIS hardening
*To be completed after Phase 3 validation*

---

## Recovery procedures
*To be completed after testing*

---

## Known issues and workarounds
*Populated as issues are discovered during testing*

---

*Steps are added only after successful validation in the Proxmox test environment.*
RB

# docs/itglue/SB-PROV-CL-001.md
cat > docs/itglue/SB-PROV-CL-001.md << 'CL'
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
CL

# Commit and push
git add -A
git commit -m "initial scaffold: directory structure, placeholder configs, IT Glue doc skeletons"
git push origin main

echo ""
echo "[✓] Scaffold complete. Repo pushed to GitHub."
echo ""
git log --oneline
