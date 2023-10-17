{...}: {
  # Chad moment: https://github.com/NixOS/nixpkgs/pull/221321
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        settings = {
          main = {
            capslock = "overload(control, esc)";
            rightalt = "layer(rightalt)";
          };
          "rightalt:G" = {
            h = "left";
            j = "down";
            k = "up";
            l = "right";
            leftalt = "capslock";
          };
        };
      };
    };
  };

  # Disable touchpad while typing
  # environment.etc."libinput/local-overrides.quirks".text = ''
  #   [Serial Keyboards]
  #   MatchUdevType=keyboard
  #   MatchName=keyd virtual device
  #   AttrKeyboardIntegration=internal
  # '';
}
