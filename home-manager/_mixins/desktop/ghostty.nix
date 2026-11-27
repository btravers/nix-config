{ config, lib, ... }:
{
  xdg.configFile."ghostty/config" = {
    text = ''
      # Follows the macOS appearance: Latte in light mode, Mocha in dark mode.
      theme = light:Catppuccin Latte,dark:Catppuccin Mocha
      font-family = JetBrainsMono Nerd Font

      # Every window runs its own zellij session; zellij does tabs and splits.
      command = ${lib.getExe config.programs.zellij.package}

      # Native Ghostty tabs break AeroSpace tiling: cmd+t opens a zellij tab
      # instead (Alt+t, bound in zellij.nix).
      keybind = cmd+t=text:\x1bt
    '';
  };
}
