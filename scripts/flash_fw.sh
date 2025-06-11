#!/usr/bin/env bash
set -Eeuo pipefail
shopt -s nullglob

# Script to update the DAPLink interface firmware on a micro:bit in maintenance mode.

# Determine project root (parent of this script's directory)
proj="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# Pattern for firmware hex (beta) files in project root
pattern="*beta*.hex"

ts=$(date +"%Y%m%d_%H%M%S")
log="/tmp/flash_fw_${ts}.log"

exec > >(tee "$log") 2>&1
echo "=== flash_fw run $ts ==="

# 1. find firmware hex in project root
files=("$proj"/$pattern)
if ((${#files[@]} == 0)); then
    echo "❌  No firmware .hex matching '$pattern' in $proj."
    exit 1
fi
# sort by mtime, newest first
IFS=$'\n' sorted=($(stat -c "%Y %n" "${files[@]}" | sort -nr | cut -d' ' -f2-))
fw="${sorted[0]}"
echo "Chosen firmware : $fw"
echo "Size             : $(stat -c%s "$fw") bytes"

# 2. locate MAINTENANCE-mode mount (bootloader drive)
echo "Looking for micro:bit in maintenance mode (drive label 'MAINTENANCE')..."
mnt=$(lsblk -o LABEL,MOUNTPOINT -nr | awk '$1=="MAINTENANCE"{print $2;exit}')
if [[ -z "$mnt" ]]; then
    echo "❌  Maintenance-mode drive 'MAINTENANCE' not found. Press reset twice to enter maintenance mode."
    exit 1
fi
echo "Mount point     : $mnt"

# 3. copy firmware to device
echo -n "Copying firmware to board… "
cp -- "$fw" "$mnt/" && sync
echo "done."

echo "Firmware update complete. Log saved to $log"
