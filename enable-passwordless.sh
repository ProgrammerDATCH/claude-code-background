#!/bin/bash
#
# Claude Code Background — passwordless toggling (optional)
#
# Installs a sudoers rule scoped to exactly two commands, so flipping the
# lid-sleep setting stops asking for your admin password.
#
# Usage:
#   ./enable-passwordless.sh            # enable
#   ./enable-passwordless.sh --remove   # undo
#

set -e

SUDOERS_FILE="/etc/sudoers.d/claude-code-background"
PMSET="/usr/bin/pmset"
USER_NAME="$(id -un)"

echo "Claude Code Background — passwordless toggling"
echo

# --- Undo ---
if [ "$1" = "--remove" ]; then
  sudo rm -f "$SUDOERS_FILE"
  echo "✅ Removed. Toggling will ask for your password again."
  exit 0
fi

# --- Preflight ---
if [ ! -x "$PMSET" ]; then
  echo "❌ $PMSET not found. Aborting."
  exit 1
fi

if ! sudo grep -qE '^@includedir[[:space:]]+/private/etc/sudoers.d' /etc/sudoers; then
  echo "❌ /etc/sudoers does not include /etc/sudoers.d, so the rule would be"
  echo "   ignored. Aborting rather than leaving a file that does nothing."
  exit 1
fi

# --- Build and validate the rule ---
# Args are matched exactly, so this grants these two invocations and nothing
# else — not pmset in general.
TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT

cat > "$TMP" <<EOF
# Claude Code Background — passwordless lid-sleep toggle
# Undo with: enable-passwordless.sh --remove
$USER_NAME ALL=(root) NOPASSWD: $PMSET -a disablesleep 0, $PMSET -a disablesleep 1
EOF

# A malformed sudoers file can break sudo entirely, so never install unchecked.
if ! sudo visudo -c -f "$TMP" >/dev/null 2>&1; then
  echo "❌ The generated rule failed validation. Nothing was changed."
  exit 1
fi

sudo install -m 0440 -o root -g wheel "$TMP" "$SUDOERS_FILE"

# --- Verify ---
# Re-applying the current value is a no-op, so this proves the rule works
# without changing your sleep behaviour.
CUR=$(pmset -g | grep -i SleepDisabled | awk '{print $2}')
if sudo -n "$PMSET" -a disablesleep "${CUR:-0}" 2>/dev/null; then
  echo
  echo "✅ Enabled. Toggling no longer asks for your password."
  echo "   Undo any time: ./enable-passwordless.sh --remove"
else
  echo
  echo "⚠️  Rule installed at $SUDOERS_FILE but the test still required a password."
  echo "   Toggling will keep using the password dialog."
  exit 1
fi
