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

      # Helpful aliases
      alias = {
        co = "checkout";
        br = "branch";
        st = "status";
        lg = "log --oneline --graph --decorate --all";
        # New: additional helpful aliases
        unstage = "reset HEAD --";
        last = "log -1 HEAD";
        visual = "log --oneline --graph --all --decorate";
        amend = "commit --amend --no-edit";
        contributors = "shortlog -sn";
      };

      # Workflow improvements
      pull.rebase = true; # Cleaner history
      fetch.prune = true; # Auto-cleanup deleted remote branches
      push.autoSetupRemote = true; # Auto-create remote branch on push
      rerere.enabled = true; # Remember merge conflict resolutions
      rebase.autoStash = true; # Auto-stash before rebase
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
