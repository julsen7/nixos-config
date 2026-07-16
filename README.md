# NIXOS

Boot from USB-stick with Nixos-minimal. Change host.

```bash
sudo cfdisk /dev/nvme0n1 gpt (512M EFI System und rest linux filesystem) schreiben

sudo mkfs.vfat -F 32 -n boot /dev/nvme0n1p1
sudo mkfs.ext4 -F -L nixos /dev/nvme0n1p2

sudo mount /dev/nvme0n1p2 /mnt
sudo mount --mkdir /dev/nvme0n1p1 /mnt/boot
lsblk -f

sudo nixos-install --flake github:julsen7/nixos#HOST
```
