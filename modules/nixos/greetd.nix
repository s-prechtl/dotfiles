{
  pkgs,
  ...
}: {
  services.greetd = {
    enable = true;

    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-user-session --cmd Hyprland";
        user = "greeter";
      };
    };
  };
}
