{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "sprechtl";
  home.homeDirectory = "/home/sprechtl";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
	zsh-autosuggestions
	zsh-syntax-highlighting
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
	programs.zsh = {
	  enable = true;
	  shellAliases = {
	    ll = "exa -l";
	    l = "exa -la";
	    ls = "exa";
	    update = "sudo nixos-rebuild switch";
	    clear = "clear && fastfetch";
	  };

	  history.size = 10000;
	  autosuggestion.enable = true;
	  syntaxHighlighting.enable = true;

	  oh-my-zsh = {
	    enable = true;
	    plugins = [ "git" "docker" ];
	    theme = "strug";
	  };
	};
}
