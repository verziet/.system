{
  lib,
  config,
  ...
}: {
  options."pipewire".enableModule = lib.mkOption {
    description = "Enable the pipewire module";
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf config."pipewire".enableModule {
    services.pipewire = {
      enable = lib.mkForce true;
      alsa.enable = lib.mkDefault true;
      alsa.support32Bit = lib.mkDefault true;
      pulse.enable = lib.mkDefault true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
    };

    # rtkit is optional but recommended
    security.rtkit.enable = lib.mkDefault true;
  };
}
