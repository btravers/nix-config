# Nix-Darwin Configuration Guide

> **AI Assistant Context**  
> This file provides architectural guidelines, conventions, and operational instructions for managing this nix-darwin configuration. When working with this repository, follow these principles to maintain consistency and best practices.

## Quick Start

### Apply Configuration Changes

```sh
# Standard method
sudo darwin-rebuild switch --flake ~/.config/nix-darwin

# Using development shell (recommended)
nix develop --command apply-nix-darwin-configuration

# Check configuration before applying
nix develop --command check-nix-darwin-configuration

# Preview changes
nix develop --command diff-nix-darwin-configuration
```

### Development Shell Commands

When you enter the dev shell with `nix develop`, you get access to:

- **`apply-nix-darwin-configuration`** - Apply the configuration with darwin-rebuild
- **`check-nix-darwin-configuration`** - Run `nix flake check` to validate syntax
- **`diff-nix-darwin-configuration`** - Preview what will change using nvd

## Architecture Principles

This configuration follows a modular, composable architecture designed for maintainability and scalability.

### Core Principles

1. **Separation of Concerns**
   - Split configuration into logical domains: `darwin/`, `home-manager/`, `lib/`, `overlays/`
   - Never create monolithic configuration files
   - Each concern gets its own module

2. **Helper-Based Machine Configuration**
   - Use `mkDarwin` helper in `lib/helpers.nix` to wire up machines
   - Adding a new Mac should require only a single line in `flake.nix`
   - All machine-specific context passed via `specialArgs`

3. **Convention Over Configuration**
   - Per-host overrides auto-load from `darwin/<hostname>/default.nix` if present
   - Per-user configs auto-load from `home-manager/_mixins/users/<username>/`
   - Use `builtins.pathExists` for optional configuration files
   - Provide sensible defaults, allow targeted overrides

4. **Context Propagation**
   - Pass metadata via `specialArgs`: `username`, `hostname`, `inputs`
   - Never hardcode usernames, hostnames, or platform-specific values
   - Make all modules context-aware

5. **Modularity**
   - One module per tool, feature, or system aspect
   - Use `_mixins/` directories for composable fragments
   - Each tool in `_mixins/terminal/` gets its own file (e.g., `bat.nix`, `fzf.nix`)
   - Import mixins via directory-level `default.nix` files

## Repository Structure

```
.
├── flake.nix                        # Minimal: inputs, outputs, machine wiring
├── flake.lock                       # Locked dependency versions
│
├── lib/
│   └── helpers.nix                  # mkDarwin helper function
│
├── darwin/                          # macOS system-level configuration
│   ├── default.nix                  # Shared darwin config (all machines)
│   ├── _mixins/
│   │   ├── desktop/                 # Desktop environment settings
│   │   │   ├── default.nix          # Auto-imports all desktop mixins
│   │   │   ├── dock.nix             # Dock configuration
│   │   │   ├── finder.nix           # Finder settings
│   │   │   ├── keyboard.nix         # Keyboard settings
│   │   │   ├── trackpad.nix         # Trackpad settings
│   │   │   └── ui.nix               # UI/UX settings
│   │   └── features/                # Feature modules
│   │       ├── nix-registry.nix     # Flake registry pinning
│   │       ├── nix-homebrew.nix     # Homebrew configuration
│   │       └── nix-gc.nix           # Weekly nh clean (generations + store GC)
│   └── <hostname>/                  # Per-host overrides (optional)
│       └── default.nix              # Host-specific config
│
├── home-manager/                    # User environment configuration
│   ├── default.nix                  # Home-manager entry point
│   └── _mixins/
│       ├── terminal/                # CLI tools
│       │   ├── default.nix          # Auto-imports all terminal tools
│       │   ├── bat.nix              # bat (cat alternative)
│       │   ├── eza.nix              # eza (ls alternative)
│       │   ├── fzf.nix              # Fuzzy finder
│       │   ├── nh.nix               # nh darwin switch / clean
│       │   ├── starship.nix         # Prompt
│       │   ├── zellij.nix           # Terminal multiplexer
│       │   ├── zsh.nix              # Shell configuration
│       │   └── ...                  # One file per tool
│       ├── development/             # Development tools
│       │   ├── git.nix              # Git configuration
│       │   ├── containers.nix       # Colima + docker CLI
│       │   ├── brain.nix            # mcp-brain: vault clone, sync, MCP server
│       │   ├── mcp.nix              # Registers MCP servers with every agent
│       │   └── ...
│       ├── desktop/                 # GUI applications
│       │   ├── ghostty.nix          # Terminal emulator config
│       │   ├── zed.nix              # Editor config
│       │   └── ...
│       └── users/<username>/        # Per-user overrides
│           └── default.nix          # User-specific config
│
└── overlays/
    └── default.nix                  # Package overlays
                                     # - modified packages
```

## Home-Manager Integration

