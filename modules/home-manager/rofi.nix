{pkgs, ...}: {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    theme = "gruvbox-dark";
    font = "JetBrainsMono Nerd Font Mono";
    terminal = "${pkgs.alacritty}/bin/alacritty";
    pass = {
      enable = true;
      package = pkgs.rofi-pass-wayland;
      extraConfig = ''
        URL_field='url'
        USERNAME_field='user'
      '';
    };
    plugins = [
      pkgs.rofi-emoji-wayland
    ];
    extraConfig = {
      modi = "drun,emoji";
      show-icons = true;
    };
  };
}
