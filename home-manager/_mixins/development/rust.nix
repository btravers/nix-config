{ pkgs, ... }:
{
  home.packages = with pkgs; [
    rustup
  ];

  home.sessionVariables = {
    RUST_BACKTRACE = "1";
  };
}
