{
  config,
  pkgs,
  ...
}: {
  age.secrets.nextcloud = {
    file = ../../secrets/nextcloud.age;
    owner = "nextcloud";
    group = "nextcloud";
  };
  age.secrets.onlyoffice = {
    file = ../../secrets/onlyoffice.age;
    owner = "onlyoffice";
    group = "onlyoffice";
  };
  networking.firewall.allowedTCPPorts = [80 443];
  services.nextcloud = {
    enable = true;
    hostName = "nextcloud.sprechtl.me";
    https = true;
    nginx.recommendedHttpHeaders = true;
    configureRedis = true;
    caching.redis = true;
    extraAppsEnable = true;
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps) news contacts calendar mail deck onlyoffice polls tasks bookmarks cookbook cospend;
    };
    autoUpdateApps.enable = true;
    package = pkgs.nextcloud31;
    config = {
      adminuser = "admin";
      adminpassFile = config.age.secrets.nextcloud.path;
      dbtype = "pgsql";
    };
    settings = {
      maintenance_window_start = 3;
    };
    database.createLocally = true;
  };

  services.onlyoffice = {
    enable = true;
    hostname = "onlyoffice.sprechtl.me";
    jwtSecretFile = config.age.secrets.onlyoffice.path;
  };

  services.nginx = {
    enable = true;
    virtualHosts.${config.services.nextcloud.hostName} = {
      forceSSL = true;
      enableACME = true;
    };

    virtualHosts.${config.services.onlyoffice.hostname} = {
      forceSSL = true;
      enableACME = true;
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "stefan@tague.at";
  };
}
