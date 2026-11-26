{ username, ... }:
{
  system.defaults.controlcenter = {
    BatteryShowPercentage = true;
    NowPlaying = true;
    Sound = true;
    Bluetooth = false;
    AirDrop = false;
    Display = false;
    FocusModes = false;
  };

  system.defaults.menuExtraClock = {
    ShowDate = 1;
    ShowDayOfWeek = true;
    ShowSeconds = true;
  };

  # Hide Spotlight from the menu bar. -currentHost targets ByHost/com.apple.Spotlight.<UUID>.plist.
  system.activationScripts.postActivation.text = ''
    sudo -u ${username} defaults -currentHost write com.apple.Spotlight MenuItemHidden -int 1
  '';
}
