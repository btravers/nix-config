{ pkgs, ... }:
{
  home.packages = with pkgs; [
    just
    nixd
    protobuf
    tilt
    watchexec
  ];
}
