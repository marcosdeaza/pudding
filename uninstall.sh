#!/usr/bin/env bash
# ============================================================
#  pudding uninstaller
# ============================================================
set -euo pipefail

echo "▸ Uninstalling pudding..."

rm -f "$HOME/.local/bin/pudding" "$HOME/.local/bin/ai-sh"

for rc in "$HOME/.zshrc" "$HOME/.bashrc" "$HOME/.bash_profile"; do
    if [[ -f "$rc" ]]; then
        sed -i '' '/# === pudding integration ===/d' "$rc" 2>/dev/null || true
        sed -i '' '/pudding\.zsh/d' "$rc" 2>/dev/null || true
        sed -i '' '/pudding\.bash/d' "$rc" 2>/dev/null || true
    fi
done

echo "✓ pudding uninstalled cleanly."
