{
  pkgs,
  inputs,
  lib,
  config,
  host,
  ...
}: {
  options."zoxide".enableModule = lib.mkOption {
    description = "Enable the zoxide module";
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf config."zoxide".enableModule {
    programs.zoxide = {
      enable = lib.mkForce true;
      enableZshIntegration = lib.mkDefault true;
    };
  };
}
