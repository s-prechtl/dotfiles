{...}: {
  home.file.".config/oh-my-zsh/themes/custom.zsh-theme".text = ''
    # OhMyZsh Strug Theme but with nix-shell support
    # Yoinked by d-hain

    export CLICOLOR=1
    export LSCOLORS=dxFxCxDxBxegedabagacad

    function in_nix_shell() {
        if [ ! -z ''${IN_NIX_SHELL+x} ]; then
            if [ -e ./.envrc ] && [ ! -d ./.envrc ]; then
                local first_line=$(head -n 1 ./.envrc)

                if [ $first_line = "use flake" ]; then
                    echo -n " dev";
                else
                    echo -n " shell";
                fi
            else
                echo -n " shell";
            fi
        fi
    }

    function in_venv() {
        if [ ! -z ''${VIRTUAL_ENV+x} ]; then
            echo -n " venv";
        fi
    }

    function get_status() {
        local nix_shell=$(in_nix_shell)
        local venv=$(in_venv)

        if [ ! -z ''${nix_shell} ]; then
            echo -n " %{$fg[blue]%}''${nix_shell}%{$reset_color%}"
        fi
        if [ ! -z ''${venv} ]; then
            echo -n " %{$fg[magenta]%}''${venv}%{$reset_color%}"
        fi
    }

    local git_branch='$(git_prompt_info)%{$reset_color%}$(git_remote_status)'
    local curr_status='$(get_status)'
    VIRTUAL_ENV_DISABLE_PROMPT=1

    PROMPT="%{$fg[green]%}╭─%n@%m%{$reset_color%}''${curr_status} %{$fg[yellow]%}in %~ %{$reset_color%}''${git_branch}
    %{$fg[green]%}╰\$ %{$reset_color%}"

    ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[yellow]%}on "
    ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"

    ZSH_THEME_GIT_PROMPT_DIRTY="%{$reset_color%}%{$fg[red]%} ✘ %{$reset_color%}"
    ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%} ✔ %{$reset_color%}"

    ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_DETAILED=true
    ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_PREFIX="%{$fg[yellow]%}("
    ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_SUFFIX="%{$fg[yellow]%})%{$reset_color%}"

    ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE=" +"
    ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE_COLOR=%{$fg[green]%}

    ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE=" -"
    ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE_COLOR=%{$fg[red]%}
  '';
  programs.eza.enable = true;
  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "exa --icons -l";
      l = "exa --icons -la";
      ls = "exa --icons";
      update = "sudo nixos-rebuild switch";
      clear = "clear && fastfetch";
      sl = "sl | lolcat";
      cds = "cd \"$HOME/Nextcloud/Obsidian/FH/2. Semester/\"";
      mux = "tmuxinator";
      cat = "bat";
      cd = "z";
    };
    initContent = ''
      bindkey -s ^f "mux-sessionizer\n"

      fastfetch
      eval "$(zoxide init zsh)"
      eval "$(direnv hook zsh)"
    '';

    history = {
      size = 10000;
      append = true;
    };
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "aliases"
        "bgnotify"
        "colored-man-pages"
        "colorize"
        "command-not-found"
        "docker"
        "docker-compose"
        "gh"
        "git"
        "git-auto-fetch"
        "golang"
        "pass"
        "safe-paste"
        "tmuxinator"
      ];
      theme = "custom";
      custom = "$HOME/.config/oh-my-zsh";
    };
  };
}
