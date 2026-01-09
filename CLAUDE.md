# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Zellij Kit is a collection of zsh scripts for managing Zellij terminal multiplexer sessions with predefined layouts. The primary focus is Zellij workflows with AI coding assistants (Claude).

## Repository Structure

```
bin/           # Executable scripts (add to PATH)
  zellij-launch       # Create/attach to Zellij sessions
  zellij-workspace    # Open new tabs in existing sessions
  zellij-common.zsh   # Shared functions (sourced by scripts)
layouts/       # KDL layout files for Zellij
```

## Key Scripts

- **zellij-launch**: Creates or attaches to a Zellij session with a layout
  ```bash
  zellij-launch [--layout regular|compact] [session_name]
  ```
  Default: `--layout regular`, session name `master`

- **zellij-workspace**: Opens a new tab in an existing Zellij session (must run inside Zellij)
  ```bash
  zellij-workspace [--layout regular|compact] [working_directory]
  ```
  Default: `--layout compact`, current directory

## Layouts

Two layout variants, each with session and workspace versions:

- **regular**: Split vertical layout with Claude agent pane + Yazi file explorer, floating htop
- **compact**: Stacked panes (Shell + Claude), floating htop/Yazi

Layout files use KDL format and are located relative to scripts via `$ZJ_LAYOUT_DIR`.

## Environment Variables

- `ZJ_LAYOUT_DIR`: Override default layouts directory (default: `../layouts` relative to script)

## Development Notes

- All scripts use zsh (`#!/bin/zsh`) and `set -euo pipefail` for strict error handling
- Scripts source `zellij-common.zsh` for shared functions (`get_layout`, `check_zellij_installed`)
- Scripts detect if running inside Zellij (`$ZELLIJ` env var) to prevent nesting or enforce context
- Layout paths are resolved relative to script location for portability

## Design Principles: Exit Codes & Silent Success

**Golden Rule**: Successfully preventing an undesired operation is SUCCESS, not failure.

### Re-entrance Prevention Pattern

When detecting you're already in the desired state, exit silently with code 0:

```zsh
# GOOD: Silent success (idempotent, no noise)
if [[ -n "${ZELLIJ:-}" ]]; then
    exit 0
fi

# BAD: Noisy error (breaks idempotency, pollutes terminal)
if [[ -n "${ZELLIJ:-}" ]]; then
    echo "Error: Already inside a Zellij session..."
    exit 1
fi
```

**Why exit 0?**
- Desired state already achieved = success
- Enables safe idempotent execution (auto-launch scripts)
- Prevents terminal clutter in nested shell contexts
- Unix philosophy: silence is golden

**Why no output?**
- User can see the Zellij UI (redundant information)
- Might be muscle memory or auto-executed
- Every echo is cognitive pollution

**Exit 1 reserved for**: Actual errors (missing files, invalid args, command failures)
