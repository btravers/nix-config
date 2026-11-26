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

| Host | Machine | Profile |
|---|---|---|
| `air` | MacBook Air, French AZERTY keyboard | workstation |
| `pro` | MacBook Pro, US ANSI keyboard | workstation |
| `runner` | Old MacBook Pro, GitHub Actions runner | minimal: tart, gh, python, never sleeps (even with the lid closed) |

Replace `pro` below with the machine you are setting up. On `runner`, skip
step 5 (no vault or AI agents there) and the app steps in step 4.

1. **Finish the macOS setup assistant.** Create the account `btravers` as the
   first user on the machine (the config expects uid 501), sign in with your
   Apple ID, and install pending macOS updates.

2. **Run the bootstrap script** in Terminal:
   ```sh
   curl -fsSL https://raw.githubusercontent.com/btravers/nix-config/main/bootstrap.sh | sh -s -- pro
   ```
   It asks for your password and shows one dialog (the command line tools).
   Click Install there and the script carries on by itself:
   1. installs the command line tools and Rosetta;
   2. installs Determinate Nix;
   3. clones this repository into `~/.config/nix-darwin` over HTTPS (there is
      no SSH key yet);
   4. applies the configuration for the host you named. It first sets aside the
      `/etc` shell files nix-darwin won't overwrite, as `*.before-nix-darwin`,
      and puts them back if the switch fails.

   Each step is skipped when it's already done, so you can re-run the script
   after fixing an error. Read [bootstrap.sh](./bootstrap.sh) first if you
   like; it's about 70 lines.

   <details>
   <summary>The same steps by hand</summary>

   ```sh
   xcode-select --install
   sudo softwareupdate --install-rosetta --agree-to-license
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
   # open a new terminal
   git clone https://github.com/btravers/nix-config.git ~/.config/nix-darwin
   cd ~/.config/nix-darwin
   nix develop --command sudo darwin-rebuild switch --flake .#pro
   ```
   If activation stops on *unexpected files in /etc*, rename each file it
   lists (e.g. `sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin`) and run it
   again.
   </details>

3. **Log out and back in.** The language, keyboard layout and menu bar clock
   only change at login.

4. **Finish by hand** (things Nix can't do):
   - Allow **AeroSpace** and **Raycast** in System Settings → Privacy &
     Security → Accessibility when they ask.
   - In Raycast, set the hotkey to `Cmd+Space` (Spotlight's shortcut is
     already turned off).
   - Install Claude Code: `curl -fsSL https://claude.ai/install.sh | bash`
   - **Create this Mac's SSH key** in **Secretive** (installed by the
     config): open it, click **+**, name the key after the host (e.g. `pro`)
     and keep "Require authentication" on. The key never leaves the Secure
     Enclave; every use asks for Touch ID. Workstations only; on `runner`,
     `gh auth login` is enough.
   - Log in to GitHub, add the key for login and for commit signing, and
     switch this repository to SSH:
     ```sh
     gh auth login
     key=$(ls ~/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/PublicKeys/*.pub)
     gh ssh-key add "$key" --type authentication --title "$(hostname)"
     gh ssh-key add "$key" --type signing --title "$(hostname)"
     git -C ~/.config/nix-darwin remote set-url origin git@github.com:btravers/nix-config.git
     ```
   - Turn on commit signing with that key: in `darwin/<hostname>/default.nix`,
     set `home-manager.users.btravers.programs.git.signing.key` to
     `"key::"` followed by the contents of the `.pub` file, and commit it.
   - Sign in to your apps (Slack, Obsidian, Spotify, …).

5. **Apply the configuration again** now that GitHub SSH works:
   ```sh
   nh darwin switch
   ```
   This clones the vault into `~/Obsidian/btravers` and registers the `brain`
   MCP server with Claude Code, Codex, Claude Desktop, opencode and Zed. The
   vault then syncs every 15 minutes (log: `~/Library/Logs/mcp-brain-sync.log`).
   Restart the agents to pick the server up.

To add a machine with a new hostname, see
[Adding a New Machine](./DEVELOPMENT.md#adding-a-new-machine). Each host sets
its keyboard layout in `darwin/<hostname>/default.nix`.

### SSH Keys and Secrets

Each workstation has its own SSH key in its Secure Enclave, managed by
Secretive (`home-manager/_mixins/development/secretive.nix`). Nothing to sync
or back up: on a new Mac, create a new key. If you lose a Mac, delete its keys at
github.com/settings/keys. Passwords live in Apple Passwords.

`~/.ssh/config` is generated. Put machine-only hosts (client servers, old key
files) in `~/.ssh/config.local`, which it includes and git never sees.

### MCP Servers

`programs.mcp.servers` (Home Manager) is the single list of MCP servers. Each
rebuild registers every server with Claude Code, Codex and Claude Desktop
(`home-manager/_mixins/development/mcp.nix`), and writes them into the Zed and
opencode configs. `brain` (`development/brain.nix`) is built from the
[mcp-brain](https://github.com/btravers/mcp-brain) flake input; update it with
`nix flake update mcp-brain`.

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
│   ├── _mixins/           # Modular system configs (workstation.nix: air + pro)
│   └── <hostname>/        # Per-host config: air, pro, runner
├── home-manager/          # User environment configuration
│   ├── default.nix        # Every host: terminal tools, git
│   ├── workstation.nix    # air + pro: desktop configs, agents, brain
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
