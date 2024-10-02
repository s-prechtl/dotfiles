{...}: {
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 0;
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

      input-field = [
        {
          size = "200, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(235, 219, 178)";
          inner_color = "rgb(40, 40, 40)";
          outer_color = "rgb(235, 219, 178)";
          check_color = "rgb(191, 97, 106)";
          outline_thickness = 5;
          placeholder_text = "<span foreground='##cad3f5'>Password...</span>";
          shadow_passes = 2;
        }
      ];
    };
  };
}
