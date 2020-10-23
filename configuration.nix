# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  unstable = import <nixpkgs-unstable> { };
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.grub.useOSProber = true;

  # UNFREE PKGS
  nixpkgs.config.allowUnfree = true;

  # BOOT FASTER
  systemd.services = {
    systemd-udev-settle.enable = false;
    NetworkManager-wait-online.enable = false;
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    useDHCP = false;
    interfaces = {
      enp7s0.useDHCP = true;
      wlp0s20f3.useDHCP = true;
    };
  };


  # networking.hostName = "nixos"; # Define your hostname.
  # networking.networkmanager.enable = true;    
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  # networking.useDHCP = false;
  # networking.interfaces.enp7s0.useDHCP = true;
  # networking.interfaces.


  # SSD
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Set your time zone.
  time.timeZone = "Asia/Jakarta";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = (with pkgs; [
    wget
    vim
    git
    htop
    zip
    unzip
    curl
    upower
    kitty
    neofetch
    pfetch
    pciutils
    # Intel
    mesa
    glxinfo
    vaapiIntel
    libva-utils
    libva-full
    vaapi-intel-hybrid
    xorg.xorgserver
    xorg.xf86inputlibinput
    xorg.xf86videointel
    # haskell stuff
    cabal2nix
    cabal-install
    ghc
    # xmonad stuff
    dmenu
    scrot
    feh
    xdotool
    picom
    xscreensaver
    xorg.xbacklight
    xclip
    # emacs
    emacs
    ripgrep
    fd
    # GUI
    chromium
    firefox
    pavucontrol
    xfce.thunar
  ]) ++ (with pkgs.haskellPackages; [
    xmonad
    xmonad-contrib
    xmobar
    hlint
    brittany
    xmonad-extras
    apply-refact
  ]);


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  #   pinentryFlavor = "gnome3";
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware = {
    pulseaudio = (import ./pulseaudio.nix) { inherit pkgs; };
    opengl.enable = true;
    opengl.driSupport = true;
    opengl.extraPackages = with pkgs; [
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      intel-media-driver
    ];
    opengl.driSupport32Bit = true;
    cpu.intel.updateMicrocode = true;
  };


  services = {
    httpd = {
      enable = true;
      adminAddr = "fahmiirsyadk";
      virtualHosts = {
        "fah.mi" = {
          documentRoot = "/var/www/html";
          adminAddr = "fahmiirsyad10@gmail.com";
          extraConfig = ''
            <Directory "/var/www/html">
               Options Indexes FollowSymLinks
               AllowOverride None
               Allow from all
               Require all granted
            </Directory>
          '';
          listen = [{ port = 2345; }];
        };
      };
      #};
      #};
      #virtualHosts = {
      #localhost = {
      # documentRoot = "/home/fahmiirsyadk/.nix-profile/htdocs";
      #};
      #};
      enablePHP = true;
      phpOptions = ''
        date.timezone = Asia/Jakarta
        display_error = On
        extension=gd
        extension=imap
        extension=mysqli
        extension=pdo_mysql
        extension=bz2
      '';
    };
    mysql.enable = true;
    mysql.package = unstable.mariadb;

    xserver = {
      enable = true;
      layout = "us";
      # videoDrivers = ["intel"];
      libinput = {
        enable = true;
        naturalScrolling = true;
      };
      displayManager.defaultSession = "none+xmonad";
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
      };
    };
  };

  # PROGRAMS
  programs = {
    adb.enable = true; # recently, it's use for android studio stuff
  };

  # services.xserver.xkbOptions = "eurosign:e";

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.fahmiirsyadk = {
    isNormalUser = true;
    group = "users";
    home = "/home/fahmiirsyadk";
    createHome = true;
    uid = 1000;
    extraGroups = [ "wheel" "audio" "video" "disk" "networkmanager" "fahmiirsyadk" ]; # Enable ‘sudo’ for the user.
  };

  # home sweet home
  home-manager.users.fahmiirsyadk = { pkgs, ... }: {
    home.packages = [
      pkgs.atool
      pkgs.httpie
      unstable.discord
      unstable.android-studio
      pkgs.gotop
      unstable.nix-prefetch-github
      # PHP
      unstable.mariadb
      unstable.apacheHttpd
      unstable.php
    ];
    programs.bash.enable = true;

  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?
}
  

