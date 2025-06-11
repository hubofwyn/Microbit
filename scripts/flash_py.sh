#!/usr/bin/env bash

# A small helper to make flashing MicroPython source files to the BBC micro:bit
# from VS Code **dead-simple**.
#
# Usage (normally invoked through the VS Code "Flash to micro:bit" task):
#   scripts/flash_py.sh path/to/file.py
#
# The script will:
#   1. Convert the `.py` file to a `.hex` using `uflash`.
#   2. Copy the generated `.hex` to the micro:bit drive labeled `MICROBIT`.
#   3. Sync the disks and, if available, unmount the drive cleanly.
#   4. Detect the presence of `FAIL.TXT` to warn the user of any problems.

set -Eeuo pipefail

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <file.py>" >&2
    exit 1
fi

src="$1"

# Absolute path to the source file for safety
src_abs="$(cd "$(dirname "$src")" && pwd)/$(basename "$src")"

if [[ ! -f "$src_abs" ]]; then
    echo "❌  Source file '$src_abs' not found." >&2
    exit 1
fi

# Ensure py2hex is installed (provided by the uflash package)
if ! command -v py2hex >/dev/null 2>&1; then
    echo "❌  'py2hex' is not installed. Install it with:  pip install uflash" >&2
    exit 1
fi

# Determine repository root (directory above this script)
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

build_dir="$repo_root/build"
mkdir -p "$build_dir"

# Archive the source file to prevent loss (timestamped).
ts="$(date +'%Y%m%d_%H%M%S')"
# Determine archive directory; use per-kid subfolder if editing under python/<kid>/
relpath="${src_abs#$repo_root/python/}"
if [[ "$relpath" != "$src_abs" && "$relpath" == */* ]]; then
    kid="${relpath%%/*}"
    archive_dir="$repo_root/python/$kid/archive"
else
    archive_dir="$repo_root/python/archive"
fi
mkdir -p "$archive_dir"
cp -- "$src_abs" "$archive_dir/${ts}_$(basename "$src_abs")"
echo "🗄️  Archived source to $archive_dir/${ts}_$(basename "$src_abs")"

# Generate HEX in the build directory using py2hex
hex_basename="$(basename "${src_abs%.*}").hex"
hex_path="$build_dir/$hex_basename"

echo "⚙️  Converting $src_abs → $hex_path"
py2hex -o "$build_dir" "$src_abs"

# Locate MICROBIT mount point
mnt="$(lsblk -o LABEL,MOUNTPOINT -nr | awk '$1=="MICROBIT"{print $2;exit}')"

if [[ -z "$mnt" ]]; then
    echo "❌  micro:bit drive 'MICROBIT' not found. Is the board plugged in?" >&2
    exit 1
fi

echo "📄 Copying $(basename "$hex_path") → $mnt/microbit.hex"
cp -- "$hex_path" "$mnt/microbit.hex"

# Ensure data is flushed to the device
sync

# Try to unmount cleanly (non-fatal if it fails)
dev="$(lsblk -o NAME,LABEL -nr | awk '$2=="MICROBIT"{print "/dev/"$1;exit}')"
if [[ -n "$dev" ]]; then
    udisksctl unmount -b "$dev" >/dev/null 2>&1 || true
fi

# Give the board a moment to reboot.
sleep 2

# Check for FAIL.TXT – if present, print its contents so the user immediately
# knows what went wrong.
if [[ -f "${mnt}/FAIL.TXT" ]]; then
    echo "⚠️  FAIL.TXT detected on the device – flashing may have failed:"
    echo "------------------------------------------------------------"
    cat "${mnt}/FAIL.TXT"
    echo "------------------------------------------------------------"
    exit 1
fi

echo "✅  Flash successful! Your program should now be running on the micro:bit."
