{ config, pkgs, ... }:

{
  home.username = "julsen";
  home.homeDirectory = "/home/julsen";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    awww
    blender
    bluetui
    btop
    chromium
    discord
    cliphist
    dunst
    easyeffects
    gimp
    github-cli
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

  xdg.configFile = {
    "dunst/dunstrc".source = ./dotfiles/dunst/dunstrc;
    "hypr/hyprland.lua".source = ./dotfiles/hypr/hyprland.lua;
    "obs-studio/hyprland.lua".source = ./dotfiles/obs-studio;
    "rofi/config.rasi".source = ./dotfiles/rofi/config.rasi;
    "waybar".source = ./dotfiles/waybar;
  };

  home.sessionVariables = {
    EDITOR = "code";
    HYPRCURSOR_THEME = "Bibata-Modern-Ice";
    HYPRCURSOR_SIZE = "24";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/share/icons"
    "${config.home.homeDirectory}/.spicetify"
  ];

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "Bibata-Modern-Ice";
    size = 24;
    package = pkgs.bibata-cursors;
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };

  programs.git = {
    enable = true;
    userName  = "julsen7";
    userEmail = "263753131+julsen7@users.noreply.github.com";
    init.defaultBranch = "main";

    extraConfig = {
      "credential \"https://github.com\"" = {
        helper = "${pkgs.github-cli}/bin/gh auth git-credential";
      };
      "credential \"https://gist.github.com\"" = {
        helper = "${pkgs.github-cli}/bin/gh auth git-credential";
      };
    };
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    history = {
      append = true;
      ignoreAllDups = true;
      saveNoDups = true;
      size = 10000;
      path = "`\${config.programs.zsh.dotDir}/.zsh_history`";
    };
    
    shellAliases = {
      ls = "eza --icons --group-directories-first --color=always";
      ll = "eza -lh --icons --group-directories-first";
      lt = "eza --tree --level=2 --icons";
      la = "eza -a --icons";
      lla = "eza -lha --icons --group-directories-first";
      cd = "z";
      cl = "clear";
      update = "sudo nixos-rebuild switch --flake ~/nixos-config#$(hostname)";
    };

    syntaxHighlighting.enable = true;

    completionInit = ''
      zstyle ':completion:*' menu select
      zstyle ':completion:*' use-cache on
      zstyle ':completion:*' cache-path ~/.cache/zsh/
      autoload -U compinit && compinit
    '';

    initContent = ''
      bindkey '^[[3~' delete-char
    '';
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fastfetch = {
    settings = {
      logo = {
        source = "nixos_small";
        padding = {
          right = 1;
        };
      };
      display = {
        size = {
          binaryPrefix = "si";
        };
        color = "blue";
        separator = "  ";
      };
      modules = [
        {
          type = "datetime";
          key = "Date";
          format = "{1}-{3}-{11}";
        }
        {
          type = "datetime";
          key = "Time";
          format = "{14}:{17}:{20}";
        }
        "break"
        "player"
        "media"
      ];
    };
  };

  programs.kitty = {
    enable = true;
    dynamic_background_opacity = true;
    enable_audio_bell = false;
    mouse_hide_wait = "3.0";
    window_padding_width = 30;

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
      add_newline = true;
      format = lib.concatStrings [
        "$os"
        "$directory"
        "$git_branch"
        "$git_status"
        "$fill"
        "$all"
        "$cmd_duration"
        "$time"
        "$line_break"
        "$character"
      ];

      os = {
        format = "[$symbol]($style) ";
        disabled = false;
        # Hier ändern wir das Symbol für dein neues NixOS-System!
        symbols = {
          NixOS = "";
        };
      };

      directory = {
        format = "[󰉋 $path]($style)[$read_only]($read_only_style) ";
        truncate_to_repo = false;
        substitutions = {
          "Documents" = "󰈙 Documents";
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
        symbol = "󰬷";
        style = "#ed8b00";
      };

      c = {
        format = " [\${symbol} (\${version})]($style) ";
        symbol = "󰙱";
        style = "#3848a9";
      };

      cpp = {
        format = " [\${symbol} (\${version})]($style) ";
        symbol = "󰙲";
        style = "#00599c";
      };

      haskell = {
        format = " [\${symbol} (\${version})]($style) ";
        symbol = "󰲒";
        style = "#5e5086";
      };

      kotlin = {
        format = " [\${symbol} (\${version})]($style) ";
        symbol = "󱈙";
      };

      python = {
        format = " [\${symbol} (\${version})]($style) ";
        symbol = "󰌠";
        style = "#ffd43b";
      };

      cmd_duration = {
        format = " 󱦟 [$duration]($style) ";
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
    enableZshIntegration = true;

    settings = {
      mgr = {
        show_hidden = true;
      };

      opener = {
        vscode = [
          {
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

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        ignore_empty_input = true;
      };

      animations = {
        enabled = true;
        fade_in = {
          duration = 300;
          bezier = "easeOutQuint";
        };
        fade_out = {
          duration = 300;
          bezier = "easeOutQuint";
        };
      };

      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      input-field = [
        {
          size = "250, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
          outline_thickness = 5;
          placeholder_text = ''<span foreground="##cad3f5">Password...</span>'';
          shadow_passes = 2;
        }
      ];
    };
  };

  # programs.obs-studio = {
  #   enable = true;

  #   package = (
  #     pkgs.obs-studio.override {
  #       cudaSupport = true;
  #     }
  #   );

  #   plugins = with pkgs.obs-studio-plugins; [
  #     wlrobs
  #     obs-backgroundremoval
  #     obs-pipewire-audio-capture
  #     obs-vaapi
  #     obs-gstreamer
  #     obs-vkcapture
  #   ];
  # };
}
