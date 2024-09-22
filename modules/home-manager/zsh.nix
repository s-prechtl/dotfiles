{...}: {
  programs.eza.enable = true;
  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "exa --icons -l";
      l = "exa --icons -la";
      ls = "exa --icons";
      update = "sudo nixos-rebuild switch";
      clear = "clear && fastfetch";
    };
    initExtra = "fastfetch";

    history.size = 10000;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = ["git" "docker"];
      theme = "strug";
    };
  };
}
