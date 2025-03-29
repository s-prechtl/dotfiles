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
    temurin-bin-17
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

    instances = {
      # The name will be used for the state folder and system user.
      # In this case, the folder is `/var/lib/mc-aged`
      # and the user `mc-aged`.
      aged = {
        enable = true;
        jvmMaxAllocation = "12G";
        jvmInitialAllocation = "2G";
        jvmPackage = pkgs.temurin-bin-17;
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

        rsyncSSHKeys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDBQtMQF6NpN/tPS01LRAI1yIzfTj+tNQi+TsG7+dRSsTxxv4eXJ1EQ1HV5vSAYlCwt0FjlK2ejXUqXzGzZBdd2usPBYPHiE3n2ZfQ3bCPJVa17M/ZIgX2PB/CcewQSVMZmlNu2SoocGaOBSQ9CaGQYe8Cj2nrZxF6ArPEm7FcFTvV+nJa//nEXccM2gexEyuuPm/ESMbCB/sffz8xgeDpCgG97Hb8JDcEtw5n17ZzR0eSJlSGQ2Sv8rM0ymO9GwHIJgnvPBxLV1TTotAy8E2kQF84Z9/tPkrI2T30EPvOxCtbIHR/8ZCbasTWfyoM2+Gum63soxAdcvjbRbiQEwpO2KiEYl4Zu3n0FJqqJGnC3yVpK7zZfEw7djeX8PJOjt5xzyhTGyjkLREuO/1IwLN0vCdC9irjCWrdoPTDnYLPN4aYEbH19Ff1UiVFB/jAsIwKsMFJ66/EawrJ1MLcdhSbZv0wZgG4DByeBz148Ev7uidT7orpaqf/dCCYpHc8Kfys= sprechtl@sprechtl-Laptop"
        ];

        serverConfig = {
          server-port = 25565;
          rcon-port = 25566;
          motd = "SIB24 Aged Server";
          white-list = true;
          spawn-protection = 0;
          max-tick-time = 5 * 60 * 1000;
          allow-flight = true;
        };
      };
    };
  };

  system.stateVersion = "24.11";
}
