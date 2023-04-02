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
          left = [ "mode" "spinner" "spacer" "version-control" ];
          center = [ "file-name" "file-modification-indicator" "spacer" "diagnostics" ];
          right = [ "selections" "position-percentage" "position" "file-encoding" "file-type" ];
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
        # whitespace.render.newline = "all"; # Enable temporarily: `set whitespace.render.newline all`
        soft-wrap = {
          enable = true;
          # MB remove this because outside of the markdown I think I would need it
          wrap-indicator = "";
        };
      };
      keys = {
        normal = {
          "X" = "extend_line_above";
          "A-w" = ":buffer-close";
          "A-l" = ":buffer-next";
          "A-h" = ":buffer-previous";
          space.c = {
            "w" = {
              "a" = ":set whitespace.render all";
              "n" = ":set whitespace.render none";
            };
          };
        };
      };
      theme = "sonokai-transparent";
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
    themes = {
      sonokai-custom = {
        inherits = "sonokai";
        "ui.virtual.inlay-hint" = {
          fg = "grey_dim";
        };
        # "ui.statusline.normal" = { fg = "bg0"; bg = "bg_blue"; }; # Noisy when scrolling through code
        "ui.statusline.insert" = { fg = "bg0"; bg = "bg_green"; };
        "ui.statusline.select" = { fg = "bg0"; bg = "bg_red"; };
      };
      sonokai-transparent = {
        inherits = "sonokai-custom";
        "ui.background" = { };
        "ui.statusline" = { };
        "ui.statusline.inacative" = { };
        "ui.bufferline" = { };
        "ui.bufferline.active" = { bg = "bg1"; };
      };
    };
  };
}
