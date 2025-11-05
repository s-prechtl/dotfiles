{...}: {
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };
  programs.git = {
    enable = true;
    settings = {
      user = {
        email = "stefan@tague.at";
        name = "s-prechtl";
      };
      init.defaultBranch = "master";
      push.autoSetupRemote = true;
    };
  };
}
