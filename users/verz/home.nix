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
    ../../modules/home-manager/cli/git.nix

    ../../modules/home-manager/desktop/hyprland.nix

    ../../modules/home-manager/programs/textfox.nix
    ../../modules/home-manager/programs/nixcord.nix
    ../../modules/home-manager/programs/spicetify-nix.nix
  ];

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

  home.file = {
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
