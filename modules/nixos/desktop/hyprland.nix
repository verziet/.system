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
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf config."hyprland".enableModule {
    programs.uwsm.enable = lib.mkForce true;
    nix.settings = {
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };

    programs.hyprland = {
      enable = lib.mkForce true;
      withUWSM = lib.mkForce true;
      xwayland.enable = lib.mkDefault true;

      package = lib.mkDefault inputs.hyprland.packages.${host.system}.hyprland;
      portalPackage = lib.mkDefault inputs.hyprland.packages.${host.system}.xdg-desktop-portal-hyprland;
    };
  };
}
