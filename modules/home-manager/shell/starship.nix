{
  pkgs,
  inputs,
  lib,
  config,
  host,
  ...
}: {
  options."starship".enableModule = lib.mkOption {
    description = "Enable the starship module";
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf config."starship".enableModule {
    programs.starship = {
      enable = lib.mkForce true;
      enableZshIntegration = lib.mkDefault true;
    };
  };
}
