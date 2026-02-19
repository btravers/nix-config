{ pkgs, ... }:
{
  home.packages = with pkgs; [
    rustup
  ];

  home.sessionPath = [
    "$HOME/.cargo/bin"
  ];

  home.sessionVariables = {
    RUST_BACKTRACE = "1";
  };
}
