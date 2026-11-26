{ username, ... }:
{
  # Every host, the runner included. Desktop apps, agents and brain come from
  # ./workstation.nix (via darwin/_mixins/workstation.nix).
  imports = [
    ./_mixins/development/git.nix
    ./_mixins/terminal
    ./_mixins/users/${username}
  ];

  home = {
    username = username;
    homeDirectory = "/Users/${username}";
    stateVersion = "25.11";
    shellAliases = {
      ls = "eza";
      ll = "eza -la";
      cat = "bat";
      lg = "lazygit";
    };
  };
}
