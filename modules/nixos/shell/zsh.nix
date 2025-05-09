{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: {
  options."zsh".enableModule = lib.mkOption {
    description = "Enable the zsh module";
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf config."zsh".enableModule {
    programs.zsh.enable = lib.mkForce true;
  };
}
