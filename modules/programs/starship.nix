{...}: {
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = false;
    settings = {
      # time.disabled = false;
      command_timeout = 3000;
      character = {
        success_symbol = "[](bold green) ";
        error_symbol = "[](bold red) ";
        vimcmd_symbol = "[](bold green) ";
        vimcmd_replace_one_symbol = "[](bold purple) ";
        vimcmd_replace_symbol = "[](bold purple) ";
        vimcmd_visual_symbol = "[](bold yellow) ";
      };

      git_status = {
        untracked = "";
        ignore_submodules = true;
      };

      aws.symbol = "  ";
      buf.symbol = " ";
      c.symbol = " ";
      conda.symbol = " ";
      dart.symbol = " ";
      directory.read_only = " 󰌾";
      docker_context.symbol = " ";
      docker_context.format = "via [$symbol]($style)[docker]($style) ";
      elixir.symbol = " ";
      elm.symbol = " ";
      git_branch.symbol = " ";
      golang.symbol = " ";
      guix_shell.symbol = " ";
      haskell.symbol = " ";
      haxe.symbol = "⌘ ";
      hg_branch.symbol = " ";
      java.symbol = " ";
      julia.symbol = " ";
      lua.symbol = " ";
      memory_usage.symbol = "󰍛 ";
      meson.symbol = "󰔷 ";
      nim.symbol = "󰆥 ";
      nix_shell.symbol = " ";
      nix_shell.format = "via [$symbol$state]($style) ";
      nodejs.symbol = " ";

      kotlin.symbol = " ";
      gradle.symbol = " ";

      os.symbols.Alpine = " ";
      os.symbols.Amazon = " ";
      os.symbols.Android = " ";
      os.symbols.Arch = " ";
      os.symbols.CentOS = " ";
      os.symbols.Debian = " ";
      os.symbols.DragonFly = " ";
      os.symbols.Emscripten = " ";
      os.symbols.EndeavourOS = " ";
      os.symbols.Fedora = " ";
      os.symbols.FreeBSD = " ";
      os.symbols.Garuda = "﯑ ";
      os.symbols.Gentoo = " ";
      os.symbols.HardenedBSD = "ﲊ ";
      os.symbols.Illumos = " ";
      os.symbols.Linux = " ";
      os.symbols.Macos = " ";
      os.symbols.Manjaro = " ";
      os.symbols.Mariner = " ";
      os.symbols.MidnightBSD = " ";
      os.symbols.Mint = " ";
      os.symbols.NetBSD = " ";
      os.symbols.NixOS = " ";
      os.symbols.OpenBSD = " ";
      os.symbols.openSUSE = " ";
      os.symbols.OracleLinux = "󰌷 ";
      os.symbols.Pop = " ";
      os.symbols.Raspbian = " ";
      os.symbols.Redhat = " ";
      os.symbols.RedHatEnterprise = " ";
      os.symbols.Redox = " ";
      os.symbols.Solus = "ﴱ ";
      os.symbols.SUSE = " ";
      os.symbols.Ubuntu = " ";
      os.symbols.Unknown = " ";
      os.symbols.Windows = "󰍲 ";

      package.symbol = "󰏗 ";
      python.symbol = " ";
      rlang.symbol = "ﳒ ";
      ruby.symbol = " ";
      rust.symbol = " ";
      scala.symbol = " ";
      spack.symbol = "SPACK SYMBOL ISN'T PRESENT :( ";
    };
  };
}
