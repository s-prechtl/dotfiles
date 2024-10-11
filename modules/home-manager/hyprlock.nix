{...}: {
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 5;
        hide_cursor = true;
        no_fade_in = false;
      };

      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      shape = [
        {
          monitor = "";
          size = "360, 360";
          color = "rgb(40, 40, 40)";
          rounding = -1;
          border_size = 8;
          border_color = "rgb(235, 219, 178)";
          rotate = 0;

          position = "0, 0";
          halign = "center";
          valign = "center";
        }
      ];

      label = [
        {
          monitor = "";
          text = "cmd[update:1000] echo \"<span>$(date +\"%H:%M:%S\")</span>\"";
          text_align = "center";
          color = "rgb(235, 219, 178)";
          font_size = 25;
          font_family = "JetBrainsMono Nerd Font Mono";

          position = "0, 0";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
