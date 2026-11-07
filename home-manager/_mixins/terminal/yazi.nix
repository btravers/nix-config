{ ... }:
{
  programs.yazi = {
    enable = true;
    shellWrapperName = "yy"; # keep pre-26.05 default
  };
}
