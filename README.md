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

### First Time Setup

```sh
# Clone this repository
git clone <your-repo> ~/.config/nix-darwin
cd ~/.config/nix-darwin

# Apply the configuration
sudo darwin-rebuild switch --flake ~/.config/nix-darwin
```

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
