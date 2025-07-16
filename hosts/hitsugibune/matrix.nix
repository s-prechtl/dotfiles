{ pkgs, lib, config, ... }:
let
  fqdn = "matrix.sprechtl.me";
  baseUrl = "https://${fqdn}";
  clientConfig."m.homeserver".base_url = baseUrl;
  serverConfig."m.server" = "${fqdn}:443";
  mkWellKnown = data: ''
    default_type application/json;
    add_header Access-Control-Allow-Origin *;
    return 200 '${builtins.toJSON data}';
  '';
  turn  = config.services.coturn;
in {
  age.secrets.matrix = {
    file = ../../secrets/matrix.age;
    owner = "matrix-synapse";
    group = "matrix-synapse";
  };

  age.secrets.coturn = {
    file = ../../secrets/coturn.age;
    owner = "turnserver";
    group = "turnserver";
  };

  networking.domain = "sprechtl.me";

  # Coturn Ports
  networking.firewall = {
    interfaces.enp0s31f6 = let
      range = with config.services.coturn; lib.singleton {
        from = min-port;
        to = max-port;
      };
    in
    {
      allowedUDPPortRanges = range;
      allowedUDPPorts = [ 3478 5349 ];
      allowedTCPPortRanges = [ ];
      allowedTCPPorts = [ 3478 5349 ];
    };
  };
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  # Make certificate readable
  users.users.nginx.extraGroups = [ "turnserver" ];
  services.nginx.virtualHosts.${turn.realm} = {
  addSSL = true;
  enableACME = false; # we’ll do ACME ourselves
  forceSSL = false;
  sslCertificate = "${config.security.acme.certs.${turn.realm}.directory}/full.pem";
  sslCertificateKey = "${config.security.acme.certs.${turn.realm}.directory}/key.pem";
  locations."/.well-known/acme-challenge/" = {
    root = "/var/lib/acme/acme-challenges";
  };
};

  security.acme.certs.${turn.realm} = {
    email = "stefan@tague.at";
    webroot = "/var/lib/acme/acme-challenges";
    postRun = "systemctl restart coturn.service";
    group = "turnserver";
  };

  services.postgresql.enable = true;

   services.coturn = rec {
    enable = true;
    no-cli = true;
    no-tcp-relay = true;
    min-port = 49000;
    max-port = 49999;
    use-auth-secret = true;
    static-auth-secret-file = config.age.secrets.coturn.path;
    realm = "turn.sprechtl.me";
    cert = "${config.security.acme.certs.${realm}.directory}/full.pem";
    pkey = "${config.security.acme.certs.${realm}.directory}/key.pem";
    extraConfig = ''
      # for debugging
      verbose
      # ban private IP ranges
      no-multicast-peers
      denied-peer-ip=0.0.0.0-0.255.255.255
      denied-peer-ip=10.0.0.0-10.255.255.255
      denied-peer-ip=100.64.0.0-100.127.255.255
      denied-peer-ip=127.0.0.0-127.255.255.255
      denied-peer-ip=169.254.0.0-169.254.255.255
      denied-peer-ip=172.16.0.0-172.31.255.255
      denied-peer-ip=192.0.0.0-192.0.0.255
      denied-peer-ip=192.0.2.0-192.0.2.255
      denied-peer-ip=192.88.99.0-192.88.99.255
      denied-peer-ip=192.168.0.0-192.168.255.255
      denied-peer-ip=198.18.0.0-198.19.255.255
      denied-peer-ip=198.51.100.0-198.51.100.255
      denied-peer-ip=203.0.113.0-203.0.113.255
      denied-peer-ip=240.0.0.0-255.255.255.255
      denied-peer-ip=::1
      denied-peer-ip=64:ff9b::-64:ff9b::ffff:ffff
      denied-peer-ip=::ffff:0.0.0.0-::ffff:255.255.255.255
      denied-peer-ip=100::-100::ffff:ffff:ffff:ffff
      denied-peer-ip=2001::-2001:1ff:ffff:ffff:ffff:ffff:ffff:ffff
      denied-peer-ip=2002::-2002:ffff:ffff:ffff:ffff:ffff:ffff:ffff
      denied-peer-ip=fc00::-fdff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
      denied-peer-ip=fe80::-febf:ffff:ffff:ffff:ffff:ffff:ffff:ffff
    '';
  };

  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    virtualHosts = {
      # If the A and AAAA DNS records on example.org do not point on the same host as the
      # records for myhostname.example.org, you can easily move the /.well-known
      # virtualHost section of the code to the host that is serving example.org, while
      # the rest stays on myhostname.example.org with no other changes required.
      # This pattern also allows to seamlessly move the homeserver from
      # myhostname.example.org to myotherhost.example.org by only changing the
      # /.well-known redirection target.
      "${config.networking.domain}" = {
        enableACME = true;
        forceSSL = true;
        # This section is not needed if the server_name of matrix-synapse is equal to
        # the domain (i.e. example.org from @foo:example.org) and the federation port
        # is 8448.
        # Further reference can be found in the docs about delegation under
        # https://element-hq.github.io/synapse/latest/delegate.html
        locations."= /.well-known/matrix/server".extraConfig = mkWellKnown serverConfig;
        # This is usually needed for homeserver discovery (from e.g. other Matrix clients).
        # Further reference can be found in the upstream docs at
        # https://spec.matrix.org/latest/client-server-api/#getwell-knownmatrixclient
        locations."= /.well-known/matrix/client".extraConfig = mkWellKnown clientConfig;
      };
      "${fqdn}" = {
        enableACME = true;
        forceSSL = true;
        # It's also possible to do a redirect here or something else, this vhost is not
        # needed for Matrix. It's recommended though to *not put* element
        # here, see also the section about Element.
        locations."/".extraConfig = ''
          return 404;
        '';
        # Forward all Matrix API calls to the synapse Matrix homeserver. A trailing slash
        # *must not* be used here.
        locations."/_matrix".proxyPass = "http://[::1]:8008";
        # Forward requests for e.g. SSO and password-resets.
        locations."/_synapse/client".proxyPass = "http://[::1]:8008";
      };
    };
  };

  services.matrix-synapse = {
    enable = true;
    settings.server_name = config.networking.domain;
    # The public base URL value must match the `base_url` value set in `clientConfig` above.
    # The default value here is based on `server_name`, so if your `server_name` is different
    # from the value of `fqdn` above, you will likely run into some mismatched domain names
    # in client applications.
    settings.public_baseurl = baseUrl;
    settings.enable_registration = false;
    enableRegistrationScript = true;
    settings.listeners = [
      { port = 8008;
        bind_addresses = [ "::1" ];
        type = "http";
        tls = false;
        x_forwarded = true;
        resources = [ {
          names = [ "client" "federation" ];
          compress = true;
        } ];
      }
    ];

    extraConfigFiles = [ config.age.secrets.matrix.path ];
    settings.turn_uris = ["turn:${turn.realm}:3478?transport=udp" "turn:${turn.realm}:3478?transport=tcp"];
    settings.turn_user_lifetime = "1h";
  };

  # WARN: Remove once mautrix is updated
  nixpkgs.config.permittedInsecurePackages = [
                "olm-3.2.16"
  ];
  services.mautrix-signal = {
    enable = true;
    settings = {
      homeserver = {
        address = "http://localhost:8008";
        name = config.networking.domain;
      };

      bridge = {
        permissions = {
          "*" = "relay";
          "sprechtl.me" = "user";
          "@spr3ez:sprechtl.me" = "admin";
        };
      };

      backfill = {
        enabled = true;
      };

      matrix = {
        message_status_events = true;
      };

      database = {
        type = "sqlite3-fk-wal";
      };

      # encryption = {
      #   allow = true;
      #   default = true;
      #   pickle_key = "$ENCRYPTION_PICKLE_KEY";
      # };
    };
  };
}
