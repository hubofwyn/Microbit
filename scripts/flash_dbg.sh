#!/usr/bin/env bash
set -Eeuo pipefail
shopt -s nullglob

pattern="microbit-*.hex"
downloads="$HOME/Downloads"
proj="$HOME/Projects/Microbit"
ts=$(date +"%Y%m%d_%H%M%S")
log="/tmp/flash_dbg_${ts}.log"

exec > >(tee "$log") 2>&1
echo "=== flash_dbg run $ts ==="

# 1. newest MakeCode file (glob instead of ls)
files=("$downloads"/$pattern)
if ((${#files[@]} == 0)); then
    echo "❌  No MakeCode .hex in $downloads.  Download a program first."
    exit 1
fi
# sort by mtime, newest first
IFS=$'\n' sorted=($(stat -c "%Y %n" "${files[@]}" | sort -nr | cut -d' ' -f2-))
src="${sorted[0]}"
echo "Chosen file : $src"
echo "Size        : $(stat -c%s "$src") bytes"

# 2. archive original
mkdir -p "$proj"
arch="${proj}/${ts}_$(basename "$src")"
mv -- "$src" "$arch"
echo "Archived to : $arch"

# 3. locate MICROBIT mount + block dev
mnt=$(lsblk -o LABEL,MOUNTPOINT -nr | awk '$1=="MICROBIT"{print $2;exit}')
dev=$(lsblk -o NAME,LABEL     -nr | awk '$2=="MICROBIT"{print "/dev/"$1;exit}')
if [[ -z "$mnt" || -z "$dev" ]]; then
    echo "❌  MICROBIT not mounted.  Plug the board in and wait a second."
    exit 1
fi
echo "Mount point : $mnt"
echo "Block dev   : $dev"

# 4. copy file under short name
echo -n "Copying to board… "
cp -- "$arch" "${mnt}/microbit.hex" && sync
echo "done."

# 5. compare checksums
sha_src=$(sha1sum "$arch" | awk '{print $1}')
sha_board=$(sha1sum "${mnt}/microbit.hex" | awk '{print $1}')
echo "SHA‑1 src   : $sha_src"
echo "SHA‑1 board : $sha_board"

# 6. unmount, wait 3 s for reboot
udisksctl unmount -b "$dev" >/dev/null 2>&1 || true
sleep 3

# 7. check for FAIL.TXT
if [[ -d "$mnt" && -f "${mnt}/FAIL.TXT" ]]; then
    echo "FAIL.TXT detected:"
    cat "${mnt}/FAIL.TXT"
else
    echo "No FAIL.TXT immediately after unmount."
fi

# 8. tail kernel log (needs sudo)
echo "-- dmesg tail --"
sudo dmesg | tail -n 40

echo "Log saved to $log"

