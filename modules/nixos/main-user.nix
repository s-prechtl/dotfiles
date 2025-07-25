{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.main-user;
in {
  options.main-user = {
    enable =
      lib.mkEnableOption "enable user module";

    username = lib.mkOption {
      default = "mainuser";
      description = ''
        username
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zsh.enable = true;
    users.users.${cfg.username} = {
      isNormalUser = true;
      initialPassword = "12345";
      extraGroups = ["docker" "input" "networkmanager" "wheel" "vboxusers" "libvirtd" "wireshark" "kvm"];
      description = "Stefan";
      shell = pkgs.zsh;
    };
  };
}
