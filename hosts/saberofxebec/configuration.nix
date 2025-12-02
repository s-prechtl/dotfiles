# Edit this configuration file to define what should be installed on your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  serverIP = "192.168.0.201";
  pkgs-unstable = inputs.nixpkgs.legacyPackages.${pkgs.system};
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./secrets.nix
    ./nvidia.nix
    ./intel.nix
    ./disk-spindown.nix
    ./homebridge.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "saberofxebec";
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  networking.firewall.allowedTCPPorts = [80 443];

  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  home-manager = {
    backupFileExtension = "backup";
    extraSpecialArgs = {inherit inputs;};
    users = {
      "root" = import ./home.nix;
    };
  };
  programs.zsh.enable = true;
  users.users.root.shell = pkgs.zsh;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bat
    btop
    fzf
    gcc
    git
    tmuxinator
    vt-cli
    wget
    zoxide
  ];

  users.groups.media = {};

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
    };
  };
  services.logind.lidSwitchExternalPower = "ignore";
  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';
  programs.neovim.enable = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  virtualisation.docker.enable = true;
  virtualisation.oci-containers = {
    backend = "docker";
    containers.pihole = {
      image = "pihole/pihole:latest";
      ports = [
        "${serverIP}:53:53/tcp"
        "${serverIP}:53:53/udp"
        "12345:80"
        "23456:443"
      ];
      volumes = [
        "/var/lib/pihole/:/etc/pihole/"
        "/var/lib/dnsmasq.d:/etc/dnsmasq.d/"
      ];
      environment = {
        ServerIP = serverIP;
      };
      extraOptions = [
        "--cap-add=NET_ADMIN"
        "--dns=127.0.0.1"
        "--dns=1.1.1.1"
      ];
      workdir = "/var/lib/pihole/";
    };
    containers.homarr = {
      image = "ghcr.io/homarr-labs/homarr:v1.36.1";
      ports = [
        "7575:7575"
      ];
      volumes = [
        "/var/lib/homarr/:/appdata"
        "/var/lib/caddy/.local/share/caddy/pki/authorities/local/root.crt:/usr/local/share/ca-certificates/root.crt:ro"
      ];
      extraOptions = [
        "--network"
        "host"
        "--dns=192.168.0.201"
      ];

      environmentFiles = [config.age.secrets.homarr.path];
    };

    containers.speedtest-tracker = {
      image = "lscr.io/linuxserver/speedtest-tracker:latest";
      ports = [
        "42069:80"
      ];
      environmentFiles = [config.age.secrets.speedtest-tracker.path];
      volumes = [
        "/var/lib/speedtest-tracker/:/config"
      ];
    };
  };

  services.radarr = {
    enable = true;
    openFirewall = true;
    dataDir = "/media/radarr/config";
    group = "media";
  };

  services.sonarr = {
    enable = true;
    openFirewall = true;
    dataDir = "/media/sonarr/config";
    group = "media";
  };

  services.readarr = {
    enable = true;
    openFirewall = true;
    dataDir = "/media/readarr/config";
    group = "media";
  };

  services.bazarr = {
    enable = true;
    openFirewall = true;
    group = "media";
  };

  services.qbittorrent = {
    enable = true;
    openFirewall = true;
    group = "media";
    profileDir = "/media/qbittorrent";

    serverConfig = {
      LegalNotice.Accepted = true;
      General.Locale = "en";
      Preferences = {
        WebUI = {
          Username = "Spr3eZ";
          Password_PBKDF2 = "@ByteArray(rSRSjyLjKHX4KeDHgtx8qA==:EdZC27+FdG0aFtqVtEsiuqQAA6NROdBRXVSySD6ktgBY7k9ORrq8Kgo2uIkXvAWssmMIFb+C3RZS2PMWAt/Ihw==)";
        };
        Scheduler = {
          end_time = ''@Variant(\0\0\0\xf\0\x36\xee\x80)'';
          start_time = ''@Variant(\0\0\0\xf\x1\xb7t\0)'';
        };
      };
      AutoRun = {
        OnTorrentAdded.Enabled = true;
        OnTorrentAdded.Program = "chmod -R 777 %F";
        enabled = true;
        program = "chmod -R 777 %F";
      };

      BitTorrent = {
        Session.AddTorrentStopped = false;
        Session.AlternativeGlobalDLSpeedLimit = 204800;
        Session.AlternativeGlobalUPSpeedLimit = 10240;
        Session.BandwidthSchedulerEnabled = true;
        Session.ExcludedFileNames = "";
        Session.QueueingSystemEnabled = false;
        # I am big storage now
        # Session.GlobalMaxInactiveSeedingMinutes = 1440;
        # Session.GlobalMaxRatio = 2;
        # Session.GlobalMaxSeedingMinutes = 1440;
      };
    };
  };

  services.jackett = {
    enable = true;
    openFirewall = true;
    dataDir = "/media/jackett";
    package = pkgs-unstable.jackett;
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
    group = "media";
    dataDir = "/media/jellyfin";
  };

  services.jellyseerr = {
    enable = true;
    openFirewall = true;
  };

  systemd.services.jellyseerr-restarter = {
    enable = true;
    description = "Restarts Jellyseerr on startup as that fixes it not loading anything and not recognizing anything for whatever reason.";
    wantedBy = ["default.target"];
    after = ["jellyseerr.service"];
    script = ''
      sleep 10
      systemctl restart jellyseerr.service
    '';
  };

  services.caddy = {
    enable = true;
    virtualHosts."jackett.saberofxebec".extraConfig = ''
      reverse_proxy :9117
      tls internal
    '';
    virtualHosts."speedtest.saberofxebec".extraConfig = ''
      reverse_proxy :42069
      tls internal
    '';
    virtualHosts."qbittorrent.saberofxebec".extraConfig = ''
      reverse_proxy :8080
      tls internal
    '';
    virtualHosts."radarr.saberofxebec".extraConfig = ''
      reverse_proxy :7878
      tls internal
    '';
    virtualHosts."sonarr.saberofxebec".extraConfig = ''
      reverse_proxy :8989
      tls internal
    '';
    virtualHosts."bazarr.saberofxebec".extraConfig = ''
      reverse_proxy :6767
      tls internal
    '';
    virtualHosts."readarr.saberofxebec".extraConfig = ''
      reverse_proxy :8787
      tls internal
    '';
    virtualHosts."jellyfin.saberofxebec".extraConfig = ''
      reverse_proxy :8096 {
        transport http {
          keepalive 32s
        }
      }
      tls internal
    '';
    virtualHosts."jellyseer.saberofxebec".extraConfig = ''
      reverse_proxy :5055
      tls internal
    '';
    virtualHosts."homarr.saberofxebec".extraConfig = ''
      reverse_proxy :7575
      tls internal
    '';
    virtualHosts."pihole.saberofxebec".extraConfig = ''
      reverse_proxy :12345
      tls internal
    '';
  };

  system.stateVersion = "25.11";
}
