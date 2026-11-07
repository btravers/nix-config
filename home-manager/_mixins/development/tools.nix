{ pkgs, ... }:
{
  home.packages = with pkgs; [
    just
    protobuf
    tilt
    watchexec
  ];
}
