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
