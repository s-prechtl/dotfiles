{config, ...}: {
  # This is only a temporary password and will be changed
  environment.etc."nextcloud-admin-pass".text = "samc";
  services.nextcloud = {
    enable = true;
    hostName = "sprechtl.ddns.net";
    https = true;
  };

  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    forceSSL = true;
    enableACME = true;
  };

  security.acme = {
    acceptTerms = true;
    certs = {
      ${config.services.nextcloud.hostName}.email = "stefan@tague.at";
    };
  };
}
