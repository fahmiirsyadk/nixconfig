{ config, lib, pkgs, ... }:
let unstable = import <nixpkgs-unstable> { };
in
{
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
    picom
    vim
    neofetch
    pfetch
    emacs
    xfce.thunar
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
  };
}
