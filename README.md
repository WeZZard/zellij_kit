# Zellij Kit

Shell scripts for managing Zellij sessions with AI coding assistant layouts.

## Installation

1. Clone this repository:
   ```bash
   git clone <repository-url> ~/zellij_kit
   ```

2. Add the `bin/` directory to your PATH in `~/.zshrc`:
   ```bash
   export PATH="$HOME/zellij_kit/bin:$PATH"
   ```

3. Reload your shell:
   ```bash
   source ~/.zshrc
   ```

## Scripts

### zellij-launch

Create or attach to a Zellij session with a predefined layout.

```bash
zellij-launch [--layout regular|compact] [session_name]
```

**Examples:**
- `zellij-launch` - Create/attach to 'master' session with regular layout
- `zellij-launch --layout compact` - Use compact layout
- `zellij-launch mysession` - Custom session name
- `zellij-launch --layout compact dev` - Compact layout with 'dev' session

### zellij-workspace

Open a new tab in the current Zellij session. Must be run inside an existing Zellij session.

```bash
zellij-workspace [--layout regular|compact] [working_directory]
```

**Examples:**
- `zellij-workspace` - Open tab in current directory with compact layout
- `zellij-workspace --layout regular` - Use regular layout
- `zellij-workspace ~/Projects/myapp` - Open specific directory
- `zellij-workspace --layout regular ~/Projects/myapp` - Regular layout in specific directory

## Layouts

| Layout | Description |
|--------|-------------|
| **regular** | Claude + Yazi side-by-side, floating htop |
| **compact** | Stacked Shell + Claude panes, floating htop |

Each layout has a session variant (for `zellij-launch`) and a workspace variant (for `zellij-workspace`).

### Layout Files

- `layouts/regular-layout.kdl` - Regular session layout
- `layouts/regular-workspace-layout.kdl` - Regular workspace tab layout
- `layouts/compact-layout.kdl` - Compact session layout
- `layouts/compact-workspace-layout.kdl` - Compact workspace tab layout

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `ZJ_LAYOUT_DIR` | Override layouts directory | `../layouts` relative to scripts |

## Requirements

- [Zellij](https://zellij.dev/) terminal multiplexer
- [Yazi](https://yazi-rs.github.io/) file manager (used in layouts)
- [Claude Code](https://claude.ai/code) CLI (used in layouts)
