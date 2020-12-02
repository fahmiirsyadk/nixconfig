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
    unstable.discord
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
    emacs
    xfce.thunar
    vscode
    pfetch
    appimage-run
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
  };
  xsession.windowManager = {
    xmonad = (import desktop/xmonad/xmonad.nix);
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
