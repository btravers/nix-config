{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Rust toolchain
    rustup

    # WASM development for Leptos
    trunk # WASM bundler and dev server
    wasm-bindgen-cli # JS bindings generator

    # Essential Rust utilities (beginner-friendly)
    cargo-edit # cargo add, cargo rm, cargo upgrade

    # Future additions as you level up:
    # cargo-watch       # Auto-rebuild on file changes
    # cargo-nextest     # Faster test runner
    # bacon             # Background code checker
  ];

  # Helpful environment variables
  home.sessionVariables = {
    RUST_BACKTRACE = "1"; # Always show backtraces for learning
  };
}
