{ lib, pkgs, ... }:
let
  # The agent harness, the same on every workstation: one process layer
  # (superpowers), one style layer (ponytail), language servers.
  marketplaces = {
    claude-plugins-official = "anthropics/claude-plugins-official";
    ponytail = "DietrichGebert/ponytail";
  };
  plugins = [
    "superpowers@claude-plugins-official"
    "ponytail@ponytail"
    "rust-analyzer-lsp@claude-plugins-official"
    "typescript-lsp@claude-plugins-official"
  ];

  jq = lib.getExe pkgs.jq;
  # Activation runs with a minimal PATH (coreutils, grep, sed, jq): no awk.
  awk = lib.getExe pkgs.gawk;
  forMarketplaces = f: lib.concatStrings (lib.mapAttrsToList f marketplaces);
  forPlugins = f: lib.concatMapStrings f plugins;
  q = lib.escapeShellArg;
in
{
  # Binaries the LSP plugins start. rust-analyzer comes from each project's
  # devShell instead, so it matches that project's Rust toolchain.
  home.packages = [
    pkgs.typescript
    pkgs.typescript-language-server
  ];

  # Claude Code and Codex come from their vendors' installers, not Nix: both
  # ship several times a week and update themselves. Install them once if
  # missing. ~/.local/bin on PATH keeps the installers from editing shell
  # profiles (zsh.nix already adds it); /usr/bin provides their curl and tar.
  home.activation.installAgentCLIs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    installer_path="$HOME/.local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
    if [ ! -x "$HOME/.local/bin/claude" ]; then
      run env PATH="$installer_path" /bin/bash -c \
        'set -o pipefail; curl -fsSL https://claude.ai/install.sh | bash' \
        || warnEcho "agents: could not install Claude Code"
    fi
    if [ ! -x "$HOME/.local/bin/codex" ]; then
      run env PATH="$installer_path" CODEX_NON_INTERACTIVE=1 /bin/bash -c \
        'set -o pipefail; curl -fsSL https://chatgpt.com/codex/install.sh | sh' \
        || warnEcho "agents: could not install Codex"
    fi
  '';

  # Claude Code and Codex write their own plugin state, so install through
  # their CLIs, only what is missing. Plugins added by hand are left alone.
  home.activation.installAgentPlugins = lib.hm.dag.entryAfter [ "installAgentCLIs" ] ''
    claude="$HOME/.local/bin/claude"
    codex="$HOME/.local/bin/codex"

    if [ -x "$claude" ]; then
      known=$("$claude" plugin marketplace list --json 2>/dev/null | ${jq} -r '.[].name' || true)
      enabled=$("$claude" plugin list --json 2>/dev/null \
        | ${jq} -r '.[] | select(.scope == "user" and .enabled) | .id' || true)
      ${forMarketplaces (
        name: repo: ''
          if ! grep -qx ${q name} <<< "$known"; then
            run "$claude" plugin marketplace add ${q repo} >/dev/null \
              || warnEcho "agents: could not add marketplace ${name} to Claude Code"
          fi
        ''
      )}
      ${forPlugins (p: ''
        if ! grep -qx ${q p} <<< "$enabled"; then
          run "$claude" plugin install --scope user ${q p} >/dev/null 2>&1 \
            || run "$claude" plugin enable --scope user ${q p} >/dev/null \
            || warnEcho "agents: could not install ${p} in Claude Code"
        fi
      '')}
    fi

    if [ -x "$codex" ]; then
      known=$("$codex" plugin marketplace list 2>/dev/null | ${awk} 'NR > 1 { print $1 }' || true)
      enabled=$("$codex" plugin list --json 2>/dev/null \
        | ${jq} -r '.installed[] | select(.installed and .enabled) | .pluginId' || true)
      ${forMarketplaces (
        name: repo: ''
          if ! grep -qx ${q name} <<< "$known"; then
            run "$codex" plugin marketplace add ${q repo} >/dev/null 2>&1 \
              || warnEcho "agents: could not add marketplace ${name} to Codex"
          fi
        ''
      )}
      ${forPlugins (p: ''
        if ! grep -qx ${q p} <<< "$enabled"; then
          run "$codex" plugin add ${q p} >/dev/null 2>&1 \
            || warnEcho "agents: could not install ${p} in Codex"
        fi
      '')}
    fi
  '';
}
