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

  # Secretive key "pro" (Secure Enclave): GitHub login and commit signing.
  home-manager.users.${username}.programs.git.signing.key =
    "key::ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBAafciifGUWifrUPAiUW6/T7k+ExKwLvCgi3bV25FunOXrmLaTpV6bbDbNkp2EdRgwlRROkZM8UcZSDm/YFCSsM=";

  system.defaults.CustomUserPreferences."com.apple.HIToolbox" = {
    AppleEnabledInputSources = [ layout ];
    AppleSelectedInputSources = [ layout ];
  };
}
