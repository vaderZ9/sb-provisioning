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
