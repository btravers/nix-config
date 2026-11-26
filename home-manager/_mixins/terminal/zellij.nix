{ ... }:
{
  programs.zellij = {
    enable = true;
    # Ghostty launches zellij; don't also auto-start it from zsh (Zed, IDEs, ssh).
    enableZshIntegration = false;
    # Closing a Ghostty window ends its session instead of leaving it detached.
    settings.on_force_close = "quit";
  };
}
