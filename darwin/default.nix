{ pkgs, username, ... }:
{
  imports = [
    ./_mixins/desktop
  ];

  system.stateVersion = 1;
  system.primaryUser = username;

  users.knownUsers = [ username ];
  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
    uid = 501;
    shell = pkgs.nushell;
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  environment.shells = [ pkgs.nushell ];

  environment.systemPackages = with pkgs; [
    curl
    fastfetch
    ffmpeg
    gh
    htop
    imagemagick
    jq
    nushell
    poppler
    resvg
    ripgrep
    tldr
    tree
    vim
    wget
    _7zz
  ];

  programs.zsh.enable = true;

  determinateNix = {
    enable = true;
    customSettings = {
      eval-cores = 0;
      extra-experimental-features = [
        "build-time-fetch-tree"
      ];
    };
  };

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    taps = [
      "TheBoredTeam/boring-notch"
    ];
    casks = [
      "font-jetbrains-mono-nerd-font"
      "TheBoredTeam/boring-notch/boring-notch"
      "claude"
      "claude-code"
      "docker-desktop"
      "firefox"
      "ghostty"
      "google-chrome"
      "obsidian"
      "raycast"
      "slack"
      "spotify"
      "zed"
    ];
  };
}
