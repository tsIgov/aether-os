#!/bin/sh
strict_mode(){
    set -T # inherit DEBUG and RETURN trap for functions
    set -C # prevent file overwrite by > &> <>
    set -E # inherit -e
    set -e # exit immediately on errors
    set -u # exit on not assigned variables
    set -o pipefail # exit on pipe failure
}
strict_mode

reset() {
	sudo umount /mnt/boot &>/dev/null || true
	sudo umount /mnt &>/dev/null || true
	sudo rm -rf /mnt &>/dev/null || true

	sudo swapoff /dev/disk/by-label/AetherOS-swap &>/dev/null || true
	sudo vgchange -an lvmroot &>/dev/null || true
	sudo cryptsetup close cryptroot &>/dev/null || true
}

disk=$1
start_s=$2
root_size_mib=$3
swap_size_mib=$4
boot_size_mib=$5
sectors_per_mib=$6
encryption_password="$7"

boot_start_s=$start_s
boot_end_s=$(( $boot_start_s + $boot_size_mib * $sectors_per_mib - 1 ))

root_start_s=$(( $boot_start_s + $boot_size_mib * $sectors_per_mib ))
root_end_s=$(( $root_start_s + $root_size_mib * $sectors_per_mib - 1 ))

efi_part_num=$(sudo parted -m "/dev/$disk" print | awk -F: 'END {print $1+1}') //1
if [[ "$disk" =~ nvme|mmcblk ]]; then
    efi_part="/dev/${disk}p${efi_part_num}"
else
    efi_part="/dev/${disk}${efi_part_num}"
fi

root_part_num=$(( $efi_part_num + 1 )) //2
if [[ "$disk" =~ nvme|mmcblk ]]; then
    root_part="/dev/${disk}p${root_part_num}"
else
    root_part="/dev/${disk}${root_part_num}"
fi

reset

sudo parted -s "/dev/$disk" mkpart primary fat32 "$boot_start_s"s "$boot_end_s"s
sudo parted -s "/dev/$disk" mkpart primary ext4 "$root_start_s"s "$root_end_s"s

sudo wipefs -fa "$efi_part" &>/dev/null || true
sudo wipefs -fa "$root_part" &>/dev/null || true

sudo parted -s "/dev/$disk" set $efi_part_num esp on
sudo parted -s "/dev/$disk" set $efi_part_num boot on

sudo mkfs.fat -F 32 "$efi_part" -n "aether-boot"
echo -n "$encryption_password" | sudo cryptsetup luksFormat --type luks2 --label="AetherOS-encrypted" "$root_part"
echo -n "$encryption_password" | sudo cryptsetup open "$root_part" cryptroot
sudo pvcreate /dev/mapper/cryptroot
sudo vgcreate lvmroot /dev/mapper/cryptroot

if [[ $swap_size_mib -gt 0 ]]; then
	sudo lvcreate --size ${swap_size_mib}M lvmroot --name swap
	sudo mkswap -L "AetherOS-swap" /dev/mapper/lvmroot-swap
	sudo swapon /dev/disk/by-label/AetherOS-swap
fi

sudo lvcreate -l 100%FREE lvmroot --name root
sudo mkfs.ext4 -L "AetherOS-root" /dev/mapper/lvmroot-root

sudo mkdir /mnt
sudo mount /dev/disk/by-label/AetherOS-root /mnt
sudo mkdir /mnt/boot
sudo mount "$efi_part" /mnt/boot

