{
  config,
  pkgs,
  lib,
  utils,
  ...
}: {
  services.greetd = {
    enable = true;
    vt = 2;

    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --remember-user-session --cmd Hyprland";
        user = "greeter";
      };
    };
  };
}
