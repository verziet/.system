{
  pkgs,
  lib,
  config,
  ...
}: {
  options."network".enableModule = lib.mkOption {
    description = "Enable the network module";
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf config."network".enableModule {
    networking.networkmanager.enable = lib.mkForce true;
  };
}
