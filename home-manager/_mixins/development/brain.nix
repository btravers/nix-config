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
  # HTTPS, authenticated by gh's credential helper: the 15-minute sync never
  # touches the Secretive key, so it never asks for Touch ID.
  remote = "https://github.com/btravers/obsidian.git";
  git = lib.getExe pkgs.git;
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

  # Clone the vault on a new machine, or move an existing clone off SSH. The
  # clone needs gh's login, so it only warns until `gh auth login` has run;
  # the next switch retries.
  home.activation.cloneBrainVault = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -e ${lib.escapeShellArg vault} ]; then
      if ! run env GIT_TERMINAL_PROMPT=0 \
          ${git} clone ${remote} ${lib.escapeShellArg vault}; then
        warnEcho "brain: could not clone the vault; run gh auth login and switch again."
      fi
    elif [ "$(${git} -C ${lib.escapeShellArg vault} remote get-url origin 2>/dev/null)" != ${remote} ]; then
      run ${git} -C ${lib.escapeShellArg vault} remote set-url origin ${remote}
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
