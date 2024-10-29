{...}: {
  services.dunst = {
    enable = true;
    settings = {
      global = {
        frame_width = "2";
        frame_color = "#ebdbb2";
        background = "#282828";
        foreground = "#ebdbb2";
        offset = "30x30";
        corner_radius = 10;
        icon_corner_radius = 5;
        gap_size = 5;
        font = "JetBrainsMono Nerd Font Mono 10";
      };

      urgency_critical = {
        frame_color = "#BF616A";
      };
    };
  };
}
