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
