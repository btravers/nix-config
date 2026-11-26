#!/bin/sh
# Bootstrap a fresh Mac into this configuration. Safe to re-run.
#   curl -fsSL https://raw.githubusercontent.com/btravers/nix-config/main/bootstrap.sh | sh -s -- <host>
set -eu

# Wrapped in main so `curl | sh` reads the whole script before any command
# can consume stdin.
main() {
  host="${1:?usage: bootstrap.sh <host>   (a darwinConfigurations name in flake.nix)}"
  repo="https://github.com/btravers/nix-config.git"
  dir="$HOME/.config/nix-darwin"

  step() { printf '\n==> %s\n' "$*"; }

  step "Command line tools"
  if ! xcode-select -p >/dev/null 2>&1; then
    xcode-select --install
    echo "Finish the installer dialog; waiting for it..."
    until xcode-select -p >/dev/null 2>&1; do sleep 5; done
  fi

  step "Rosetta"
  if ! arch -x86_64 /usr/bin/true 2>/dev/null; then
    sudo softwareupdate --install-rosetta --agree-to-license
  fi

  step "Determinate Nix"
  if [ ! -x /nix/var/nix/profiles/default/bin/nix ]; then
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix |
      sh -s -- install --no-confirm
  fi
  # Load Nix into this shell; its profile script is not written for `set -u`.
  set +u
  # shellcheck disable=SC1091
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  set -u

  step "Clone $repo"
  if [ ! -d "$dir/.git" ]; then
    git clone "$repo" "$dir"
  fi

  step "Switch to $host"
  cd "$dir"
  # The darwin-rebuild pinned in flake.lock, run by full path: sudo resets PATH.
  rebuild=$(nix build --no-link --print-out-paths --inputs-from . nix-darwin#darwin-rebuild)
  # nix-darwin refuses to overwrite /etc files it did not write (the shell files,
  # Determinate's nix.custom.conf, which determinateNix manages); set them aside
  # (what it would ask you to do), and put them back if the switch fails early.
  for f in bashrc zshrc zshenv nix/nix.custom.conf; do
    if [ -f "/etc/$f" ] && [ ! -L "/etc/$f" ]; then
      sudo mv "/etc/$f" "/etc/$f.before-nix-darwin"
    fi
  done
  if ! sudo "$rebuild/bin/darwin-rebuild" switch --flake ".#$host"; then
    for f in bashrc zshrc zshenv nix/nix.custom.conf; do
      if [ ! -e "/etc/$f" ] && [ -f "/etc/$f.before-nix-darwin" ]; then
        sudo mv "/etc/$f.before-nix-darwin" "/etc/$f"
      fi
    done
    echo "Switch failed; fix the error above and re-run this script." >&2
    exit 1
  fi

  cat <<'EOF'

==> Done. Next, by hand:
  1. Log out and back in (language, keyboard layout, menu bar clock).
  2. gh auth login
     git -C ~/.config/nix-darwin remote set-url origin git@github.com:btravers/nix-config.git
  3. Workstations only: allow AeroSpace and Raycast in Accessibility, set the
     Raycast hotkey to Cmd+Space, create this Mac's key in Secretive and add
     it to GitHub (see README), then run `nh darwin switch` again to clone
     the vault. Claude Code and Codex are already installed.
EOF
}

main "$@"
