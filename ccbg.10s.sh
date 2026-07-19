#!/bin/bash
#
# Claude Code Background — SwiftBar plugin
# Toggles macOS lid-close sleep so Claude Code (or any process) keeps
# running with the laptop lid shut.
#
# 🤖 = ON  (survives lid close)   😴 = OFF (sleeps on lid close)
#
# Developer: Programmer DATCH — https://programmerdatch.com
# License: MIT
#

SELF="${SWIFTBAR_PLUGIN_PATH:-$0}"

# --- Click action (toggle) ---
if [ "$1" = "toggle" ]; then
  CUR=$(pmset -g | grep -i SleepDisabled | awk '{print $2}')
  if [ "$CUR" = "1" ]; then
    osascript -e 'do shell script "pmset -a disablesleep 0" with administrator privileges'
  else
    osascript -e 'do shell script "pmset -a disablesleep 1" with administrator privileges'
  fi
  exit 0
fi

# --- Menu render ---
STATUS=$(pmset -g | grep -i SleepDisabled | awk '{print $2}')

if [ "$STATUS" = "1" ]; then
  echo "🤖"
  echo "---"
  echo "🤖  Awake — survives lid close | color=#32d74b"
  echo "Claude Code keeps running when the lid is shut | color=gray size=11"
  echo "Keep the Mac plugged in ⚡ | color=gray size=11"
  echo "---"
  echo "Switch to sleep-on-lid-close 😴 | bash='$SELF' param1=toggle terminal=false refresh=true"
else
  echo "😴"
  echo "---"
  echo "😴  Sleeps on lid close | color=#8e8e93"
  echo "Everything pauses when you shut the lid | color=gray size=11"
  echo "---"
  echo "Keep running with lid closed 🤖 | bash='$SELF' param1=toggle terminal=false refresh=true"
fi

echo "---"
echo "About | sfimage=info.circle"
echo "-- Claude Code Background — v1.0 | color=gray"
echo "-- Keeps Claude Code alive with the lid closed | color=gray size=11"
echo "-- Developer: Programmer DATCH | color=gray"
echo "-- 🌐  programmerdatch.com | href=https://programmerdatch.com sfimage=safari"
