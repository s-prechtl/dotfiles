{ config, pkgs, ... }: {
  age.secrets.mail-admin = {
    file = ../../secrets/mail-admin.age;
    owner = "virtualMail";
    group = "virtualMail";
  };

  mailserver = {
    enable = true;
    fqdn = "mail.sprechtl.me";
    domains = [ "sprechtl.me" ];

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
    certificateScheme = "acme-nginx";
  };
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "stefan@tague.at";
}
