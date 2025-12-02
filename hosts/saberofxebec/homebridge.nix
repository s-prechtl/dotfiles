{config, ...}: {
  services.homebridge = {
    enable = true;
    openFirewall = true;
  };

  networking.firewall.allowedTCPPorts = [ config.services.homebridge.settings.bridge.port ];
  networking.firewall.allowedUDPPorts = [ 5353 ]; # mDNS / Bonjour


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
      users = [ "homebridge" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
  };
}
