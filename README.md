# Microbit Flash Script

This repository provides a simple script to flash a micro:bit board,
automatically archiving downloaded MakeCode hex files.

## Usage

```bash
scripts/flash_dbg.sh
```

The script will:

- Find the newest downloaded `microbit-*.hex` file in `$HOME/Downloads`.
- Archive it to `archive/` with a timestamp prefix.
- Copy it as `microbit.hex` to the connected micro:bit.
- Compare SHA-1 checksums before and after flashing.
- Unmount the device and show kernel messages.