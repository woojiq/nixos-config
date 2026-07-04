{...}: {
  services.wob = {
    enable = true;
    settings = {
      "" = {
        anchor = "top left";
        margin = 10;
        background_color = "373333";
        bar_color = "93c47d";
        timeout = 1000;
        width = 200;
        overflow_mode = "nowrap";
        height = 25;
        border_offset = 0;
        border_size = 1;
        border_color = "efe3e3";
      };
    };
  };
}
