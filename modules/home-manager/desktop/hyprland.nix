{
  pkgs,
  inputs,
  lib,
  config,
  host,
  username,
  ...
}: {
  options."hyprland".enableModule = lib.mkOption {
    description = "Enable the hyprland module";
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf config."hyprland".enableModule {
    wayland.windowManager.hyprland = {
      enable = lib.mkForce true;

      plugins = [
        inputs.split-monitor-workspaces.packages.${host.system}.split-monitor-workspaces
      ];

      systemd.enable = lib.mkForce false; # Required for Hyprland UWSM
      package = lib.mkDefault inputs.hyprland.packages.${host.system}.hyprland;

      settings = lib.mkDefault {
        plugin = lib.mkDefault {
          split-monitor-workspaces = lib.mkDefault {
            count = lib.mkDefault 10;
            keep_focused = lib.mkDefault 0;
            enable_notifications = lib.mkDefault 0;
            enable_persistent_workspaces = lib.mkDefault 1;
          };
        };

        "$mainMod" = "SUPER";
        "$terminal" = "kitty";
        #"$menu" = "wofi";

        exec-once = lib.mkDefault [
          "swww-daemon"
        ];

        exec = lib.mkDefault [
          "kanata -c $HOME/kanata.kbd"
          "ags run /home/${username}/.config/ags/simple-bar"
          "ags run /home/${username}/.config/ags/applauncher"
        ];

        monitor = lib.mkDefault [
          # TODO
          "desc:Chimei Innolux Corporation 0x1521, 1920x1080@144, 0x0, 1.2"
          "desc:Microstep MSI G27CQ4 0x000008D3,2560x1440@120,-320x-1440,1"
          "desc:Vestel Elektronik Sanayi ve Ticaret A. S. 24W_LCD_TV,1920x1080@60,-1400x-1440,1,transform,1"
        ];

        general = lib.mkDefault {
          gaps_in = lib.mkDefault 5;
          gaps_out = lib.mkDefault 10;

          border_size = lib.mkDefault 1;

          "col.active_border" = lib.mkDefault "rgba(00000000)";
          "col.inactive_border" = lib.mkDefault "rgba(00000000)";

          resize_on_border = lib.mkDefault true;

          allow_tearing = lib.mkDefault false;
          layout = lib.mkDefault "dwindle";
        };

        decoration = lib.mkDefault {
          rounding = lib.mkDefault 0;

          active_opacity = lib.mkDefault 1.0;
          inactive_opacity = lib.mkDefault 1.0;

          shadow.enabled = lib.mkDefault false;
          blur.enabled = lib.mkDefault false;
        };

        animations = lib.mkDefault {
          enabled = lib.mkDefault true;
          # TODO
        };

        dwindle = lib.mkDefault {
          pseudotile = lib.mkDefault true;
          preserve_split = lib.mkDefault true;
        };

        misc = lib.mkDefault {
          force_default_wallpaper = lib.mkDefault 0;
          disable_hyprland_logo = lib.mkDefault true;
        };

        # INPUT
        input = lib.mkDefault {
          kb_layout = lib.mkDefault "us,cz";
          kb_variant = lib.mkDefault ",qwerty";
          kb_options = lib.mkDefault "grp:menu_toggle";

          follow_mouse = lib.mkDefault 1;

          sensitivity = lib.mkDefault 0;

          touchpad.natural_scroll = lib.mkDefault true;
        };

        gestures = lib.mkDefault {
          #TODO
          workspace_swipe = lib.mkDefault true;
          workspace_swipe_invert = lib.mkDefault false;
          workspace_swipe_forever = lib.mkDefault true;
        };

        windowrulev2 = lib.mkDefault [
          "suppressevent maximize, class:.*"
          "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
        ];

        workspace =
          lib.mkDefault [
          ];

        bind = lib.mkDefault [
          "$mainMod,       Q, exec, $terminal"
          "$mainMod,       SPACE, exec, ags toggle launcher --instance launcher"
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

          # Switching monitors
          "Super_R&Alt_R&Shift_R, 1, focusmonitor, desc:Chimei Innolux Corporation 0x1521"
          "Super_R&Alt_R&Shift_R, 2, focusmonitor, desc:Microstep MSI G27CQ4 0x000008D3"
          "Super_R&Alt_R&Shift_R, 3, focusmonitor, desc:Vestel Elektronik Sanayi ve Ticaret A. S. 24W_LCD_TV"

          # Switching workspaces
          "$mainMod, 1, split-workspace, 1"
          "$mainMod, 2, split-workspace, 2"
          "$mainMod, 3, split-workspace, 3"
          "$mainMod, 4, split-workspace, 4"
          "$mainMod, 5, split-workspace, 5"
          "$mainMod, 6, split-workspace, 6"
          "$mainMod, 7, split-workspace, 7"
          "$mainMod, 8, split-workspace, 8"
          "$mainMod, 9, split-workspace, 9"
          "$mainMod, 0, split-workspace, 10"

          # Moving windows to workspaces
          "$mainMod SHIFT, 1, split-movetoworkspacesilent, 1"
          "$mainMod SHIFT, 2, split-movetoworkspacesilent, 2"
          "$mainMod SHIFT, 3, split-movetoworkspacesilent, 3"
          "$mainMod SHIFT, 4, split-movetoworkspacesilent, 4"
          "$mainMod SHIFT, 5, split-movetoworkspacesilent, 5"
          "$mainMod SHIFT, 6, split-movetoworkspacesilent, 6"
          "$mainMod SHIFT, 7, split-movetoworkspacesilent, 7"
          "$mainMod SHIFT, 8, split-movetoworkspacesilent, 8"
          "$mainMod SHIFT, 9, split-movetoworkspacesilent, 9"
          "$mainMod SHIFT, 0, split-movetoworkspacesilent, 10"

          # Scratchpad
          "$mainMod,       S, togglespecialworkspace,  magic"
          "$mainMod SHIFT, S, split-movetoworkspace, special:magic"
        ];

        # Move/resize windows with mainMod + LMB/RMB and dragging
        bindm = lib.mkDefault [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        # Laptop multimedia keys for volume and LCD brightness
        bindel = lib.mkDefault [
          ",XF86AudioRaiseVolume,  exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86AudioLowerVolume,  exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ",XF86MonBrightnessUp,   exec, brightnessctl s 5%+"
          ",XF86MonBrightnessDown, exec, brightnessctl s 5%- -n 1"
        ];

        bindl = lib.mkDefault [
          ",XF86AudioNext,  exec, playerctl next"
          ",XF86AudioPause, exec, playerctl play-pause"
          ",XF86AudioPlay,    exec, playerctl play-pause"
          ",XF86AudioPrev,    exec, playerctl previous"
          ",XF86AudioMute,         exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ",XF86AudioMicMute,      exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ];
      };
    };
  };
}
