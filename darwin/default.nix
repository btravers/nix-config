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

  environment.shells = [
    pkgs.zsh
  ];

  environment.systemPackages = with pkgs; [
    bun
    curl
    ffmpeg
    gh
    htop
    imagemagick
    jq
    nixd
    poppler
    protobuf
    resvg
    ripgrep
    tldr
    tree
    vim
    wget
    _7zz
    just
    direnv
    tilt
    watchexec
    httpie
    yq-go
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

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    warn-dirty = false;
    auto-optimise-store = true;
  };

  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.cleanup = "zap";
    onActivation.upgrade = true;
    taps = builtins.attrNames config.nix-homebrew.taps;
    casks = [
      "TheBoredTeam/boring-notch/boring-notch"
      "claude"
      "claude-code"
      "docker-desktop"
      "firefox"
      "firefox@developer-edition"
      "font-jetbrains-mono-nerd-font"
      "ghostty"
      "google-chrome"
      "intellij-idea"
      "obsidian"
      "nikitabobko/tap/aerospace"
      "raycast"
      "slack"
      "spotify"
      "whatsapp"
      "zed"
    ];
  };
}
