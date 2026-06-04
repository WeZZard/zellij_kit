#!/bin/zsh

# zellij-common.zsh - Shared functions for Zellij Kit scripts
# This file should be sourced, not executed directly

# Resolve layout directory relative to the sourcing script
: ${ZJ_SCRIPT_DIR:="$(cd "$(dirname "${(%):-%x}")" && pwd)"}
: ${ZJ_LAYOUT_DIR:="${ZJ_SCRIPT_DIR}/../layouts"}
: ${ZJ_DEFAULT_LAYOUT:="compact"}

# Check whether a layout type is supported
is_valid_layout_type() {
    [[ "${1:-}" =~ ^(regular|compact)$ ]]
}

# Get the configured default layout type
get_default_layout() {
    local layout_type="${ZJ_DEFAULT_LAYOUT:-compact}"

    if is_valid_layout_type "${layout_type}"; then
        echo "${layout_type}"
    else
        echo "Error: ZJ_DEFAULT_LAYOUT must be 'regular' or 'compact' (got '${layout_type}')" >&2
        return 1
    fi
}

# Function to determine the layout path based on type and variant
# Usage: get_layout <type> [variant]
#   type: "regular" or "compact" (default: ZJ_DEFAULT_LAYOUT)
#   variant: "session" (default) or "workspace"
get_layout() {
    local layout_type="${1:-${ZJ_DEFAULT_LAYOUT}}"
    local variant="${2:-session}"
    local layout_file

    if [[ "${variant}" == "workspace" ]]; then
        layout_file="${ZJ_LAYOUT_DIR}/${layout_type}-workspace-layout.kdl"
    else
        layout_file="${ZJ_LAYOUT_DIR}/${layout_type}-layout.kdl"
    fi

    if [[ -f "${layout_file}" ]]; then
        echo "${layout_file}"
    else
        echo ""
    fi
}

# Check if zellij is installed
check_zellij_installed() {
    if ! command -v zellij &> /dev/null; then
        echo "Error: zellij is not installed or not in PATH"
        return 1
    fi
    return 0
}
