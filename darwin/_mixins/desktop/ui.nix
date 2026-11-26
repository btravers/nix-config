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

  # English UI, French region formats (metric, €, 24h, dd/mm).
  system.defaults.CustomUserPreferences.NSGlobalDomain = {
    AppleLanguages = [ "en-US" ];
    AppleLocale = "en_FR";
  };

  system.defaults.SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;

  system.defaults.CustomUserPreferences."com.apple.WindowManager" = {
    StandardHideWidgets = 1;
  };

  system.defaults.CustomUserPreferences."com.apple.LaunchServices/com.apple.launchservices.secure" = {
    LSHandlers = [
      {
        LSHandlerURLScheme = "http";
        LSHandlerRoleAll = "org.mozilla.firefoxdeveloperedition";
      }
      {
        LSHandlerURLScheme = "https";
        LSHandlerRoleAll = "org.mozilla.firefoxdeveloperedition";
      }
    ];
  };
}
