{
  pkgs,
  lib,
  config,
  ...
}: {
  options."nix".enableModule = lib.mkOption {
    description = "Enable the nix module";
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf config."nix".enableModule {
    nixpkgs.config.allowUnfree = lib.mkDefault true;

    nix = {
      channel.enable = lib.mkDefault false;

      settings = {
        experimental-features = lib.mkDefault ["flakes" "nix-command"];

        substituters = lib.mkDefault ["https://hyprland.cachix.org"];
        trusted-public-keys = lib.mkDefault ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
      };
    };
  };
}
