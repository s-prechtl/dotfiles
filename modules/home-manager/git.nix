{ config, pkgs, ... }:

{
	programs.git = {
		enable = true;
		delta.enable = true;
		userEmail = "stefan@tague.at";
		userName = "s-prechtl";
	};
}
