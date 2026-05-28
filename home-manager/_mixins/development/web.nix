{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bun
    fx
    tailwindcss-language-server
    typescript-language-server
    vscode-langservers-extracted
  ];
}
