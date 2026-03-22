{config, ...}: {
  age.secrets.authentik-env = {
    file = ../../secrets/authentik.age;
  };

  services.authentik = {
    enable = true;
    environmentFile = config.age.secrets.authentik-env.path;
    settings = {
      disable_startup_analytics = true;
      avatars = "initials";
    };

    postgresql = {
      host = "/run/postgresql";
      name = "authentik";
      user = "authentik";
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
}
