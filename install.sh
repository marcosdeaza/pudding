#!/usr/bin/env bash
# ============================================================
#  pudding installer — Clean Natural Language Terminal Bridge
# ============================================================
set -euo pipefail

INSTALL_BIN="$HOME/.local/bin"
INSTALL_CONFIG="$HOME/.config/pudding"

echo "▸ Installing pudding..."

mkdir -p "$INSTALL_BIN" "$INSTALL_CONFIG"

# Copy binary
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cp "$DIR/bin/pudding" "$INSTALL_BIN/pudding"
chmod +x "$INSTALL_BIN/pudding"
ln -sf "$INSTALL_BIN/pudding" "$INSTALL_BIN/ai-sh"

# Setup config template if not exists
if [[ ! -f "$INSTALL_CONFIG/config.json" ]]; then
    cp "$DIR/config/config.example.json" "$INSTALL_CONFIG/config.json"
    echo "  ✓ Config created at ~/.config/pudding/config.json"
fi

# Detect shell
SHELL_NAME="$(basename "$SHELL")"
RC_FILE=""

if [[ "$SHELL_NAME" == "zsh" ]]; then
    RC_FILE="$HOME/.zshrc"
    SHELL_SCRIPT="$DIR/shell/pudding.zsh"
elif [[ "$SHELL_NAME" == "bash" ]]; then
    RC_FILE="$HOME/.bashrc"
    [[ ! -f "$RC_FILE" && -f "$HOME/.bash_profile" ]] && RC_FILE="$HOME/.bash_profile"
    SHELL_SCRIPT="$DIR/shell/pudding.bash"
else
    RC_FILE="$HOME/.zshrc"
    SHELL_SCRIPT="$DIR/shell/pudding.zsh"
fi

if [[ -n "$RC_FILE" && -f "$RC_FILE" ]]; then
    if ! grep -q "pudding" "$RC_FILE" 2>/dev/null; then
        echo "" >> "$RC_FILE"
        echo "# === pudding integration ===" >> "$RC_FILE"
        echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> "$RC_FILE"
        echo "source \"$SHELL_SCRIPT\"" >> "$RC_FILE"
        echo "  ✓ Integration added to $RC_FILE"
    else
        echo "  ✓ Integration already configured in $RC_FILE"
    fi
fi

echo ""
echo "🍮 pudding installed successfully!"
echo "   Restart your terminal or run: source $RC_FILE"
echo ""
