{pkgs, ...}: {
  imports = [
    ./hyprpaper.nix
    ./hypridle.nix
    ./hyprlock.nix
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
          "$mod SHIFT, E, exit"
          "$mod, Q, killactive"
          "$mod, B, exec, brave"
          "SUPERCTRLALTSHIFT, L, exec, brave https://linkedin.com"
          "$mod, return, exec, alacritty"
          "$mod,E,exec,nautilus"
          "$mod,D,exec,killall -q rofi; rofi -show drun -p 'Search...' | xargs -I{} xdg-open https://duckduckgo.com/?q={}"
          "$mod,Period,exec,killall -q rofi; rofi -show emoji"
          "$mod, P,exec,rofi-pass"
          "$mod SHIFT,R,exec,hyprctl reload"
          "$mod,space,togglefloating,"
          "ALTSHIFT, L, exec, hyprlock"
          "$mod,F,fullscreen"
          "ALTSHIFT,K,exec,amixer set 'Master' 5%+"
          "ALTSHIFT,J,exec,amixer set 'Master' 5%-"
          "$mod, M, exec,hyprctl keyword monitor 'eDP-1, enable'"
          "$mod SHIFT, M, exec,hyprctl keyword monitor 'eDP-1, disable'"
          "$mod SHIFT,P,exec,hyprshot -z -m region -o ~/Screenshot"
          "$mod ALTSHIFT, P, exec, hyprshot -z -m window -o ~/Screenshot"
          "$mod SHIFT, N, exec, dunstctl history-pop"
          "$mod ALTSHIFT, N, exec, dunstctl close-all"
          "$mod,left,movefocus,l"
          "$mod, H,movefocus,l"
          "$mod ALT, left, movewindow, l"
          "$mod ALT, H, movewindow, l"
          "$mod,right,movefocus,r"
          "$mod, L,movefocus,r"
          "$mod ALT, right, movewindow, r"
          "$mod ALT, L, movewindow, r"
          "$mod,up,movefocus,u"
          "$mod, K,movefocus,u"
          "$mod ALT, up, movewindow, u"
          "$mod ALT, K, movewindow, u"
          "$mod,down,movefocus,d"
          "$mod, J,movefocus,d"
          "$mod ALT, down, movewindow, d"
          "$mod ALT, J, movewindow, d"
          "$mod, 0, workspace, 10"
          "$mod SHIFT, 0, movetoworkspace, 10"
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
        "$mod SHIFT,right,resizeactive, 10 0"
        "$mod SHIFT,L,resizeactive, 10 0"
        "$mod SHIFT,down,resizeactive, 0 10"
        "$mod SHIFT,J,resizeactive, 0 10"
        "$mod SHIFT,left,resizeactive, -10 0"
        "$mod SHIFT,H,resizeactive, -10 0"
        "$mod SHIFT,up,resizeactive, 0 -10"
        "$mod SHIFT,K,resizeactive, 0 -10"
      ];

      # MONITOR

      monitor = [
        "eDP-1,2560x1600@165.0,0x0,1.6"
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

      dwindle = {
        force_split = 2;
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
          "workspaces,1,5,overshot,slide"
        ];
      };

      misc = {
        allow_session_lock_restore = true;
        focus_on_activate = true;
      };

      # EXEC ONCE
      exec-once = [
        "waybar"
        "nm-applet"
        "whatpulse"
      ];

      # WINDOW RULES
      windowrule = [
        "move 400 400, float, title:(jetbrains toolbox)"
        "opacity 1 override,title:^(.*)(Brave)(.*)$"
      ];
    };
  };
  # Optional, hint Electron apps to use Wayland:
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    GDK_BACKEND = "wayland,x11,*";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
    QT_AUTO_SCREEN_SCALE_FACTOR = 1;
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
  };
}
