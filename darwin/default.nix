{
  pkgs,
  config,
  username,
  hostname,
  ...
}:
{
  imports = [
    ./_mixins/features/nix-registry.nix
    ./_mixins/features/nix-homebrew.nix
    ./_mixins/features/nix-gc.nix
  ];

  system.stateVersion = 1;
  system.primaryUser = username;

  # LocalHostName must match the flake attribute so `darwin-rebuild --flake .`
  # picks this host's configuration.
  networking.hostName = hostname;

  users.knownUsers = [ username ];
  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
    uid = 501;
    shell = "/bin/zsh";
  };

  security.pam.services.sudo_local = {
    touchIdAuth = true;
    # Touch ID inside zellij/tmux sessions.
    reattach = true;
  };

  networking.applicationFirewall = {
    enable = true;
    enableStealthMode = true;
  };

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
    onActivation.cleanup = "zap";
    onActivation.upgrade = true;
    taps = builtins.attrNames config.nix-homebrew.taps;
  };
}
