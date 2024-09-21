{
  pkgs, ...
}: {
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    disableConfirmationPrompt = true;
    newSession = true;
    mouse = true;
    secureSocket = true;
    shell = "${pkgs.zsh}/bin/zsh";
    shortcut = "a";
    terminal = "screen-256color";
    plugins = with pkgs.tmuxPlugins; [
      gruvbox
      sensible
      vim-tmux-navigator
      {
        plugin = resurrect;
        extraConfig = "set -g @ressurect-strategy-nvim 'session'";
      }
    ];
    extraConfig = ''
        set -as terminal-features ",xterm-256color:RGB"
      '';

  };
}
