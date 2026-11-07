{ username, ... }:
{
  # Disable Spotlight shortcut (Cmd+Space) so Raycast can use it.
  # Must be postActivation: nix-darwin silently skips custom activationScripts names.
  system.activationScripts.postActivation.text = ''
    sudo -u ${username} defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 '<dict><key>enabled</key><false/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>49</integer><integer>1048576</integer></array><key>type</key><string>standard</string></dict></dict>'
    sudo -u ${username} /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';
}
