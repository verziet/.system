{
  pkgs,
  inputs,
  lib,
  config,
  host,
  ...
}: {
  options."git".enableModule = lib.mkOption {
    description = "Enable the git module";
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf config."git".enableModule {
    programs.git = {
      enable = lib.mkForce true;

      extraConfig = {
        user.name = lib.mkDefault "verz";
        user.email = lib.mkDefault "verzleet@gmail.com";
        init.defaultBranch = lib.mkDefault "main";
      };
    };
  };
}
