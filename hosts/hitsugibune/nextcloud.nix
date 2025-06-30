{
  config,
  pkgs,
  lib,
  ...
}: {
  networking.firewall.allowedTCPPorts = [80 443];
  services.nextcloud = {
    enable = true;
    hostName = "nextcloud.sprechtl.me";
    https = true;
    configureRedis = true;
    caching.redis = true;
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps) news contacts calendar mail deck onlyoffice polls tasks bookmarks;
    };
    extraAppsEnable = true;
    autoUpdateApps.enable = true;
    package = pkgs.nextcloud31;
    config = {
      adminuser = "admin";
      adminpassFile = config.age.secrets.nextcloud.path;
      dbtype = "pgsql";
    };
    database.createLocally = true;
  };

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts.${config.services.nextcloud.hostName} = {
      forceSSL = true;
      enableACME = true;
    };
  };

  security.acme = {
    acceptTerms = true;
    certs = {
      ${config.services.nextcloud.hostName}.email = "stefan@tague.at";
    };
  };
}
