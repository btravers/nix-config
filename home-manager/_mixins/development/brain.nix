{
  config,
  inputs,
  lib,
  pkgs,
  username,
  ...
}:
let
  vault = "${config.home.homeDirectory}/Obsidian/btravers";
  # Stable profile path, not a store path: agent registrations survive updates.
  bin = "/etc/profiles/per-user/${username}/bin/mcp-brain";
in
{
  home.packages = [ inputs.mcp-brain.packages.${pkgs.stdenv.hostPlatform.system}.default ];

  # Registered with every agent by mcp.nix.
  programs.mcp.servers.brain = {
    command = bin;
    args = [
      "--vault"
      vault
      "serve"
    ];
  };

  # Clone the vault on a new machine. Needs GitHub SSH access, so it only
  # warns until `gh auth login` has run; the next switch retries.
  home.activation.cloneBrainVault = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -e ${lib.escapeShellArg vault} ]; then
      if ! run env GIT_SSH_COMMAND="/usr/bin/ssh -o BatchMode=yes" \
          ${lib.getExe pkgs.git} clone git@github.com:btravers/obsidian.git ${lib.escapeShellArg vault}; then
        warnEcho "brain: could not clone the vault; set up GitHub SSH (gh auth login) and switch again."
      fi
    fi
  '';

  # Keep every machine's copy in step: fetch, fast-forward, push local commits.
  launchd.agents.mcp-brain-sync = {
    enable = true;
    config = {
      ProgramArguments = [
        bin
        "--vault"
        vault
        "sync"
      ];
      EnvironmentVariables.PATH = "/etc/profiles/per-user/${username}/bin:/usr/bin:/bin";
      StartInterval = 900;
      RunAtLoad = true;
      ProcessType = "Background";
      StandardOutPath = "${config.home.homeDirectory}/Library/Logs/mcp-brain-sync.log";
      StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/mcp-brain-sync.log";
    };
  };
}
