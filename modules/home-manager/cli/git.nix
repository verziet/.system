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
        user.name = lib.mkDefault "verziet";
        user.email = lib.mkDefault "garlic-boss-batch@duck.com";
        init.defaultBranch = lib.mkDefault "main";
      };
    };
  };
}
