{ ... }:
{
  # Workstation only (git.nix is shared and imported from home-manager/default.nix).
  # Project toolchains (languages, CLIs, databases) live in each project's
  # devShell, loaded by direnv. Run one-off tools with `, <cmd>` (comma).
  imports = [
    ./brain.nix
    ./containers.nix
    ./mcp.nix
    ./opencode.nix
  ];
}
