# Nix-Darwin Configuration

## Apply Changes

```sh
sudo darwin-rebuild switch --flake ~/.config/nix-darwin
```

Or via the dev shell:

```sh
nix develop --command apply-nix-darwin-configuration
```

## Architecture Principles

- **Separate concerns**: split the monolithic `flake.nix` into `darwin/`, `home-manager/`, `lib/`, and `overlays/`.
- **Use a `mkDarwin` helper** in `lib/helpers.nix` to wire up each machine. Adding a new Mac should be a single line in `flake.nix`.
- **Convention-over-configuration host overrides**: use `builtins.pathExists` to load per-host config from `darwin/<hostname>/default.nix` when it exists, otherwise fall back to defaults.
- **Pass context via `specialArgs`**: pass `username`, `hostname`, and boolean flags (`isWorkstation`, `isLaptop`) to all modules instead of hardcoding values.
- **One module per concern**: each tool, feature, or system aspect gets its own file — never one giant block.

## Target Structure

```
flake.nix                        # Minimal: inputs, outputs, machine wiring
lib/
  helpers.nix                    # mkDarwin helper function
darwin/
  default.nix                   # Shared darwin config (system defaults, nix settings)
  _mixins/
    desktop/                    # Fonts, dock, finder, keyboard, trackpad
    features/                   # Feature modules (network, security, etc.)
  <hostname>/default.nix        # Per-host overrides (optional)
home-manager/
  default.nix                   # Home-manager entry point
  _mixins/
    terminal/                   # CLI tools: one file per tool (bat.nix, eza.nix, fzf.nix…)
    development/                # Dev tools: git, editors, languages
    desktop/                    # GUI app configs
    users/<username>/           # Per-user config (auto-imported by username)
overlays/
  default.nix                   # unstablePackages, modifiedPackages, localPackages
pkgs/                           # Custom package derivations (if needed)
secrets/                        # SOPS-encrypted secrets (if needed)
```

## Home-Manager

- Integrate home-manager as a **darwin module** (not standalone) so it runs as part of `darwin-rebuild switch`.
- Use `useGlobalPkgs = true` and `useUserPackages = true`.
- Replace activation scripts with declarative home-manager modules:
  - Git config -> `programs.git`
  - Ghostty config -> `xdg.configFile`
  - Nushell config -> `programs.nushell` or `xdg.configFile`
  - Starship config -> `programs.starship`
- Each CLI tool gets its own file in `_mixins/terminal/` (e.g., `bat.nix`, `eza.nix`).
- Per-user config lives in `_mixins/users/<username>/` and is auto-imported based on `username`.

## Nixpkgs Channels and Overlays

- Use **nixpkgs unstable** as the primary channel for darwin (better darwin support).
- Add a separate `nixpkgs-unstable` input for cherry-picking bleeding-edge packages.
- Expose unstable packages via an **overlay** as `pkgs.unstable.<package>` rather than passing a separate `unstablePkgs` arg — this makes them available everywhere without threading specialArgs.
- Use a **modifiedPackages overlay** for patching upstream packages when needed.

## Homebrew

- Pin homebrew taps (`homebrew-core`, `homebrew-cask`, `homebrew-bundle`) as **flake inputs** with `flake = false` for reproducible cask management.
- Use the **`nix-homebrew`** module with dynamic Rosetta detection.
- Use `onActivation.cleanup = "zap"` to remove unmanaged casks.

## Useful Flake Inputs to Add

- **`home-manager`**: declarative user environment (dotfiles, shell, programs).
- **`mac-app-util`**: make Nix-installed .app bundles visible in Spotlight and Launchpad.
- **`nix-homebrew`**: declarative Homebrew tap management.
- **`nix-index-database`**: pre-built `nix-index` database for `command-not-found` replacement.
- **`sops-nix`**: encrypted secrets management (age-based) for API keys, SSH keys, etc.
- **`catppuccin`**: theming — load palette JSON at eval time and pass as `specialArgs` for consistent colors across all modules.
- All inputs should use `follows` to pin `nixpkgs` and avoid duplicate store paths.

## Nix Settings

- **Pin the flake registry** to your inputs so `nix shell nixpkgs#foo` uses the locked version:
  ```nix
  nix.registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
  nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  ```

## Coding Conventions

- Format all Nix files with `nixfmt-rfc-style` (RFC 166).
- Keep `flake.nix` minimal — only inputs, outputs, and machine wiring via helpers.
- Prefer typed nix-darwin/home-manager options over raw text (`environment.etc`, `writeText`, activation scripts).
- Use `_mixins/` directories for composable config fragments.
- Use auto-import patterns (`builtins.readDir` + filter) for directories where every subfolder should be imported (e.g., scripts).
- Gate per-user features with `lib.mkIf (lib.elem username installFor)` when a module shouldn't apply to all users.
