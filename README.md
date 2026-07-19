# Claude Code Background

A tiny macOS menu-bar toggle that keeps **Claude Code** (or any long-running process) alive when you **close your laptop lid** — so you can shut the lid, walk away, and keep monitoring/remote-controlling from your phone.

| Menu bar | Meaning |
|----------|---------|
| 🤖 | **Awake** — survives lid close. Processes keep running with the lid shut. |
| 😴 | **Asleep** — sleeps normally on lid close. |

Click the icon to flip between the two. The icon always shows the *live* state, so even if a reboot resets the setting, you'll see the truth at a glance.

---

## How it works

Under the hood it toggles a single macOS power setting:

```bash
sudo pmset -a disablesleep 1   # ON  — no sleep on lid close
sudo pmset -a disablesleep 0   # OFF — normal sleep
```

That's it. No background daemons, no kernel extensions — just a [SwiftBar](https://github.com/swiftbar/SwiftBar) plugin that reads and flips that flag.

---

## Requirements

- macOS (Apple Silicon or Intel)
- [SwiftBar](https://github.com/swiftbar/SwiftBar) — the menu-bar plugin runner

Install SwiftBar first:

```bash
HOMEBREW_NO_AUTO_UPDATE=1 brew install --cask swiftbar
```

…or grab the app directly from the [SwiftBar releases page](https://github.com/swiftbar/SwiftBar/releases/latest) (faster than Homebrew).

---

## Install

**One-liner:**

```bash
curl -fsSL https://raw.githubusercontent.com/programmerdatch/claude-code-background/develop/install.sh | bash
```

**Or manually:**

1. Copy `ccbg.10s.sh` into your SwiftBar plugins folder (e.g. `~/.swiftbar`).
2. Make it executable: `chmod +x ~/.swiftbar/ccbg.10s.sh`
3. Open SwiftBar and point it at that folder if it asks.

The 🤖 / 😴 icon appears in your menu bar within ~10 seconds.

---

## Usage

1. Start Claude Code as usual.
2. Click the menu-bar icon → **Keep running with lid closed** (🤖).
3. Close the lid — **keep the Mac plugged in.**
4. Monitor / remote-control from the Claude app on your phone.

Click again → **Switch to sleep-on-lid-close** (😴) when you're done.

> **Note:** toggling changes a system power setting, so macOS asks for your admin password each time. That's expected and safe — the plugin only ever runs `pmset -a disablesleep`.

---

## Cautions

- **Keep it plugged in.** A closed laptop doing real work drains fast and has no airflow — heat builds up.
- **Reboots can reset it.** macOS sometimes clears `disablesleep` on restart; the icon reflects the real state, so just click once to re-arm.
- Don't bury the closed laptop under things while it's working.

---

## License

[MIT](LICENSE) © 2026 **Programmer DATCH** — [programmerdatch.com](https://programmerdatch.com)
