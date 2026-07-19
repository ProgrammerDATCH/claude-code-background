#!/bin/bash
#
# Claude Code Background — passwordless toggling (optional)
#
# Installs a sudoers rule scoped to exactly two commands, so flipping the
# lid-sleep setting stops asking for your admin password.
#
# Download it first — piping straight into bash leaves no terminal for sudo
# to prompt on:
#
#   curl -fsSL https://raw.githubusercontent.com/programmerdatch/claude-code-background/main/enable-passwordless.sh -o enable-passwordless.sh
#   bash enable-passwordless.sh            # enable
#   bash enable-passwordless.sh --remove   # undo
#

set -e

SUDOERS_FILE="/etc/sudoers.d/claude-code-background"
PMSET="/usr/bin/pmset"
USER_NAME="$(id -un)"
SCRIPT_URL="https://raw.githubusercontent.com/programmerdatch/claude-code-background/main/enable-passwordless.sh"

echo "Claude Code Background — passwordless toggling"
echo

# sudo prompts on the terminal, and `curl | bash` doesn't leave one attached —
# every sudo call would fail for reasons that look nothing like the real cause.
if [ ! -t 0 ] && ! sudo -n true 2>/dev/null; then
  echo "❌ This needs to ask for your admin password, which can't happen when"
  echo "   the script is piped from curl. Download it first, then run it:"
  echo
  echo "     curl -fsSL $SCRIPT_URL -o enable-passwordless.sh"
  echo "     bash enable-passwordless.sh"
  exit 1
fi

# --- Undo ---
if [ "$1" = "--remove" ]; then
  sudo rm -f "$SUDOERS_FILE"
  echo "✅ Removed. Toggling will ask for your password again."
  exit 0
fi

if [ ! -x "$PMSET" ]; then
  echo "❌ $PMSET not found. Aborting."
  exit 1
fi

# --- Build and validate the rule ---
# sudo matches arguments exactly, so this grants these two invocations and
# nothing else — not pmset in general.
TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT

cat > "$TMP" <<EOF
# Claude Code Background — passwordless lid-sleep toggle
# Undo with: bash enable-passwordless.sh --remove
$USER_NAME ALL=(root) NOPASSWD: $PMSET -a disablesleep 0, $PMSET -a disablesleep 1
EOF

# A malformed sudoers file can break sudo entirely, so never install unchecked.
if ! sudo visudo -c -f "$TMP" >/dev/null 2>&1; then
  echo "❌ The generated rule failed validation. Nothing was changed."
  exit 1
fi

echo "→ Installing rule at $SUDOERS_FILE"
sudo install -m 0440 -o root -g wheel "$TMP" "$SUDOERS_FILE"

# --- Verify by behaviour, not by inspecting config ---
# Re-applying the current value is a no-op, so this proves the rule actually
# took effect without changing your sleep behaviour.
CUR=$(pmset -g | grep -i SleepDisabled | awk '{print $2}')
if sudo -n "$PMSET" -a disablesleep "${CUR:-0}" 2>/dev/null; then
  echo
  echo "✅ Enabled. Toggling no longer asks for your password."
  echo "   Undo any time: bash enable-passwordless.sh --remove"
else
  sudo rm -f "$SUDOERS_FILE"
  echo
  echo "❌ The rule installed but had no effect, so it has been removed again."
  echo "   Most likely /etc/sudoers does not include /etc/sudoers.d."
  echo "   Nothing changed — toggling will keep using the password dialog."
  exit 1
fi
