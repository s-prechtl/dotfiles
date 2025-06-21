{
  config,
  pkgs,
  ...
}: {
  # This is only a temporary password and will be changed
  environment.etc."nextcloud-admin-pass".text = "samcsamc11";
  networking.firewall.allowedTCPPorts = [80 443];
  services.nextcloud = {
    enable = true;
    hostName = "sprechtl.ddns.net";
    https = false;
    package = pkgs.nextcloud31;
    settings = let
      prot = "http"; # or https
      host = "127.0.0.1";
      dir = "/nextcloud";
    in {
      overwriteprotocol = prot;
      overwritehost = host;
      overwritewebroot = dir;
      overwrite.cli.url = "${prot}://${host}${dir}/";
      htaccess.RewriteBase = dir;
    };
    config = {
      adminpassFile = "/etc/nextcloud-admin-pass";
      dbtype = "sqlite";
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts.${config.services.nextcloud.hostName} = {
      forceSSL = false;
      enableACME = true;
      listen = [
        {
          addr = "127.0.0.1";
          port = 8080; # NOT an exposed port
        }
      ];
    };

    virtualHosts."localhost" = {
      locations = {
        "/nextcloud" = {
          priority = 9999;
          extraConfig = ''
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-NginX-Proxy true;
            proxy_set_header X-Forwarded-Proto http;
            proxy_pass http://127.0.0.1:8080/; # tailing / is important!
            proxy_set_header Host $host;
            proxy_cache_bypass $http_upgrade;
            proxy_redirect off;
          '';
        };
        "^~ /.well-known" = {
          priority = 9000;
          extraConfig = ''
            absolute_redirect off;
            location ~ ^/\\.well-known/(?:carddav|caldav)$ {
              return 301 /nextcloud/remote.php/dav;
            }
            location ~ ^/\\.well-known/host-meta(?:\\.json)?$ {
              return 301 /nextcloud/public.php?service=host-meta-json;
            }
            location ~ ^/\\.well-known/(?!acme-challenge|pki-validation) {
              return 301 /nextcloud/index.php$request_uri;
            }
            try_files $uri $uri/ =404;
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
