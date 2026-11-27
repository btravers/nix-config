{ config, lib, ... }:
{
  xdg.configFile."ghostty/config" = {
    text = ''
      # Always Mocha: zellij, starship, fzf, bat... are themed Mocha by the
      # global catppuccin flavor and can't follow the macOS appearance, so a
      # Latte background leaves their light text unreadable.
      theme = Catppuccin Mocha
      font-family = JetBrainsMono Nerd Font

      # Every window runs its own zellij session; zellij does tabs and splits.
      command = ${lib.getExe config.programs.zellij.package}

      # Native Ghostty tabs break AeroSpace tiling: cmd+t opens a zellij tab
      # instead (Alt+t, bound in zellij.nix).
      keybind = cmd+t=text:\x1bt
    '';
  };
}
