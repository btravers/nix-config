{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
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
