{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/home-manager/hyprland.nix
    ../../modules/home-manager/pass.nix
    ../../modules/home-manager/btop.nix
    ../../modules/home-manager/dunst.nix
    ../../modules/home-manager/blueman.nix
    ../../modules/home-manager/git.nix
    ../../modules/home-manager/wofi.nix
    ../../modules/home-manager/rofi.nix
    ../../modules/home-manager/waybar.nix
    ../../modules/home-manager/alacritty.nix
    ../../modules/home-manager/nextcloud.nix
    ../../modules/home-manager/zsh.nix
    ../../modules/home-manager/tmux.nix
    ../../modules/home-manager/fastfetch.nix
  ];
  home.username = "sprechtl";
  home.homeDirectory = "/home/sprechtl";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.
  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    zsh-autosuggestions
    zsh-syntax-highlighting

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    (pkgs.writeShellScriptBin "mux-sessionizer" ''
      session=$(tmuxinator list | tail -n +2 | tr -s '[:space:]' '\n' | fzf)

      if [ -n "$session" ]; then
        tmuxinator start "$session"
      else
          echo "No session selected"
      fi
    '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/sprechtl/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.pointerCursor = {
    package = pkgs.banana-cursor;
    name = "Banana Cursor";
    gtk.enable = true;
    x11.enable = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
