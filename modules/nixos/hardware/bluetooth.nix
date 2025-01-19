{
  lib,
  config,
  ...
}: {
  options."bluetooth" = {
    enable = lib.mkEnableOption {
      default = false;
      description = "Enable bluetooth and bluetoothctl";
    };
  };

  config = lib.mkIf config."bluetooth".enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    services.blueman.enable = true;
  };
}
