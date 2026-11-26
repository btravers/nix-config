{ ... }:
{
  # Project toolchains (languages, CLIs, databases) live in each project's
  # devShell, loaded by direnv. Run one-off tools with `, <cmd>` (comma).
  imports = [
    ./containers.nix
    ./git.nix
  ];
}
