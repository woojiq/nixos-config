{
  config,
  inputs,
  pkgs,
  ...
}: let
  helix-flake = inputs.helix.packages.${pkgs.system}.default;
in {
  programs.helix = {
    enable = true;
    package = helix-flake;
    defaultEditor = true;

    settings = {
      editor = {
        line-number = "relative";
        popup-border = "all";
        shell = ["${config.globals.shell}" "-c"];
        bufferline = "multiple";
        idle-timeout = 20;
        color-modes = true;
        cursor-shape.insert = "underline";
        scrolloff = 3;
        statusline = {
          left = ["mode" "spinner" "spacer" "version-control" "read-only-indicator"];
          center = ["file-name" "file-modification-indicator" "spacer" "diagnostics"];
          right = ["selections" "position-percentage" "position" "file-encoding" "file-type"];
        };
        lsp = {
          display-signature-help-docs = false;
          auto-signature-help = false;
          display-inlay-hints = true;
          display-messages = true;
        };
        indent-guides = {
          render = false;
          character = "╎";
          skip-levels = 1;
        };
        soft-wrap = {
          enable = true;
          # MB remove this because outside of the markdown I think I would need it
          wrap-indicator = "";
        };
        file-picker = {
          hidden = false;
        };
      };
      keys = {
        normal = {
          "X" = "extend_line_above";
          "A-w" = ":buffer-close";
          "A-l" = ":buffer-next";
          "A-h" = ":buffer-previous";
          space.c = {
            "f" = ":reflow";
            "r" = ":reset-diff-change";
            "w" = {
              "a" = ":set whitespace.render all";
              "n" = ":set whitespace.render none";
            };
            "s" = "signature_help";
            "l" = ":lsp-restart";
          };
          # Ukrainian layout imitation (https://docs.helix-editor.com/master/keymap.html)
          ## Movement
          "р" = "move_char_left";
          "о" = "move_visual_line_down";
          "л" = "move_visual_line_up";
          "д" = "move_char_right";
          "и" = "move_prev_word_start";
          "у" = "move_next_word_end";
          "е" = "find_till_char";
          "Е" = "till_prev_char";
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
          "Ю" = "indent";
          "Б" = "unindent";
          "г" = "undo";
          "Г" = "redo";
          ## Selection manipulation
          "ч" = "extend_line_below";
          "Ч" = "extend_line_above";
          ## Search
          # "." = "search"; Doesn't work because in Eng layout this key is mapped to "repeat op".
          "т" = "search_next";
          "Т" = "search_prev";
          ## Minor modes
          "м" = "select_mode";
          "Ж" = "command_mode";
        };
      };
      # theme = "github_dark_dimmed";
      theme = "base16_transparent";
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
          args = ["--stdio"];
          config = {};
        };
        emmet-ls = {
          command = "emmet-ls";
          args = ["--stdio"];
        };
      };
      language = [
        {
          name = "python";
          roots = ["pyproject.toml"];
          language-servers = ["pyright-langserver"];
          formatter = {
            command = "black";
            args = ["--quiet" "-"];
          };
          auto-format = true;
        }
        {
          name = "nix";
          auto-format = true;
          formatter = {
            command = "alejandra";
            args = [];
          };
        }
        {
          name = "javascript";
          formatter = {
            command = "prettier";
            args = ["--parser" "typescript"];
          };
          auto-format = true;
        }
        {
          name = "typescript";
          formatter = {
            command = "prettier";
            args = ["--parser" "typescript"];
          };
          auto-format = true;
        }
        {
          name = "html";
          language-servers = ["vscode-html-language-server" "emmet-ls"];
          formatter = {
            command = "prettier";
            args = ["--parser" "html"];
          };
        }
      ];
    };
    themes = {
      github_dark_dimmed = {
        inherits = "github_dark_dimmed";
        "ui.virtual.ruler" = {bg = "scale.gray.8";};

        # Less colors pls <3
        "operator" = "fg.default";
        "variable.parameter" = "fg.default";
        "variable.other.member" = "fg.default";
        "function" = "fg.default";
        "string" = "#d6dde3";
        "type" = "fg.default";
      };
      mini = {
        palette = {};
        "ui.bufferline.active" = {bg = "gray";};
        "ui.text.focus" = {bg = "gray";};
        "ui.virtual.inlay-hint" = {bg = "gray";};
        "ui.selection" = {
          fg = "white";
          bg = "gray";
        };
        "ui.cursor.primary" = {
          fg = "black";
          bg = "light-gray";
        };
        "ui.linenr.selected" = {
          fg = "white";
          bg = "gray";
        };
        "ui.menu.selected" = {
          bg = "light-gray";
          fg = "black";
        };
      };
      sonokai = {
        inherits = "sonokai";
        "ui.virtual.inlay-hint" = {
          fg = "grey_dim";
        };
        # "ui.statusline.normal" = { fg = "bg0"; bg = "bg_blue"; }; # Noisy when scrolling through code
        "ui.statusline.insert" = {
          fg = "bg0";
          bg = "bg_green";
        };
        "ui.statusline.select" = {
          fg = "bg0";
          bg = "bg_red";
        };
      };
      sonokai_transparent = {
        inherits = "sonokai";
        "ui.background" = {};
        "ui.statusline" = {};
        "ui.statusline.inacative" = {};
        "ui.bufferline" = {};
        "ui.bufferline.active" = {bg = "bg1";};
      };
      base16_transparent = {
        inherits = "base16_transparent";
        # Remove blinking.
        "ui.cursor.primary" = {modifiers = ["reversed"];};
      };
    };
  };
}
