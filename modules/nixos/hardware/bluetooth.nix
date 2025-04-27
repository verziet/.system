{
  pkgs,
  lib,
  config,
  ...
}: {
  options."bluetooth".enableModule = lib.mkOption {
    description = "Enable the bluetooth module";
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf config."bluetooth".enableModule {
    hardware.bluetooth.enable = lib.mkForce true;
  };
}
