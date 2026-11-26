{ lib, pkgs, ... }:
{
  home.packages = [ pkgs.fnm ];

  programs.zsh.initContent = lib.mkAfter ''
    eval "$(fnm env --use-on-cd --shell zsh)"
  '';
}
