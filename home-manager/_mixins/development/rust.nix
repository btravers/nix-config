{ pkgs, ... }:
{
  # Project-specific cargo tools (cargo-leptos, sqlx-cli, trunk) belong in each
  # project's devShell so their versions match the project.
  home.packages = with pkgs; [
    espup
    rustlings
    rustup
  ];

  home.sessionPath = [
    "$HOME/.cargo/bin"
  ];

  home.sessionVariables = {
    RUST_BACKTRACE = "1";
  };
}
