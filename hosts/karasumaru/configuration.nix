# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  ...
}: let
  serverIP = "0.0.0.0";
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  networking.hostName = "karasumaru";

  time.timeZone = "Europe/Vienna";

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
  ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  virtualisation.docker.enable = true;
  virtualisation.oci-containers = {
    backend = "docker";
    containers.pihole = {
      image = "pihole/pihole:latest";
      ports = [
        "${serverIP}:53:53/tcp"
        "${serverIP}:53:53/udp"
        "3080:80"
        "30443:443"
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
  };

  system.stateVersion = "24.11";
}
