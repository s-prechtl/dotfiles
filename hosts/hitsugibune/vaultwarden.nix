{ config, ... }:

let
  domain = "vaultwarden.sprechtl.me";
in
{
  age.secrets.vaultwarden-env = {
    file = ../../secrets/vaultwarden.age;
    owner = "vaultwarden";
    group = "vaultwarden";
    mode = "0400";
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.vaultwarden = {
    enable = true;
    environmentFile = config.age.secrets.vaultwarden-env.path;
    config = {
      DOMAIN = "https://${domain}";
      SIGNUPS_ALLOWED = false;
      ROCKET_PORT = 8222;      # internal port (nginx will proxy to this)
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts."${domain}" = {
      forceSSL = true;
      enableACME = true;

      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
        proxyWebsockets = true;
      };
    };
  };
}
