{
  pkgs,
  pkgs-stable,
  pkgs-master,
  inputs,
  lib,
  config,
  host,
  hostname,
  configuration,
  ...
}: {
  options."nixpkgs" = {
    enable = lib.mkEnableOption {
      default = false;
      description = "Enable some opinionated nixpkgs options";
    };
  };

  config = lib.mkIf config."nixpkgs".enable {
    nixpkgs.config = {
      allowUnfree = true;
      curaSupport = true;
    };
  };
}
