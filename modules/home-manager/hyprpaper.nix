{
  config,
  pkgs,
  ...
}: {
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = "/home/sprechtl/dotfiles/background.png";
      wallpaper = "/home/sprechtl/dotfiles/background.png";
    };
  };
}
