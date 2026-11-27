{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = [ pkgs.nil ];

  xdg.configFile."zed/settings.json" = {
    text = builtins.toJSON {
      # Follow the macOS appearance: Latte in light mode, Mocha in dark mode.
      icon_theme = {
        mode = "system";
        light = "Catppuccin Latte";
        dark = "Catppuccin Mocha";
      };
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      base_keymap = "JetBrains";
      ui_font_size = 16;
      buffer_font_size = 15;
      theme = {
        mode = "system";
        light = "Catppuccin Latte";
        dark = "Catppuccin Mocha";
      };
      context_servers = lib.mapAttrs (_: s: { inherit (s) command args; }) config.programs.mcp.servers;
      terminal = {
        shell = {
          program = "/bin/zsh";
        };
      };
      auto_install_extensions = {
        catppuccin = true;
        catppuccin-icons = true;
        html = true;
        just = true;
        nix = true;
        oxc = true;
        rust = true;
        toml = true;
        typescript = true;
        tailwind = true;
      };
      lsp = {
        # Nix LSP
        nil.binary.path = "${pkgs.nil}/bin/nil";

        # Rust analyzer configuration
        rust-analyzer = {
          initialization_options = {
            check = {
              command = "clippy"; # Use clippy instead of cargo check
            };
            cargo = {
              features = "all"; # Enable all features
            };
          };
        };

        # TypeScript language server
        typescript-language-server = {
          initialization_options = {
            preferences = {
              includeInlayParameterNameHints = "all";
              includeInlayFunctionParameterTypeHints = true;
            };
          };
        };

        # Tailwind CSS language server (with Rust support for Leptos)
        tailwindcss-language-server = {
          initialization_options = {
            userLanguages = {
              rust = "html"; # Enable Tailwind in Leptos view! macros
            };
          };
        };
      };
    };
  };
}
