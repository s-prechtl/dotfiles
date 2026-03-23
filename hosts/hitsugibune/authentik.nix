{ config, ... }:
{
  age.secrets.authentik-env = {
    file = ../../secrets/authentik.age;
  };

  users.users.authentik = {
    isSystemUser = true;
    group = "authentik";
  };

  users.groups.authentik = {};

  services.authentik = {
    enable = true;
    environmentFile = config.age.secrets.authentik-env.path;
    settings = {
      disable_startup_analytics = true;
      avatars = "initials";
      postgresql = {
        host = "/run/postgresql";
        name = "authentik";
        user = "authentik";
      };
      email = {
        host = "tague.at";
        port = 587;
        username = "stefan@tague.at";
        use_tls = true;
        use_ssl = false;
        from = "authentik@tague.at";
      };
    };
    nginx = {
      enable = true;
      enableACME = true;
      host = "auth.sprechtl.me";
    };
  };

  services.postgresql = {
    ensureDatabases = [ "authentik" ];
    ensureUsers = [{
      name = "authentik";
      ensureDBOwnership = true;
    }];
  };

  services.redis.servers.authentik = {
    enable = true;
    port = 0;
  };
}
