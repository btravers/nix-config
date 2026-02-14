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

  system.activationScripts.hideSpotlight.text = ''
    SPOTLIGHT_PLIST=$(ls /Users/${username}/Library/Preferences/ByHost/com.apple.Spotlight.*.plist 2>/dev/null | head -1)
    if [ -n "$SPOTLIGHT_PLIST" ]; then
      sudo -u ${username} defaults write "$SPOTLIGHT_PLIST" MenuItemHidden -int 1
    else
      sudo -u ${username} defaults -currentHost write com.apple.Spotlight MenuItemHidden -int 1
    fi
  '';
}
