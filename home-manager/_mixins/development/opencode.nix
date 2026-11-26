{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = [ pkgs.opencode ];

  xdg.configFile."opencode/opencode.jsonc".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/config.json";
    mcp = lib.mapAttrs (_: s: {
      type = "local";
      command = [ s.command ] ++ s.args;
    }) config.programs.mcp.servers;
  };
}
