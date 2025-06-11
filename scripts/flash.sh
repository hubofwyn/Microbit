#!/usr/bin/env bash
set -Eeuo pipefail
shopt -s nullglob

pattern="microbit-*.hex"
downloads="$HOME/Downloads"
files=("$downloads"/$pattern)
if ((${#files[@]} == 0)); then
    echo "No MakeCode .hex file found in $downloads. Download your program first!"
    exit 1
fi
fw=$(ls -t "${files[@]}" | head -n1)
echo "Flashing $fw to micro:bit..."

mnt=$(lsblk -o LABEL,MOUNTPOINT -nr | awk '$1=="MICROBIT"{print $2;exit}')
if [[ -z "$mnt" ]]; then
    echo "Please plug in your micro:bit normally and try again."
    exit 1
fi

cp -- "$fw" "$mnt"/microbit.hex && sync
echo "Done! Your program is now running on the micro:bit."