### Integration Strategy

- Integrate home-manager as a **darwin module** (not standalone)
- Runs as part of `darwin-rebuild switch` for atomic system updates
- Configuration: `useGlobalPkgs = true`, `useUserPackages = true`

### Module Guidelines

Replace imperative activation scripts with declarative home-manager modules:

| Old Approach | New Approach | Module |
|--------------|--------------|--------|
| Manual dotfiles | Declarative config | `xdg.configFile.*` |
| Git setup scripts | Git module | `programs.git` |
| Shell init scripts | Shell modules | `programs.zsh`, `programs.bash` |
| Tool configs | Tool modules | `programs.<tool>` |

### Organization

- **Terminal tools**: One file per tool in `_mixins/terminal/`
  - Examples: `bat.nix`, `eza.nix`, `fzf.nix`, `ripgrep.nix`
  - Each file configures one tool completely

- **Development tools**: Language/tooling in `_mixins/development/`
  - Examples: `git.nix`, `containers.nix`, `comma.nix`

- **Desktop apps**: GUI configs in `_mixins/desktop/`
  - Examples: `ghostty.nix`, `zed.nix`, `aerospace.nix`

- **User-specific**: Per-user overrides in `_mixins/users/<username>/`
  - Auto-imported based on `username` variable
  - User-specific theme preferences, personal settings

## Nixpkgs Channels and Overlays

### Channel Strategy

- **Single channel**: `nixpkgs` from FlakeHub `NixOS/nixpkgs/0` (rolling unstable)
  - Don't add a second nixpkgs input unless a package is actually pinned to it

### Overlay Pattern

`overlays/default.nix` holds package overrides only (e.g. disabling a flaky
test suite). Add an overlay entry when an upstream package needs patching.

## Homebrew Management

### Configuration Strategy

- **Pin taps as flake inputs** with `flake = false`
  - `homebrew-core`, `homebrew-cask` (`brew bundle` is built into brew; no tap needed)
  - Custom taps for specific applications
  - Ensures reproducible cask versions

- **Use nix-homebrew module**
  - Declarative tap management
  - Dynamic Rosetta detection for Apple Silicon
  - Set `mutableTaps = false` for reproducibility

- **Cleanup strategy**
  - `onActivation.cleanup = "zap"` removes unmanaged casks
  - Keeps system clean and in sync with config

### Example Configuration

```nix
homebrew = {
  enable = true;
  onActivation.cleanup = "zap";
  taps = builtins.attrNames config.nix-homebrew.taps;
  casks = [
    "app-name"
  ];
};
```

## Recommended Flake Inputs

### Essential Inputs

- **`nixpkgs`**: Package collection (use unstable for darwin)
- **`nix-darwin`**: macOS system configuration
- **`home-manager`**: User environment management

### Recommended Additions

- **`nix-homebrew`**: Declarative Homebrew tap management
- **`nix-index-database`**: Pre-built database for `command-not-found` functionality
- **`catppuccin`**: Unified theming across applications
- **`determinate`**: Determinate Systems Nix installer enhancements

### Input Pinning

Always use `follows` to avoid duplicate nixpkgs in store:

```nix
home-manager = {
  url = "github:nix-community/home-manager";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

## Nix Settings

### Flake Registry Pinning

Pin the flake registry so `nix shell nixpkgs#foo` uses locked versions:

```nix
# In darwin/default.nix or feature module
let
  flakeInputs = lib.filterAttrs (_: v: v ? outputs) inputs;
in
{
  determinateNix.registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
}
```

### Settings (Determinate Nix)

Determinate Nix disables nix-darwin's Nix module, so `nix.settings`,
`nix.registry` and `nix.nixPath` are silently ignored. Use the
`determinateNix.*` options instead:

```nix
determinateNix.customSettings = {
  warn-dirty = false;              # Don't warn on dirty git trees
};
```

Flakes and `nix-command` are enabled by default. Leave
`auto-optimise-store` off on macOS (known store corruption issues);
run `nix store optimise` manually if needed.

## Coding Conventions

### Formatting

- **Formatter**: Use `nixfmt-rfc-style` (RFC 166) for all Nix files
- **Consistency**: Run formatter before committing
- **Command**: `nix fmt` (configured in flake outputs)

### File Organization

- **Minimal flake.nix**: Only inputs, outputs, and machine wiring
  - No configuration logic in flake.nix
  - Use helpers for complex setup

- **Typed options over raw text**:
  - ✅ Use `programs.git.settings`
  - ❌ Avoid `environment.etc."gitconfig".text`
  - ✅ Use `system.defaults.dock.*`
  - ❌ Avoid activation scripts for system settings

- **Mixin directories**: Use `_mixins/` for composable fragments
  - Indicates modular, importable configs
  - Clear separation from required configs

- **Auto-imports**: Use `builtins.readDir` + filter for directories where all files should be imported

