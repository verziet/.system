{
  pkgs,
  inputs,
  lib,
  config,
  host,
  ...
}: {
  options."ags".enableModule = lib.mkOption {
    description = "Enable the ags module";
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf config."ags".enableModule {
    programs.ags = {
      enable = lib.mkForce true;

      # symlink to ~/.config/ags
      #configDir = ../ags;

      # additional packages to add to gjs's runtime
      extraPackages = with inputs.ags.packages.${host.system}; [
        battery
        network
        hyprland
        mpris
        tray
        wireplumber
        apps
        notifd
      ];
    };
  };
}
