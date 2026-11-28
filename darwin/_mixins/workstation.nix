{ inputs, username, ... }:
{
  # Daily-driver Macs (air, pro): desktop apps and settings, AI agents, brain.
  # Imported from darwin/<hostname>/default.nix; the runner leaves it out.
  imports = [ ./desktop ];

  home-manager.users.${username}.imports = [ ../../home-manager/workstation.nix ];

  nix-homebrew.taps."nikitabobko/homebrew-tap" = inputs.homebrew-aerospace;

  homebrew = {
    brews = [
      "gdb"
      "lsusb"
      "minicom"
      "sdl2"
    ];
    casks = [
      "autodesk-fusion"
      "bambu-connect"
      "bambu-studio"
      "chatgpt"
      "claude"
      "cyberghost-vpn"
      "firefox@developer-edition"
      "font-jetbrains-mono-nerd-font"
      "ghostty"
      "google-chrome"
      "intellij-idea"
      "lm-studio"
      "obsidian"
      "ollama-app"
      "nikitabobko/tap/aerospace"
      "raycast"
      "secretive"
      "slack"
      "spotify"
      "vorssaint"
      "whatsapp"
      "zed"
    ];
  };
}
