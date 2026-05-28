{ pkgs, ... }:
{
  home.packages = with pkgs; [
    typescript-language-server
    vscode-langservers-extracted
    tailwindcss-language-server
    fx

    # node-canvas native dependencies
    pkg-config
    cairo
    pango
    libpng
    libjpeg
    giflib
    librsvg
    pixman
    python3Packages.setuptools
  ];
}
