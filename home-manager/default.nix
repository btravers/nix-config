{ username, ... }:
{
  imports = [
    ./_mixins/desktop/ghostty.nix
    ./_mixins/desktop/zed.nix
    ./_mixins/development/git.nix
    ./_mixins/development/rust.nix
    ./_mixins/terminal
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
