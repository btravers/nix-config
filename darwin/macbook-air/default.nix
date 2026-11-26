{ inputs, ... }:
let
  # French AZERTY keyboard.
  layout = {
    InputSourceKind = "Keyboard Layout";
    "KeyboardLayout ID" = 1;
    "KeyboardLayout Name" = "French";
  };
in
{
  nix-homebrew.taps."TheBoredTeam/homebrew-boring-notch" = inputs.homebrew-boring-notch;
  homebrew.casks = [ "TheBoredTeam/boring-notch/boring-notch" ];

  system.defaults.CustomUserPreferences."com.apple.HIToolbox" = {
    AppleEnabledInputSources = [ layout ];
    AppleSelectedInputSources = [ layout ];
  };
}
