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
    autoMigrate = true;
    enableRosetta = pkgs.stdenv.hostPlatform.isAarch64;
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
      "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
      "TheBoredTeam/homebrew-boring-notch" = inputs.homebrew-boring-notch;
      "nikitabobko/homebrew-tap" = inputs.homebrew-aerospace;
    };
    mutableTaps = false;
  };
}
