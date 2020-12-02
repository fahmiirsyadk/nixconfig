{ pkgs }:
{
  enable = true;
  support32Bit = true;
  package = pkgs.pulseaudioFull;
  extraConfig = ''
   load-module module-echo-cancel source_name=record_mono_cancel aec_method=webrtc format=s16le rate=44100 channels=1
   set-default-source record_mono_cancel
  '';
}
