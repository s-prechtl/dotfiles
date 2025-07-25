# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ../../modules/nixos/main-user.nix
    ../../modules/nixos/greetd.nix
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  networking.hostName = "goingmerry"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_AT.UTF-8";
    LC_IDENTIFICATION = "de_AT.UTF-8";
    LC_MEASUREMENT = "de_AT.UTF-8";
    LC_MONETARY = "de_AT.UTF-8";
    LC_NAME = "de_AT.UTF-8";
    LC_NUMERIC = "de_AT.UTF-8";
    LC_PAPER = "de_AT.UTF-8";
    LC_TELEPHONE = "de_AT.UTF-8";
    LC_TIME = "de_AT.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.pcscd.enable = true;
  services.dbus.packages = [pkgs.gcr];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  main-user = {
    enable = true;
    username = "sprechtl";
  };

  home-manager = {
    backupFileExtension = "backup";
    extraSpecialArgs = {inherit inputs;};
    users = {
      "sprechtl" = import ./home.nix;
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.android_sdk.accept_license = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #ciscoPacketTracer8
    SDL2
    air
    alacritty
    android-studio-full
    anki
    banana-cursor
    bat
    blueman
    brave
    brightnessctl
    chromium
    clang-tools
    cmake
    curlHTTP3
    dig
    electrum
    element-desktop
    fastfetch
    file
    filezilla
    flutter
    fzf
    gccgo
    gdb
    geogebra6
    gh
    gimp
    git
    gnumake
    gnupg
    go
    nil
    google-chrome
    goose
    hyprshot
    inputs.agenix.packages."${system}".default
    jdk
    jdt-language-server
    kdePackages.dolphin
    kdePackages.kwalletmanager
    libgcc
    linux-manual
    lolcat
    man-pages
    man-pages-posix
    marp-cli
    mplayer
    mpv
    networkmanagerapplet
    newsflash
    nextcloud-client
    nmap
    nodejs_22
    obsidian
    onlyoffice-bin
    openssl
    pass
    php83
    php83Packages.composer
    pinentry-qt
    pnpm
    postman
    prismlauncher
    pwvucontrol
    python3
    radare2
    ripgrep
    rustup
    signal-desktop
    sl
    socat
    spotify
    spotify-player
    sqlc
    teams-for-linux
    teamspeak6-client
    texliveFull
    thunderbird
    tldr
    tmuxinator
    tokei
    tree-sitter
    unixtools.script
    unzip
    usbutils
    vencord
    vesktop
    vim
    virtiofsd
    watchexec
    waybar
    wdisplays
    webcord
    wget
    whois
    wireguard-tools
    wireshark
    wl-clicker
    wl-clipboard
    wofi
    wofi-pass
    zip
    zoxide
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    ipafont
    kochi-substitute
  ];

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
    firefox.enable = true;
    hyprland.enable = true;
    direnv.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-qt;
    };

    virt-manager.enable = true;

    wireshark.enable = true;
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        # Add any missing dynamic libraries for unpackaged programs
        # here, NOT in environment.systemPackages
      ];
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };
  };

  virtualisation = {
    libvirtd.enable = true;
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
    # Uncommented since it causes delay in rebuilding the config
    # virtualbox = {
    #   host.enable = true;
    #   guest = {
    #     enable = true;
    #     clipboard = true;
    #     dragAndDrop = true;
    #     seamless = true;
    #   };
    # };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  services = {
    fprintd.enable = true;
    blueman.enable = true;
    onedrive.enable = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  security.pam.services = {
    hyprlock = {};
    "kdewallet" = {
      kwallet.enable = true;
    };
  };
  networking.firewall.checkReversePath = false;
  networking.wg-quick.interfaces = {
    home = {
      address = ["10.154.125.2/24"];
      dns = ["10.0.0.1"];
      privateKeyFile = "/home/sprechtl/.wg-keys/priv";

      peers = [
        {
          publicKey = "GEX4m+MaTgiFJIusY8lAWkKji5WjzKmyMsSbCmBmHSQ=";
          presharedKeyFile = "/home/sprechtl/.wg-keys/psk";
          allowedIPs = ["10.0.0.0/24"];
          endpoint = "sprechtl.me:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
  systemd.services.wg-quick-home.wantedBy = lib.mkForce [];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
