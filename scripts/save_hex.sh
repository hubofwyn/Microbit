#!/usr/bin/env bash
set -Eeuo pipefail

usage() {
    echo "Usage: $(basename "$0") <kid_name> [dest_base_dir]"
    echo
    echo "Copy micro:bit's current microbit.hex to a per-kid directory with timestamp."
    echo
    echo "Arguments:"
    echo "  kid_name        Name of the child (e.g., wyn, ila, axel)"
    echo "  dest_base_dir   Base directory to store programs (default: ./programs)"
    exit 1
}

if [[ $# -lt 1 ]]; then
    usage
fi

kid="$1"
dest_base_dir="${2:-$PWD/programs}"
dest_dir="$dest_base_dir/$kid"
mkdir -p "$dest_dir"

# Locate MICROBIT mount point
mnt="$(lsblk -o LABEL,MOUNTPOINT -nr | awk '$1=="MICROBIT"{print $2;exit}')"
if [[ -z "$mnt" ]]; then
    echo "❌  micro:bit drive 'MICROBIT' not found. Is the board plugged in?"
    exit 1
fi

hexfile="$mnt/microbit.hex"
if [[ ! -f "$hexfile" ]]; then
    echo "❌  No microbit.hex found on the device at $mnt."
    exit 1
fi

ts="$(date +'%Y%m%d_%H%M%S')"
dest_file="$dest_dir/${ts}_microbit.hex"

cp -- "$hexfile" "$dest_file"
echo "✅  Saved $hexfile to $dest_file"