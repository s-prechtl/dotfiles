{...}: {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        # height = 36; # Auto height by default
        modules-left = [
          "clock#time"
          "custom/arrow1"
          "clock#date"
          "custom/arrow2"
          "hyprland/workspaces"
          "custom/arrow3"
        ];
        modules-center = [
          "custom/arrow4"
          "hyprland/window"
          "custom/arrow5"
        ];
        modules-right = [
          "custom/arrow6"
          "battery"
          "custom/arrow7"
          "network"
          "bluetooth"
          "custom/arrow8"
          "pulseaudio"
          "custom/kdeconnect"
          "tray"
        ];

        # Module configurations
        "hyprland/window" = {
          format = "{}";
        };

        "keyboard-state" = {
          numlock = true;
          capslock = true;
          format = {
            numlock = "N {icon}";
            capslock = "C {icon}";
          };
          format-icons = {
            locked = "";
            unlocked = "";
          };
        };

        battery = {
          states = {
            good = 95;
            warning = 30;
            critical = 20;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-alt = "{time} {icon}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
          ];
        };

        bluetooth = {
          format = " {status}";
          format-disabled = "";
          format-connected = " {num_connections} connected";
          tooltip-format = "{controller_alias}\t{controller_address}";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
          tooltip = true;
        };

        tray = {
          spacing = 4;
        };

        "clock#time" = {
          interval = 10;
          format = "  {:%H:%M}";
          tooltip = false;
        };

        "clock#date" = {
          interval = 20;
          format = " {:%a %e/%m}";
          on-click = "gnome-calendar";
        };

        temperature = {
          interval = 1;
          hwmon-path = "/sys/class/hwmon/hwmon3/temp1_input";
          critical-threshold = 75;
          format-critical = "  {temperatureC}°C";
          format = "{icon}  {temperatureC}°C";
          format-icons = [
            ""
            ""
            ""
          ];
          max-length = 8;
          min-length = 7;
          tooltip = false;
        };

        cpu = {
          interval = 5;
          format = "  {max_frequency:1}GHz  􏏴  {usage:2}%";
          on-click = "kitty -e htop --sort-key PERCENT_CPU";
          tooltip = false;
        };

        "custom/gpu" = {
          exec = "$HOME/.config/waybar/custom_modules/custom-gpu-lite.sh";
          return-type = "json";
          format = "{}";
          interval = 5;
          tooltip = "{tooltip}";
          on-click = "powerupp";
        };

        network = {
          format-wifi = "<span color=\"#ebdbb2\"></span>  {essid}";
          format-ethernet = "{ifname}: {ipaddr}/{cidr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
          family = "ipv4";
          tooltip-format-wifi = "  {ifname} @ {essid}\nIP: {ipaddr}\nStrength: {signalStrength}%\nFreq: {frequency}MHz\n {bandwidthUpBits}  {bandwidthDownBits}";
          tooltip-format-ethernet = " {ifname}\nIP: {ipaddr}\n {bandwidthUpBits}  {bandwidthDownBits}";
        };

        "custom/kdeconnect" = {
          exec = "$HOME/.config/waybar/custom_modules/custom-kdeconnect.sh battery";
          format = "{}";
          interval = 60;
          on-click = "$HOME/.config/waybar/custom_modules/custom-kdeconnect.sh ring";
        };

        pulseaudio = {
          scroll-step = 3;
          format = "{icon} {volume:2}% {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "";
          format-source-muted = "<span color=\"#fb4833\"></span>";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "pavucontrol";
          on-click-right = "pactl set-source-mute @DEFAULT_SOURCE@ toggle";
        };

        "custom/pacman" = {
          format = "<u>↓</u> {}";
          interval = 3600;
          exec = "yay -Qu | wc -l";
          exec-if = "exit 0";
          on-click = "alacritty -e 'yay'; pkill -SIGRTMIN+8 waybar";
          signal = 8;
          max-length = 5;
          min-length = 3;
        };

        "custom/weather" = {
          exec = "curl 'https://wttr.in/?format=1'";
          interval = 3600;
        };

        "custom/cpugovernor" = {
          format = "{icon}";
          interval = "once";
          return-type = "json";
          exec = "$HOME/.config/waybar/custom_modules/cpugovernor.sh";
          min-length = 2;
          max-length = 3;
          signal = 8;
          format-icons = {
            perf = "";
            ondemand = "";
          };
          on-click = "$HOME/.config/waybar/custom_modules/cpugovernor.sh switch";
        };

        "custom/playerctl" = {
          exec = "$HOME/.config/waybar/custom_modules/media-player-status.py";
          return-type = "json";
          on-click = "playerctl play-pause";
        };

        "custom/media" = {
          format = "{icon} {}";
          return-type = "json";
          max-length = 40;
          format-icons = {
            spotify = "";
            default = "🎜";
          };
          escape = false;
          exec = "$HOME/.config/waybar/custom_modules/mediaplayer.py 2> /dev/null";
        };

        "custom/scratchpad-indicator" = {
          interval = 3;
          return-type = "json";
          exec = "swaymsg -t get_tree | jq --unbuffered --compact-output '( select(.name == \"root\") | .nodes[] | select(.name == \"__i3\") | .nodes[] | select(.name == \"__i3_scratch\") | .focus) as $scratch_ids | [..  | (.nodes? + .floating_nodes?) // empty | .[] | select(.id |IN($scratch_ids[]))] as $scratch_nodes | { text: \"\\($scratch_nodes | length)\", tooltip: $scratch_nodes | map(\"\\(.app_id // .window_properties.class) (\\(.id)): \\(.name)\") | join(\"\\n\") }'";
          format = "{} 􏠜";
          on-click = "exec swaymsg 'scratchpad show'";
          on-click-right = "exec swaymsg 'move scratchpad'";
        };

        "custom/arrow1" = {
          format = "";
          tooltip = false;
        };

        "custom/arrow2" = {
          format = "";
          tooltip = false;
        };

        "custom/arrow3" = {
          format = "";
          tooltip = false;
        };

        "custom/arrow4" = {
          format = "";
          tooltip = false;
        };

        "custom/arrow5" = {
          format = "";
          tooltip = false;
        };

        "custom/arrow6" = {
          format = "";
          tooltip = false;
        };

        "custom/arrow7" = {
          format = "";
          tooltip = false;
        };

        "custom/arrow8" = {
          format = "";
          tooltip = false;
        };

        "custom/arrow9" = {
          format = "";
          tooltip = false;
        };

        "custom/arrow10" = {
          format = "";
          tooltip = false;
        };
      };
    };

    style = ''
      @keyframes blink-warning {
          70% {
      	color: @light;
          }

          to {
      	color: @light;
      	background-color: @warning;
          }
      }

      @keyframes blink-critical {
          70% {
            color: @light;
          }

          to {
      	color: @light;
      	background-color: @critical;
          }
      }


      /* -----------------------------------------------------------------------------
       * Styles
       * -------------------------------------------------------------------------- */

      /* COLORS */

      /* Gruvbox Dark */

      /*@define-color bg #353C4A;*/
      @define-color light #D8DEE9;
      /*@define-color dark @nord_dark_font;*/
      @define-color warning #ebcb8b;
      /*@define-color critical #BF616A;*/
      /*@define-color mode @bg;*/
      /*@define-color workspaces @bg;*/
      /*@define-color workspaces @nord_dark_font;*/
      /*@define-color workspacesfocused #655b53;*/
      /*@define-color tray @bg;*/
      /*@define-color workspacesfocused #4C566A;
      @define-color tray @workspacesfocused;
      @define-color sound #EBCB8B;
      @define-color network #5D7096;
      @define-color memory #546484;
      @define-color cpu #596A8D;
      @define-color temp #4D5C78;
      @define-color layout #5e81ac;
      @define-color battery #88c0d0;
      @define-color date #434C5E;
      @define-color time #434C5E;
      @define-color backlight #434C5E;*/
      @define-color nord_bg #282828;
      @define-color nord_bg_blue @bg;
      @define-color nord_light #D8DEE9;

      @define-color nord_dark_font #272727;


      @define-color bg #282828;
      @define-color critical #BF616A;
      @define-color tray @bg;
      @define-color mode @bg;

      @define-color bluetint #448488;
      @define-color bluelight #83a597;
      @define-color magenta-dark #b16185;


      @define-color font_gruv_normal #ebdbb2;
      @define-color font_gruv_faded #a89985;
      @define-color font_gruv_darker #D8DEE9;
      @define-color font_dark_alternative #655b53;

      /* Reset all styles */
      * {
          border: none;
          border-radius: 0px;
          min-height: 0;
          /*margin: 0.15em 0.25em 0.15em 0.25em;*/
      }

      /* The whole bar */
      #waybar {
          background: @bg;
          color: @light;
          font-family: JetBrainsMono Nerd Font Mono;
          font-size: 9pt;
          font-weight: bold;
      }

      /* Each module */
      #battery,
      #clock,
      #cpu,
      #custom-layout,
      #memory,
      #mode,
      #network,
      #pulseaudio,
      #temperature,
      #custom-alsa,
      #custom-pacman,
      #custom-weather,
      #custom-gpu,
      #custom-playerctl,
      #tray,
      #backlight,
      #language,
      #custom-cpugovernor,
      #battery,
      #custom-scratchpad-indicator,
      #custom-pacman,
      #idle_inhibitor,
      #bluetooth {
      /*    padding-left: 0.3em;
          padding-right: 0.3em;*/
          padding: 0.6em 0.8em;
      }

      /* Each module that should blink */
      #mode,
      #memory,
      #temperature,
      #battery {
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }

      /* Each critical module */
      #memory.critical,
      #cpu.critical,
      #temperature.critical,
      #battery.critical {
          color: @critical;
      }

      /* Each critical that should blink */
      #mode,
      #memory.critical,
      #temperature.critical,
      #battery.critical.discharging {
          animation-name: blink-critical;
          animation-duration: 2s;
      }

      /* Each warning */
      #network.disconnected,
      #memory.warning,
      #cpu.warning,
      #temperature.warning,
      #battery.warning {
          background: @warning;
          color: @nord_dark_font;
      }

      /* Each warning that should blink */
      #battery.warning.discharging {
          animation-name: blink-warning;
          animation-duration: 3s;
      }

      /* Adding arrows to boxes */
      /*#custom-arrow1 {
          font-size: 16px;
          color: @sound;
          background: transparent;
      }

      #custom-arrow2 {
          font-size: 16px;
          color: @network;
          background: @sound;
      }

      #custom-arrow3 {
          font-size: 16px;
          color: @memory;
          background: @network;
      }

      #custom-arrow4 {
          font-size: 16px;
          color: @cpu;
          background: @memory;
      }

      #custom-arrow5 {
          font-size: 16px;
          color: @temp;
          background: @cpu;
      }

      #custom-arrow6 {
          font-size: 16px;
          color: @layout;
          background: @temp;
      }

      #custom-arrow7 {
          font-size: 16px;
          color: @battery;
          background: @layout;
      }

      #custom-arrow8 {
          font-size: 16px;
          color: @date;
          background: @battery;
      }

      #custom-arrow9 {
          font-size: 16px;
          color: @time;
          background: @date;
      }*/

      #custom-arrow1 {
          font-size: 2em;
          color: @bg;
          background: @bluetint;
      }
      #custom-arrow2 {
          font-size: 2em;
          color: @bluetint;
          background: @font_dark_alternative;
      }
      #custom-arrow3 {
          font-size: 2em;
          color: @font_dark_alternative;
          background: @bg;
      }
      #custom-arrow4 {
          font-size: 2em;
          color: @font_gruv_normal;
          background: @bg;
      }
      #custom-arrow5 {
          font-size: 2em;
          color: @font_gruv_normal;
          background: @bg;
      }
      #custom-arrow6 {
          font-size: 2em;
          color: @font_dark_alternative;
          background: @bg;
      }
      #custom-arrow7 {
          font-size: 2em;
          color: @bluetint;
          background: @font_dark_alternative;
      }
      #custom-arrow8 {
          font-size: 2em;
          color: @bg;
          background: @bluetint;
      }

      /* And now modules themselves in their respective order */
      #clock.time {
          background: @bg;
          color: @font_gruv_normal;
      }
      #clock.date {
          background: @bluetint;
          color: @font_gruv_normal;
      }

      #custom-scratchpad-indicator {
          background: @bluetint;
          color: @font_gruv_normal;
      }
      #language {
          background: @bg;
          color: @font_gruv_normal;
      }
      #custom-kdeconnect {
          background: @bg;
          color: @font_gruv_normal;
      }
      #custom-pacman {
          background: @bluetint;
          color: @font_gruv_normal;
      }
      #idle_inhibitor {
          background: @font_dark_alternative;
          color: @font_gruv_normal;
      }
      #custom-playerctl {
          font-size: 0.9em;
          color: @font_gruv_normal;
      }
      #custom-playerctl.paused{
          color: @font_dark_alternative;
          font-size: 0.9em;
      }
      /* Workspaces stuff */
      #workspaces {
      }
      #workspaces button {
          background: @font_dark_alternative;
          color: @font_gruv_normal;
          padding: 0em 1.2em;
          min-width: 0em;
      }
      #workspaces button.focused {
          font-weight: bolder; /* Somewhy the bar-wide setting is ignored*/
      }
      #workspaces button.urgent {
          color: #c9545d;
          opacity: 1;
      }
      #battery {
          color: @font_gruv_normal;
          background: @font_dark_alternative;
      }
      #custom-cpugovernor.perf {

      }
      #cpu {
          background: @bluetint;
          color: @font_gruv_normal;
          padding-left: 0em;
          padding-right: 0.2em;
      }
      #cpu.critical {
          color: @nord_dark_font;
          background: @critical;
      }
      #temperature {
          background-color: @bluetint;
          color: @font_gruv_normal;
          padding-right: 0em;
      }
      #temperature.critical {
          background:  @critical;
      }
      #custom-gpu {
          background: @bluetint;
          color: @font_gruv_normal;
          padding-left: 0em;
      }
      #pulseaudio {
          background: @bg;
          color: @font_gruv_normal;
      }
      #pulseaudio.muted {
          color: #fb4833;
      }
      #pulseaudio.source-muted {
          /* moved to config */
      }
      #bluetooth {
          background: @bluetint;
          color: @font_gruv_normal;
      }
      #network {
          background: @bluetint;
          color: @font_gruv_normal;
      }
      #tray {
          background: @bg;
          color: @font_gruv_normal;
      }

      #custom-alsa {
          background: @sound;
      }
      #memory {
          background: @memory;
      }
      #custom-layout {
          background: @layout;
      }
      #mode { /* Shown current Sway mode (resize etc.) */
          color: @light;
          background: @mode;
      }

      #backlight {
          background: @backlight;
      }
      #window {
          padding: 0px 10px 0px 10px;
          font-weight: bold;
          font-size: 1em;
          color: @bg;
          background: @font_gruv_normal;
      }
      #custom-weather {
          background: @mode;
          font-weight: bold;
          padding: 0 0.6em;
      }
    '';
  };
}
