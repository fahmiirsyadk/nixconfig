{ unstable }:
# let unstable = import <nixkpgs-unstable> { }; in
{
  enable = true;
  package = unstable.picom;
  backend = "glx";
  blur = true;
  experimentalBackends = true;
  fade = true;
  fadeSteps = [ "0.03" "0.03" ];
  inactiveOpacity = "0.8";
  menuOpacity = "0.8";
  refreshRate = 144;
  extraOptions =
    ''
      use-damage = true
      log-level = warn
      detect-transient = true
      detect-client-leader = true
      use-ewmh-active-win = true
      mark-wmwin-focused = true
      mark-ovredir-focused = true
    '';
}
