{ ... }:
{
  programs.zellij = {
    enable = true;
    # Ghostty launches zellij; don't also auto-start it from zsh (Zed, IDEs, ssh).
    enableZshIntegration = false;
    settings = {
      # Closing a Ghostty window ends its session instead of leaving it detached.
      on_force_close = "quit";
      # Start locked so Ctrl+p/n/s/o/h/t reach zsh, vim, lazygit. Ctrl+g unlocks.
      default_mode = "locked";
    };
    # Ghostty's cmd+t sends Alt+t (ESC t); works from any mode.
    extraConfig = ''
      keybinds {
          shared {
              bind "Alt t" { NewTab; SwitchToMode "Locked"; }
          }
      }
    '';
  };
}
