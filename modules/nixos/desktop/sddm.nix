{
  pkgs,
  inputs,
  lib,
  config,
  host,
  ...
}: {
  options."sddm".enableModule = lib.mkOption {
    description = "Enable the sddm module";
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf config."sddm".enableModule {
    services.displayManager.sddm = {
      enable = lib.mkForce true;
      wayland.enable = lib.mkForce true;
      package = lib.mkForce pkgs.kdePackages.sddm;
      #theme = lib.mkDefault "sddm-astronaut-theme";
      extraPackages = with pkgs; [
        #kdePackages.qtmultimedia
        #kdePackages.qtsvg
        #kdePackages.qtvirtualkeyboard
      ];
    };

    environment.systemPackages = with pkgs; [
      #(pkgs.callPackage ../../../pkgs/sddm-astronaut-theme.nix {
      #  theme = "japanese_aesthetic";
      #})
    ];
  };
}
