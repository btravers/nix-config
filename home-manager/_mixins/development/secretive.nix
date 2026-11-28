{ config, ... }:
let
  home = config.home.homeDirectory;
  # Secretive (cask in darwin/_mixins/workstation.nix) keeps SSH keys in the
  # Secure Enclave, one per Mac, created without Touch ID (push and sign silently).
  socket = "${home}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
in
{
  # Shell tools, and git commit signing (ssh-keygen -Y sign only reads this).
  home.sessionVariables.SSH_AUTH_SOCK = socket;
  # Same for GUI apps (Zed's git), which never read shell variables.
  launchd.agents.secretive-ssh-auth-sock = {
    enable = true;
    config = {
      ProgramArguments = [
        "/bin/launchctl"
        "setenv"
        "SSH_AUTH_SOCK"
        socket
      ];
      RunAtLoad = true;
    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [
      # Colima's VM; it skips editing ~/.ssh/config when this line exists.
      "${home}/.colima/ssh_config"
      # Machine-local hosts (client servers, legacy key files), kept out of git.
      "${home}/.ssh/config.local"
    ];
    # Every app that runs ssh, GUI ones too.
    settings."*".IdentityAgent = socket;
  };

  # Each host sets programs.git.signing.key to its Secretive public key
  # (darwin/<hostname>/default.nix); signing turns on once it is set.
  programs.git.signing = {
    format = "ssh";
    signByDefault = config.programs.git.signing.key != null;
  };
}
