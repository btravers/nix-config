{ lib, pkgs, ... }:
{
  home.packages = [ pkgs.fnm ];

  programs.nushell = {
    extraEnv = ''
      ^fnm env --corepack-enabled --json | from json | load-env
      $env.PATH = ($env.PATH | prepend ($env.FNM_MULTISHELL_PATH | path join "bin"))
    '';
    extraConfig = ''
      $env.config.hooks.env_change.PWD = ($env.config.hooks.env_change? | default {} | get PWD? | default [] | append {|before, after|
        if ([.nvmrc .node-version package.json] | any {|it| ($after | path join $it | path exists)}) {
          ^fnm use --silent-if-unchanged
          ^fnm env --corepack-enabled --json | from json | load-env
          $env.PATH = ($env.PATH | prepend ($env.FNM_MULTISHELL_PATH | path join "bin"))
        }
      })
    '';
  };

  programs.zsh.initContent = lib.mkAfter ''
    eval "$(fnm env --corepack-enabled --use-on-cd --shell zsh)"
  '';
}
