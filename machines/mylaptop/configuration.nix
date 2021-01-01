# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, config, pkgs, ... }:
let
  unstable = import <nixpkgs-unstable> { config.allowUnfree = true; };
  pkgsocaml = import (builtins.fetchGit {
         # Descriptive name to make the store path easier to identify                
         name = "my-old-revision";                                                 
         url = "https://github.com/nixos/nixpkgs-channels/";                       
         ref = "refs/heads/nixpkgs-unstable";                     
         rev = "0cf6a5035932023c324bfda301b89190801c3f30";                                           
  }) {};  
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

  boot.kernel.sysctl = {
    "vm.swappiness" = lib.mkDefault 1;
  };

  services.fstrim.enable = lib.mkDefault true;
  
  nix = {
    nixPath = [
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      "nixos-config=/home/fahmiirsyadk/.nix-config/machines/mylaptop/configuration.nix"
    ];
  };

  # UNFREE PKGS
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.pulseaudio = true;
    nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
    }))
    ];
    
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
    git
    zip
    unzip
    curl
    upower
    pciutils
    # nodejs
    # haskell stuff
    cabal2nix
    cabal-install
    ghc
    cmake
    libev
    gcc
    m4
    ntfs3g
    # xmonad stuff
    xscreensaver
    xorg.xbacklight
    # emacs
    ripgrep
    fd
    emacsGit
    # GUI
    font-manager
    pavucontrol
    home-manager
    # Lang
    php
    python
    python3
    php74Packages.composer2
  ]) ++ (with pkgsocaml; [
    ocaml
    ocamlPackages.merlin
  ]) ++ (with pkgs.php74Extensions; [
    bcmath ctype fileinfo json
    mbstring openssl pdo tokenizer xml
  ]) ++ (with unstable; [
    nodejs
  ]) ++ (with unstable.nodePackages; [
    yarn
    node2nix
    bower
    gulp
    live-server
  ]);

  fonts.fonts = (with pkgs; [
    fira-code
    mononoki
    nerdfonts
    fira-code-symbols
    ubuntu_font_family
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
    pulseaudio = (import ../../modules/hardware/pulseaudio.nix) { inherit pkgs; };
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
    httpd = (import ../../modules/services/httpd.nix);
    mysql = {
      enable = true;
      package = unstable.mariadb;
    };

    xserver = {
      enable = true;
      layout = "us";
      libinput = {
        enable = true;
      };
      displayManager.lightdm = {
        enable = true;
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

  environment.sessionVariables = {
    NIXOS_CONFIG="/home/fahmiirsyadk/.nix-config/machines/mylaptop/configuration.nix";
    _JAVA_AWT_WM_NONREPARENTING="1";
  };
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.fahmiirsyadk = {
    isNormalUser = true;
    group = "users";
    home = "/home/fahmiirsyadk";
    createHome = true;
    uid = 1000;
    extraGroups = [ "wheel" "audio" "video" "disk" "networkmanager" "sudo" ]; # Enable ‘sudo’ for the user.
  };

  home-manager = {
    useUserPackages = true;
    verbose = true;
    users.fahmiirsyadk = (import ../../modules/home.nix);
  };

  # home sweet home
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}
