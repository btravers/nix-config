{ pkgs, ... }:
{
  home.packages = with pkgs; [
    rustup
    trunk
    wasm-bindgen-cli
    cargo-edit
    cargo-leptos
  ];

  home.sessionVariables = {
    RUST_BACKTRACE = "1";
  };
}
