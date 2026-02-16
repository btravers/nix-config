{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Language servers for Zed/IntelliJ IDE integration
    # These provide editor features by interfacing with project-local tools
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted # HTML/CSS/JSON LSPs
    tailwindcss-language-server # Tailwind CSS IntelliSense

    # Standalone development utilities
    fx # Interactive JSON viewer (useful for API debugging)

    # Note: Project-specific tools (biome, prettier, eslint, etc.) 
    # should be installed as devDependencies in each project's package.json
  ];
}
