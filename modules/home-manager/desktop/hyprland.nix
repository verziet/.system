{
  pkgs,
  inputs,
  lib,
  config,
  host,
  ...
}: {
  options."hyprland".enableModule = lib.mkOption {
    description = "Enable the hyprland module";
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf config."hyprland".enableModule {
    wayland.windowManager.hyprland = {
      enable = lib.mkForce true;

      systemd.enable = lib.mkForce false; # Required for Hyprland UWSM
      package = lib.mkDefault inputs.hyprland.packages.${host.system}.hyprland;

      settings = lib.mkDefault {
        "$mainMod" = "SUPER";
        "$terminal" = "kitty";
        #"$menu" = "wofi";

        exec-once = lib.mkDefault [
          "swww-daemon"
        ];

        exec = lib.mkDefault [
          "kanata -c $HOME/kanata.kbd"
        ];

        monitor = lib.mkDefault [
          # TODO
          "eDP-1, 1920x1080@144, 0x0, 1.2"
        ];

        general = lib.mkDefault {
          gaps_in = lib.mkDefault 5;
          gaps_out = lib.mkDefault 10;

          border_size = lib.mkDefault 1;

          "col.active_border" = lib.mkDefault "rgba(ffffffff)";
          "col.inactive_border" = lib.mkDefault "rgba(ffffffff)";

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
