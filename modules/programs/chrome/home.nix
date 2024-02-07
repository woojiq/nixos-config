{pkgs, ...}: {
  # NOTDECL: ./*.user.js scipts must be manually added to the Violentmonkey Chrome extension.
  # I'm not sure if they will persist after OS/Browser reinstallation as they are stored in local storage.
  home.packages = with pkgs; [google-chrome];
}
