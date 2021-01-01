{ config, lib, pkgs, ... }:
let unstable = import <nixpkgs-unstable> { config.allowUnfree = true; };
    picom = pkgs.picom.overrideAttrs (old: rec {
    version = "git";
    src = builtins.fetchurl "https://github.com/ibhagwan/picom/archive/next.tar.gz";
  });
in
{
  nixpkgs.config.allowUnfree = true;
  home.packages = (with pkgs; [
    discord
    cordless
    unstable.android-studio
    gotop
    unstable.nix-prefetch-github
    kitty
    unstable.chromium
    unstable.firefox
    tdesktop
    unstable.zoom-us
    tty-clock
    htop
    dmenu
    scrot
    feh
    xdotool
    vim
    neofetch
    pfetch
    xfce.thunar
    vscode
    unrar
    libnotify
    cava
    kazam
    offlineimap
    xclip
    steam
    simplescreenrecorder
    scilab-bin
    ncmpcpp
    mpd
    mu                              # mail client
    dunst                           # notification daemon
    pfetch                          # simpler neofetch
    appimage-run                    # run AppImage
    dijo                            # simple tracker
  ]) ++ (with pkgs.haskellPackages; [
    xmonad
    xmonad-contrib
    xmobar
    hlint
    xmonad-extras
    apply-refact
  ]);
  programs = {
    home-manager.enable = true;
    bash.enable = true;
    kitty = (import terminal/kitty/kitty.nix);
    git = {
      enable = true;
      userName = "fahmiirsyadk";
      userEmail = "fahmiirsyad10@gmail.com";
      delta.enable = true;
    };
    feh.enable = true;
    mu.enable = true;
    offlineimap.enable = true;
  };
  xsession.windowManager = {
    xmonad = (import desktop/xmonad/xmonad.nix);
  };
  services = {
    dunst = {
      enable = true;
      settings = {
        global = {
          geometry = "300x27-370+15";
          alignment = "right";
          font = "RobotoMonoNerdFontCompleteM-Bold 11";
          padding = 5;
          shrink = "yes";
          horizontal_padding = 15;
          sticky_history = "false";
        };
        urgency_normal = {
          background = "#040403";
          foreground = "#FFB86C";
          timeout = 10;
        };
        urgency_critical = {
          background = "#cc241d";
          foreground = "#FFF";
        };
      };
    };
  };
  home.file = {
    ".xmonad/autostart.sh" = {
      executable = true;
      text = ''
        ${picom}/bin/picom --config ${./desktop/picom/picom.conf} &
      '';
    };
  };
}
