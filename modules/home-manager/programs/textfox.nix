{
  pkgs,
  inputs,
  lib,
  config,
  host,
  username,
  ...
}: {
  options."textfox".enableModule = lib.mkOption {
    description = "Enable the textfox module";
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf config."textfox".enableModule {
    textfox = {
      enable = lib.mkForce true;
      profile = "${username}";
      config = {
        # Optional config
      };
    };
  };
}
