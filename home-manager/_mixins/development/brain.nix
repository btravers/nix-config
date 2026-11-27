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
  package = inputs.mcp-brain.packages.${pkgs.stdenv.hostPlatform.system}.default;
  # Stable profile path, not a store path: agent registrations survive updates.
  bin = "/etc/profiles/per-user/${username}/bin/mcp-brain";
in
{
  home.packages = [ package ];

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

  # Semantic search: the pinned embedding model (~490 MB, SHA-256 verified)
  # lives in mcp-brain's state dir, outside the vault. Installing is a no-op
  # once the files verify; a fresh install embeds the whole vault right away
  # instead of gradually on later queries.
  # Activation's PATH has neither curl (download) nor git (mcp-brain opens the
  # vault's repo), so pass both.
  home.activation.installBrainModel = lib.hm.dag.entryAfter [ "cloneBrainVault" ] ''
    brain_path=${
      lib.makeBinPath [
        pkgs.curl
        pkgs.git
      ]
    }:$PATH
    if [ -d ${lib.escapeShellArg vault} ]; then
      if out=$(run env PATH="$brain_path" \
          ${lib.getExe package} --vault ${lib.escapeShellArg vault} --json model install); then
        if [ "$(${lib.getExe pkgs.jq} -r .already_installed <<<"$out" 2>/dev/null)" = false ]; then
          run env PATH="$brain_path" ${lib.getExe package} --vault ${lib.escapeShellArg vault} index rebuild \
            || warnEcho "brain: model installed, but index rebuild failed; queries will embed notes gradually."
        fi
      else
        warnEcho "brain: could not install the search model; switch again to retry."
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
