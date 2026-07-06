{ config, pkgs, ... }:

{
  home.username = "julsen";
  home.homeDirectory = "/home/julsen";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    chromium

    awww
    blender
    bluetui
    btop
    discord
    cliphist
    dunst
    easyeffects
    eza
    fastfetch
    fzf
    gimp
    github-cli
    hyprlock
    hyprpolkitagent
    hyprpicker
    hyprshot
    jdk
    krita
    matugen
    noto-fonts
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
    piper
    rofi
    spotify
    vscode
    waybar
    wiremix
    zoxide
  ];

  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/julsen/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ls = "eza --icons --group-directories-first --color=always";
      ll = "eza -lh --icons --group-directories-first";
      lt = "eza --tree --level=2 --icons";
      la = "eza -a --icons";
      lla = "eza -lha --icons --group-directories-first";
      cd = "z";
      cl = "clear";
      # Der neue Update-Befehl für dein Flake-System:
      update = "sudo nixos-rebuild switch --flake ~/nixos-config#$(hostname)";
    };

    history = {
      size = 10000;
      ignoreAllDups = true;
      path = "$HOME/.zsh_history";
      ignorePatterns = ["rm *" "pkill *" "cp *"];
    };

    initExtra = ''
      # Zusätzliche History-Optionen
      setopt APPEND_HISTORY
      setopt HIST_SAVE_NO_DUPS

      # Completion-Menü Styling
      zstyle ':completion:*' menu select
      zstyle ':completion:*' use-cache on
      zstyle ':completion:*' cache-path ~/.cache/zsh/

      # Tastenkürzel: Entf-Taste (Delete) reparieren
      bindkey '^[[3~' delete-char

      # Inits für Tools (Fzf wird von Home Manager separat unten sauberer gelöst)
      eval "$(zoxide init zsh)"
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.spicetify"
  ];

  xdg.configFile = {
    "hypr/hyprland.lua".source = ./dotfiles/hypr/hyprland.lua;
    "fastfetch/config.jsonc".source = ./dotfiles/fastfetch/config.jsonc;
    "rofi/config.rasi".source = ./dotfiles/rofi/config.rasi;
    "waybar".source = ./dotfiles/waybar;
  };

  programs.git = {
    enable = true;
    userName  = "julsen7";
    userEmail = "263753131+julsen7@users.noreply.github.com";

    extraConfig = {
      "credential \"https://github.com\"" = {
        helper = "${pkgs.github-cli}/bin/gh auth git-credential";
      };
      "credential \"https://gist.github.com\"" = {
        helper = "${pkgs.github-cli}/bin/gh auth git-credential";
      };
    };
  };

  programs.kitty = {
    enable = true;

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };

    settings = {
      disable_ligatures = "never";
      
      cursor_stop_blinking_after = 0;
      cursor_trail = 10;
      
      mouse_hide_wait = "3.0";
      
      enable_audio_bell = "no";
      
      window_padding_width = 30;
      confirm_os_window_close = 0;
      
      shell = "zsh";
    };

    extraConfig = ''
      include current-theme.conf
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true; # Registriert Starship automatisch in der Zsh

    # Hier wandert deine TOML-Konfiguration direkt als Nix-Attribut-Set hinein
    settings = {
      "$schema" = "https://starship.rs/config-schema.json";

      format = ''
        $os\
        $directory\
        $git_branch\
        $git_status\
        $fill\
        $all\
        $cmd_duration\
        $time\
        $line_break\
        $character
      '';

      add_newline = true;

      os = {
        format = "[$symbol]($style) ";
        disabled = false;
        # Hier ändern wir das Symbol für dein neues NixOS-System!
        symbols = {
          NixOS = "";
        };
      };

      directory = {
        format = "[   $path]($style)[$read_only]($read_only_style) ";
        truncate_to_repo = false;
        substitutions = {
          "Documents" = "   Documents";
          "Downloads" = " Downloads";
          "Music" = " Music";
          "Pictures" = " Pictures";
        };
      };

      git_branch = {
        format = "[$symbol$branch]($style) ";
        symbol = " ";
      };

      fill = {
        symbol = "·";
        style = "white";
      };

      maven = {
        format = " [\${symbol} (\${version})]($style) ";
        symbol = "";
        style = "#c31e3d";
      };

      gradle = {
        format = " [\${symbol} (\${version})]($style) ";
        symbol = "";
        style = "#02303a";
      };

      java = {
        format = " [\${symbol} (\${version})]($style) ";
        symbol = "  ";
        style = "#ed8b00";
      };

      c = {
        format = " [\${symbol} (\${version})]($style) ";
        symbol = "  ";
        style = "#3848a9";
      };

      cpp = {
        format = " [\${symbol} (\${version})]($style) ";
        symbol = "  ";
        style = "#00599c";
      };

      haskell = {
        format = " [\${symbol} (\${version})]($style) ";
        symbol = "  ";
        style = "#5e5086";
      };

      kotlin = {
        format = " [\${symbol} (\${version})]($style) ";
        symbol = "  ";
      };

      python = {
        format = " [\${symbol} (\${version})]($style) ";
        symbol = "  ";
        style = "#ffd43b";
      };

      cmd_duration = {
        format = "    [$duration]($style) ";
      };

      time = {
        disabled = false;
        format = "  [$time]($style) ";
      };
    };
  };

  services.udiskie = {
    enable = true;
    tray = "auto";
    automount = true;
    notify = true;

    # Hier wandern deine restlichen Programmeinstellungen rein
    settings = {
      program_options = {
        # Nix biegt die Pfade zu Kitty und Yazi automatisch richtig ab
        file_manager = "${pkgs.kitty}/bin/kitty -e ${pkgs.yazi}/bin/yazi";
        terminal = "${pkgs.kitty}/bin/kitty";
      };
    };
  };

  programs.yazi = {
    enable = true;
    enableZshIntegration = true; # Erlaubt schnelles Navigieren in der Shell

    # Hier wandert deine TOML-Konfiguration direkt als Nix-Struktur hinein
    settings = {
      mgr = {
        show_hidden = true;
      };

      opener = {
        vscode = [
          {
            # NixOS findet den Pfad zu VS Code hier automatisch aus dem System
            run = "${pkgs.vscode}/bin/code %s";
            orphan = true;
            for = "unix";
          }
        ];
      };

      open = {
        rules = [
          {
            url = "*";
            use = "vscode";
          }
        ];
      };
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
  };

  programs.obs-studio = {
    enable = true;

    package = (
      pkgs.obs-studio.override {
        cudaSupport = true;
      }
    );

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vaapi
      obs-gstreamer
      obs-vkcapture
    ];
  };
}
