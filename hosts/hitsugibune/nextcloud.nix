{
  config,
  pkgs,
  lib,
  ...
}: {
  # This is only a temporary password and will be changed
  environment.etc."nextcloud-admin-pass".text = "samcsamc11";
  networking.firewall.allowedTCPPorts = [80 443];
  services.nextcloud = {
    enable = true;
    hostName = "sprechtl.ddns.net";
    https = false;
    configureRedis = true;
    caching.redis = true;
    autoUpdateApps.enable = true;
    package = pkgs.nextcloud31;
    settings = let
      prot = "http"; # or https
      host = config.services.nextcloud.hostName;
      dir = "/nextcloud";
    in {
      overwriteprotocol = prot;
      overwritehost = host;
      overwritewebroot = dir;
      overwrite.cli.url = "${prot}://${host}${dir}/";
      htaccess.RewriteBase = dir;
      log_type = "file";
    };
    config = {
      adminuser = "admin";
      adminpassFile = "/etc/nextcloud-admin-pass";
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
      listen = [
        {
          addr = "0.0.0.0";
          port = 80;
        }
        {
          addr = "0.0.0.0";
          port = 443;
          ssl = true;
        }
        {
          addr = "127.0.0.1";
          port = 8080;
        }
      ];
      locations = {
        "/nextcloud/" = {
          priority = 9999;
          extraConfig = ''
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-NginX-Proxy true;
            proxy_set_header X-Forwarded-Proto http;
            #rewrite ^/nextcloud(.*)$ $1 break;
            proxy_pass http://127.0.0.1:8080/; # tailing / is important!
            proxy_set_header Host $host;
            proxy_cache_bypass $http_upgrade;
            proxy_redirect off;
          '';
        };
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    certs = {
      ${config.services.nextcloud.hostName}.email = "stefan@tague.at";
    };
  };
}
