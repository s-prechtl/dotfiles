{...}: {
  programs.git = {
    enable = true;
    delta.enable = true;
    userEmail = "stefan@tague.at";
    userName = "s-prechtl";
    extraConfig = {
      init.defaultBranch = "master";
      push.autoSetupRemote = true;
    };
  };
}
