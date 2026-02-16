{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    tailwindcss-language-server
    fx
  ];
}
