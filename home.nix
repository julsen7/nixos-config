{ config, pkgs, lib, inputs, ... }:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  imports = [
    inputs.spicetify-nix.homeManagerModules.spicetify
  ];

  # GENERAL

  home.username = "julsen";
  home.homeDirectory = "/home/julsen";
  home.stateVersion = "26.05";

  # THEMING & CURSOR

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };

  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
    name = "Bibata-Modern-Ice";
    size = 24;
    package = pkgs.bibata-cursors;
  };

  # PACKAGES

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
    brightnessctl
    awww
    cliphist
    hyprpolkitagent
    hyprpicker
    hyprshot
    inputs.snappy-switcher.packages.${pkgs.stdenv.hostPlatform.system}.default
    matugen
    btop
    bluetui
    wiremix
    nvtopPackages.full
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    discord
    gimp
    krita
    audacity
    obsidian
    easyeffects
    davinci-resolve
    prismlauncher
    heroic
    vlc
    libbluray
    libreoffice-fresh
    # onlyoffice-desktopeditors
    # wpsoffice
    keepassxc
    github-cli
    _7zz
    gcc
    # gnumake
    # binutils
    # pkg-config
    jdk
    # jdk26 ?
    # python ?
    # maven ?
    # gradle
    # libosinfo
    # bridge-utils
    # dnsmasq
    (texliveMedium.withPackages (ps: with ps; [
      biber
      collection-latexextra
      collection-fontsrecommended
    ]))
    tex-fmt
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

  wayland.windowManager.hyprland.systemd.enable = false;

  home.sessionVariables = {
    EDITOR = "code";
    HYPRCURSOR_THEME = "Bibata-Modern-Ice";
    HYPRCURSOR_SIZE = "24";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/share/icons"
    "${config.home.homeDirectory}/.spicetify"
  ];

  xdg.configFile = {
    "hypr".source = ./dotfiles/hypr;
    "obs-studio".source = ./dotfiles/obs-studio;
    "rofi".source = ./dotfiles/rofi;
    "snappy-switcher".source = ./dotfiles/snappy-switcher;
    "uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
    "waybar/style.css".source = ./dotfiles/waybar/style.css;
    "waybar/colors.css".source = ./dotfiles/waybar/colors.css;
    "waybar/scripts".source = ./dotfiles/waybar/scripts;
    "wallpaper".source = ./wallpaper;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      ignoreAllDups = true;
      saveNoDups = true;
      size = 10000;
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

    completionInit = ''
      zstyle ':completion:*' menu select
      zstyle ':completion:*' use-cache on
      zstyle ':completion:*' cache-path ~/.cache/zsh/
      autoload -U compinit && compinit
    '';

    # initContent = ''
    #   bindkey '^[[3~' delete-char
    # '';
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

  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
      user = {
        name  = "julsen7";
        email = "263753131+julsen7@users.noreply.github.com";
      };
      "credential \"https://github.com\"" = {
          helper = "${pkgs.github-cli}/bin/gh auth git-credential";
      };
      "credential \"https://gist.github.com\"" = {
          helper = "${pkgs.github-cli}/bin/gh auth git-credential";
      };
    };
  };

  programs.vscode = {
    enable = true;
    profiles.default = {
      userSettings = {
        "explorer.confirmDelete" = false;
        "workbench.iconTheme" = "material-icon-theme";
        "workbench.secondarySideBar.defaultVisibility" = "hidden";
        "explorer.confirmDragAndDrop" = false;
        "git.confirmSync" = false;
        "git.autofetch" = true;
        "editor.fontFamily" = "'JetBrainsMono Nerd Font Propo', 'Droid Sans Mono', monospace";
        "explorer.confirmPasteNative" = false;
        "latex-workshop.latex.autoBuild.run" = "onFileChange";
        "files.autoSave" = "afterDelay";
        "workbench.startupEditor" = "none";
        "files.exclude" = {
          "**/.git" = false;
        };
        "latex-workshop.formatting.latex" = "tex-fmt";
        "github.copilot.enable" = {
          "*" = false;
          "plaintext" = false;
          "markdown" = false;
          "scminput" = false;
        };
        "workbench.colorTheme" = "GitHub Dark Default";
        "Lua.workspace.library" = [
          "/usr/share/hypr/stubs"
        ];
        "files.simpleDialog.enable" = true;
      };
      extensions = with pkgs.vscode-extensions; [
        bbenoist.nix
        cweijan.dbclient-jdbc
        cweijan.vscode-database-client2
        davidanson.vscode-markdownlint
        eamodio.gitlens
        ecmel.vscode-html-css
        github.github-vscode-theme
        haskell.haskell
        james-yu.latex-workshop
        ms-python.debugpy
        ms-python.python
        ms-python.vscode-pylance
        ms-vscode.cmake-tools
        ms-vscode.cpptools
        ms-vscode.cpptools-extension-pack
        pkief.material-icon-theme
        redhat.java
        ritwickdey.liveserver
        sumneko.lua
        tamasfe.even-better-toml
        vscjava.vscode-gradle
        vscjava.vscode-java-debug
        vscjava.vscode-java-dependency
        vscjava.vscode-java-pack
        vscjava.vscode-java-test
        vscjava.vscode-maven
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "language-haskell";
          publisher = "haskell";
          version = "3.8.0";
          sha256 = "sha256-wDGvGKI+YDwkbYKV0ijnB3+NwWPZAuwLN4MpFV37KFs=";
        }
        {
          name = "cpp-devtools";
          publisher = "ms-vscode";
          version = "0.5.13";
          sha256 = "sha256-g8ZXdEgKB6okJEVXvFQMGz5oDMsOh5mWzl50B/etVjw=";
        }
        {
          name = "cpptools-themes";
          publisher = "ms-vscode";
          version = "2.0.0";
          sha256 = "sha256-YWA5UsA+cgvI66uB9d9smwghmsqf3vZPFNpSCK+DJxc=";
        }
        {
          name = "prolog";
          publisher = "rebornix";
          version = "0.0.4";
          sha256 = "sha256-SZAaG3dFlDbA46s+i36CMBOU5vJ+1bgTgk+TTyi+yhA=";
        }
        {
          name = "logo-lang";
          publisher = "zion-school";
          version = "0.8.1";
          sha256 = "sha256-LvM51DKHa9G1/EAelCnB0jQL7bRBLvAgYDHQR/MR6Xc=";
        }
      ];
    };
  };

  services.dunst = {
    enable = true;
    settings = {
      global = {
        monitor = 0;
        enable_posix_regex = true;
        width = 400;
        height = "(0, 300)";
        offset = "(4, 10)";
        icon_corner_radius = 10;
        frame_width = 0;
        gap_size = 5;
        font = "JetBrainsMono Nerd Font Propo 10";
        dmenu = "${pkgs.rofi}/bin/rofi -dmenu -p dunst:";
        corner_radius = 20;
        # icon_path = "/usr/share/icons/Adwaita/16x16/devices/";
        icon_theme = "Adwaita, breeze";
        enable_recursive_icon_lookup = true;
        min_icon_size = 32;
        max_icon_size = 64;
        fullscreen = "suppress";
      };
      
      fullscreen_critical = {
        msg_urgency = "critical";
        fullscreen = "show";
      };

      urgency_low = {
        background = "#19120d";
        foreground = "#f0dfd7";
      };

      urgency_normal = {
        background = "#19120d";
        foreground = "#f0dfd7";
        override_pause_level = 30;
      };

      urgency_critical = {
        background = "#19120d";
        foreground = "#f0dfd7";
        timeout = 0;
        override_pause_level = 60;
      };
    };
  };

  # easyeffects

  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        # type = "none";
        source = "nixos_small";
      };
      display = {
        separator = " ";
      };
      modules = [
        {
            type = "custom";
            key = " ";
        }
        {
            type = "custom";
            key = "    ___              __  ";
        }
        {
            type = "custom";
            key = "   /   |  __________/ /_ ";
        }
        {
            type = "custom";
            key = "  / /| | / ___/ ___/ __ \\";
        }
        {
            type = "custom";
            key = " / ___ |/ /  / /__/ / / /";
        }
        {
            type = "custom";
            key = "/_/  |_/_/   \\___/_/ /_/ ";
        }
        {
            type = "custom";
            key = " ";
        }
        {
            type = "custom";
            key = "╭────────────╮";
        }
        {
            type = "title";
            key = "│ {#34}  user    {#keys}│";
            format = "{user-name}";
        }
        {
            type = "title";
            key = "│ {#34}󰇅  hname   {#keys}│";
            format = "{host-name}";
        }
        {
            type = "uptime";
            key = "│ {#34}󰅐  uptime  {#keys}│";
        }
        {
            type = "os";
            key = "│ {#34}{icon}  distro  {#keys}│";
        }
        {
            type = "kernel";
            key = "│ {#34}  kernel  {#keys}│";
        }
        {
            type = "wm";
            key = "│ {#34}  wm      {#keys}│";
        }
        {
            type = "de";
            key = "│ {#34}󰇄  desktop {#keys}│";
        }
        {
            type = "terminal";
            key = "│ {#34}  term    {#keys}│";
        }
        {
            type = "shell";
            key = "│ {#34}  shell   {#keys}│";
        }
        {
            type = "packages";
            key = "│ {#34}󰏓  pkgs    {#keys}│";
        }
        {
            type = "cpu";
            key = "│ {#34}󰍛  cpu     {#keys}│";
            showPeCoreCount = true;
        }
        {
            type = "gpu";
            key = "│ {#34}󰍛  gpu     {#keys}│";
            showPeCoreCount = true;
        }
        {
            type = "disk";
            key = "│ {#34}󰉉  disk    {#keys}│";
            folders = "/";
        }
        {
            type = "memory";
            key = "│ {#34}  memory  {#keys}│";
        }
        {
            type = "custom";
            key = "├────────────┤";
        }
        {
            type = "colors";
            key = "│ {#34} colors   {#keys}│";
            symbol = "circle";
        }
        {
            type = "custom";
            key = "╰────────────╯";
        }
      ];
    };
  };

  # hyprland

  programs.hyprlock = {
    enable = true;
    extraConfig = "source = \${config.xdg.configHome}/hypr/colors.conf";

    settings = {
      general = {
        hide_cursor = true;
      };

      # auth = [
      #   {
      #     pam:enabled = true:
      #     pam:module = "hyprlock";
      #     fingerprint:enabled = false;
      #     fingerprint:ready_message = "(Scan fingerprint to unlock)";
      #     fingerprint:present_message = "Scanning fingerprint";
      #     fingerprint:retry_delay = 250;
      #   };
      # ];

      background = [
        {
          monitor = "";
          path = "$image";
        }
      ];

      "input-field" = [
        {
          monitor = "";
          size = "250, 50";
          outline_thickness = 0;
          inner_color = "$on_surface";
          font_color = "$surface";
          check_color = "$primary";
          fail_color = "$error";
          fade_on_empty = false;
          font_family = "JetBrainsMono Nerd Font";
          capslock_color = "$tertiary";
        }
      ];

      label = [
        {
          monitor = "";
          text = "$TIME"; 
          color = "$primary";
          font_size = 55;
          font_family = "Noto Sans";
          position = "0, 80";
        }
      ];
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
      
      enable_audio_bell = false;
      
      window_padding_width = 30;
      confirm_os_window_close = 0;
      
      shell = "zsh";
    };

    extraConfig = ''
      include current-theme.conf
    '';
  };

  # matugen

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

  programs.rofi = {
    enable = true;
    
    extraConfig = {
      modes = [ "drun" "window" ];
      drun-display-format = "{name}";
    };

    theme = {
      "@import" = "colors.rasi";

      "*" = {
        font = "JetBrainsMono Nerd Font Propo 12";
        border-radius = "20px";
      };

      "window" = {
        width = "800px";
        background-color = "@surface";
        border = 0;
        children = [ "mainbox" ];
      };

      "mainbox" = {
        padding = "24px";
        spacing = "20px";
        children = [ "inputbar" "listview" ];
      };

      "inputbar" = {
        children = [ "entry" ];
      };

      "entry" = {
        padding = "10px 50px";
        background-color = "@surface-container";
        placeholder-color = "@on-surface";
        text-color = "@on-surface";
        placeholder = "Search...";
      };

      "listview" = {
        spacing = "16px";
        layout = "vertical";
        border = 0;
        background-color = "transparent";
        columns = 4;
        scrollbar = false;
        lines = 3;
        flow = "horizontal";
        fixed-columns = true;
      };

      "element" = {
        padding = "24px 16px";
        orientation = "vertical";
        spacing = "16px";
        border-radius = "20px";
        children = [ "element-icon" "element-text" ];
      };

      "element-icon" = {
        size = "48px";
        horizontal-align = "0.5";
      };

      "element-text" = {
        horizontal-align = "0.5";
      };

      "element normal.normal, element alternate.normal, element normal.active, element alternate.active" = {
        background-color = "@surface";
      };

      "element-text normal.normal, element-text alternate.normal, element-text normal.active, element-text alternate.active" = {
        text-color = "@on-surface";
      };

      "element selected.normal, element selected.alternate, element selected.active" = {
        border = "2px";
        border-color = "@on-surface";
        background-color = "@surface-container";
      };

      "element-text selected.normal, element-text selected.alternate, element-text selected.active" = {
        text-color = "@on-surface";
      };
    };
  };

  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      adblockify
      hidePodcasts
      shuffle
    ];
    theme = {
      name = "Theme";
      src = ./dotfiles/spicetify/Themes/Theme;
      appendName = false;
    };
    colorScheme = "Theme";
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;

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
    settings = {
      program_options = {
        file_manager = "${pkgs.kitty}/bin/kitty -e ${pkgs.yazi}/bin/yazi";
        terminal = "${pkgs.kitty}/bin/kitty";
      };
    };
  };

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        margin-top = 10;
        margin-left = 10;
        margin-right = 10;
        margin-bottom = 0;
        spacing = 5;

        modules-left = [
          "custom/arch-icon"
          "mpris"
          "custom/weather"
          "tray"
        ];
        modules-center = [
          "clock"
          "hyprland/workspaces"
        ];
        modules-right = [
          "group/audio"
          "bluetooth"
          "network"
          "battery"
        ];

        # =========================================================================
        # MODULES LEFT
        # =========================================================================
        "custom/arch-icon" = {
          format = "󰣇";
          on-click = "uwsm app -- kitty";
          tooltip = false;
        };

        mpris = {
          format = "{player_icon} {status_icon} {title} - {artist} <span color='#808080'>{position}|{length}</span>";
          interval = 1;
          max-length = 40;
          player-icons = {
            spotify = "";
            firefox = "";
          };
          status-icons = {
            playing = "";
            paused = "";
          };
        };

        "custom/weather" = {
          exec = "\${config.xdg.configHome}/waybar/scripts/weather.sh";
          format = "{}";
          return-type = "json";
          interval = 1800;
          tooltip = true;
        };

        tray = {
          spacing = 10;
          show-passive-items = false;
        };

        # =========================================================================
        # MODULES CENTER
        # =========================================================================
        "hyprland/workspaces" = {
          format = "{windows}";
          on-click = "hyprctl dispatch hl.dsp.focus({ workspace = {icon} })";
          window-rewrite-default = "";
          window-rewrite = {
            "class<kitty>" = "";
            "class<zen>" = "";
            "class<code>" = "󰨞";
            "class<spotify>" = "";
            "class<discord>" = "";
            "class<obs>" = "󱜠";
            "class<blender>" = "󰂫";
            "class<steam>" = "";
            "class<krita>" = "";
            "class<gimp>" = "";
            "class<.*virtu.*>" = "󰍺";
            "class<.*prism.*>" = "";
            "title<.*minecraft.*>" = "󰍳";
            "class<zen> title<.*youtube.*>" = "";
            "class<zen> title<.*twitch.*>" = "";
            "class<zen> title<.*gmail.*>" = "󰊫";
            "class<zen> title<.*moodle.*>" = "";
          };
        };

        clock = {
          tooltip = false;
        };

        # =========================================================================
        # MODULES RIGHT
        # =========================================================================
        "group/audio" = {
          orientation = "horizontal";
          modules = [
            "pulseaudio"
            "pulseaudio/slider"
            "pulseaudio#microphone"
          ];
        };

        pulseaudio = {
          format = "{icon}";
          format-muted = "";
          format-bluetooth = "{icon}";
          format-icons = {
            headphone = "󰋋";
            headset = "󰋎";
            default = [
              ""
              ""
              ""
            ];
          };
          tooltip-format = "{desc}";
          on-click = "wpctl set-mute @DEFAULT_SINK@ toggle";
          on-click-right = "uwsm app -- kitty --title=wiremix -e wiremix";
        };

        "pulseaudio#microphone" = {
          format = "{format_source}";
          format-source = "";
          format-source-muted = "";
          tooltip-format = "{source_desc}";
          on-click = "wpctl set-mute @DEFAULT_SOURCE@ toggle";
          on-click-right = "uwsm app -- kitty --title=wiremix -e wiremix";
        };

        bluetooth = {
          format = "󰂯 {num_connections}";
          on-click = "uwsm app -- kitty --title=bluetui -e bluetui";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}";
        };

        network = {
          format = "";
          format-ethernet = "󰌗";
          format-wifi = " {essid}";
          tooltip-format-ethernet = " {bandwidthDownBytes}  {bandwidthUpBytes}";
          tooltip-format-wifi = " {bandwidthDownBytes}  {bandwidthUpBytes} | {signalStrength}%";
          on-click = "uwsm app -- kitty --title=nmtui-go -e nmtui-go";
        };

        battery = {
          format = "{icon} {capacity}%";
          states = {
            warning = 30;
            critical = 15;
          };
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };
      };
    };
  };

  # wireplumber

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
            run = "uwsm app -- code %s";
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
}
