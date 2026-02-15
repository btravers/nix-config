{ username, ... }:
{
  programs.nushell = {
    enable = true;

    settings = {
      show_banner = false;
      edit_mode = "vi";

      completions = {
        case_sensitive = false;
        quick = true;
        partial = true;
        algorithm = "fuzzy";
      };

      history = {
        file_format = "sqlite";
        max_size = 1000000;
        sync_on_enter = true;
        isolation = false;
      };

      cursor_shape = {
        emacs = "line";
        vi_insert = "line";
        vi_normal = "block";
      };
    };

    environmentVariables = {
      EDITOR = "vim";
    };

    extraEnv = ''
      $env.PATH = ($env.PATH | split row (char esep)
        | prepend "/opt/homebrew/bin"
        | prepend "/run/current-system/sw/bin"
        | prepend "/etc/profiles/per-user/${username}/bin"
        | uniq
      )
    '';

    extraConfig = ''
      $env.config.hooks.display_output = {||
        if (term size).columns >= 100 { table -ed 1 } else { table }
      }
    '';
  };
}
