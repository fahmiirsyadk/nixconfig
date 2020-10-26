{ pkgs }:
{
  enable = true;
  support32Bit = true;
  package = pkgs.pulseaudioFull;
}
