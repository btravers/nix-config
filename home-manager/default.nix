{ username, ... }:
{
  imports = [
    ./_mixins/desktop/aerospace.nix
    ./_mixins/desktop/ghostty.nix
    ./_mixins/desktop/zed.nix
    ./_mixins/development/git.nix
    ./_mixins/development/rust.nix
    ./_mixins/terminal
    ./_mixins/users/${username}
  ];

  home = {
    username = username;
    homeDirectory = "/Users/${username}";
    stateVersion = "25.11";
    shellAliases = {
      # ls = "eza";
      ll = "eza -la";
      cat = "bat";
      lg = "lazygit";
    };
  };
}
