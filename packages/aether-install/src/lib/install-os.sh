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

sudo nixos-install --root /mnt --no-root-passwd --flake /mnt/etc/aether-os#aether-os
