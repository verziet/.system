{
  pkgs,
  inputs,
  lib,
  config,
  host,
  ...
}: {
  options."displaylink".enableModule = lib.mkOption {
    description = "Enable the displaylink module";
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf config."displaylink".enableModule {
    services.xserver.videoDrivers = ["displaylink" "modesetting"];
    boot.extraModulePackages = with config.boot.kernelPackages; [evdi];
    boot.kernelModules = ["evdi"];
  };
}
