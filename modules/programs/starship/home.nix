{lib, ...}: {
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = false;
    enableTransience = true;
    settings = let
      prompt = builtins.fromTOML (builtins.readFile ./prompt.toml);

      preset = builtins.fromTOML (builtins.readFile ./pure-preset.toml);
      # preset = builtins.fromTOML (builtins.readFile ./nerd-font.toml);
    in
      lib.recursiveUpdate prompt preset;
  };

  # https://starship.rs/advanced-config/#transientprompt-and-transientrightprompt-in-fish
  programs.fish.functions = {
    starship_transient_prompt_func = ''
      echo -e "\x1b[38;5;135m\033[0m "
      # starship module character
    '';
  };
}
