{
  pkgs,
  pkgs-stable,
  pkgs-master,
  inputs,
  lib,
  host,
  hostname,
  username,
  ...
}: {
  # Modules
  git.enableModule = lib.mkDefault true;
  hyprland.enableModule = lib.mkDefault true;
  ags.enableModule = lib.mkDefault true;
  nixcord.enableModule = lib.mkDefault true;
  nvf.enableModule = lib.mkDefault true;
  spicetify-nix.enableModule = lib.mkDefault true;
  starship.enableModule = lib.mkDefault true;
  zoxide.enableModule = lib.mkDefault true;
  zsh.enableModule = lib.mkDefault true;

  # Settings up home folder
  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
  };

  # Nix settings
  nixpkgs.config.allowUnfree = lib.mkDefault true;

  # Imports
  imports =
    [
      ./${username}/home.nix
      ./${username}/packages.nix
      ../modules/home-manager
    ]
    ++ lib.optional (builtins.pathExists ./${username}/per-host/${hostname}.nix)
    ./${username}/per-host/${hostname}.nix;

  systemd.user.startServices = "sd-switch";

  home.stateVersion = host.stateVersion;
}
