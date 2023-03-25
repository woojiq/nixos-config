{ pkgs, ... }:

{
  programs.helix = {
    enable = true;
    settings = {
      editor = {
        line-number = "relative";
        shell = [ "${pkgs.fish}/bin/fish" "-c" ];
        bufferline = "multiple";
        idle-timeout = 50;
        color-modes = true;
        cursor-shape.insert = "underline";
        statusline = {
          left = [ "mode" "spinner" ];
          center = [ "file-name" "file-modification-indicator" "spacer" "diagnostics" ];
          right = [ "selections" "position" "file-encoding" "file-type" ];
        };
        lsp = {
          display-signature-help-docs = false;
          auto-signature-help = false;
          display-inlay-hints = true;
          display-messages = true;
        };
        indent-guides = {
          render = true;
          character = "╎";
          skip-levels = 1;
        };
      };
      keys = {
        normal = {
          "X" = "extend_line_above";
          "A-w" = ":buffer-close";
          "A-l" = ":buffer-next";
          "A-h" = ":buffer-previous";
        };
      };
      theme = "sonokai-custom";
    };
    languages = [
      {
        name = "rust";
      }
      {
        name = "python";
        roots = [ "pyproject.toml" ];
        language-server = { command = "pyright-langserver"; args = [ "--stdio" ]; };
        config = { }; # <- this is the important line;
        formatter = { command = "black"; args = [ "--quiet" "-" ]; };
        auto-format = true;
      }
      {
        name = "nix";
        auto-format = true;
        formatter = { command = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt"; args = [ ]; };
      }
    ];
    themes.sonokai-custom = {
      inherits = "sonokai";
      # palette.bg2 = "#2c2e34"; # bg0

      "ui.virtual.inlay-hint" = {
        fg = "grey_dim";
      };
    };
  };
}
