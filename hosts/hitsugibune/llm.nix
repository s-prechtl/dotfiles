{...} :
{
  services.open-webui = {
    enable = true;
    openFirewall = true;
    host = "0.0.0.0";
  };

  services.ollama = {
  enable = true;
  acceleration = "cuda";
  loadModels = [ "llama3.2:3b" "deepseek-r1:1.5b" "gpt-oss:20b" ];
    
};
}
