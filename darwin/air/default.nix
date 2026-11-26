{ inputs, username, ... }:
let
  # French AZERTY keyboard.
  layout = {
    InputSourceKind = "Keyboard Layout";
    "KeyboardLayout ID" = 1;
    "KeyboardLayout Name" = "French";
  };
in
{
  imports = [ ../_mixins/workstation.nix ];

  nix-homebrew.taps."TheBoredTeam/homebrew-boring-notch" = inputs.homebrew-boring-notch;
  homebrew.casks = [ "TheBoredTeam/boring-notch/boring-notch" ];

  # Secretive key "air" (Secure Enclave): GitHub login and commit signing.
  home-manager.users.${username}.programs.git.signing.key =
    "key::ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBP7XsyaFsrSDvV3cXdXyXwwQdBNVUxNZfCzFEdW00T4UPTt2c8GwaC3MSraCYEnDNckz5cHwz+DsrR+wo7rOsc8=";

  system.defaults.CustomUserPreferences."com.apple.HIToolbox" = {
    AppleEnabledInputSources = [ layout ];
    AppleSelectedInputSources = [ layout ];
  };
}
