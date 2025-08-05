{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.home-manager.darwinModules.home-manager
  ];
  system.primaryUser = "ichlebemietfreiindeinemapfel";
  users.users.ichlebemietfreiindeinemapfel = {
    home = "/Users/ichlebemietfreiindeinemapfel";
  };

  environment.systemPackages = with pkgs; [
    alacritty
    element-desktop
    flutter
    gnupg
    mkalias
    neovim
    pass
    vim
    zoxide
  ];

  home-manager = {
    backupFileExtension = "backup";
    extraSpecialArgs = {inherit inputs;};
    users = {
      "ichlebemietfreiindeinemapfel" = import ./home.nix;
    };
  };

  homebrew = {
    enable = true;
    casks = [
      "zen"
    ];
    brews = [
    ];
    masApps = {
      "xcode" = 497799835;
    };
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";
  programs.zsh.enable = true;

  # Enable alternative shell support in nix-darwin.
  # programs.fish.enable = true;

  system.activationScripts.applications.text = let
    env = pkgs.buildEnv {
      name = "system-applications";
      paths = config.environment.systemPackages;
      pathsToLink = "/Applications";
    };
  in
    pkgs.lib.mkForce ''
      # Set up applications.
      echo "setting up /Applications..." >&2
      rm -rf /Applications/Nix\ Apps
      mkdir -p /Applications/Nix\ Apps
      find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
      while read -r src; do
        app_name=$(basename "$src")
        echo "copying $src" >&2
        ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
      done
    '';
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # Set Git commit hash for darwin-version.
  #system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
