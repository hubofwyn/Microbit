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

### `scripts/save_hex.sh` (Retrieve flashed `.hex`)

A helper to copy the current `microbit.hex` file from the connected micro:bit drive into a local per-kid directory for safekeeping.

- Copies `microbit.hex` from the board to `programs/<kid_name>/` (by default under the current directory).
- Usage:
  ```bash
  scripts/save_hex.sh <kid_name> [dest_base_dir]
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
2. Create (if needed) and edit a per-child Python file under `python/` (e.g., `python/axel/main.py`) instead of the default `python/main.py` to organize code per kid.
3. Press `Ctrl+Shift+B` (or `Cmd+Shift+B` on macOS) to run the **Flash to micro:bit** task, which archives your source automatically and flashes the board.

   This launches `scripts/flash_py.sh`, our small helper that:

- Converts the current `.py` file to a `.hex` using `py2hex` (via the uflash package) and saves it to `./build/`.
   - Archives your `.py` source under `python/archive/` or `python/<kid>/archive/` with a timestamp.
   - Copies the `.hex` to the board and syncs/unmounts.
   - Checks for `FAIL.TXT` so you get immediate feedback if something went wrong.

### Serial console (optional)

If you need to inspect `print()` output or interact with the MicroPython REPL,
run the secondary VS Code task **Open serial console**.  It starts
`python -m serial.tools.miniterm /dev/ttyACM0 115200` in a dedicated panel.  To
exit the console press `Ctrl-]` followed by `Ctrl-D`.

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