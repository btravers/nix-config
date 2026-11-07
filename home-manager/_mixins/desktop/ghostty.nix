{ ... }:
{
  xdg.configFile."ghostty/config" = {
    text = ''
      theme = Catppuccin Mocha
      font-family = JetBrainsMono Nerd Font

      # Remap cmd+t to open a new window instead of a tab (use tmux for tabs)
      keybind = cmd+t=new_window
    '';
  };
}
