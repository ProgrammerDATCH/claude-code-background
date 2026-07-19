#!/bin/bash
#
# Claude Code Background — installer
# Installs the SwiftBar plugin into your SwiftBar plugins folder.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/programmerdatch/claude-code-background/main/install.sh | bash
#

set -e

PLUGIN_URL="https://raw.githubusercontent.com/programmerdatch/claude-code-background/main/ccbg.10s.sh"
PLUGIN_DIR="${SWIFTBAR_PLUGIN_DIR:-$HOME/.swiftbar}"

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
echo "→ Downloading plugin to $PLUGIN_DIR/ccbg.10s.sh"
curl -fsSL "$PLUGIN_URL" -o "$PLUGIN_DIR/ccbg.10s.sh"
chmod +x "$PLUGIN_DIR/ccbg.10s.sh"

echo
echo "✅ Installed."
echo
echo "Next:"
echo "  1. Open SwiftBar (Applications → SwiftBar, or: open -a SwiftBar)"
echo "  2. If asked, point it at your plugins folder: $PLUGIN_DIR"
echo "  3. Look for 🤖 / 😴 in your menu bar — click it to toggle."
