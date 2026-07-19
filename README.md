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
pmset -a disablesleep 1   # ON  — no sleep on lid close
pmset -a disablesleep 0   # OFF — normal sleep
```

Those need admin rights, so the plugin runs them via `osascript ... with administrator privileges` — which is what triggers the macOS password dialog described [below](#the-admin-password-prompt).

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
curl -fsSL https://raw.githubusercontent.com/programmerdatch/claude-code-background/main/install.sh | bash
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
3. Close the lid — ideally with the Mac plugged in (optional, see below).
4. Monitor / remote-control from the Claude app on your phone.

Click again → **Switch to sleep-on-lid-close** (😴) when you're done.

### The admin password prompt

Every toggle changes a system power setting, so macOS will ask for your admin password. You'll see a dialog like this:

> **Allow administrator access for a script started by "bash"?**
>
> This will allow the script to access and modify your data, files, and settings on this Mac.
> **Apple could not verify this script is free of malware** that may harm your Mac or compromise your privacy.
>
> Enter your password to continue with the script.

**This is expected.** The malware line reads alarmingly, but it isn't a detection — macOS shows that exact wording for *any* unsigned shell script asking for admin rights. It means "this script isn't notarized by Apple", not "Apple found something wrong with it". SwiftBar plugins are plain `.sh` files, so they're never notarized.

What you're actually approving is one command:

```bash
osascript -e 'do shell script "pmset -a disablesleep 1" with administrator privileges'
```

That's the only thing the plugin ever runs with elevated rights. You can read the whole script yourself — it's 51 lines at `~/.swiftbar/ccbg.10s.sh`, and it's worth doing before you type your password into anything.

A few things to expect:

- **It asks every time you toggle.** Each click is a fresh invocation, so there's no "remember this" — that's by design, not a bug.
- **"Don't Allow" is safe.** The setting stays as it was and the icon keeps showing the true state.
- **It says "bash", not the plugin name.** SwiftBar runs the script through `bash`, so that's the process macOS names.

---

## Cautions

- **Power is optional, but recommended.** It works fine on battery — being unplugged won't stop it. The catch is that a closed laptop doing real work drains fast, and once the battery runs out everything stops. Plugging in just means your work isn't cut short. Also watch heat: a closed lid has no airflow.
- **Reboots can reset it.** macOS sometimes clears `disablesleep` on restart; the icon reflects the real state, so just click once to re-arm.
- Don't bury the closed laptop under things while it's working.

---

## License

[MIT](LICENSE) © 2026 **Programmer DATCH** — [programmerdatch.com](https://programmerdatch.com)
