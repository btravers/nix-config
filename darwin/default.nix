{
  pkgs,
  config,
  username,
  ...
}:
{
  imports = [
    ./_mixins/desktop
    ./_mixins/features/nix-registry.nix
    ./_mixins/features/nix-homebrew.nix
  ];

  system.stateVersion = 1;
  system.primaryUser = username;

  users.knownUsers = [ username ];
  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
    uid = 501;
    shell = "/bin/zsh";
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  system.startup.chime = false;

  environment.systemPackages = with pkgs; [
    _7zz
    curl
    vim
    wget
  ];

  programs.zsh.enable = true;

  nixpkgs.config.allowUnfree = true;

  # Determinate owns nix.conf; nix.settings is ignored. Flakes are on by default.
  determinateNix = {
    enable = true;
    customSettings = {
      extra-experimental-features = [
        "build-time-fetch-tree"
      ];
      warn-dirty = false;
    };
  };

  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.cleanup = "zap";
    onActivation.upgrade = true;
    taps = builtins.attrNames config.nix-homebrew.taps;
    brews = [
      "gdb"
      "lsusb"
      "minicom"
      "sdl2"
    ];
    casks = [
      "TheBoredTeam/boring-notch/boring-notch"
      "autodesk-fusion"
      "bambu-connect"
      "bambu-studio"
      "chatgpt"
      "claude"
      "cyberghost-vpn"
      "docker-desktop"
      "firefox"
      "firefox@developer-edition"
      "font-jetbrains-mono-nerd-font"
      "ghostty"
      "google-chrome"
      "intellij-idea"
      "obsidian"
      "ollama-app"
      "nikitabobko/tap/aerospace"
      "raycast"
      "slack"
      "spotify"
      "whatsapp"
      "zed"
    ];
  };
}
