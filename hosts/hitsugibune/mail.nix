{
  config,
  pkgs,
  ...
}: {
  age.secrets.mail-admin = {
    file = ../../secrets/mail-admin.age;
    owner = "virtualMail";
    group = "virtualMail";
  };

  mailserver = {
    stateVersion = 3;
    enable = true;
    fqdn = "mail.sprechtl.me";
    domains = ["sprechtl.me"];

    # A list of all login accounts. To create the password hashes, use
    # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
    loginAccounts = {
      "admin@sprechtl.me" = {
        hashedPasswordFile = config.age.secrets.mail-admin.path;
        aliases = ["postmaster@sprechtl.me"];
      };
    };

    # Use Let's Encrypt certificates. Note that this needs to set up a stripped
    # down nginx and opens port 80.
    x509.useACMEHost = config.mailserver.fqdn;
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "stefan@tague.at";
    certs.${config.mailserver.fqdn} = {
      webroot = "/var/lib/acme/acme-challenges";
    };
  };
}
