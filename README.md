# nixos-config

Boot from USB-stick with Nixos-minimal.

```bash
sudo cfdisk /dev/nvme0n1 gpt (512M EFI System und rest linux filesystem) schreiben

sudo mkfs.vfat -F 32 -n boot /dev/nvme0n1p1
sudo mkfs.ext4 -F -L nixos /dev/nvme0n1p2

sudo mount /dev/nvme0n1p2 /mnt
sudo mount --mkdir /dev/nvme0n1p1 /mnt/boot
lsblk -f

sudo nixos-install --flake github:julsen7/nixos-config#HOST --no-write-lock-file
```

TODO:

hyprlock
wallpaper
matugen
rest an dotfiles

git clone <https://github.com/JafarAkhondali/acer-predator-turbo-and-rgb-keyboard-linux-module>
cd "acer-predator-turbo-and-rgb-keyboard-linux-module"
chmod +x ./*.sh
sudo ./install.sh
./facer_rgb.py -m 3
