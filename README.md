# Zellij Kit

A collection of utility scripts for managing Zellij sessions and layouts.

## Scripts

### zj
Session management utility for Zellij.

Usage:
```bash
zj [session_name] [layout_path]
```

- Creates or attaches to a zellij session
- Optionally loads a layout file when creating a new session

### new-tab-with-layout
Opens a new tab in the current zellij session with a specified layout.

Usage:
```bash
new-tab-with-layout [layout_path]
```

- Must be run inside an active zellij session
- Requires a valid layout file path

## Installation

1. Clone this repository to your home directory:
   ```bash
   git clone <repository-url> $HOME/zellij_kit
   ```

2. Add the bin directory to your PATH in ~/.zshrc:
   ```bash
   export PATH="$HOME/zellij_kit/bin:$PATH"
   ```

3. Reload your shell configuration:
   ```bash
   source ~/.zshrc
   ```

## Layout Files

Layout files should be in KDL format. Store them in a `layouts/` directory within this repository for easy access.