{
  pkgs,
  inputs,
  lib,
  config,
  host,
  ...
}: {
  options."firewall".enableModule = lib.mkOption {
    description = "Enable the firewall module";
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf config."firewall".enableModule {
    networking.firewall.enable = lib.mkForce true;
  };
}
