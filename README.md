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
2. Create (if needed) and edit a per-child Python file under `python/` (for example `python/axel/main.py`) instead of the default `python/main.py` to organize code per kid.
3. Press `Ctrl+Shift+B` (or `Cmd+Shift+B` on macOS) to run the **Flash to micro:bit** task, which will also archive your source to prevent accidental loss.

Behind the scenes this will call `scripts/flash_py.sh`, which:

1. Converts the active `.py` file to a `.hex` using `py2hex` (via the uflash package) and saves it to `./build/`.
2. Archives your `.py` source under `python/archive/` or `python/<kid>/archive/` with a timestamp.
3. Copies the `.hex` to the connected micro:bit drive.
4. Syncs/unmounts the drive and checks for `FAIL.TXT` so you get **immediate** feedback if something went wrong.

When everything is fine you will see a green “Flash successful!” message in the VS Code terminal and your Python program will start running on the board within a couple of seconds.

### (Optional) Serial console

Want to see `print()` output or REPL messages?  Run the **Open serial console** task:

1. Press `F1` → *Tasks: Run Task* → *Open serial console*, or
2. Use the dedicated keybinding you may assign in VS Code.

This opens a `miniterm` session at `115200 baud` on `/dev/ttyACM0`.  Close it with `Ctrl-]` then `Ctrl-D`.

### Saving hex programs from the micro:bit

If you need to retrieve a MakeCode or previously flashed Python `.hex` file from the board, use the `scripts/save_hex.sh` helper:

```bash
scripts/save_hex.sh <kid_name> [dest_base_dir]
```

This will copy `microbit.hex` from the connected micro:bit drive into a timestamped file under `programs/<kid_name>/` by default (or the specified destination directory), making it easy to keep each child's programs organized.
