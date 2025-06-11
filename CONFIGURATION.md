# Project Configuration Guide

This document provides detailed information on the scripts, configurations,
and file structure included in this repository to streamline micro:bit
development using MakeCode and MicroPython, both via command-line scripts
and within VSCode.

## Repository Layout

```text
.
├── archive/              # Archived .hex builds (ignored by Git)
├── scripts/              # Helper scripts for flashing and firmware updates
│   ├── flash.sh          # Simple flash script for beginners
│   ├── flash_dbg.sh      # Advanced debug-flash script with logging
│   └── flash_fw.sh       # Firmware update script (maintenance mode)
├── python/               # Python/MicroPython template code
│   └── main.py           # Example MicroPython script to run on micro:bit
├── .vscode/              # VSCode editor configuration
│   └── tasks.json        # VSCode Build Task for flashing Python code
├── .gitignore            # Patterns for files/directories to ignore in Git
├── README.md             # High-level usage and getting started guide
└── CONFIGURATION.md      # (this file) detailed config & usage reference
```

---

## Quick Flash Script (`scripts/flash.sh`)

Beginners can flash their MakeCode `.hex` files with a single command:

```bash
scripts/flash.sh
```

This script:

- Locates the newest `microbit-*.hex` in your `$HOME/Downloads`.
- Finds the **MICROBIT** USB drive.
- Copies the file and synchronizes it.
- Prints a simple “Done!” message when complete.

---

## Advanced Debug Flash Script (`scripts/flash_dbg.sh`)

For more control and logging, use:

```bash
scripts/flash_dbg.sh
```

Features include:

- Archiving each flashed `.hex` into `archive/` with a timestamp.
- Detailed logging (saved to `/tmp/flash_dbg_<timestamp>.log`).
- SHA-1 checksum comparison, unmount, and kernel message tail.

---

## Firmware Update Script (`scripts/flash_fw.sh`)

To update the DAPLink interface firmware (maintenance mode):

1. Put the micro:bit into maintenance mode (hold RESET while plugging in).
2. Verify a drive labeled **MAINTENANCE** is mounted.
3. Run:
   ```bash
   scripts/flash_fw.sh
   ```

The script finds the latest `*beta*.hex` firmware in the repo root, flashes it,
and logs output to `/tmp/flash_fw_<timestamp>.log`.

---

## Python Development & VSCode Setup

We’ve provided a template and a VSCode Build Task so you can write
MicroPython code and flash it directly from the editor.

### Prerequisites

- Python 3 and `pip`
- Install `uflash`:
  ```bash
  pip install uflash
  ```
- VSCode with the Python extension

### Using the template

Edit your code in `python/main.py`.

### Flashing from VSCode

Press **Ctrl+Shift+B** (or **Cmd+Shift+B** on macOS), which runs the
**Flash to micro:bit** task defined in `.vscode/tasks.json`. This will
automatically convert and flash your current Python file to the connected
micro:bit.

---

## GitHub Publishing

This repository is already configured for GitHub. Create and push to the
remote with:

```bash
gh repo create --public --source=. --remote=origin --push --confirm
```

You now have a clean, well-organized project ready for public sharing.