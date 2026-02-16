{ pkgs, ... }:
{
  home.packages = with pkgs; [
    rustup
    trunk
    wasm-bindgen-cli
    cargo-edit
  ];

  home.sessionVariables = {
    RUST_BACKTRACE = "1";
  };
}
