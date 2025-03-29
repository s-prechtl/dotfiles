{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) concatStringsSep;
in {
  imports = [
    ./hardware-configuration.nix
    inputs.mms.module
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "hitsugibune";
  time.timeZone = "Europe/Vienna";

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
  ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "prohibit-password";
    };
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  services.modded-minecraft-servers = {
    # This is mandatory, sorry.
    eula = true;

    # The name will be used for the state folder and system user.
    # In this case, the folder is `/var/lib/mc-aged`
    # and the user `mc-aged`.
    aged = {
      enable = true;
      jvmMaxAllocation = "12G";
      jvmInitialAllocation = "2G";
      jvmOpts = concatStringsSep " " [
        "-XX:+UseG1GC"
        "-XX:+ParallelRefProcEnabled"
        "-XX:MaxGCPauseMillis=200"
        "-XX:+UnlockExperimentalVMOptions"
        "-XX:+DisableExplicitGC"
        "-XX:+AlwaysPreTouch"
        "-XX:G1NewSizePercent=40"
        "-XX:G1MaxNewSizePercent=50"
        "-XX:G1HeapRegionSize=16M"
        "-XX:G1ReservePercent=15"
        "-XX:G1HeapWastePercent=5"
        "-XX:G1MixedGCCountTarget=4"
        "-XX:InitiatingHeapOccupancyPercent=20"
        "-XX:G1MixedGCLiveThresholdPercent=90"
        "-XX:G1RSetUpdatingPauseTimePercent=5"
        "-XX:SurvivorRatio=32"
        "-XX:+PerfDisableSharedMem"
        "-XX:MaxTenuringThreshold=1"
      ];

      serverConfig = {
        server-port = 25566;
        motd = "SIB24 Aged Server";
        white-list = true;
        spawn-protection = 0;
        max-tick-time = 5 * 60 * 1000;
        allow-flight = true;
      };
    };
  };

  system.stateVersion = "24.11";
}
