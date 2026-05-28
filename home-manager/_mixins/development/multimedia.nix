{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ffmpeg
    imagemagick
    poppler
    resvg
  ];
}
