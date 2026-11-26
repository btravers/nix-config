let
  # US ANSI keyboard.
  layout = {
    InputSourceKind = "Keyboard Layout";
    "KeyboardLayout ID" = 0;
    "KeyboardLayout Name" = "U.S.";
  };
in
{
  system.defaults.CustomUserPreferences."com.apple.HIToolbox" = {
    AppleEnabledInputSources = [ layout ];
    AppleSelectedInputSources = [ layout ];
  };
}
