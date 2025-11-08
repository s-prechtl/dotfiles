{...}: {
  services.nginx = {
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    enable = true;
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "stefan@tague.at";
  };
}
