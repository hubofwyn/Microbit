# Configuration Guide

This document describes the layout and configuration of this repository,
including the helper scripts, Python/VSCode setup, and Git/GitHub conventions.

## Repository layout

```
/archive/               Archived MakeCode `.hex` files
/scripts/               Helper flash and firmware-update scripts
/python/                MicroPython template files
.vscode/tasks.json      VSCode task for flashing Python code
README.md               Project overview and quickstart instructions
CONFIGURATION.md        This configuration guide
.gitignore              Git ignore rules
```

## Scripts

### `scripts/flash.sh` (Beginner friendly)

A simple flash helper for beginners:

- Finds the newest `microbit-*.hex` in `~/Downloads`
- Copies it to the micro:bit drive (`MICROBIT`)
- Synchronizes and reports "Done!"

Usage:

```bash
scripts/flash.sh
```

### `scripts/flash_dbg.sh` (Advanced logging)

A debug flash script that:

- Finds and archives the latest downloaded `.hex` to `archive/` with timestamp
- Copies and syncs to the micro:bit
- Compares SHA‑1 checksums before and after
- Unmounts the device and shows kernel messages
- Logs output to `/tmp/flash_dbg_<timestamp>.log`

Usage:

```bash
scripts/flash_dbg.sh
```

### `scripts/flash_fw.sh` (Firmware update)

A script to update the DAPLink interface firmware on a micro:bit in
maintenance mode (drive label `MAINTENANCE`):

- Finds the newest `*beta*.hex` in the project root
- Copies it to the maintenance-mode drive and syncs

Usage:

```bash
scripts/flash_fw.sh
```

#### Entering maintenance mode

To enter maintenance mode:

1. Unplug the micro:bit.
2. Press and hold the reset button while plugging it back in.
3. The board will mount as a drive labeled `MAINTENANCE`.

## Python development with VSCode

### Prerequisites

- Python 3
- [uflash](https://github.com/ntoll/uflash): `pip install uflash`
- [Visual Studio Code](https://code.visualstudio.com/) with the Python extension

### Getting started

1. Open the project in VSCode:
   ```bash
   code .
   ```
2. Edit `python/main.py` as your MicroPython code starter template.
3. Press `Ctrl+Shift+B` (or `Cmd+Shift+B` on macOS) to run the **Flash to micro:bit** task,
   which invokes `uflash` on the active file and flashes the resulting `.hex`.

## Git & GitHub conventions

- **Branch**: The default branch is named `main`.
- **Remote**: The `origin` remote points to the GitHub repository:
  ```
  git@github.com:hubofwyn/Microbit.git
  ```
- **Archive**: All archived hex files are stored in `archive/` (ignored by Git).
- **Commits**: Organize commits logically; avoid unrelated changes in the same commit.
- **Pull requests**: Use GitHub PRs for code reviews and collaboration.

---

That's the full configuration for this project.  
Happy coding!