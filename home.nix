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

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
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
    udiskie
    cliphist
    playerctl
    wl-clipboard
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

  # SYSTEM

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
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

  # FILES & CONFIGURATION

  home.file = {
    "wallpaper".source = ./wallpaper;
    "scripts".source = ./scripts;
    "themes/blackwhite".source = ./themes/blackwhite;
  };

  xdg.configFile = {
    "matugen".source = ./dotfiles/matugen;
    "obs-studio/basic".source = ./dotfiles/obs-studio/basic;
    "snappy-switcher".source = ./dotfiles/snappy-switcher;
    "spicetify".source = ./dotfiles/spicetify;
    "uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
  };

  # PROGRAMS

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

    initContent = ''
      bindkey '^[[3~' delete-char
      fastfetch
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

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    
    extraConfig = ''
      local success, colors = pcall(require, "colors")

      if not success then
          colors = {
              primary_container = "0xee1a1a1a"
          }
      end

      hl.monitor({
          output   = "HDMI-A-1",
          mode     = "2560x1440@144",
          position = "0x0",
          scale    = 1,
      })

      hl.monitor({
          output   = "eDP-1",
          mode     = "1920x1080@60",
          position = "2560x500",
          scale    = 1,
      })

      hl.monitor({
          output = "",
          mode = "preferred",
          position = "auto",
          scale = 1,
          mirror = "eDP-1"
      })

      hl.on("hyprland.start", function()
          hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")
          hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Ice'")

          hl.exec_cmd("xrandr --output HDMI-A-1 --primary")

          hl.exec_cmd("uwsm app -- wl-paste --type text --watch cliphist store")
          hl.exec_cmd("uwsm app -- wl-paste --type image --watch cliphist store")
          hl.exec_cmd("uwsm app -- udiskie &")
          hl.exec_cmd("uwsm app -- snappy-switcher --daemon")
          hl.exec_cmd("uwsm app -- awww-daemon")

          hl.exec_cmd("uwsm app -- discord --start-minimized")
          hl.exec_cmd("uwsm app -- spotify", { workspace = "6 silent" })

          hl.dispatch(hl.dsp.focus({ workspace = "1" }))
      end)

      for i = 1, 3 do
          hl.workspace_rule({ workspace = tostring(i), monitor = "HDMI-A-1", persistent = true })
      end

      for i = 4, 6 do
          hl.workspace_rule({ workspace = tostring(i), monitor = "eDP-1", persistent = true })
      end

      hl.config({
          general = {
              border_size      = 0,
              gaps_in          = 5,
              gaps_out         = 10,
              resize_on_border = true,
          },
          decoration = {
              rounding = 20,
              shadow   = {
                  enabled = true,
                  range = 10,
                  color = colors.primary_container
              }
          },
          input = {
              kb_layout = "de"
          },
      })

      hl.bind("CTRL + ALT + Delete", hl.dsp.exit())
      hl.bind("SUPER + left", hl.dsp.window.move({ direction = "left" }))
      hl.bind("SUPER + right", hl.dsp.window.move({ direction = "right" }))
      hl.bind("SUPER + up", hl.dsp.window.move({ direction = "up" }))
      hl.bind("SUPER + down", hl.dsp.window.move({ direction = "down" }))
      hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
      hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
      hl.bind("F11", hl.dsp.window.fullscreen())
      hl.bind("SUPER + F", hl.dsp.window.float({ action = "toggle" }))
      hl.bind("SUPER + S", hl.dsp.layout("togglesplit"))
      hl.bind("ALT + F4", hl.dsp.window.close())
      hl.bind("ALT + TAB", hl.dsp.exec_cmd("snappy-switcher next --workspace --mod alt"))

      hl.bind("SUPER + TAB", hl.dsp.exec_cmd("~/scripts/wallpaper.sh"))
      hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("~/scripts/theme.sh"))
      hl.bind("SUPER + SHIFT + V", hl.dsp.exec_cmd("uwsm app -- kitty --title=wiremix -e wiremix"))

      hl.bind("SUPER + ALT_L", hl.dsp.exec_cmd("uwsm app -- rofi -show drun -show-icons -disable-history"))
      hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("uwsm app -- hyprshot -m region --clipboard-only"))
      hl.bind("SUPER + L", hl.dsp.exec_cmd("uwsm app -- hyprlock"))
      hl.bind("SUPER + P", hl.dsp.exec_cmd("uwsm app -- hyprpicker -a"))
      hl.bind("SUPER + V", hl.dsp.exec_cmd("uwsm app -- cliphist list | rofi -dmenu -display-columns 2 | cliphist decode | wl-copy"))

      hl.bind("SUPER + Q", hl.dsp.exec_cmd("uwsm app -- kitty"))
      hl.bind("SUPER + E", hl.dsp.exec_cmd("uwsm app -- kitty -e yazi"))
      hl.bind("SUPER + B", hl.dsp.exec_cmd("uwsm app -- zen"))
      hl.bind("SUPER + M", hl.dsp.exec_cmd("uwsm app -- spotify"))
      hl.bind("SUPER + D", hl.dsp.exec_cmd("uwsm app -- discord"))
      hl.bind("SUPER + C", hl.dsp.exec_cmd("uwsm app -- code"))

      for i = 1, 6 do
          hl.bind("SUPER + " .. i, hl.dsp.focus({ workspace = i }))
          hl.bind("SUPER + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
      end

      hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
      hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
          { locked = true, repeating = true })
      hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
          { locked = true, repeating = true })
      hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
          { locked = true, repeating = true })
      hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
          { locked = true, repeating = true })
      hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
      hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
      hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
      hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
      hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
      hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

      hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0 }, { 0.35, 1 } } })

      hl.curve("rubber", { type = "spring", mass = 1, stiffness = 40, dampening = 10 })

      hl.animation({ leaf = "windows", enabled = true, speed = 2, bezier = "easeInOutCubic", style = "slide" })
      hl.animation({ leaf = "workspaces", enabled = true, speed = 2, spring = "rubber", style = "slide" })
    '';
  };

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

    modes = [ "drun" "window" ];

    extraConfig = {
      "drun" = {
        display-format =  "{name}";
      };
    };

    theme = let 
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
          font = "JetBrainsMono Nerd Font Propo 12";
          border-radius = mkLiteral "20px";
      };

      "#window" = {
          width = mkLiteral "800px";
          background-color = "@surface";
          border = 0;
          children = map mkLiteral [ "mainbox" ];
      };

      "#mainbox" = {
          padding = "24px";
          spacing = "20px";
          children = map mkLiteral [ "inputbar" "listview" ];
      };

      "#inputbar" = {
          children = map mkLiteral [ "entry" ];
      };

      "#entry" = {
          padding = mkLiteral "10px 50px";
          background-color = mkLiteral "@surface-container";
          placeholder-color = mkLiteral "@on-surface";
          text-color = mkLiteral "@on-surface";
          placeholder = "Search...";
      };

      "#listview" = {
          spacing = mkLiteral "16px";
          layout = vertical;
          border = 0;
          background-color = transparent;
          columns = 4;
          scrollbar = false;
          lines = 3;
          flow = horizontal;
          fixed-columns = true;
      };

      "#element" = {
          padding = mkLiteral "24px 16px";
          orientation = vertical;
          spacing = "16px";
          border-radius = "20px";
          children = map mkLiteral [ "element-icon" "element-text" ];
      };

      "#element-icon" = {
          size = "48px";
          horizontal-align = 0.5;
      };

      "#element-text" = {
          horizontal-align = 0.5;
      }

      "element normal.normal,
      element alternate.normal,
      element normal.active,
      element alternate.active" = {
          background-color = mkLiteral "@surface";
      };

      "element-text normal.normal,
      element-text alternate.normal,
      element-text normal.active, 
      element-text alternate.active" = {
          text-color = mkLiteral "@on-surface";
      };

      "element selected.normal,
      element selected.alternate,
      element selected.active" = {
          border = mkLiteral "2px";
          border-color = mkLiteral "@on-surface";
          background-color = mkLiteral "@surface-container";
      };

      "element-text selected.normal,
      element-text selected.alternate,
      element-text selected.active" = {
          text-color = mkLiteral "@on-surface";
      };
    }
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
          exec = "\${config.xdg.configHome}/scripts/waybar_weather.sh";
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
          on-click = "activate";
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

    style = ''
      @import "colors.css";

        * {
          font-family: "JetBrainsMono Nerd Font Propo";
          font-size: 16px;
          color: @on_surface;
          border-radius: 20px;
        }

        window#waybar {
          background-color: transparent;
        }

        #custom-arch-icon,
        #mpris,
        #custom-weather,
        #tray,
        #clock,
        #workspaces,
        #audio,
        #bluetooth,
        #network,
        #battery {
          background-color: @surface;
          padding: 0px 16px;
        }

        #tray menu {
          background-color: @surface;
          padding: 4px 8px;
        }

        #tray menuitem:hover {
          background-color: @surface_container;
        }

        #workspaces {
          padding: 2px 4px;
        }

        #workspaces button {
          background-color: @surface_container;
          margin: 4px;
        }

        #workspaces button.active {
          background-color: @primary;
        }

        #workspaces button.active label {
          color: @on_primary;
        }

        #pulseaudio-slider slider {
          min-height: 0px;
          min-width: 0px;
          opacity: 0;
          background-image: none;
          border: none;
          box-shadow: none
        }

        #pulseaudio-slider trough {
          min-height: 10px;
          min-width: 100px;
          background-color: @surface_container;
        }

        #pulseaudio-slider highlight {
          background-color: @primary;
        }

        #battery.charging {
          color: @primary;
        }

        #battery.warning {
          color: @inverse_surface;
        }

        #battery.critical {
          color: @error;
        }
    '';
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
