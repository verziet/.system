{
  pkgs,
  inputs,
  lib,
  config,
  host,
  ...
}: {
  options."gnome".enableModule = lib.mkOption {
    description = "Enable the gnome module";
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf config."gnome".enableModule {
    services.xserver = {
      desktopManager.gnome.enable = lib.mkForce true;

      excludePackages = lib.mkDefault (with pkgs; [
        xterm
      ]);
    };
  };
}
