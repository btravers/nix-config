{ ... }:
{
  system.defaults.NSGlobalDomain = {
    AppleInterfaceStyle = "Dark";
    AppleShowAllExtensions = true;
    NSNavPanelExpandedStateForSaveMode = true;
    NSNavPanelExpandedStateForSaveMode2 = true;
    PMPrintingExpandedStateForPrint = true;
    PMPrintingExpandedStateForPrint2 = true;
    KeyRepeat = 2;
    InitialKeyRepeat = 15;
    NSAutomaticSpellingCorrectionEnabled = false;
    NSAutomaticQuoteSubstitutionEnabled = false;
    NSAutomaticDashSubstitutionEnabled = false;
  };

  system.defaults.SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;

  system.defaults.CustomUserPreferences."com.apple.WindowManager" = {
    StandardHideWidgets = 1;
  };

  system.defaults.CustomUserPreferences."com.apple.LaunchServices/com.apple.launchservices.secure" = {
    LSHandlers = [
      {
        LSHandlerURLScheme = "http";
        LSHandlerRoleAll = "org.mozilla.firefox";
      }
      {
        LSHandlerURLScheme = "https";
        LSHandlerRoleAll = "org.mozilla.firefox";
      }
    ];
  };
}
