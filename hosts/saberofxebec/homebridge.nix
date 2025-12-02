{...}: {
  services.homebridge = {
    enable = true;
  };

  services.caddy = {
    enable = true;
    virtualHosts."homebridge.saberofxebec".extraConfig = ''
      reverse_proxy :5353
      tls internal
    '';
  };
}
