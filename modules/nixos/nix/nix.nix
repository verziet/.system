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
  options."nix" = {
    enable = lib.mkEnableOption {
      default = false;
      description = "Some opinionated nix options";
    };
  };

  config = lib.mkIf config."nix".enable {
    nix = {
      channel.enable = false;

      settings = {
	experimental-features = ["flakes" "nix-command"];

	substituters = ["https://hyprland.cachix.org"];
    	trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
      };
    };
  };
}
