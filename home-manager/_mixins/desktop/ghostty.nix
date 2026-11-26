{ config, lib, ... }:
{
  xdg.configFile."ghostty/config" = {
    text = ''
      theme = Catppuccin Mocha
      font-family = JetBrainsMono Nerd Font

      # Every window runs its own zellij session; zellij does tabs and splits.
      command = ${lib.getExe config.programs.zellij.package}

      # Native Ghostty tabs break AeroSpace tiling: cmd+t opens a zellij tab
      # instead (Ctrl+t, n).
      keybind = cmd+t=text:\x14n
    '';
  };
}
