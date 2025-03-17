# empty for now
{
  pkgs,
  pkgs-stable,
  pkgs-master,
  inputs,
  lib,
  host,
  hostname,
  username,
  configuration,
  ...
}: {
  imports = [
    ./packages.nix
    inputs.spicetify-nix.homeManagerModules.default
    inputs.nixcord.homeManagerModules.nixcord
    inputs.ags.homeManagerModules.default
    inputs.textfox.homeManagerModules.default
  ];

  programs.git = {
    enable = true;
    extraConfig = {
      user.name = "verz";
      user.email = "verzleet@gmail.com";
      init.defaultBranch = "main";
    };
  };

  /*

  programs.ags = {
    enable = true;
    configDir = null; # if ags dir is managed by home-manager, it'll end up being read-only. not too cool.
    # configDir = ./.config/ags;

    extraPackages = with pkgs; [
      gtksourceview
      gtksourceview4
      python311Packages.material-color-utilities
      python311Packages.pywayland
      pywal
      sassc
      webkitgtk
      webp-pixbuf-loader
      ydotool
    ];
  };
  */

  programs.vscode.enable = true;

  programs.nixcord = {
    enable = true; # enable Nixcord. Also installs discord package
    quickCss = ""; # quickCSS file
    config = {
      useQuickCss = false; # use out quickCSS
      themeLinks = [
        "https://raw.githubusercontent.com/refact0r/system24/refs/heads/main/theme/system24.theme.css"
      ];
      frameless = true; # set some Vencord options
      plugins = {
        hideAttachments.enable = true; # Enable a Vencord plugin
        /*
          ignoreActivities = {    # Enable a plugin and set some options
          enable = true;
          ignorePlaying = true;
          ignoreWatching = true;
          ignoredActivities = [ "someActivity" ];
        };
        */
      };
    };
    extraConfig = {
      # Some extra JSON config here
      # ...
    };
  };

  textfox = {
    enable = true;
    profile = "${username}";
    config = {
      # Optional config
    };
  };

  xdg.desktopEntries = {
    control-center = {
      name = "Control Center";
      genericName = "Control Center";
      type = "Application";
      exec = "env XDG_CURRENT_DESKTOP=GNOME ${pkgs.gnome-control-center}/bin/gnome-control-center";
      terminal = false;
      categories = ["Application"];
    };
  };

  programs = {
    kitty.enable = true;

    spicetify = let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${host.system};
    in {
      enable = true;
      enabledCustomApps = [
        {
          # The source of the customApp
          # make sure you're using the correct branch
          # It could also be a sub-directory of the repo
          src = pkgs.fetchFromGitHub {
            owner = "spicetify";
            repo = "cli";
            rev = "main";
            hash = "sha256-2fsHFl5t/Xo7W5IHGc5FWY92JvXjkln6keEn4BZerw4=";
          };
          # The actual file name of the customApp usually ends with .js
          name = "lyrics-plus";
        }
      ];

      enabledExtensions = with spicePkgs.extensions; [
        adblock
        hidePodcasts
        shuffle
      ];

      theme = spicePkgs.themes.text;
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false; # Required for Hyprland UWSM
    package = inputs.hyprland.packages.${host.system}.hyprland;

    settings = {
      "$mainMod" = "SUPER";
      "$terminal" = "kitty";
      #"$menu" = "wofi";

      exec-once = [
        "swww-daemon"
      ];

      exec = [
        "kanata -c $HOME/kanata.kbd"
      ];

      monitor = [
        # TODO
        "eDP-1, 1920x1080@144, 0x0, 1.2"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 10;

        border_size = 1;

        "col.active_border" = lib.mkForce "rgba(ffffffff)";
        "col.inactive_border" = lib.mkForce "rgba(ffffffff)";

        resize_on_border = true;

        allow_tearing = false;
        layout = "dwindle";
      };

      decoration = {
        rounding = 0;

        active_opacity = 1.0;
        inactive_opacity = 1.0;

        shadow.enabled = false;
        blur.enabled = false;
      };

      animations = {
        enabled = true;
        # TODO
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };

      # INPUT
      input = {
        kb_layout = "us,cz";
        kb_variant = ",qwerty";
        kb_options = "grp:menu_toggle";

        follow_mouse = 1;

        sensitivity = 0;

        touchpad.natural_scroll = true;
      };

      gestures = {
        #TODO
        workspace_swipe = true;
        workspace_swipe_invert = false;
        workspace_swipe_forever = true;
      };

      windowrulev2 = [
        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];

      workspace = [
      ];

      bind = [
        "$mainMod,       Q, exec, $terminal"
        "$mainMod,       SPACE, exec, wofi --show drun"
        "$mainMod,       C, killactive,"
        "$mainMod,       M, exit,"
        "$mainMod,       F, togglefloating,"
        "$mainMod,       P, pseudo,"
        "$mainMod,       J, togglesplit,"

        # Moving focus
        "$mainMod, H, movefocus, l"
        "$mainMod, L, movefocus, r"
        "$mainMod, K, movefocus, u"
        "$mainMod, J, movefocus, d"

        # Moving windows
        "$mainMod CTRL, H,  swapwindow, l"
        "$mainMod CTRL, L, swapwindow, r"
        "$mainMod CTRL, K,    swapwindow, u"
        "$mainMod CTRL, J,  swapwindow, d"

        # Resizeing windows                   X  Y
        "$mainMod SHIFT, H,  resizeactive, -60 0"
        "$mainMod SHIFT, L, resizeactive,  60 0"
        "$mainMod SHIFT, K,    resizeactive,  0 -60"
        "$mainMod SHIFT, J,  resizeactive,  0  60"

        # Switching workspaces
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Moving windows to workspaces
        "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
        "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
        "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
        "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
        "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
        "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
        "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
        "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
        "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
        "$mainMod SHIFT, 0, movetoworkspacesilent, 10"

        # Scratchpad
        "$mainMod,       S, togglespecialworkspace,  magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"
      ];

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      # Laptop multimedia keys for volume and LCD brightness
      bindel = [
        ",XF86AudioRaiseVolume,  exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume,  exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86MonBrightnessUp,   exec, brightnessctl s 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 5%- -n 1"
      ];

      bindl = [
        ",XF86AudioNext,  exec, playerctl next"
        ",XF86AudioPause, exec, playerctl play-pause"
        ",XF86AudioPlay,    exec, playerctl play-pause"
        ",XF86AudioPrev,    exec, playerctl previous"
        ",XF86AudioMute,         exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute,      exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ];
    };
  };

  home.file = {
    ".zshrc" = {
      text = ''
        alias hyprland="exec uwsm start hyprland-uwsm.desktop"
        alias gnome="XDG_SESSION_TYPE=wayland exec dbus-run-session gnome-session"
        export EDITOR=vim
               set -o vi
               bindkey '^H' backward-kill-word
               bindkey '5~' kill-word
        clear
      '';
    };

    ".config/uwsm/env-hyprland" = {
      text = ''
        export AQ_DRM_DEVICES="/dev/dri/card1:/dev/dri/card0; # card 0 is nvidia
      '';
    };

    #todo this should be host specific instead
    ".config/uwsm/env" = {
      text = ''
        export LIBVA_DRIVER_NAME=nvidia
        export __GLX_VENDOR_LIBRARY_NAME=nvidia
        export NIXOS_OZONE_WL=1
      '';
    };
  };
}
