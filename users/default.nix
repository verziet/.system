{
  pkgs,
  pkgs-stable,
  pkgs-master,
  inputs,
  lib,
  config,
  host,
  hostname,
  username,
  configuration,
  ...
}: {
  nixpkgs.config.allowUnfree = lib.mkDefault true;

  imports =
    [
      ../modules/home-manager/shell/zsh.nix
      ../modules/home-manager/shell/zoxide.nix
      ../modules/home-manager/shell/starship.nix

      ./${username}/home.nix
      ./${username}/packages.nix
    ]
    ++ lib.optional (builtins.pathExists ./${username}/per-host/${hostname}.nix)
    ./${username}/per-host/${hostname}.nix;

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
  };

  systemd.user.startServices = "sd-switch";

  home.stateVersion = host.stateVersion;
}
