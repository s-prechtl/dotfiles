{
  config,
  pkgs,
  ...
}: {
  services.xserver.videoDrivers = ["modesetting"];
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # Enable Hardware Acceleration
    ];
  };
  environment.sessionVariables = {LIBVA_DRIVER_NAME = "iHD";};
}
