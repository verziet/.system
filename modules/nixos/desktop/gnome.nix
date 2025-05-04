{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: {
  options."gnome".enableModule = lib.mkOption {
    description = "Enable the gnome module";
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf config."gnome".enableModule {
    services.gnome.core-utilities.enable = lib.mkOverride 999 false;
    services.xserver = {
      desktopManager.gnome.enable = lib.mkForce true;

      excludePackages = lib.mkDefault (with pkgs; [
        xterm
      ]);
    };
  };
}
