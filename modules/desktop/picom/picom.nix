{
  enable = true;
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
      frame-opacity = 1;
      blur-background = true;
      blur-kern = "7x7box";
      blur-background-exclude = [];
        blur =
          { method = "gaussian";
            size = 10;
            deviation = 5.0;
          };
      use-damage = true
      log-level = warn
      detect-transient = true
      detect-client-leader = true
      use-ewmh-active-win = true
      mark-wmwin-focused = true
      mark-ovredir-focused = true
    '';
}
