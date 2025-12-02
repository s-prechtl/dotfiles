{...}: {
  services.homebridge = {
    enable = true;
  };

  services.caddy = {
    enable = true;
    virtualHosts."homebridge.saberofxebec".extraConfig = ''
      reverse_proxy :8581
      tls internal
    '';
  };
}
