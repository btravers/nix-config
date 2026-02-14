{ ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Benoit TRAVERS";
        email = "benoit.travers.fr@gmail.com";
      };
      core.editor = "vim";
      init.defaultBranch = "main";
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
      alias = {
        co = "checkout";
        br = "branch";
        st = "status";
        lg = "log --oneline --graph --decorate --all";
      };
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      side-by-side = true;
    };
  };

  programs.lazygit.enable = true;
}
