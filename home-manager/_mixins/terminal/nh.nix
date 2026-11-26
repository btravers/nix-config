{ config, ... }:
{
  # `nh darwin switch` rebuilds from anywhere and shows what changed.
  programs.nh = {
    enable = true;
    darwinFlake = "${config.home.homeDirectory}/.config/nix-darwin";
  };
}
