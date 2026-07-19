#!/bin/bash
#
# Claude Code Background — installer
# Installs the SwiftBar plugin into your SwiftBar plugins folder.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/programmerdatch/claude-code-background/main/install.sh | bash
#

set -e

REPO_BRANCH="${CCBG_BRANCH:-main}"
RAW_BASE="https://raw.githubusercontent.com/programmerdatch/claude-code-background/$REPO_BRANCH"
PLUGIN_NAME="ccbg.10s.sh"
PLUGIN_DIR="${SWIFTBAR_PLUGIN_DIR:-$HOME/.swiftbar}"
PLUGIN_PATH="$PLUGIN_DIR/$PLUGIN_NAME"

echo "Claude Code Background — installer"
echo

# 1. Check for SwiftBar
if [ ! -d "/Applications/SwiftBar.app" ] && ! command -v swiftbar >/dev/null 2>&1; then
  echo "⚠️  SwiftBar isn't installed yet."
  echo "    Install it with one of:"
  echo "      HOMEBREW_NO_AUTO_UPDATE=1 brew install --cask swiftbar"
  echo "      or download: https://github.com/swiftbar/SwiftBar/releases/latest"
  echo
  read -r -p "Continue installing the plugin anyway? [y/N] " ans
  case "$ans" in
    [yY]*) ;;
    *) echo "Aborted."; exit 1 ;;
  esac
fi

# 2. Install the plugin
mkdir -p "$PLUGIN_DIR"
echo "→ Downloading plugin to $PLUGIN_PATH"
curl -fsSL "$RAW_BASE/$PLUGIN_NAME" -o "$PLUGIN_PATH"
chmod +x "$PLUGIN_PATH"

echo
echo "✅ Installed."
echo
echo "Next:"
echo "  1. Open SwiftBar (Applications → SwiftBar, or: open -a SwiftBar)"
echo "  2. If asked, point it at your plugins folder: $PLUGIN_DIR"
echo "  3. Look for 🤖 / 😴 in your menu bar — click it to toggle."
