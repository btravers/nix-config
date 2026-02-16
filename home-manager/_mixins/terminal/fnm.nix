{ lib, pkgs, ... }:
{
  home.packages = [ pkgs.fnm ];

  programs.zsh.initContent = lib.mkAfter ''
    eval "$(fnm env --corepack-enabled --use-on-cd --shell zsh)"
  '';
}
