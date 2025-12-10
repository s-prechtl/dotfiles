{config, ...}: let
  accessoryStart = 20000;
  accessoryEnd = 20200;
in {
  services.homebridge = {
    enable = true;
    openFirewall = true;
    settings = {
      ports = {
        start = accessoryStart;
        end = accessoryEnd;
      };
    };
  };

  # 50202 LG Subbridge
  networking.firewall.allowedTCPPorts = [config.services.homebridge.settings.bridge.port 50202];
  networking.firewall.allowedTCPPortRanges = [
    {
      from = accessoryStart;
      to = accessoryEnd;
    }
  ];
  networking.firewall.allowedUDPPorts = [5353]; # mDNS / Bonjour

  services.caddy = {
    enable = true;
    virtualHosts."homebridge.saberofxebec".extraConfig = ''
      reverse_proxy :8581
      tls internal
    '';
  };

  security.sudo = {
    enable = true;

    extraRules = [
      {
        users = ["homebridge"];
        commands = [
          {
            command = "ALL";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];
  };
}
