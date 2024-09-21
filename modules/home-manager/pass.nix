{
  ...
}: {
  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_DIR = "$HOME/.password-store";
      PASSWORD_STORE_GENERATED_LENGTH = "20";
      PASSWORD_STORE_ENABLE_EXTENSIONS = "true";
    };
  };
  programs.browserpass.enable = true;
}
