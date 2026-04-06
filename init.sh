#!/bin/bash

# Zellij Kit Initialization Script
# Usage: ./init.sh [--force]
# Options:
#   --force  Force re-add PATH and auto-launch config even if already present

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"
ZSHRC="$HOME/.zshrc"
FORCE=false

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print functions
info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Parse arguments
for arg in "$@"; do
    case $arg in
        --force)
            FORCE=true
            shift
            ;;
        --help|-h)
            echo "Usage: ./init.sh [--force]"
            echo ""
            echo "Options:"
            echo "  --force  Force re-add PATH and auto-launch config even if already present"
            echo "  --help   Show this help message"
            exit 0
            ;;
    esac
done

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    warn "This script is designed for macOS with Homebrew"
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Check if Homebrew is installed
check_homebrew() {
    if ! command -v brew &> /dev/null; then
        error "Homebrew is not installed"
        echo "Please install Homebrew first: https://brew.sh"
        exit 1
    fi
    success "Homebrew is installed"
}

# Check and install a brew package
install_brew_pkg() {
    local pkg="$1"
    local cmd="${2:-$1}"
    
    if command -v "$cmd" &> /dev/null; then
        success "$pkg is already installed"
        return 0
    fi
    
    info "Installing $pkg via Homebrew..."
    if brew install "$pkg"; then
        success "$pkg installed successfully"
    else
        error "Failed to install $pkg"
        return 1
    fi
}

# Check and install npm package
install_npm_pkg() {
    local pkg="$1"
    local cmd="${2:-$1}"
    
    if command -v "$cmd" &> /dev/null; then
        success "$pkg is already installed"
        return 0
    fi
    
    # Check if npm is available
    if ! command -v npm &> /dev/null; then
        error "npm is not installed"
        warn "Please install Node.js first: brew install node"
        return 1
    fi
    
    info "Installing $pkg via npm..."
    if npm install -g "$pkg"; then
        success "$pkg installed successfully"
    else
        error "Failed to install $pkg"
        return 1
    fi
}

# Check if PATH is already configured
check_path_setup() {
    if [[ -f "$ZSHRC" ]] && grep -q 'zellij_kit/bin' "$ZSHRC"; then
        return 0
    fi
    return 1
}

# Check if auto-launch is already configured
check_autolaunch_setup() {
    if [[ -f "$ZSHRC" ]] && grep -q 'zellij-launch' "$ZSHRC"; then
        return 0
    fi
    return 1
}

# Add PATH configuration to .zshrc
add_path_setup() {
    local path_entry="export PATH=\"$PROJECT_ROOT/bin:\$PATH\""
    
    if check_path_setup && [[ "$FORCE" != true ]]; then
        success "PATH already configured in $ZSHRC (skipped)"
        return 0
    fi
    
    info "Adding PATH configuration to $ZSHRC..."
    
    # Add a comment and the PATH export
    cat >> "$ZSHRC" << EOF

# Zellij Kit
$path_entry
EOF
    
    success "PATH configuration added to $ZSHRC"
}

# Add auto-launch configuration to .zshrc
add_autolaunch_setup() {
    if check_autolaunch_setup && [[ "$FORCE" != true ]]; then
        success "Auto-launch already configured in $ZSHRC (skipped)"
        return 0
    fi
    
    info "Adding auto-launch configuration to $ZSHRC..."
    
    cat >> "$ZSHRC" << 'EOF'

# Auto-launch zellij when entering shell at $HOME
if [[ -z "${TERM_PROGRAM+x}" ]]; then
    # SSH Connection - do nothing
else
    if [[ "${TERM_PROGRAM}" == "ghostty" || "${TERM_PROGRAM}" == "Apple_Terminal" ]]; then
        if [[ "$PWD" == "$HOME" ]]; then
            if command -v zellij-launch >/dev/null 2>&1; then
                zellij-launch
            else
                echo "Error: zellij-launch not found in PATH"
            fi
        fi
    fi
fi
EOF
    
    success "Auto-launch configuration added to $ZSHRC"
}

# Main
echo "======================================"
echo "  Zellij Kit Initialization Script"
echo "======================================"
echo ""

# Check Homebrew
check_homebrew

echo ""
echo "--- Checking Dependencies ---"

# Install dependencies
install_brew_pkg "zellij"
install_brew_pkg "yazi"
install_brew_pkg "htop"
install_npm_pkg "@anthropic-ai/claude-code" "claude"

echo ""
echo "--- Checking Shell Configuration ---"

# Setup shell configuration
add_path_setup
add_autolaunch_setup

echo ""
echo "======================================"
success "Initialization complete!"
echo "======================================"
echo ""
echo "Next steps:"
echo "  1. Run 'source ~/.zshrc' to reload your shell configuration"
echo "  2. Open a new terminal to test auto-launch"
echo ""
echo "Usage:"
echo "  zellij-launch [--layout regular|compact] [session_name]"
echo "  zellij-workspace [--layout regular|compact] [working_directory]"
echo ""