### Module Patterns

- **Context-aware modules**: Use `specialArgs` for dynamic behavior

  ```nix
  { username, hostname, ... }:
  {
    # Configuration that adapts to context
  }
  ```

- **Conditional features**: Gate features with `lib.mkIf`

  ```nix
  { lib, username, ... }:
  {
    # Only enable for specific users
    programs.foo.enable = lib.mkIf (lib.elem username ["alice" "bob"]) true;
  }
  ```

- **Per-host overrides**: Use convention-based loading

  ```nix
  modules = [
    # ... base modules
  ] ++ (
    if builtins.pathExists (./darwin + "/${hostname}")
    then [ (./darwin + "/${hostname}") ]
    else [ ]
  );
  ```

## Home-Manager Attribute Reference

### Common Pitfalls

- Git configuration uses `settings` not `extraConfig`:
  ```nix
  programs.git.settings = {
    user.name = "...";
    user.email = "...";
  };
  ```

- ZSH initialization uses `initContent` not `initExtra`:
  ```nix
  programs.zsh.initContent = ''
    # shell code
  '';
  ```

## Adding a New Machine

To add a new machine to this configuration:

1. **Add one line to flake.nix**:
   ```nix
   darwinConfigurations.new-hostname = helpers.mkDarwin {
     hostname = "new-hostname";
     username = "your-username";
   };
   ```

2. **(Optional) Add host-specific config**:
   - Create `darwin/new-hostname/default.nix`
   - Add any machine-specific overrides

3. **Deploy**:
   ```sh
   sudo darwin-rebuild switch --flake "$HOME/.config/nix-darwin#new-hostname"
   ```

4. **Install Claude Code** (native, self-updating; the cask lags behind the
   pinned homebrew-cask input). It lands in `~/.local/bin`, which `zsh.nix`
   adds to PATH:
   ```sh
   curl -fsSL https://claude.ai/install.sh | bash
   ```
   On a machine that still has the old `claude-code` cask, run
   `brew uninstall --cask claude-code` **before** switching. Otherwise
   `cleanup = "zap"` trashes `~/.local/share/claude` and `~/.claude.json`.

## Adding a New Tool

### Terminal Tool

1. Create `home-manager/_mixins/terminal/<tool>.nix`:
   ```nix
   { pkgs, ... }:
   {
     programs.<tool> = {
       enable = true;
       # configuration
     };
   }
   ```

2. Import in `home-manager/_mixins/terminal/default.nix`:
   ```nix
   {
     imports = [
       # ...
       ./<tool>.nix
     ];
   }
   ```

### System Package

Add to `darwin/default.nix`:

```nix
environment.systemPackages = with pkgs; [
  # ...
  new-package
];
```

### GUI Application (Homebrew Cask)

Add to `darwin/default.nix`:

```nix
homebrew.casks = [
  # ...
  "app-name"
];
```

## Troubleshooting

### Configuration Won't Build

```sh
# Check for syntax errors
nix flake check

# Show detailed evaluation errors
nix eval .#darwinConfigurations.<hostname>.config --show-trace
```

### Changes Not Taking Effect

```sh
# Verify configuration builds
nix build .#darwinConfigurations.<hostname>.system

# Check for activation issues
sudo darwin-rebuild switch --flake . --show-trace
```

### Git Dirty Tree Warnings

Set `nix.settings.warn-dirty = false` in `darwin/default.nix`.

### Store Optimization

```sh
# Manual optimization (auto-optimise-store is unsafe on macOS)
nix store optimise
```

## Best Practices Summary

1. ✅ **DO**: Keep configuration modular and composable
2. ✅ **DO**: Use typed nix-darwin/home-manager options
3. ✅ **DO**: Pin flake inputs and use `follows`
4. ✅ **DO**: Format code with nixfmt before committing
5. ✅ **DO**: Test changes with dev shell commands
6. ✅ **DO**: Use `_mixins/` for composable configs
7. ✅ **DO**: Document complex or non-obvious configurations

8. ❌ **DON'T**: Hardcode usernames or hostnames
9. ❌ **DON'T**: Create monolithic configuration files
10. ❌ **DON'T**: Use activation scripts for declarative config
11. ❌ **DON'T**: Bypass the formatter
12. ❌ **DON'T**: Mix concerns in single files

## Contributing

When making changes:

1. Follow the architecture principles above
2. Run `nix flake check` before committing
3. Format with `nix fmt`
4. Test with `check-nix-darwin-configuration`
5. Preview changes with `diff-nix-darwin-configuration`
6. Document non-obvious decisions

## Resources

- [Nix-Darwin Manual](https://daiderd.com/nix-darwin/manual/index.html)
- [Home-Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Language Basics](https://nix.dev/tutorials/nix-language)
- [nixfmt RFC 166](https://github.com/NixOS/rfcs/blob/master/rfcs/0166-nix-formatting.md)
