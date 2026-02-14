{ ... }:
{
  programs.atuin = {
    enable = true;
    enableNushellIntegration = true;
    settings = {
      style = "compact";
    };
  };
}
