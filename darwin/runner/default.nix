{ inputs, pkgs, ... }:
{
  # GitHub Actions runner: tart VMs, no workstation profile.

  # cirruslabs/cli/tart now redirects to openai/tools/tart.
  nix-homebrew.taps."openai/homebrew-tools" = inputs.homebrew-openai-tools;
  homebrew.brews = [ "openai/tools/tart" ];

  # gh comes from home-manager (terminal/gh.nix).
  environment.systemPackages = [ pkgs.python3 ];

  # Stay up with the lid closed, on battery or charger.
  system.activationScripts.postActivation.text = ''
    pmset -a disablesleep 1
    pmset -a sleep 0
  '';
}
