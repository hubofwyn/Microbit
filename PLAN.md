# Plan for Python + VSCode Flash Workflow

**NOTE:** This plan assumes your micro:bit interface firmware has already been updated to v0258+ (or later); firmware upgrade steps are omitted.

## Goal

Maintain the existing browser/MakeCode flash scripts while also offering a robust, one‑step Python‑in‑VSCode → flash experience—without manual firmware updates.

## Proposed changes

### 1. Provide a unified Python‑flash wrapper

- Add a shell wrapper script (`scripts/flash_py.sh`) that:
  1. Runs `uflash` on the specified `.py` file to generate a `.hex` (e.g., in `./build/`).
  2. Copies the generated `.hex` to the micro:bit mass‑storage drive (`MICROBIT`), then syncs and optionally unmounts, checking for `FAIL.TXT`.
- Update the VS Code task in `.vscode/tasks.json` to invoke this wrapper instead of raw `uflash ${file}`.

### 2. Enhance documentation

- Extend `CONFIGURATION.md`/`README.md` to document the new Python‑flash wrapper workflow step by step.
- Include notes on failure‑mode detection (`FAIL.TXT`) and point users to `scripts/flash_dbg.sh` for debugging.

## Next steps

1. Review this plan.
2. Implement `scripts/flash_py.sh`, update `.vscode/tasks.json`, and enhance the docs accordingly.