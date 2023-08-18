{ pkgs, helix-flake, ... }:

{
  programs.helix = {
    enable = true;
    package = helix-flake;

    settings = {
      editor = {
        line-number = "relative";
        shell = [ "${pkgs.fish}/bin/fish" "-c" ];
        bufferline = "multiple";
        idle-timeout = 50;
        color-modes = true;
        cursor-shape.insert = "underline";
        scrolloff = 3;
        statusline = {
          left = [ "mode" "spinner" "spacer" "version-control" "read-only-indicator" ];
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
            "r" = ":reset-diff-change";
            "w" = {
              "a" = ":set whitespace.render all";
              "n" = ":set whitespace.render none";
            };
          };
          # Ukrainian basic movement (https://docs.helix-editor.com/master/keymap.html)
          ## Movement
          "р" = "move_char_left";
          "о" = "move_visual_line_down";
          "л" = "move_visual_line_up";
          "д" = "move_char_right";
          "и" = "move_prev_word_start";
          "у" = "move_next_word_end";
          ## Changes
          "щ" = "open_below";
          "Щ" = "open_above";
          "ш" = "insert_mode";
          "Ш" = "insert_at_line_start";
          "ф" = "append_mode";
          "Ф" = "insert_at_line_end";
          "к" = "replace";
          "с" = "change_selection";
          "в" = "delete_selection";
          "ʼ" = "switch_case";
          ## Search
          "." = "search";
        };
      };
      # theme = "sonokai-transparent";
      # theme = "ayu_dark";
      theme = "github_dark_dimmed_custom";
    };
    languages = {
      language-server = {
        rust-analyzer = {
          config = {
            check.command = "clippy";
            inlayHints.lifetimeElisionHints.enable = "always";
          };
        };
        pyright-langserver = {
          command = "pyright-langserver";
          args = [ "--stdio" ];
          config = { };
        };
      };
      language = [
        {
          name = "python";
          roots = [ "pyproject.toml" ];
          language-servers = [ "pyright-langserver" ];
          formatter = { command = "black"; args = [ "--quiet" "-" ]; };
          auto-format = true;
        }
        {
          name = "nix";
          auto-format = true;
          formatter = { command = "nixpkgs-fmt"; args = [ ]; };
        }
      ];
    };
    themes = {
      github_dark_dimmed_custom = {
        inherits = "github_dark_dimmed";
        "ui.virtual.ruler" = { bg = "scale.gray.8"; };
      };
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
