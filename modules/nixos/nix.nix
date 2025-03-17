{
  pkgs,
  inputs,
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

      # make `nix run nixpkgs#nixpkgs` use the same nixpkgs as the one used by this flake.
      registry = {
        pkgs.flake = lib.mkDefault inputs.nixpkgs;
        pkgs-stable.flake = lib.mkDefault inputs.nixpkgs-stable;
        pkgs-master.flake = lib.mkDefault inputs.nixpkgs-master;
      };

      settings = {
        experimental-features = lib.mkDefault ["flakes" "nix-command"];
        flake-registry = lib.mkDefault "";

        # https://github.com/NixOS/nix/issues/9574
        nix-path = lib.mkForce "nixpkgs=/etc/nix/inputs/nixpkgs";

        substituters = lib.mkIf config.hyprland.enableModule (lib.mkDefault ["https://hyprland.cachix.org"]);
        trusted-public-keys = lib.mkIf config.hyprland.enableModule (lib.mkDefault ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="]);
      };
    };

    # but NIX_PATH is still used by many useful tools, so we set it to the same value as the one used by this flake.
    # Make `nix repl '<nixpkgs>'` use the same nixpkgs as the one used by this flake.
    environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs}";
  };
}
