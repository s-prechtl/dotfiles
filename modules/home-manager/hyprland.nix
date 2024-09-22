{...}: {
  imports = [
    ./hyprlock.nix
    ./hyprpaper.nix
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    settings = {
      # BINDS
      "$mod" = "SUPER";
      bind =
        [
          "SUPERSHIFT, E, exit"
          "$mod, Q, killactive"
          "$mod, B, exec, brave"
          "$mod, return, exec, alacritty"
          "$mod,E,exec,nautilus"
          "$mod,D,exec,killall -q wofi; wofi --show drun -I"
          "$mod, P,exec,wofi-pass -c"
          "SUPERSHIFT,R,exec,hyprctl reload"
          "$mod,space,togglefloating,"
          "ALTSHIFT, L, exec, swaylock"
          "$mod,F,fullscreen"
          "ALTSHIFT,K,exec,amixer set 'Master' 5%+"
          "ALTSHIFT,J,exec,amixer set 'Master' 5%-"
          "SUPERSHIFT,N,exec, swaync-client -t -sw"
          "$mod, M, exec,hyprctl keyword monitor 'eDP-1, enable'"
          "SUPERSHIFT, M, exec,hyprctl keyword monitor 'eDP-1, disable'"
          "SUPERSHIFT,P,exec,hyprshot -m region -o ~/Screenshot/"
          "SUPERALTSHIFT, P, exec, hyprshot -m window -o ~/Screenshot/"

          "$mod,left,movefocus,l"
          "$mod, H,movefocus,l"
          "SUPERALT, left, movewindow, l"
          "SUPERALT, H, movewindow, l"
          "$mod,right,movefocus,r"
          "$mod, L,movefocus,r"
          "SUPERALT, right, movewindow, r"
          "SUPERALT, L, movewindow, r"
          "$mod,up,movefocus,u"
          "$mod, K,movefocus,u"
          "SUPERALT, up, movewindow, u"
          "SUPERALT, K, movewindow, u"
          "$mod,down,movefocus,d"
          "$mod, J,movefocus,d"
          "SUPERALT, down, movewindow, d"
          "SUPERALT, J, movewindow, d"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (builtins.genList (
              i: let
                ws = i + 1;
              in [
                "$mod, code:1${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            )
            9)
        );

      bindm = [
        "$mod, mouse:272,movewindow"
        "$mod, mouse:273,resizewindow"
      ];
      binde = [
        ",XF86MonBrightnessDown,exec,brightnessctl --device=intel_backlight s 5%-"
        ",XF86MonBrightnessUp,exec,brightnessctl --device=intel_backlight s 5%+"
        "SUPERSHIFT,right,resizeactive, 10 0"
        "SUPERSHIFT,L,resizeactive, 10 0"
        "SUPERSHIFT,down,resizeactive, 0 10"
        "SUPERSHIFT,J,resizeactive, 0 10"
        "SUPERSHIFT,left,resizeactive, -10 0"
        "SUPERSHIFT,H,resizeactive, -10 0"
        "SUPERSHIFT,up,resizeactive, 0 -10"
        "SUPERSHIFT,K,resizeactive, 0 -10"
      ];

      # MONITOR

      monitor = [
        "eDP-1,2560x1600@165.0,0x0,2"
        "DP-1,preferred,auto-right,2,bitdepth,10"
        "DP-2,preferred,auto-right,2,bitdepth,10"
        "DP-3,preferred,auto-right,2,bitdepth,10"
        ", preferred, auto,1"
      ];

      # INPUT

      input = {
        kb_layout = "us";
        kb_options = "compose:ralt,caps:escape";
        follow_mouse = 2;

        touchpad = {
          natural_scroll = "yes";
        };

        sensitivity = 0.0; # -1.0 - 1.0, 0 means no modification.
      };

      # GENERAL
      general = {
        gaps_in = 10;
        gaps_out = 20;

        border_size = 2;
        "col.active_border" = "0xffBF616A";
        "col.inactive_border" = "0xffebdbb2";
      };

      # CURSOR
      cursor = {
        no_warps = true;
        inactive_timeout = 3;
      };

      # DECORATION
      decoration = {
        active_opacity = 0.95;
        inactive_opacity = 0.95;
        rounding = 10;
      };

      # ANIMATION
      animations = {
        enabled = 1;
        bezier = "overshot,0.13,0.99,0.29,1.1";
        animation = [
          "windows,1,4,overshot,slide"
          "border,1,10,default"
          "fade,1,10,default"
          "workspaces,1,6,overshot,slide"
        ];
      };

      # EXEC ONCE
      exec-once = [
        "waybar"
        "nm-applet"
        "dunst"
        "whatpulse"
      ];

      # WINDOW RULES
      windowrule = [
        "move 400 400, float, title:(jetbrains toolbox)"
        "float,wofi"
        "opacity 1 override,title:^(.*)(Brave)(.*)$"
      ];
    };
  };
  # Optional, hint Electron apps to use Wayland:
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
}
