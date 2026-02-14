{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;

    defaultKeymap = "viins";
    autocd = true;

    autosuggestion = {
      enable = true;
      strategy = [
        "history"
        "completion"
      ];
    };

    syntaxHighlighting = {
      enable = true;
      highlighters = [
        "main"
        "brackets"
        "pattern"
        "cursor"
      ];
    };

    history = {
      size = 1000000;
      save = 1000000;
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      extended = true;
      share = true;
    };

    plugins = [
      {
        name = "zsh-autopair";
        src = pkgs.zsh-autopair;
        file = "share/zsh/zsh-autopair/autopair.zsh";
      }
    ];

    initContent = ''
      # ── Shell Options ──────────────────────────────────
      setopt NO_CLOBBER
      setopt NO_BEEP
      setopt HIST_REDUCE_BLANKS
      setopt HIST_VERIFY
      setopt INC_APPEND_HISTORY
      setopt EXTENDED_GLOB
      setopt GLOB_DOTS
      setopt NUMERIC_GLOB_SORT
      setopt AUTO_PUSHD
      setopt PUSHD_IGNORE_DUPS
      setopt PUSHD_SILENT
      setopt LONG_LIST_JOBS
      setopt INTERACTIVE_COMMENTS
      setopt CORRECT
      setopt COMPLETE_IN_WORD
      setopt ALWAYS_TO_END

      REPORTTIME=5
      KEYTIMEOUT=10

      # ── Vi Mode Cursor Shape ───────────────────────────
      function zle-keymap-select {
        case $KEYMAP in
          vicmd)      print -n -- "\e[2 q" ;;
          viins|main) print -n -- "\e[6 q" ;;
        esac
      }
      zle -N zle-keymap-select
      function zle-line-init {
        print -n -- "\e[6 q"
      }
      zle -N zle-line-init

      # ── Edit command in $EDITOR ────────────────────────
      autoload -Uz edit-command-line
      zle -N edit-command-line
      bindkey -M vicmd 'v' edit-command-line

      # ── Keybindings ────────────────────────────────────
      bindkey '^Z' undo
      bindkey '^Y' redo
      bindkey '^Q' push-line-or-edit
      bindkey ' ' magic-space

      # ── Sudo Widget (Esc Esc) ──────────────────────────
      function prepend-sudo {
        if [[ $BUFFER != "sudo "* ]]; then
          BUFFER="sudo $BUFFER"
          CURSOR+=5
        fi
      }
      zle -N prepend-sudo
      bindkey -M vicmd '\e\e' prepend-sudo
      bindkey -M viins '\e\e' prepend-sudo

      # ── Completion zstyles ─────────────────────────────
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
      zstyle ':completion:*' menu select
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
      zstyle ':completion:*' group-name '''
      zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'

      # ── fzf-tab (fuzzy completion UI) ──────────────────
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
      zstyle ':fzf-tab:complete:(cat|bat|less|head|tail|vim|nvim):*' fzf-preview 'bat --color=always --style=numbers --line-range=:500 $realpath 2>/dev/null || eza -1 --color=always $realpath'
      zstyle ':fzf-tab:*' switch-group '<' '>'

      # ── Startup ────────────────────────────────────────
      ${pkgs.fastfetch}/bin/fastfetch
    '';
  };
}
