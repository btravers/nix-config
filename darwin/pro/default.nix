{ username, ... }:
let
  # US ANSI keyboard.
  layout = {
    InputSourceKind = "Keyboard Layout";
    "KeyboardLayout ID" = 0;
    "KeyboardLayout Name" = "U.S.";
  };
in
{
  imports = [ ../_mixins/workstation.nix ];

  home-manager.users.${username} = {
    # Secretive key "pro" (Secure Enclave, no Touch ID): GitHub login and commit signing.
    programs.git.signing.key = "key::ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBIR944lMGBb7U487CDONCM43pameAJCU/bMxlK5wWEAFcKdkhMbrl4B/r6bqKCgnm8VNFw4zgJZsaUYkTJNyvX0=";

    # US layout: Option types no symbols needed for code, so plain alt is free.
    aerospace.modifier = "alt";
  };

  system.defaults.CustomUserPreferences."com.apple.HIToolbox" = {
    AppleEnabledInputSources = [ layout ];
    AppleSelectedInputSources = [ layout ];
  };
}
