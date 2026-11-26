# Nix-Darwin Configuration

A modular, maintainable nix-darwin configuration for macOS following best practices and architectural principles.

## 📚 Documentation

- **[DEVELOPMENT.md](./DEVELOPMENT.md)** - Comprehensive guide for developers and AI assistants
  - Architecture principles and design patterns
  - Repository structure and organization
  - Coding conventions and best practices
  - How to add machines, tools, and features
  - Troubleshooting and common issues

- **[AGENTS.md](./AGENTS.md)** - Quick reference for AI coding assistants
  - Fast command reference
  - Links to detailed documentation
  - Also available as `CLAUDE.md` for backward compatibility

## 🚀 Quick Start

### Set Up a New Mac

Hosts: `macbook-air` (French AZERTY keyboard) and `macbook-pro` (US ANSI
keyboard). Replace `macbook-pro` below with the machine you are setting up.

1. **Finish the macOS setup assistant.** Create the account `btravers` as the
   first user on the machine (the config expects uid 501), sign in with your
   Apple ID, and install pending macOS updates.

2. **Install the command line tools and Rosetta:**
   ```sh
   xcode-select --install
   softwareupdate --install-rosetta --agree-to-license
   ```

3. **Install Determinate Nix**, then open a new terminal:
   ```sh
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
   ```

4. **Clone this repository** (HTTPS, since there is no SSH key yet):
   ```sh
   git clone https://github.com/btravers/nix-config.git ~/.config/nix-darwin
   ```
   If the repository is private, authenticate first with
   `nix run nixpkgs#gh -- auth login`, then clone with
   `nix run nixpkgs#gh -- repo clone btravers/nix-config ~/.config/nix-darwin`.

5. **Apply the configuration.** Name the host explicitly on the first run.
   Activation sets the hostname, so later runs find it on their own:
   ```sh
   cd ~/.config/nix-darwin
   nix develop --command sudo darwin-rebuild switch --flake .#macbook-pro
   ```
   If activation stops on *unexpected files in /etc*, rename each file it
   lists (e.g. `sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin`) and run it again.

6. **Log out and back in.** The language, keyboard layout and menu bar clock
   only change at login.

7. **Finish by hand** (things Nix can't do):
   - Allow **AeroSpace** and **Raycast** in System Settings → Privacy &
     Security → Accessibility when they ask.
   - In Raycast, set the hotkey to `Cmd+Space` (Spotlight's shortcut is
     already turned off).
   - Install Claude Code: `curl -fsSL https://claude.ai/install.sh | bash`
   - Log in to GitHub and switch this repository to SSH:
     ```sh
     gh auth login
     git -C ~/.config/nix-darwin remote set-url origin git@github.com:btravers/nix-config.git
     ```
   - Sign in to your apps (Slack, Obsidian, Spotify, …).

To add a machine with a new hostname, see
[Adding a New Machine](./DEVELOPMENT.md#adding-a-new-machine). Machines other
than `macbook-air` get the US keyboard layout; change that in
`darwin/_mixins/desktop/keyboard.nix`.

### Daily Use

```sh
nh darwin switch                      # rebuild and apply, showing what changed
nix flake update && nh darwin switch  # update everything (nixpkgs, Homebrew taps, …)
```

Old generations are cleaned every Sunday (`darwin/_mixins/features/nix-gc.nix`).
To clean right away: `sudo nh clean all --keep-since 14d`.

### Keyboard Shortcuts

| Keys | What it does |
|---|---|
| `Ctrl+Alt+h/j/k/l` | AeroSpace: focus window left/down/up/right |
| `Ctrl+Alt+Shift+h/j/k/l` | AeroSpace: move window |
| `Ctrl+Alt+1…9` / `Ctrl+Alt+Shift+1…9` | AeroSpace: go to / move window to workspace |
| `Cmd+n` | New Ghostty window (each one runs its own Zellij session) |
| `Cmd+t` | New Zellij tab |
| `Ctrl+g` | Unlock Zellij, then `Ctrl+p` panes, `Ctrl+t` tabs, `Ctrl+s` scroll, `Ctrl+o` session; `Ctrl+g` again to lock |

AeroSpace uses `Ctrl+Alt` rather than `Alt` because on the French layout
`Alt` (Option) types `{`, `[` and `|`.

### Development Workflow

```sh
# Enter development shell
nix develop

# Check configuration for errors
check-nix-darwin-configuration

# Preview what will change
diff-nix-darwin-configuration

# Apply changes
apply-nix-darwin-configuration
```

## 🏗️ Architecture Overview

This configuration is organized into modular components:

```
├── flake.nix              # Dependency management and machine definitions
├── darwin/                # macOS system configuration
│   ├── default.nix        # Shared system settings
│   ├── _mixins/           # Modular system configs
│   └── <hostname>/        # Per-host overrides
├── home-manager/          # User environment configuration
│   ├── default.nix        # Home-manager entry point
│   └── _mixins/           # Modular user configs
│       ├── terminal/      # CLI tools (one file per tool)
│       ├── development/   # Development tools
│       ├── desktop/       # GUI application configs
│       └── users/         # Per-user overrides
├── lib/                   # Helper functions
└── overlays/              # Package overlays
```

### Key Features

- ✨ **Modular Design** - One file per tool/feature for easy maintenance
- 🔄 **Per-Host Overrides** - Machine-specific configs auto-load
- 👤 **Per-User Configs** - User-specific settings auto-import
- 📦 **Declarative Homebrew** - Reproducible cask management
- 🎨 **Unified Theming** - Catppuccin theme across applications
- 🛠️ **Development Shell** - Built-in tools for config management

## 🤖 AI Coding CLIs (outside Nix)

`claude` (Claude Code) and `codex` are installed with their vendors' native
installers into `~/.local/bin` and update themselves. They are deliberately
not managed here, because nixpkgs and the pinned Homebrew taps lag behind
their release cadence.

**Option if this changes:** [`numtide/llm-agents.nix`](https://github.com/numtide/llm-agents.nix)
packages `claude-code`, `codex`, `opencode` and others, is updated daily, and
ships a binary cache. To switch:

1. Add the flake input `llm-agents.url = "github:numtide/llm-agents.nix";`
   and its binary cache (see its README) to `determinateNix.customSettings`.
2. Add `inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code`
   (and `codex`) to `home.packages`.
3. Set `DISABLE_AUTOUPDATER=1` so Claude Code doesn't try to update itself.
4. Remove the native installs: `~/.local/bin/{claude,codex}`,
   `~/.local/share/claude`, `~/.codex/packages`.
5. Update with `nix flake update llm-agents`.

## 🎯 Philosophy

This configuration follows these principles:

1. **Separation of Concerns** - Each aspect in its own module
2. **Convention Over Configuration** - Smart defaults, targeted overrides
3. **Declarative > Imperative** - Prefer nix options over scripts
4. **Composability** - Mix and match modules as needed
5. **Maintainability** - Clear structure, documented decisions

## 📖 Learn More

For detailed information about:
- Architecture principles
- Adding new tools or machines
- Coding conventions
- Troubleshooting

See **[DEVELOPMENT.md](./DEVELOPMENT.md)**.

## 🤝 AI Assistant Context

This repository includes comprehensive documentation for AI coding assistants in [DEVELOPMENT.md](./DEVELOPMENT.md). When working with AI tools, they will automatically reference this file to understand:

- Project structure and conventions
- Best practices for this configuration
- How to make consistent changes
- Common patterns and anti-patterns

## 📝 License

[Your License Here]
