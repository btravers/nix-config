{ pkgs, ... }:
{
  home.packages = [ pkgs.nil ];

  xdg.configFile."zed/settings.json" = {
    text = builtins.toJSON {
      lsp.nil.binary.path = "${pkgs.nil}/bin/nil";
      icon_theme = "Catppuccin Macchiato";
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      base_keymap = "JetBrains";
      ui_font_size = 16;
      buffer_font_size = 15;
      theme = {
        mode = "system";
        light = "One Light";
        dark = "Catppuccin Macchiato";
      };
      terminal = {
        shell = {
          program = "/run/current-system/sw/bin/nu";
        };
      };
      auto_install_extensions = {
        biome = true;
        catppuccin = true;
        catppuccin-icons = true;
        html = true;
        nix = true;
        oxc = true;
      };
    };
  };
}
