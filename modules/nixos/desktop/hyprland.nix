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
    programs.uwsm.enable = lib.mkForce true;

    programs.hyprland = {
      enable = lib.mkForce true;
      withUWSM = lib.mkForce true;

      package = lib.mkDefault inputs.hyprland.packages.${host.system}.hyprland;
      portalPackage = lib.mkDefault inputs.hyprland.packages.${host.system}.xdg-desktop-portal-hyprland;
    };
  };
}
