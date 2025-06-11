# Microbit Flash Script

This repository provides a simple script to flash a micro:bit board,
automatically archiving downloaded MakeCode hex files.

## Usage

### Quick flash (for beginners)

Plug in your micro:bit normally (no special buttons), then run:

```bash
scripts/flash.sh
```

It will find the latest MakeCode `.hex` in your Downloads folder, flash it, and you're ready to go!

### Advanced usage

To see detailed logs and archive previous builds, use:

```bash
scripts/flash_dbg.sh
```

The script will:

- Find the newest downloaded `microbit-*.hex` file in `$HOME/Downloads`.
- Archive it to `archive/` with a timestamp prefix.
- Copy it as `microbit.hex` to the connected micro:bit.
- Compare SHA-1 checksums before and after flashing.
- Unmount the device and show kernel messages.

## Firmware update

To update the DAPLink interface firmware on a micro:bit in maintenance mode, follow these steps:

1. Unplug the micro:bit, then press and hold the reset button while plugging it back in to enter maintenance mode. It will mount as a drive labeled `MAINTENANCE`.
2. (Optional) Verify the maintenance-mode drive is mounted:
   ```bash
   lsblk -o LABEL,MOUNTPOINT | grep MAINTENANCE
   ```
3. Run the firmware update script:
   ```bash
   scripts/flash_fw.sh
   ```

# Python development with VSCode

For Python-based micro:bit projects (for advanced users), we've included a template and VSCode setup to make editing and flashing easy.

### Prerequisites

- Python 3
- Install the `uflash` tool:
  ```bash
  pip install uflash
  ```
- VSCode with the Python extension

### Getting started

1. Open this folder in VSCode:
   ```bash
   code .
   ```
2. Edit your Python code in `python/main.py` (starting template provided).
3. Press `Ctrl+Shift+B` (or `Cmd+Shift+B` on macOS) to run the **Flash to micro:bit** task.

Your script will be converted to a `.hex` and flashed to the connected micro:bit automatically.
