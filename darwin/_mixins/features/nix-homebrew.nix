{
  inputs,
  username,
  pkgs,
  ...
}:
{
  nix-homebrew = {
    enable = true;
    user = username;
    enableRosetta = pkgs.stdenv.hostPlatform.isAarch64;
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
      "TheBoredTeam/homebrew-boring-notch" = inputs.homebrew-boring-notch;
      "nikitabobko/homebrew-tap" = inputs.homebrew-aerospace;
    };
    mutableTaps = false;
    # ponytail: workaround for zhaofengli/nix-homebrew#187 (generated bin/brew
    # shim lacks this export, every brew command crashes); drop once fixed upstream.
    extraEnv.HOMEBREW_ORIGINAL_BREW_FILE = "/opt/homebrew/bin/brew";
  };
}
