{...}: {
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "off";
      splash = false;
      preload = "~/dotfiles/background.png";
      wallpaper = ",~/dotfiles/background.png";
    };
  };
}
