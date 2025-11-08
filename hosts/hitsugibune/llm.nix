{config, ...}: {
  services.open-webui = {
    enable = true;
    openFirewall = true;
    host = "0.0.0.0";
  };

  services.ollama = {
    enable = true;
    host = "chattn.sprechtl.me";
    acceleration = "cuda";
    loadModels = ["llama3.2:3b" "deepseek-r1:1.5b" "gpt-oss:20b"];
  };

  services.nginx = {
    enable = true;
    virtualHosts.${config.services.ollama.host} = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8080";
        proxyWebsockets = true;
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "stefan@tague.at";
  };
}
