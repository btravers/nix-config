{ pkgs, ... }:
{
  home.packages = with pkgs; [
    httpie
    tldr
    tree
    yq-go
  ];
}
