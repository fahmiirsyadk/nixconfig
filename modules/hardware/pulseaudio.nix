{ pkgs }:
{
	enable = true;
	support32Bit = true;
	extraModules = [pkgs.pulseaudio-modules-bt];
	package = pkgs.pulseaudioFull;
	# daemon.config = {
	  # default-sample-rate = "48000";
	  # alternative-sample-rate = "41000";
	  

	#};
}
